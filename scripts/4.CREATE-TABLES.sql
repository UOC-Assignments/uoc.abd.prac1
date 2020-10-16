CREATE TABLE companies OF Company_ob (CIF PRIMARY KEY) 
  NESTED TABLE hasColAgreements STORE AS hasColAgreements_nt
  NESTED TABLE hasIntAgreements STORE AS hasIntAgreements_nt
    (NESTED TABLE hasAddendums STORE AS hasAddendums_nt); 
/

/* CREATE TABLE agreementCols OF AgreementCol_ob (
		CHECK (hasLinesOfResearch IS NOT NULL),
		CHECK (hasStakeholder IS NOT NULL)
		);
-- AQUESTS CHECKS HAN D'ANAR AL NESTED TABLE hasAgreements_nt
/ */

CREATE TABLE PDIS OF PDI_ob (NIF PRIMARY KEY)
  /* Si ho activem passa el següent al inserir files a PDIS -> Error report -ORA-22979: cannot INSERT object view REF or user-defined REF */
  --OBJECT IDENTIFIER IS PRIMARY KEY; 
/

ALTER TABLE PDIS
  ADD CONSTRAINT hasSpecialty CHECK (hasSpecialty IS NOT NULL);
/

CREATE TABLE students OF Student_ob (NIF PRIMARY KEY)
  --OBJECT IDENTIFIER IS PRIMARY KEY;
/

CREATE TABLE staff OF Staff_ob (NIF PRIMARY KEY)
  --OBJECT IDENTIFIER IS PRIMARY KEY; 
/

CREATE TABLE lResearches OF LResearch_ob (name PRIMARY KEY);
  /* Si ho activem passa el següent al inserir files a PDIS -> Error report -ORA-22979: cannot INSERT object view REF or user-defined REF */
  --OBJECT IDENTIFIER IS PRIMARY KEY; 
/