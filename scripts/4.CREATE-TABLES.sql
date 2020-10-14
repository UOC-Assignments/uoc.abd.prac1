CREATE TABLE companies OF Company_ob (PRIMARY KEY (CIF)) 
	NESTED TABLE hasIntAgreements STORE AS hasIntAgreements_nt(
	(PRIMARY KEY (NESTED_TABLE_ID))
		NESTED TABLE hasAddendums STORE AS hasAddendums_nt)
	NESTED TABLE hasTestAgreements STORE AS hasTestAgreements_nt; 
/

CREATE TABLE companies_new OF Company_ob (CIF PRIMARY KEY) 
	NESTED TABLE hasIntAgreements STORE AS hasIntAgreements_nt(
	(NESTED_TABLE_ID PRIMARY KEY)
		NESTED TABLE hasAddendums STORE AS hasAddendums_nt)
	NESTED TABLE hasTestAgreements STORE AS hasTestAgreements_nt
    OBJECT IDENTIFIER IS PRIMARY KEY; 
/

/* CREATE TABLE agreementCols OF AgreementCol_ob (
		CHECK (hasLinesOfResearch IS NOT NULL),
		CHECK (hasStakeholder IS NOT NULL)
		);

-- AQUESTS CHECKS HAN D'ANAR AL NESTED TABLE hasAgreements_nt

/ */

-- agreementInts no compila, possiblement per culpa de les nested tables multicapa. La solució es canviar una NT per un VARRAY gran (1000 per ex.) o unscoped:
-- https://www.experts-exchange.com/questions/21344386/Oracle-problem-creating-multi-layer-nested-table.html

CREATE TABLE PDIS OF PDI_ob (
        PRIMARY KEY (NIF),
        CHECK (hasSpecialty IS NOT NULL)
        --OBJECT IDENTIFIER IS PRIMARY KEY
        ); 
/

CREATE TABLE students OF Student_ob (PRIMARY KEY (NIF));

/

CREATE TABLE staff OF Staff_ob (PRIMARY KEY (NIF))
--OBJECT IDENTIFIER IS PRIMARY KEY
;

/

CREATE TABLE lResearches OF LResearch_ob (PRIMARY KEY (name));

/