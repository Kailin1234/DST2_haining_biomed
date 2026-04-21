USE biomed;

ALTER TABLE drug_label
    ADD COLUMN treatment_indication TEXT NULL,
    ADD COLUMN target_population TEXT NULL,
    ADD COLUMN adverse_reaction TEXT NULL,
    ADD COLUMN contraindication TEXT NULL,
    ADD COLUMN warning_precaution TEXT NULL;

SELECT id, name, source, dosing_information, drug_id
FROM drug_label
LIMIT 20;

UPDATE drug_label
SET treatment_indication = 'Used in regulatory drug label guidance for genotype-informed treatment decisions.',
    target_population = 'Patients whose therapy may be influenced by relevant pharmacogenomic biomarkers.',
    adverse_reaction = 'Potential for altered efficacy or adverse response depending on patient-specific genetic background.',
    contraindication = 'Use with caution when genetic or clinical factors suggest increased treatment risk.',
    warning_precaution = 'Review related pharmacogenomic evidence and regulatory recommendations before prescribing.'
WHERE id = 'PA166104775';

UPDATE drug_label
SET treatment_indication = 'Provides regulatory label information relevant to personalized medicine and biomarker-guided drug use.',
    target_population = 'Patients considered for treatment in settings where genotype or biomarker status may affect therapy.',
    adverse_reaction = 'Adverse effects may vary according to patient-specific metabolic or biomarker characteristics.',
    contraindication = 'Avoid or reconsider use when available genetic information indicates increased safety concern.',
    warning_precaution = 'Clinical interpretation should be combined with label text, prescribing context, and patient-specific factors.'
WHERE id = 'PA166104776';

UPDATE drug_label
SET treatment_indication = 'Summarizes label-based treatment considerations for precision medicine applications.',
    target_population = 'Individuals receiving therapy in contexts where pharmacogenomic evidence may influence treatment choice or monitoring.',
    adverse_reaction = 'Drug response and toxicity risk may differ across genetically defined patient groups.',
    contraindication = 'Contraindications should be interpreted together with genomic and regulatory evidence when available.',
    warning_precaution = 'Prescribers should evaluate label recommendations together with biomarker status and other clinical information.'
WHERE id = 'PA166104777';

SELECT id, source, treatment_indication, target_population, adverse_reaction, contraindication, warning_precaution
FROM drug_label
WHERE id IN ('PA166104775', 'PA166104776', 'PA166104777');