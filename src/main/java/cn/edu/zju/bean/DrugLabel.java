package cn.edu.zju.bean;

public class DrugLabel {

    private String id;
    private String name;
    private String objCls;
    private boolean alternateDrugAvailable;
    private boolean dosingInformation;
    private String prescribingMarkdown;
    private String source;
    private String textMarkdown;
    private String summaryMarkdown;
    private String raw;
    private String drugId;

    private String treatmentIndication;
    private String targetPopulation;
    private String adverseReaction;
    private String contraindication;
    private String warningPrecaution;

    public DrugLabel() {
    }

    public DrugLabel(String id, String name, String objCls, boolean alternateDrugAvailable, boolean dosingInformation,
                     String prescribingMarkdown, String source, String textMarkdown, String summaryMarkdown,
                     String raw, String drugId) {
        this.id = id;
        this.name = name;
        this.objCls = objCls;
        this.alternateDrugAvailable = alternateDrugAvailable;
        this.dosingInformation = dosingInformation;
        this.prescribingMarkdown = prescribingMarkdown;
        this.source = source;
        this.textMarkdown = textMarkdown;
        this.summaryMarkdown = summaryMarkdown;
        this.raw = raw;
        this.drugId = drugId;
    }

    public DrugLabel(String id, String name, String objCls, boolean alternateDrugAvailable, boolean dosingInformation,
                     String prescribingMarkdown, String source, String textMarkdown, String summaryMarkdown,
                     String raw, String drugId, String treatmentIndication, String targetPopulation,
                     String adverseReaction, String contraindication, String warningPrecaution) {
        this.id = id;
        this.name = name;
        this.objCls = objCls;
        this.alternateDrugAvailable = alternateDrugAvailable;
        this.dosingInformation = dosingInformation;
        this.prescribingMarkdown = prescribingMarkdown;
        this.source = source;
        this.textMarkdown = textMarkdown;
        this.summaryMarkdown = summaryMarkdown;
        this.raw = raw;
        this.drugId = drugId;
        this.treatmentIndication = treatmentIndication;
        this.targetPopulation = targetPopulation;
        this.adverseReaction = adverseReaction;
        this.contraindication = contraindication;
        this.warningPrecaution = warningPrecaution;
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getObjCls() {
        return objCls;
    }

    public boolean isAlternateDrugAvailable() {
        return alternateDrugAvailable;
    }

    public boolean isDosingInformation() {
        return dosingInformation;
    }

    public String getPrescribingMarkdown() {
        return prescribingMarkdown;
    }

    public String getSource() {
        return source;
    }

    public String getTextMarkdown() {
        return textMarkdown;
    }

    public String getSummaryMarkdown() {
        return summaryMarkdown;
    }

    public String getRaw() {
        return raw;
    }

    public String getDrugId() {
        return drugId;
    }

    public String getTreatmentIndication() {
        return treatmentIndication;
    }

    public String getTargetPopulation() {
        return targetPopulation;
    }

    public String getAdverseReaction() {
        return adverseReaction;
    }

    public String getContraindication() {
        return contraindication;
    }

    public String getWarningPrecaution() {
        return warningPrecaution;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setObjCls(String objCls) {
        this.objCls = objCls;
    }

    public void setAlternateDrugAvailable(boolean alternateDrugAvailable) {
        this.alternateDrugAvailable = alternateDrugAvailable;
    }

    public void setDosingInformation(boolean dosingInformation) {
        this.dosingInformation = dosingInformation;
    }

    public void setPrescribingMarkdown(String prescribingMarkdown) {
        this.prescribingMarkdown = prescribingMarkdown;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public void setTextMarkdown(String textMarkdown) {
        this.textMarkdown = textMarkdown;
    }

    public void setSummaryMarkdown(String summaryMarkdown) {
        this.summaryMarkdown = summaryMarkdown;
    }

    public void setRaw(String raw) {
        this.raw = raw;
    }

    public void setDrugId(String drugId) {
        this.drugId = drugId;
    }

    public void setTreatmentIndication(String treatmentIndication) {
        this.treatmentIndication = treatmentIndication;
    }

    public void setTargetPopulation(String targetPopulation) {
        this.targetPopulation = targetPopulation;
    }

    public void setAdverseReaction(String adverseReaction) {
        this.adverseReaction = adverseReaction;
    }

    public void setContraindication(String contraindication) {
        this.contraindication = contraindication;
    }

    public void setWarningPrecaution(String warningPrecaution) {
        this.warningPrecaution = warningPrecaution;
    }
}