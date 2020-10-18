/*###############################################################################
 #                                                                              #
 #                       UOC - Open University of Catalonia                     #
 #                                                                              #
 ################################################################################

 ################################################################################
 #                                                                              #
 #                           DATABASE ARCHITECTURE (ABD)                        #
 #                             PRACTICAL ASSIGNMENT #1                          #
 #                                                                              #
 #                        STUDENT: Jordi Bericat Ruz                            #
 #                           TERM: Autumn 2020/21                               #
 #                    GITHUB REPO: UOC-Assignments/uoc.abd.prac1"               #
 #                    FILE 2 OF 6: 2-inserts.sql                                #
 #                        VERSION: 3.0                                          #
 #                                                                              #
 ################################################################################

 ################################################################################
 #                                                                              #
 #  DESCRIPTION: SQL script to insert sample data into the object-oriented      #
 #               database                                                       #
 #                                                                              #
 ################################################################################


 _.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~*/


-- ######## 1. INSERT ROWS IN "lresearches" TABLE 

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

-- ######## 2. INSERT ROWS IN "staff" TABLE 

INSERT INTO staff 
VALUES ('11111111C',
  fullname('Elon','Reeve','Musk')
);

INSERT INTO staff 
VALUES ('22222222C',
  fullname('Sheri','MacKenzie','Tuttle')
);

INSERT INTO staff 
VALUES ('33333333C',
  fullname('Mark','Elliot','Zuckerberg')
);

INSERT INTO staff 
VALUES ('44444444C',
  fullname('William','Henry','Gates')
);

-- ######## 3. INSERT ROWS IN "students" TABLE 

INSERT INTO students 
VALUES ('11111111A',
  111111,
  fullname('John','Winston','Lenon'),
  currentStudiesList('PHILOSOPHY','CONTEMPORARY ARTS')
);

INSERT INTO students 
VALUES ('22222222A',
  222222,
  fullname('Bob','Nesta','Marley'),
  currentStudiesList('BOTANICS','BIOENGINEERING','BIOLOGY')
);

INSERT INTO students 
VALUES ('33333333A',
  333333,
  fullname('Tina','Turner',''),
  currentStudiesList('MECHANICAL ENGINNERING','AERONAUTICS','ELECTRONICS')
);

INSERT INTO students 
VALUES ('44444444A',
  444444,
  fullname('Cynthia','Stephanie','Lauper'),
  currentStudiesList('GENERAL SURGERY','PEDIATRICS')
);

-- ######## 4. INSERT ROWS IN "PDIS" TABLE 

INSERT INTO PDIS 
VALUES ('11111111B',
  555555,
  fullname('Mileva','Marić',''),
  'PHYSICS',
  '19-December-1875',
  (select ref(d) from lResearches d where d.name='ASTROPHYSICS') 
);

INSERT INTO PDIS 
VALUES ('22222222B',
  666666,
  fullname('Marie','Skłodowska','Curie'),
  'PHYSICS',
  '7-November-1867',
  (select ref(d) from lResearches d where name='NUCLEAR FUSSION') --THE NOT NULL CLAUSE ENFORCES THE REFERENTIAL INTEGRITY CONSTRAINT (MULTIPLICITY OF "1" IN THE UML DIAGRAM)
);

INSERT INTO PDIS 
VALUES ('22222222B',
  666666,
  fullname('Marie','Sklodowska','Curie'),
  'PHYSICS',
  '7-November-1867',
  (select ref(r) from lResearches r where name='RADIOACTIVITY') 
);

-- ######## 5. INSERT ROWS IN "companies" TABLE */
-- ########
-- ######## OBSERVACIÓ: Abans de poder inserir files a les nested tables hem de 
-- ########             crear una instància de classe company per a que la relació 
-- ########             amb agreement pugui existir

INSERT INTO companies (CIF,businessName,postalCode,sector) -- THIS WAY THE nested tables constructors are automatically called (p.32 M2)
VALUES ('Z12345678',
  'IBM',
  08080,
  'COMPUTING'
);

-- ######## BUG#001 -.> Si no es fa UPDATE primer, NO es poden fer INSERTS a les nested 
-- ########             tables ( Error report - ORA-22908: reference to NULL table value)
-- ######## SOLUCIONAT --> PRIMER S'HA D'INICIALITZAR LA NESTED TABLE "companies.hasIntAgreements" 
-- ########                INVOCANT ELS MÈTODE CONSTRUCTORS -> AgreementsCol_tab() i AgreementsInt_tab() 
-- ######## FONT       --> https://stackoverflow.com/questions/49565207/create-a-nested-table-and-insert-data-only-in-the-inner-table */

