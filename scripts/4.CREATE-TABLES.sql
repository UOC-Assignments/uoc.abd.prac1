/*CREATE TABLE companies OF Company_ob (PRIMARY KEY (CIF)) 
	NESTED TABLE hasIntAgreements STORE AS hasIntAgreements_nt(
	(PRIMARY KEY (NESTED_TABLE_ID))
		NESTED TABLE hasAddendums STORE AS hasAddendums_nt)
	NESTED TABLE hasTestAgreements STORE AS hasTestAgreements_nt; 
/*/

CREATE TABLE companies OF Company_ob 
  NESTED TABLE hasColAgreements STORE AS hasColAgreements_nt;
  -- NESTED TABLE hasColAgreements STORE AS hasColAgreements_nt;
  --  (NESTED TABLE hasAddendums STORE AS hasAddendums_nt);
/

-- AQUESTS CHECKS HAN D'ANAR AL NESTED TABLE hasAgreements_nt

/* CREATE TABLE agreementCols OF AgreementCol_ob (
		CHECK (hasLinesOfResearch IS NOT NULL),
		CHECK (hasStakeholder IS NOT NULL)
		); */

CREATE TABLE PDIS OF PDI_ob (NIF PRIMARY KEY)
  OBJECT IDENTIFIER IS PRIMARY KEY; 
/

ALTER TABLE PDIS
  ADD CONSTRAINT hasSpecialty CHECK (hasSpecialty IS NOT NULL);
/

CREATE TABLE students OF Student_ob (NIF PRIMARY KEY)
  OBJECT IDENTIFIER IS PRIMARY KEY;
/

CREATE TABLE staff OF Staff_ob (NIF PRIMARY KEY)
  OBJECT IDENTIFIER IS PRIMARY KEY;
/

CREATE TABLE lResearches OF LResearch_ob (name PRIMARY KEY)
  OBJECT IDENTIFIER IS PRIMARY KEY;
/