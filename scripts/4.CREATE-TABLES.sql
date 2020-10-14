CREATE TABLE companies OF Company_ob (PRIMARY KEY (CIF)) 
NESTED TABLE hasAgreements STORE AS hasAgreements_nt;

/

/* CREATE TABLE agreementCols OF AgreementCol_ob (
		CHECK (hasLinesOfResearch IS NOT NULL),
		CHECK (hasStakeholder IS NOT NULL)
		);

-- AQUESTS CHECKS HAN D'ANAR AL NESTED TABLE hasAgreements_nt

/ */

CREATE TABLE agreementInts OF AgreementInt_ob
NESTED TABLE hasAddendums STORE AS hasAddendums_nt; 

/

-- agreementInts no compila, possiblement per culpa de les nested tables multicapa. La solució es canviar una NT per un VARRAY gran (1000 per ex.) o unscoped:
-- https://www.experts-exchange.com/questions/21344386/Oracle-problem-creating-multi-layer-nested-table.html

CREATE TABLE addendums OF Addendum_ob;

/

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