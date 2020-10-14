INSERT INTO staff 
VALUES ('11111111C',
  fullname('Elon','Reeve','Musk')
);

INSERT INTO staff 
VALUES ('2222222C',
  fullname('MacKenzie','Sheri','Tuttle')
);

INSERT INTO students 
VALUES ('11111111A',
  111111,
  fullname('John','Winston','Lenon'),
  currentStudiesList('PHILOSOPHY','CONTEMPORARY ARTS')
);

INSERT INTO students 
VALUES ('2222222A',
  222222,
  fullname('Bob','Nesta','Marley'),
  currentStudiesList('BOTANICS','BIOENGINEERING','BIOLOGY')
);

INSERT INTO lresearches
VALUES ('ASTROPHYSICS',
  'Study of physics from a cosmological perspective',
  '1-January-2020',
		'1-January-2030'
);

INSERT INTO lresearches
VALUES ('RADIOACTIVITY',
  'Study of nuclear radiation and its properties',
  '1-January-2020',
		'1-January-2030'
);

INSERT INTO lresearches
VALUES ('COMPUTER ARCHITECTURES',
  'Computer hardware design and performance analysis',
  '1-January-2020',
		'1-January-2030'
);

INSERT INTO lresearches
VALUES ('SOFTWARE ENGINEERING',
  'Computer software modeling, design and implementation',
  '1-January-2020',
		'1-January-2030'
);

INSERT INTO lresearches
VALUES ('QUANTUM PHYSICS',
  'Study of the physical properties of nature at the scale of atoms and subatomic particles',
  '1-January-2020',
		'1-January-2030'
);

INSERT INTO lresearches
VALUES ('ENGINEERING',
  ' use of scientific principles to design and build machines',
  '1-January-2020',
		'1-January-2030'
);


INSERT INTO PDIS 
VALUES ('11111111B',
  333333,
  fullname('Mileva','Marić',''),
  'PHYSICS',
  '19-December-1875',
  (select ref(d) from lResearches d where d.name='ASTROPHYSICS') 
);

INSERT INTO PDIS 
VALUES ('22222222B',
  444444,
  fullname('Marie','Skłodowska','Curie'),
  'PHYSICS',
  '7-November-1867',
  (select ref(d) from lResearches d where name='NUCLEAR FUSSION') --THE NOT NULL CLAUSE ENFORCES THE REFERENTIAL INTEGRITY CONSTRAINT (MULTIPLICITY OF "1" IN THE UML DIAGRAM)
);

INSERT INTO PDIS 
VALUES ('22222222B',
  22222,
  fullname('Marie','Sklodowska','Curie'),
  'PHYSICS',
  '7-November-1867',
  (select ref(r) from lResearches r where name='RADIOACTIVITY') 
);

INSERT INTO companies (CIF,businessName,postalCode,sector) -- THIS WAY THE hasAgreement_tab table constructor is automatically called (p.32 M2)
VALUES ('Z12345678',
  'IBM',
  08080,
  'COMPUTING'
);

/* INSERIR A LA NESTED TABLE hasAgreements_nt FILES NOVES D'UN SUBTIPUS D'AQUESTA: 
INSERIM FILES DE TIPUS AGREEMENTCOL (SUBCLASSE) EN UNA TAULA DE TIPUS AGREEMENT (SUPERCLASSE)*/

INSERT INTO TABLE (SELECT c.hasAgreements FROM companies c WHERE c.businessname like 'IBM') 
VALUES (AgreementCol_ob (
  '1-January-2020', 
  '1-January-2045',
  'QUANTUM COMPUTING RESEARCH COLABORATION', 
		'N',
		(select ref(s) from PDIS s where s.NIF='22222222B'),
  refLResearch_va((select ref(r1) from LResearches r1 where r1.name='QUANTUM PHYSICS'),
		       (select ref(r2) from LResearches r2 where r2.name='ENGINEERING'),
					 (select ref(r2) from LResearches r2 where r2.name='COMPUTER ARCHITECTURES')
  ))
);

INSERT INTO TABLE (SELECT c.hasAgreements FROM companies c WHERE c.businessname like 'IBM') 
VALUES (AgreementCol_ob (
  '1-January-2020', 
  '1-January-2025', 
  'BLACK HOLE SIMULATOR PROJECT', 
		'Y',
		(select ref(s) from PDIS s where s.NIF='11111111B'),
  refLResearch_va((select ref(r1) from LResearches r1 where r1.name='SOFTWARE ENGINEERING'),
		       (select ref(r2) from LResearches r2 where r2.name='ASTROPHYSICS')
  ))
);

/* SI VOLEM ACTUALITZAR UNA FILERA D'UN NESTED TABLE PROCEDIM COM SEGUEIX */

/*UPDATE companies 
SET hasAgreements = Agreement_tab ( AgreementCol_ob (
  '1-January-2020', 
  '1-January-2025', 
  'BLACK HOLE SIMULATOR PROJECT', 
		'Y',
		(select ref(s) from PDIS s where s.NIF='11111111B'),
  refLResearch_va((select ref(r1) from LResearches r1 where r1.name='SOFTWARE ENGINEERING'),
		       (select ref(r2) from LResearches r2 where r2.name='ASTROPHYSICS')))         
  )
WHERE businessname like 'IBM';*/

INSERT INTO TABLE (SELECT c.hasAgreements FROM companies c WHERE c.businessname like 'IBM') 
VALUES (AgreementInt_ob (
  '1-January-2020', 
  '1-January-2025', 
  fullname((select ref(r1) from PDIS r1 where r1.NIF='11111111B')
  ))
);


COMMIT;