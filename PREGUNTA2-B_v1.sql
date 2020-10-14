/* 1. DEFINIM ELS TIPUS UDT */

/* 1.1. boolean UDT */

--A ORACLE NO DISPOSEM DE TIPUS BOOL PREDEFINIT -> https://stackoverflow.com/questions/14731971/create-boolean-attribute-in-oracle

CREATE TYPE boolean AS OBJECT (
	boolvar NUMBER(1) NOT NULL 
);

--(RECORDAR AFEGIR EL CHECK SEGUENT AL CREAR UNA TAULA QUE UTILITZI EL TIPUS:

--CHECK (value IN (0,1))

/* 1.2. fullname UDT */
CREATE TYPE fullname AS OBJECT (
	name VARCHAR(30),
	surname1 VARCHAR(50),
	surname2 VARCHAR(50)
);

/* 1.3. currentStudiesList Collection type (VARRAY) */
CREATE TYPE currentStudiesList AS VARRAY(10) OF VARCHAR(30);

/* 2. DEFINIM LES CLASSES DEL DIAGRAMA UML COM A TIPUS UDT */

/* 2.0. Plantilla */

CREATE TYPE class AS OBJECT (
	attr1 TYPE,
	attr2 TYPE
);

--SUBCLASSE

CREATE TYPE class UNDER parentType (
	attr1 TYPE,
	attr2 TYPE,
)NOT INSTANTIABLE;

/* 2.1. CLASSE "University" */

CREATE TYPE University AS OBJECT(
	name VARCHAR(100)
)FINAL;

--TO-DO: Composition -> es pot implementar amb una taula niuada (NESTED TABLE)???

/* 2.2. CLASSE "Company" */

CREATE TYPE Company AS OBJECT (
	CIF VARCHAR(9),
	bussinessName VARCHAR(100),
	postalCode INT,
	sector VARCHAR(100)
    )FINAL;

/* 2.3. CLASSE ABSTRACTA "Agreement" */
create or replace TYPE Agreement AS OBJECT (
	startDate date,
	endDate date
    )NOT FINAL NOT INSTANTIABLE;

/* 2.4. SUBCLASSE "AgreementCol" */
CREATE TYPE AgreementCol UNDER Agreement (
	goalsDescription VARCHAR(1000),
	extendPeriod VARCHAR(1) --IMPLEMENTACIÓ CUTRE DE BOOLEAN. MILLOR CREAR UN TYPE AMB CHECK(Y,N) i NOT NULL
)FINAL;

/* 2.5. SUBCLASSE "AgreementInt" */

CREATE TYPE AgreementInt UNDER Agreement (
	universityManager fullname,
)FINAL;


/* 2.6. CLASSE "PDI" */

CREATE TYPE PDI AS OBJECT (
	NIF VARCHAR(9),
	internalID VARCHAR(9),
	completeName fullname,
	department VARCHAR(30),
	incorporationDate date
)FINAL;

/* 2.7. CLASSE "Student" */

CREATE TYPE Student AS OBJECT (
	NIF VARCHAR(9),
	internalID VARCHAR(9),
	completeName fullname,
	currentStudies currentStudiesList
)FINAL;

/* 2.8. CLASSE "LResearch" */

CREATE TYPE LResearch AS OBJECT (
	name VARCHAR(50),
	goalsDescription VARCHAR (1000),
	startDate date,
	endDate date
)FINAL;

/* 2.9. CLASSE "Staff" */

CREATE TYPE Staff AS OBJECT (
	NIF VARCHAR(9),
	completeName fullname
)FINAL;

/* 2.10. CLASSE "Addendum" */

CREATE TYPE Addendum AS OBJECT (
	signatureDate date
)FINAL;

/* 2.11*/

/* 3. CREEM LES TAULES D'OBJECTES */

/* 3.0 plantilla */

CREATE TABLE name OF type(
	foreignKey_ref REF foreignKey REFERENCES class --DEFINIM LES RELACIONS D'INTEGRITAT REFERENCIAL (REF's) 
	OBJECT IDENTIFIER IS PRIMARY KEY;
);

/* 3.1 TAULA Universities */

CREATE TABLE universities of University (
	PRIMARY KEY (CIF);
	company_ref REF Company REFERENCES companies --DEFINIM LES RELACIONS D'INTEGRITAT REFERENCIAL (REF's) 
	OBJECT IDENTIFIER IS PRIMARY KEY;
);
