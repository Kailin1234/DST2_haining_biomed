package cn.edu.zju.controller;

import cn.edu.zju.bean.DrugLabel;
import org.junit.Before;
import org.junit.Test;

import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static org.junit.Assert.*;

public class MatchingControllerTest {

    private MatchingController matchingController;
    private Method doMatchMethod;

    @Before
    public void setUp() throws Exception {
        matchingController = new MatchingController();

        doMatchMethod = MatchingController.class.getDeclaredMethod(
                "doMatch",
                List.class,
                List.class
        );
        doMatchMethod.setAccessible(true);
    }

    @Test
    @SuppressWarnings("unchecked")
    public void doMatch_whenSummaryContainsExactGeneToken_returnsMatchedLabel() throws Exception {
        // Given
        List<String> refGenes = Collections.singletonList("EGFR");

        DrugLabel egfrLabel = buildDrugLabel(
                "LABEL_EGFR",
                "This label is associated with EGFR mutation."
        );

        DrugLabel her2Label = buildDrugLabel(
                "LABEL_HER2",
                "This label is associated with HER2 alteration."
        );

        // When
        List<DrugLabel> matched = invokeDoMatch(
                refGenes,
                Arrays.asList(egfrLabel, her2Label)
        );

        // Then
        assertEquals(1, matched.size());
        assertEquals("LABEL_EGFR", matched.get(0).getId());
    }

    @Test
    @SuppressWarnings("unchecked")
    public void doMatch_whenGeneCaseIsDifferent_stillMatches() throws Exception {
        // Given
        List<String> refGenes = Collections.singletonList("egfr");

        DrugLabel egfrLabel = buildDrugLabel(
                "LABEL_EGFR",
                "This label is associated with EGFR mutation."
        );

        // When
        List<DrugLabel> matched = invokeDoMatch(
                refGenes,
                Collections.singletonList(egfrLabel)
        );

        // Then
        assertEquals(1, matched.size());
        assertEquals("LABEL_EGFR", matched.get(0).getId());
    }

    @Test
    @SuppressWarnings("unchecked")
    public void doMatch_whenGeneIsOnlyPartOfLongerWord_doesNotMatch() throws Exception {
        // Given
        List<String> refGenes = Collections.singletonList("MET");

        DrugLabel falsePositiveLabel = buildDrugLabel(
                "LABEL_METABOLISM",
                "This label discusses drug METABOLISM and clearance."
        );

        // When
        List<DrugLabel> matched = invokeDoMatch(
                refGenes,
                Collections.singletonList(falsePositiveLabel)
        );

        // Then
        assertTrue(matched.isEmpty());
    }

    @Test
    @SuppressWarnings("unchecked")
    public void doMatch_whenGeneAppearsWithPunctuation_matchesCorrectly() throws Exception {
        // Given
        List<String> refGenes = Collections.singletonList("BRAF");

        DrugLabel brafLabel = buildDrugLabel(
                "LABEL_BRAF",
                "BRAF-mutated melanoma may respond to targeted therapy."
        );

        // When
        List<DrugLabel> matched = invokeDoMatch(
                refGenes,
                Collections.singletonList(brafLabel)
        );

        // Then
        assertEquals(1, matched.size());
        assertEquals("LABEL_BRAF", matched.get(0).getId());
    }

    @Test
    @SuppressWarnings("unchecked")
    public void doMatch_whenSummaryIsBlank_ignoresLabel() throws Exception {
        // Given
        List<String> refGenes = Collections.singletonList("EGFR");

        DrugLabel blankLabel = buildDrugLabel(
                "LABEL_BLANK",
                ""
        );

        // When
        List<DrugLabel> matched = invokeDoMatch(
                refGenes,
                Collections.singletonList(blankLabel)
        );

        // Then
        assertTrue(matched.isEmpty());
    }

    @SuppressWarnings("unchecked")
    private List<DrugLabel> invokeDoMatch(
            List<String> refGenes,
            List<DrugLabel> drugLabels
    ) throws Exception {
        return (List<DrugLabel>) doMatchMethod.invoke(
                matchingController,
                refGenes,
                drugLabels
        );
    }

    private DrugLabel buildDrugLabel(String id, String summaryMarkdown) {
        DrugLabel drugLabel = new DrugLabel();
        drugLabel.setId(id);
        drugLabel.setName(id);
        drugLabel.setObjCls("DrugLabel");
        drugLabel.setSummaryMarkdown(summaryMarkdown);
        drugLabel.setSource("JUnit Test");
        drugLabel.setDrugId("DRUG_TEST");
        return drugLabel;
    }
}