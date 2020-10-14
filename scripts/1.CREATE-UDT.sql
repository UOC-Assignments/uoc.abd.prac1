/*CREATE OR REPLACE TYPE Boolean AS OBJECT (
	boolvar NUMBER(1) NOT NULL 
);*/

CREATE OR REPLACE TYPE Fullname AS OBJECT (
	name VARCHAR(30),
	surname1 VARCHAR(50),
	surname2 VARCHAR(50)
);

/

CREATE OR REPLACE TYPE CurrentStudiesList AS VARRAY(10) OF VARCHAR(30);

/

CREATE OR REPLACE TYPE University_ob AS OBJECT(
	name VARCHAR(100)
);

/

CREATE OR REPLACE TYPE Company_ob AS OBJECT(
	CIF VARCHAR(9),
	bussinessName VARCHAR(100),
	postalCode INT,
	sector VARCHAR(100)
);

/

CREATE OR REPLACE TYPE Agreement_ob AS OBJECT(
	startDate date,
	endDate date
)NOT FINAL;

/

CREATE OR REPLACE TYPE AgreementCol_ob UNDER Agreement_ob(
	goalsDescription VARCHAR(1000),
	extendPeriod VARCHAR(1) 
);

/

CREATE OR REPLACE TYPE AgreementInt_ob UNDER Agreement_ob(
	universityManager fullname
);

/

CREATE OR REPLACE TYPE Addendum_ob AS OBJECT (
	signatureDate date
);

/

CREATE OR REPLACE TYPE Student_ob AS OBJECT (
	NIF VARCHAR(9),
	internalID VARCHAR(9),
	completeName fullname,
	currentStudies currentStudiesList
);

/

CREATE OR REPLACE TYPE PDI_ob AS OBJECT(
	NIF VARCHAR(9),
	internalID VARCHAR(9),
	completeName fullname,
	department VARCHAR(30),
	incorporationDate date
);

/

CREATE OR REPLACE TYPE Staff_ob AS OBJECT (
	NIF VARCHAR(9),
	completeName fullname
);

/

CREATE OR REPLACE TYPE LResearch_ob AS OBJECT (
	name VARCHAR(50),
	goalsDescription VARCHAR (1000),
	startDate date,
	endDate date
);

/