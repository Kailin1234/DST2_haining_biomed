USE biomed;

ALTER TABLE drug
    ADD COLUMN description TEXT NULL,
    ADD COLUMN biomarker_associated TINYINT(1) NULL,
    ADD COLUMN pharmgkb_id VARCHAR(100) NULL,
    ADD COLUMN drugbank_id VARCHAR(100) NULL,
    ADD COLUMN pubchem_id VARCHAR(100) NULL,
    ADD COLUMN kegg_id VARCHAR(100) NULL;

SELECT id, name, obj_cls, drug_url, biomarker
FROM drug;


UPDATE drug
SET description = 'Antipsychotic drug with pharmacogenomic relevance in individualized treatment.',
    biomarker_associated = 1,
    pharmgkb_id = 'PA10026',
    drugbank_id = 'DB01238',
    pubchem_id = '60795',
    kegg_id = 'D01164'
WHERE id = 'PA10026';

UPDATE drug
SET description = 'Monoclonal antibody targeting EGFR and used in biomarker-guided cancer therapy.',
    biomarker_associated = 1,
    pharmgkb_id = 'PA10040',
    drugbank_id = 'DB00002',
    pubchem_id = '123631',
    kegg_id = 'D02566'
WHERE id = 'PA10040';

UPDATE drug
SET description = 'Antifungal drug with strong pharmacogenomic relevance, especially in genotype-associated dosing considerations.',
    biomarker_associated = 1,
    pharmgkb_id = 'PA10233',
    drugbank_id = 'DB00582',
    pubchem_id = '71616',
    kegg_id = 'D08350'
WHERE id = 'PA10233';


SELECT id, name, description, biomarker_associated, pharmgkb_id, drugbank_id, pubchem_id, kegg_id
FROM drug
WHERE id IN ('PA10026', 'PA10040', 'PA10233');