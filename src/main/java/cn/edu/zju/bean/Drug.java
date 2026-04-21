package cn.edu.zju.bean;

public class Drug {

    private String id;
    private String name;
    private boolean biomarker;
    private String drugUrl;
    private String objCls;

    private String description;
    private Boolean biomarkerAssociated;
    private String pharmgkbId;
    private String drugbankId;
    private String pubchemId;
    private String keggId;

    public Drug() {
    }

    public Drug(String id, String name, boolean biomarker, String drugUrl, String objCls) {
        this.id = id;
        this.name = name;
        this.biomarker = biomarker;
        this.drugUrl = drugUrl;
        this.objCls = objCls;
    }

    public Drug(String id,
                String name,
                boolean biomarker,
                String drugUrl,
                String objCls,
                String description,
                Boolean biomarkerAssociated,
                String pharmgkbId,
                String drugbankId,
                String pubchemId,
                String keggId) {
        this.id = id;
        this.name = name;
        this.biomarker = biomarker;
        this.drugUrl = drugUrl;
        this.objCls = objCls;
        this.description = description;
        this.biomarkerAssociated = biomarkerAssociated;
        this.pharmgkbId = pharmgkbId;
        this.drugbankId = drugbankId;
        this.pubchemId = pubchemId;
        this.keggId = keggId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public boolean isBiomarker() {
        return biomarker;
    }

    public void setBiomarker(boolean biomarker) {
        this.biomarker = biomarker;
    }

    public String getDrugUrl() {
        return drugUrl;
    }

    public void setDrugUrl(String drugUrl) {
        this.drugUrl = drugUrl;
    }

    public String getObjCls() {
        return objCls;
    }

    public void setObjCls(String objCls) {
        this.objCls = objCls;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public Boolean getBiomarkerAssociated() {
        return biomarkerAssociated;
    }

    public void setBiomarkerAssociated(Boolean biomarkerAssociated) {
        this.biomarkerAssociated = biomarkerAssociated;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPharmgkbId() {
        return pharmgkbId;
    }

    public void setPharmgkbId(String pharmgkbId) {
        this.pharmgkbId = pharmgkbId;
    }

    public String getDrugbankId() {
        return drugbankId;
    }

    public void setDrugbankId(String drugbankId) {
        this.drugbankId = drugbankId;
    }

    public String getPubchemId() {
        return pubchemId;
    }

    public void setPubchemId(String pubchemId) {
        this.pubchemId = pubchemId;
    }

    public String getKeggId() {
        return keggId;
    }

    public void setKeggId(String keggId) {
        this.keggId = keggId;
    }
}