UPDATE companies 
SET hasColAgreements = NEW AgreementsCol2_tab(),
    hasIntAgreements = NEW AgreementsInt_tab()
WHERE businessname like 'IBM';

-- ######## 6. INSERT ROWS IN "companies.hasColAgreements_nt" NESTED TABLE 
  
INSERT INTO TABLE (SELECT c.hasColAgreements FROM companies c WHERE c.businessname like 'IBM') 
VALUES (AgreementCol2_ob (
  '1-January-2020', 
  '1-January-2030', 
  'QUANTUM COMPUTING RESEARCH COLABORATION', 
  'N',
  (select ref(s) from PDIS s where s.NIF='22222222B'),
  refLResearch_va(
    (select ref(r1) from LResearches r1 where r1.name='QUANTUM PHYSICS'),
	(select ref(r2) from LResearches r2 where r2.name='ENGINEERING'),
    (select ref(r3) from LResearches r3 where r3.name='COMPUTER ARCHITECTURES')
  ))
);

INSERT INTO TABLE (SELECT c.hasColAgreements FROM companies c WHERE c.businessname like 'IBM') 
VALUES (AgreementCol2_ob (
  '1-January-2020', 
  '1-January-2025',
  'BLACK HOLE SIMULATOR PROJECT', 
  'Y',
  (select ref(s) from PDIS s where s.NIF='11111111B'),
  refLResearch_va(
    (select ref(r1) from LResearches r1 where r1.name='SOFTWARE ENGINEERING'),
    (select ref(r2) from LResearches r2 where r2.name='ASTROPHYSICS')
  ))
);

-- ######## 7. INSERT ROWS IN "companies.hasIntAgreements_nt" MULTILEVEL NESTED TABLE (OUTER)

INSERT INTO TABLE (SELECT c.hasIntAgreements FROM companies c WHERE c.businessname like 'IBM') 
VALUES (AgreementInt_ob (
  '1-January-2015', 
  '1-January-2020', 
  fullname('Kurt','Vogel','Russell'),
  null
  )
);

INSERT INTO TABLE (SELECT c.hasIntAgreements FROM companies c WHERE c.businessname like 'IBM') 
VALUES (AgreementInt_ob (
  '1-January-2020', 
  '1-January-2025',
  fullname('Michael','J.','Fox'),
  null
  )
);

-- ######## ARA S'HA D'INICIALITZAR LA INNER NESTED TABLE "companies.hasIntAgreements.hasAddendums" 
-- ######## CRIDANT AL CONSTRUCTOR -> Addendums_tab() 

UPDATE TABLE(SELECT c.hasIntAgreements 
                  FROM companies c
                  WHERE c.businessname like 'IBM') nt   
SET nt.hasAddendums = Addendums_tab()
WHERE nt.startDate = '01/January/2015' AND nt.endDate = '01/January/2020';

-- ######## 8. INSERT ROWS IN "companies.hasIntAgreements.hasAddendums_nt" MULTILEVEL NESTED TABLE (INNER) 

INSERT INTO TABLE( SELECT nt1.hasAddendums 
  FROM TABLE( SELECT c.hasIntAgreements 
    FROM companies c
    WHERE c.businessName like 'IBM') nt1
  WHERE nt1.startDate = '01/January/2015' AND nt1.endDate = '01/January/2020')
VALUES (
  '01/January/2015',
  (select ref(r1) from PDIS r1 where r1.NIF='11111111B'),
  RefStaff_va(
    (select ref(r1) from staff r1 where r1.NIF='11111111C'),
    (select ref(r2) from staff r2 where r2.NIF='22222222C')
  ), 
  RefStudent_va(
    (select ref(r1) from students r1 where r1.NIF='11111111A'),
    (select ref(r2) from students r2 where r2.NIF='22222222A')
  ) 
);

INSERT INTO TABLE( SELECT nt1.hasAddendums 
  FROM TABLE( SELECT c.hasIntAgreements 
    FROM companies c
    WHERE c.businessName like 'IBM') nt1
  WHERE nt1.startDate = '01/January/2015' AND nt1.endDate = '01/January/2020')
VALUES (
  '01/January/2016',
  (select ref(r1) from PDIS r1 where r1.NIF='22222222B'),
  RefStaff_va(
    (select ref(r1) from staff r1 where r1.NIF='33333333C'),
    (select ref(r2) from staff r2 where r2.NIF='44444444C')
  ), 
  RefStudent_va(
    (select ref(r1) from students r1 where r1.NIF='33333333A'),
    (select ref(r2) from students r2 where r2.NIF='44444444A')
  ) 
);

COMMIT;