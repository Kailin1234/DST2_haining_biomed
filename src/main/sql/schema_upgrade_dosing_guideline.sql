USE biomed;

ALTER TABLE dosing_guideline
    ADD COLUMN condition_type VARCHAR(100) NULL,
    ADD COLUMN condition_value VARCHAR(255) NULL,
    ADD COLUMN evidence_level VARCHAR(100) NULL;

SELECT id, name, source, recommendation, drug_id
FROM dosing_guideline
LIMIT 20;

UPDATE dosing_guideline
SET condition_type = 'Genotype',
    condition_value = 'Genotype-guided dosing context',
    evidence_level = 'High'
WHERE id = 'PA166104931';

UPDATE dosing_guideline
SET condition_type = 'Pharmacogenomic recommendation',
    condition_value = 'Dose adjustment or therapy consideration based on gene-drug interaction',
    evidence_level = 'High'
WHERE id = 'PA166104933';

UPDATE dosing_guideline
SET condition_type = 'Clinical implementation',
    condition_value = 'Guideline-based prescribing support for precision medicine',
    evidence_level = 'Moderate'
WHERE id = 'PA166104934';


SELECT id, name, source, condition_type, condition_value, evidence_level
FROM dosing_guideline
WHERE id IN ('PA166104931', 'PA166104933', 'PA166104934');