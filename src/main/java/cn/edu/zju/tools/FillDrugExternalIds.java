package cn.edu.zju.tools;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URLEncoder;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FillDrugExternalIds {

    private static final String PUBCHEM_CID_URL =
            "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/%s/cids/TXT";

    private static final String PUBCHEM_SYNONYM_URL =
            "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/%s/synonyms/TXT";

    private static final String KEGG_FIND_DRUG_URL =
            "https://rest.kegg.jp/find/drug/%s";

    private static final Pattern DRUGBANK_PATTERN = Pattern.compile("\\bDB\\d{5}\\b");

    private static class Config {
        String host = "localhost";
        String port = "3306";
        String database = "biomed";
        String user = "root";
        String password = "";
        int limit = -1;
        boolean apply = false;
        int sleepMillis = 250;
    }

    private static class DrugRecord {
        String id;
        String name;
        String drugbankId;
        String pubchemId;
        String keggId;
    }

    private static class LookupResult {
        String drugId;
        String name;
        String pubchemId;
        String drugbankId;
        String keggId;
        String note;
    }

    public static void main(String[] args) throws Exception {
        Config config = parseArgs(args);

        System.out.println("========================================");
        System.out.println("Drug External ID Filler");
        System.out.println("Database: " + config.database);
        System.out.println("Host: " + config.host + ":" + config.port);
        System.out.println("Apply mode: " + config.apply);
        System.out.println("Limit: " + (config.limit > 0 ? config.limit : "all"));
        System.out.println("========================================");

        try (Connection connection = openConnection(config)) {
            List<DrugRecord> drugs = loadDrugs(connection, config.limit);

            System.out.println("Loaded drug records: " + drugs.size());

            List<LookupResult> results = new ArrayList<>();

            int index = 0;
            for (DrugRecord drug : drugs) {
                index++;
                System.out.println("[" + index + "/" + drugs.size() + "] " + drug.name + " (" + drug.id + ")");

                LookupResult result = lookupExternalIds(drug);
                results.add(result);

                Thread.sleep(config.sleepMillis);
            }

            writePreviewCsv(results, "external_id_lookup_preview.csv");
            writeUpdateSql(results, "drug_external_id_updates.sql");

            if (config.apply) {
                backupTable(connection);
                applyUpdates(connection, results);
                System.out.println("Database update applied.");
            } else {
                System.out.println("Dry run only. No database update applied.");
                System.out.println("Review external_id_lookup_preview.csv and drug_external_id_updates.sql first.");
            }
        }

        System.out.println("Done.");
    }

    private static Config parseArgs(String[] args) {
        Config config = new Config();

        for (int i = 0; i < args.length; i++) {
            String arg = args[i];

            switch (arg) {
                case "--host":
                    config.host = nextArg(args, ++i, "--host");
                    break;
                case "--port":
                    config.port = nextArg(args, ++i, "--port");
                    break;
                case "--database":
                    config.database = nextArg(args, ++i, "--database");
                    break;
                case "--user":
                    config.user = nextArg(args, ++i, "--user");
                    break;
                case "--password":
                    config.password = nextArg(args, ++i, "--password");
                    break;
                case "--limit":
                    config.limit = Integer.parseInt(nextArg(args, ++i, "--limit"));
                    break;
                case "--apply":
                    config.apply = true;
                    break;
                case "--sleep":
                    config.sleepMillis = Integer.parseInt(nextArg(args, ++i, "--sleep"));
                    break;
                default:
                    System.out.println("Unknown argument ignored: " + arg);
            }
        }

        return config;
    }

    private static String nextArg(String[] args, int index, String name) {
        if (index >= args.length) {
            throw new IllegalArgumentException("Missing value for " + name);
        }
        return args[index];
    }

    private static Connection openConnection(Config config) throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");

        String jdbcUrl =
                "jdbc:mysql://" + config.host + ":" + config.port + "/" + config.database
                        + "?useUnicode=true"
                        + "&characterEncoding=UTF-8"
                        + "&serverTimezone=Asia/Shanghai"
                        + "&useSSL=false"
                        + "&allowPublicKeyRetrieval=true";

        return DriverManager.getConnection(jdbcUrl, config.user, config.password);
    }

    private static List<DrugRecord> loadDrugs(Connection connection, int limit) throws SQLException {
        List<DrugRecord> drugs = new ArrayList<>();

        String sql =
                "SELECT id, name, drugbank_id, pubchem_id, kegg_id " +
                        "FROM drug " +
                        "WHERE name IS NOT NULL AND TRIM(name) <> '' " +
                        "AND (" +
                        "drugbank_id IS NULL OR drugbank_id = '' OR " +
                        "pubchem_id IS NULL OR pubchem_id = '' OR " +
                        "kegg_id IS NULL OR kegg_id = ''" +
                        ") " +
                        "ORDER BY name ASC";

        if (limit > 0) {
            sql += " LIMIT " + limit;
        }

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                DrugRecord drug = new DrugRecord();
                drug.id = rs.getString("id");
                drug.name = rs.getString("name");
                drug.drugbankId = rs.getString("drugbank_id");
                drug.pubchemId = rs.getString("pubchem_id");
                drug.keggId = rs.getString("kegg_id");
                drugs.add(drug);
            }
        }

        return drugs;
    }

    private static LookupResult lookupExternalIds(DrugRecord drug) {
        LookupResult result = new LookupResult();
        result.drugId = drug.id;
        result.name = drug.name;
        result.pubchemId = emptyToNull(drug.pubchemId);
        result.drugbankId = emptyToNull(drug.drugbankId);
        result.keggId = emptyToNull(drug.keggId);
        result.note = "";

        try {
            if (isBlank(result.pubchemId)) {
                result.pubchemId = lookupPubChemCid(drug.name);
            }

            if (isBlank(result.drugbankId) && !isBlank(result.pubchemId)) {
                result.drugbankId = lookupDrugBankIdFromPubChemSynonyms(result.pubchemId);
            }

            if (isBlank(result.keggId)) {
                result.keggId = lookupKeggDrugId(drug.name);
            }

            List<String> notes = new ArrayList<>();
            if (isBlank(result.pubchemId)) notes.add("PubChem not found");
            if (isBlank(result.drugbankId)) notes.add("DrugBank not found");
            if (isBlank(result.keggId)) notes.add("KEGG not found");

            result.note = String.join("; ", notes);

        } catch (Exception e) {
            result.note = "Lookup error: " + e.getMessage();
            System.out.println("  Lookup error for " + drug.name + ": " + e.getMessage());
        }

        System.out.println("  PubChem=" + safe(result.pubchemId)
                + ", DrugBank=" + safe(result.drugbankId)
                + ", KEGG=" + safe(result.keggId)
                + (isBlank(result.note) ? "" : ", note=" + result.note));

        return result;
    }

    private static String lookupPubChemCid(String drugName) {
        try {
            String encoded = encode(drugName);
            String url = String.format(PUBCHEM_CID_URL, encoded);
            String response = httpGet(url);

            if (isBlank(response)) {
                return null;
            }

            String[] lines = response.split("\\R");
            for (String line : lines) {
                line = line.trim();
                if (line.matches("\\d+")) {
                    return line;
                }
            }

            return null;
        } catch (Exception e) {
            return null;
        }
    }

    private static String lookupDrugBankIdFromPubChemSynonyms(String pubchemCid) {
        try {
            String url = String.format(PUBCHEM_SYNONYM_URL, encode(pubchemCid));
            String response = httpGet(url);

            if (isBlank(response)) {
                return null;
            }

            Matcher matcher = DRUGBANK_PATTERN.matcher(response);
            if (matcher.find()) {
                return matcher.group();
            }

            return null;
        } catch (Exception e) {
            return null;
        }
    }

    private static String lookupKeggDrugId(String drugName) {
        try {
            String encoded = encode(drugName);
            String url = String.format(KEGG_FIND_DRUG_URL, encoded);
            String response = httpGet(url);

            if (isBlank(response)) {
                return null;
            }

            String normalizedQuery = normalizeName(drugName);

            String[] lines = response.split("\\R");
            String firstCandidate = null;

            for (String line : lines) {
                line = line.trim();

                if (!line.startsWith("dr:")) {
                    continue;
                }

                String[] parts = line.split("\\t", 2);
                if (parts.length < 2) {
                    continue;
                }

                String keggId = parts[0].replace("dr:", "").trim();
                String keggNameText = parts[1].trim();

                if (firstCandidate == null) {
                    firstCandidate = keggId;
                }

                String normalizedKeggNames = normalizeName(keggNameText);

                if (normalizedKeggNames.contains(normalizedQuery)
                        || normalizedQuery.contains(firstToken(normalizedKeggNames))) {
                    return keggId;
                }
            }

            return firstCandidate;
        } catch (Exception e) {
            return null;
        }
    }

    private static String httpGet(String urlText) throws Exception {
        URL url = new URL(urlText);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();

        connection.setRequestMethod("GET");
        connection.setConnectTimeout(15000);
        connection.setReadTimeout(15000);
        connection.setRequestProperty("User-Agent", "haining-biomed-external-id-filler/1.0");

        int status = connection.getResponseCode();

        if (status >= 400) {
            return null;
        }

        StringBuilder sb = new StringBuilder();

        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8))) {

            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line).append("\n");
            }
        }

        return sb.toString().trim();
    }

    private static void writePreviewCsv(List<LookupResult> results, String fileName) throws Exception {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(fileName, StandardCharsets.UTF_8))) {
            writer.write("drug_id,name,pubchem_id,drugbank_id,kegg_id,note");
            writer.newLine();

            for (LookupResult result : results) {
                writer.write(csv(result.drugId));
                writer.write(",");
                writer.write(csv(result.name));
                writer.write(",");
                writer.write(csv(result.pubchemId));
                writer.write(",");
                writer.write(csv(result.drugbankId));
                writer.write(",");
                writer.write(csv(result.keggId));
                writer.write(",");
                writer.write(csv(result.note));
                writer.newLine();
            }
        }

        System.out.println("Preview CSV written: " + fileName);
    }

    private static void writeUpdateSql(List<LookupResult> results, String fileName) throws Exception {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(fileName, StandardCharsets.UTF_8))) {
            writer.write("-- Generated at " + LocalDateTime.now());
            writer.newLine();
            writer.write("USE biomed;");
            writer.newLine();
            writer.newLine();

            for (LookupResult result : results) {
                List<String> sets = new ArrayList<>();

                if (!isBlank(result.drugbankId)) {
                    sets.add("drugbank_id = COALESCE(NULLIF(drugbank_id, ''), '" + sql(result.drugbankId) + "')");
                }

                if (!isBlank(result.pubchemId)) {
                    sets.add("pubchem_id = COALESCE(NULLIF(pubchem_id, ''), '" + sql(result.pubchemId) + "')");
                }

                if (!isBlank(result.keggId)) {
                    sets.add("kegg_id = COALESCE(NULLIF(kegg_id, ''), '" + sql(result.keggId) + "')");
                }

                if (sets.isEmpty()) {
                    continue;
                }

                writer.write("UPDATE drug SET ");
                writer.write(String.join(", ", sets));
                writer.write(" WHERE id = '" + sql(result.drugId) + "';");
                writer.newLine();
            }
        }

        System.out.println("Update SQL written: " + fileName);
    }

    private static void backupTable(Connection connection) throws SQLException {
        String sql =
                "CREATE TABLE IF NOT EXISTS drug_backup_before_external_id_update AS " +
                        "SELECT * FROM drug";

        try (Statement statement = connection.createStatement()) {
            statement.executeUpdate(sql);
        }

        System.out.println("Backup table checked/created: drug_backup_before_external_id_update");
    }

    private static void applyUpdates(Connection connection, List<LookupResult> results) throws SQLException {
        String sql =
                "UPDATE drug SET " +
                        "drugbank_id = CASE WHEN (drugbank_id IS NULL OR drugbank_id = '') THEN ? ELSE drugbank_id END, " +
                        "pubchem_id = CASE WHEN (pubchem_id IS NULL OR pubchem_id = '') THEN ? ELSE pubchem_id END, " +
                        "kegg_id = CASE WHEN (kegg_id IS NULL OR kegg_id = '') THEN ? ELSE kegg_id END " +
                        "WHERE id = ?";

        connection.setAutoCommit(false);

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int updated = 0;

            for (LookupResult result : results) {
                if (isBlank(result.drugbankId) && isBlank(result.pubchemId) && isBlank(result.keggId)) {
                    continue;
                }

                ps.setString(1, result.drugbankId);
                ps.setString(2, result.pubchemId);
                ps.setString(3, result.keggId);
                ps.setString(4, result.drugId);
                ps.addBatch();
                updated++;
            }

            ps.executeBatch();
            connection.commit();

            System.out.println("Update statements applied: " + updated);
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    private static String encode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    private static String normalizeName(String value) {
        if (value == null) {
            return "";
        }

        return value.toLowerCase()
                .replaceAll("\\([^)]*\\)", " ")
                .replaceAll("[^a-z0-9]+", " ")
                .replaceAll("\\s+", " ")
                .trim();
    }

    private static String firstToken(String value) {
        if (isBlank(value)) {
            return "";
        }

        String[] parts = value.split("\\s+");
        return parts.length == 0 ? "" : parts[0];
    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private static String emptyToNull(String value) {
        return isBlank(value) ? null : value.trim();
    }

    private static String safe(String value) {
        return isBlank(value) ? "NA" : value;
    }

    private static String csv(String value) {
        if (value == null) {
            value = "";
        }

        String escaped = value.replace("\"", "\"\"");
        return "\"" + escaped + "\"";
    }

    private static String sql(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("'", "''");
    }
}