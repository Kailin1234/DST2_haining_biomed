package cn.edu.zju.bean;

public class DosingGuideline {

    private String id;
    private String objCls;
    private String name;
    private boolean recommendation;
    private String drugId;
    private String source;
    private String summaryMarkdown;
    private String textMarkdown;
    private String raw;

    private String conditionType;
    private String conditionValue;
    private String evidenceLevel;

    public DosingGuideline() {
    }

    public DosingGuideline(String id, String objCls, String name, boolean recommendation,
                           String drugId, String source, String summaryMarkdown,
                           String textMarkdown, String raw) {
        this.id = id;
        this.objCls = objCls;
        this.name = name;
        this.recommendation = recommendation;
        this.drugId = drugId;
        this.source = source;
        this.summaryMarkdown = summaryMarkdown;
        this.textMarkdown = textMarkdown;
        this.raw = raw;
    }

    public DosingGuideline(String id, String objCls, String name, boolean recommendation,
                           String drugId, String source, String summaryMarkdown,
                           String textMarkdown, String raw,
                           String conditionType, String conditionValue, String evidenceLevel) {
        this.id = id;
        this.objCls = objCls;
        this.name = name;
        this.recommendation = recommendation;
        this.drugId = drugId;
        this.source = source;
        this.summaryMarkdown = summaryMarkdown;
        this.textMarkdown = textMarkdown;
        this.raw = raw;
        this.conditionType = conditionType;
        this.conditionValue = conditionValue;
        this.evidenceLevel = evidenceLevel;
    }

    public String getId() {
        return id;
    }

    public String getObjCls() {
        return objCls;
    }

    public String getName() {
        return name;
    }

    public boolean isRecommendation() {
        return recommendation;
    }

    public String getDrugId() {
        return drugId;
    }

    public String getSource() {
        return source;
    }

    public String getSummaryMarkdown() {
        return summaryMarkdown;
    }

    public String getTextMarkdown() {
        return textMarkdown;
    }

    public String getRaw() {
        return raw;
    }

    public String getConditionType() {
        return conditionType;
    }

    public String getConditionValue() {
        return conditionValue;
    }

    public String getEvidenceLevel() {
        return evidenceLevel;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setObjCls(String objCls) {
        this.objCls = objCls;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setRecommendation(boolean recommendation) {
        this.recommendation = recommendation;
    }

    public void setDrugId(String drugId) {
        this.drugId = drugId;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public void setSummaryMarkdown(String summaryMarkdown) {
        this.summaryMarkdown = summaryMarkdown;
    }

    public void setTextMarkdown(String textMarkdown) {
        this.textMarkdown = textMarkdown;
    }

    public void setRaw(String raw) {
        this.raw = raw;
    }

    public void setConditionType(String conditionType) {
        this.conditionType = conditionType;
    }

    public void setConditionValue(String conditionValue) {
        this.conditionValue = conditionValue;
    }

    public void setEvidenceLevel(String evidenceLevel) {
        this.evidenceLevel = evidenceLevel;
    }
}