/* 3. CREEM LES TAULES D'OBJECTES */

/* 3.0 plantilla */

CREATE TABLE name OF type(
	foreignKey_ref REF foreignKey REFERENCES class --DEFINIM LES RELACIONS D'INTEGRITAT REFERENCIAL (REF's) 
	OBJECT IDENTIFIER IS PRIMARY KEY;
);

/* 3.1 TAULA companies */

CREATE TABLE companies of Company (
	PRIMARY KEY (CIF),
	OBJECT IDENTIFIER IS PRIMARY KEY;
);

/* 3.2 TAULA Universities */

CREATE TABLE universities of University (
	company_ref REF Company REFERENCES companies --DEFINIM LES RELACIONS D'INTEGRITAT REFERENCIAL (REF's) 
);