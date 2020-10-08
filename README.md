# Description
This SAS macro takes in a patient-level dataset with medication information and identifies the number of medications that are included in Beers Criteria 2015. The input dataset must be "wide," with one row per patient and one column per medication.

# Macro Inputs:
  | Input       | Description                                                               |
  |-------------|---------------------------------------------------------------------------|
  |inpath       | path of the SAS dataset with one row per patient (with quotes)            |
  |infile       |	name of the SAS dataset with one row per patient (no quotes)              | 
  |outpath      |	path to where you want to save your flagged drug file (with quotes)       |
  |maxdrugs     |	maximum number of drugs in a row (i.e. x, where columns are Drug1-Drugx)  |
  |schizo_var   |	variable name that flags the presence of schizophrenia with a 1/0         |
  |bipol_var    |	variable name that flags the presence of bipolar disorder with a 1/0      |
  |chf_var      | variable name that flags the presence of CHF with a 1/0                   |
  |sz_var       |	variable name that flags the presence of seizure disorder with a 1/0      |
  |dmta_var     |	variable name that flags the presence of dementia with a 1/0              |
  |insom_var    |	variable name that flags the presence of insomnia with a 1/0              |
  |pd_var       |	variable name that flags the presence of Parkinson's disease with a 1/0   |
  |sex_var      | variable name that flags sex with a 2 for female                          |
  |incontu_var  |	variable name that flags the presence of urinary incontinence with a 1/0  |

# Output:
This SAS macro outputs a dataset called "beers_final" that includes all the variables from the input dataset, a variable for each medication category delineated in Beers Criteria 2015, and the following summary variables:



| Column        | Description                                                                     | Valueset                 |
| ------------- | ------------------------------------------------------------------------------- | ------------------------ |
| drugid        | Code for your medical terminology of choice                                     | See medical terminology  |
| drugname      | Name of the medication                                                          | Character                |
| beers         | Flag for whether the medication is in BC15                                      | 0, 1                     |
| antihis       | Flag for whether the medication is in BC15 antihistamine category               | 0, 1                     |
| antipark      | Flag for whether the medication is in BC15 antiparkinsonian category            | 0, 1                     |
| antispas      | Flag for whether the medication is in BC15 antispasmodic category               | 0, 1                     |
| antithrom     | Flag for whether the medication is in BC15 antithrombotic category              | 0, 1                     |
| pa1b          | Flag for whether the medication is in BC15 peripheral alpha blocker category    | 0, 1                     |
| cab           | Flag for whether the medication is in BC15 central alpha blocker category       | 0, 1                     |
| cv_othr       | Flag for whether the medication is in BC15 other CV category                    | 0, 1                     |
| antidep       | Flag for whether the medication is in BC15 antidepressant category              | 0, 1                     |
| antipsy_all       | Flag for whether the medication is in BC15 antipsychotic category               | 0, 1                     |
| barb          | Flag for whether the medication is in BC15 barbiturate category                 | 0, 1                     |
| bzd           | Flag for whether the medication is in BC15 benzodiazepine category              | 0, 1                     |
| nbzd          | Flag for whether the medication is in BC15 non-benzodiazepine agonist category  | 0, 1                     |
| cns_othr      | Flag for whether the medication is in BC15 other CNS category                   | 0, 1                     |
| andro         | Flag for whether the medication is in BC15 androgen category                    | 0, 1                     |
| endo_othr     | Flag for whether the medication is in BC15 other endocrine category             | 0, 1                     |
| sulf          | Flag for whether the medication is in BC15 sulfonylurea category                | 0, 1                     |
| chlorpropamide| Flag for whether the medication is in BC15 chlorpropamide category              | 0, 1                     |
| metoc         | Flag for whether the medication is in BC15 metoclopramide category              | 0, 1                     |
| mineral       | Flag for whether the medication is in BC15 mineral oil category                 | 0, 1                     |
| ppi           | Flag for whether the medication is in BC15 PPI category                         | 0, 1                     |
| pain_othr     | Flag for whether the medication is in BC15 other pain category                  | 0, 1                     |
| nsaid         | Flag for whether the medication is in BC15 NSAID category                       | 0, 1                     |
| smr           | Flag for whether the medication is in BC15 skeletal muscle relxant category     | 0, 1                     |
| desmo         | Flag for whether the medication is in BC15 desmopressin category                | 0, 1                     |
| acei          | Flag for whether the medication is in BC15 ACE inhibitor category               | 0, 1                     |
| antichol      | Flag for whether the medication is in BC15 anticholinergic category             | 0, 1                     |
| cns           | Flag for whether the medication is in BC15 CNS category                         | 0, 1                     |
| steroid       | Flag for whether the medication is in BC15 steroid category                     | 0, 1                     |
| lith          | Flag for whether the medication is in BC15 lithium category                     | 0, 1                     |
| amil          | Flag for whether the medication is in BC15 amiloride category                   | 0, 1                     |
| triam         | Flag for whether the medication is in BC15 triamterene category                 | 0, 1                     |
| theo          | Flag for whether the medication is in BC15 theophylline category                | 0, 1                     |
| cimet         | Flag for whether the medication is in BC15 cimetidine category                  | 0, 1                     |
| warfarin      | Flag for whether the medication is in BC15 warfarin category                    | 0, 1                     |
| amiodarone    | Flag for whether the medication is in BC15 amiodarone category                  | 0, 1                     |
| loop          | Flag for whether the medication is in BC15 loop diuretic category               | 0, 1                     |
| beers_pim     |	Count of the # of potentially inappropriate meds (PIMs) from the input          | Numeric                  |
| beers_ddzi    | Count of the # of drug-disease interactions from Beers Criteria 2015            | Numeric                  |
| beers_ddi     | Count of the # of drug-drug interactions from Beers Criteria 2015               | Numeric                  |
| beers_total   | Count of the total # of PIMs, drug-disease, and drug-drug interactions          | Numeric                  |
| beers_any     | Flag for any medication that meets Beers Criteria 2015                          | 0, 1                     |


    
