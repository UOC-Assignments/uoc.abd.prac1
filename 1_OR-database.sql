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
 #                    FILE 1 OF 4: 1_OR-database.sql                            #
 #                        VERSION: 1.0                                          #
 #                                                                              #
 ################################################################################

 ################################################################################
 #                                                                              #
 #  DESCRIPTION: Oracle SQL Script that creates an object-oriented database     #
 #                                                                              #
 ################################################################################


 _.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(


/*###############################################################################
 #                                                                              #
 #                  1. DEFINIM ELS TIPUS DE DADES PERSONALITZATS                #
 #                                                                              #
 ##############################################################################*/

-- ######## DESCRIPCIÓ: En primer lloc crearem els UDT personalitzats (tipus) que 
-- ######## siguin estrictament necessaris per a declarar els atributs de cada UDT.
    
CREATE OR REPLACE TYPE Fullname AS OBJECT (
  name VARCHAR(30),
  surname1 VARCHAR(50),
  surname2 VARCHAR(50)
)FINAL;
/

CREATE OR REPLACE TYPE CurrentStudiesList AS VARRAY(10) OF VARCHAR(30);
/

/*###############################################################################
 #                                                                              #
 #          2. DEFINIM LES CLASSES DEL DIAGRAMA UML COM A TIPUS OBJECTE         #
 #                                                                              #
 ##############################################################################*/ 

-- ######## DESCRIPCIÓ: Seguidament crearem els UDT (tipus objecte) corresponents 
-- ######## a cada classe amb CREATE or REPLACE TYPE className AS OBJECT sense tenir 
-- ######## en compte les associacions entre classes, és a dir, només es crearà 
-- ######## l’esquelet de classes junt als seus atributs.

CREATE OR REPLACE TYPE Company_ob AS OBJECT(
  CIF VARCHAR(9),
  businessName VARCHAR(100),
  postalCode INT,
  sector VARCHAR(100)
)FINAL;
/

CREATE OR REPLACE TYPE Agreement_ob AS OBJECT(
  startDate date,
  endDate date
)NOT FINAL NOT INSTANTIABLE;
/

/*startDate, endDate i goalsDescription han de ser PK (TO-DO)*/
CREATE OR REPLACE TYPE AgreementCol2_ob UNDER Agreement_ob(
  goalsDescription VARCHAR(1000),
  extendPeriod VARCHAR(1) --NOMÉS POT CONTENIR VALORS "Y" i "N" (CHECK CONSTRAINT)
)FINAL;
/

CREATE OR REPLACE TYPE AgreementInt_ob UNDER Agreement_ob(
  universityManager fullname
)FINAL;
/

CREATE OR REPLACE TYPE Addendum_ob AS OBJECT (
  signatureDate date
)FINAL;
/

CREATE OR REPLACE TYPE Student_ob AS OBJECT (
  NIF VARCHAR(9),
  internalID VARCHAR(9),
  completeName fullname,
  currentStudies currentStudiesList
)FINAL;
/

CREATE OR REPLACE TYPE PDI_ob AS OBJECT(
  NIF VARCHAR(9),
  internalID VARCHAR(9),
  completeName fullname,
  department VARCHAR(30),
  incorporationDate date
)FINAL;
/

CREATE OR REPLACE TYPE Staff_ob AS OBJECT (
  NIF VARCHAR(9),
  completeName fullname
)FINAL;
/

CREATE OR REPLACE TYPE LResearch_ob AS OBJECT (
  name VARCHAR(50),
  goalsDescription VARCHAR (1000),
  startDate date,
  endDate date
)FINAL;
/

/*###############################################################################
 #                                                                              #
 #     3. DEFINIM LES ASSOCIACIONS MULTIPLES COM A TIPUS OBJECTE (AT i MT)      #
 #                                                                              #
 ##############################################################################*/

-- ######## DESCRIPCIÓ: De la mateixa manera que al pas anterior, crearem els UDT 
-- ########             (tipus objecte) necessaris per a poder referenciar les 
-- ########             associacions definides entre UDT’s:
-- ########             
-- ########             Associacions per rang: “1..n” -> Es definiran els tipus AT 
-- ########             (VARRAY) com a tipus degut a que aquests no poden ser 
-- ########             definits directament des d’un objecte.
-- ########             
-- ########             Associacions multiple: “0..*” i “1..*” -> La implementació 
-- ########             d’associacions múltiples o "multiset" es realitza mitjançant 
-- ########             la definició de taules niuades (NESTED TABLES). Concretament, 
-- ########             haurem de crear un tipus taula (TABLE TYPE) per a cada 
-- ########             associació múltiple i seguidament incloure aquest tipus a la 
-- ########             definició d’objecte (UDT). 


CREATE or REPLACE TYPE AgreementsCol2_tab AS TABLE OF AgreementCol2_ob;
/

CREATE or REPLACE TYPE AgreementsInt_tab AS TABLE OF AgreementInt_ob;
/

CREATE or REPLACE TYPE Addendums_tab AS TABLE OF Addendum_ob;
/

CREATE or REPLACE TYPE RefStudent_va AS VARRAY(5) OF REF Student_ob NOT NULL;
/

CREATE OR REPLACE TYPE RefStaff_va AS VARRAY (100) OF REF Staff_ob NOT NULL;
/

CREATE or REPLACE TYPE refLResearch_va AS VARRAY(3) OF REF LResearch_ob NOT NULL;
/

/*###############################################################################
 #                                                                              #
 #              4. IMPLEMENTACIÓ DE LES ASSOCIACIONS ALS TIPUS UDT              #
 #                                                                              #
 ##############################################################################*/

-- ########  DESCRIPCIÓ: Ara realitzem la implementació de les associacions als 
-- ########              tipus objecte UDT (classes). Concretament, haurem de 
-- ########              modificar els UDT creats al pas 2 mitjançant “ALTER TYPE 
-- ########              object_type ADD ATTRIBUTE () CASCADE” de la següent manera:
-- ########             
-- ########             Associacions úniques: “1” -> Punter (REF) a tipus UDT (classe)
-- ########             
-- ########             Associacions per rang: “1..n” -> Punter (REF) a tipus VARRAY (vector)
-- ########             
-- ########             Associacions multiple: “0..*” i “1..*” ->tipus TABLE (taula niuada)            

ALTER TYPE Addendum_ob ADD ATTRIBUTE(
  hasPDIResponsible REF PDI_ob,
  hasStaffAssigned RefStaff_va,
  hasEnrolledStudents RefStudent_va
)CASCADE;
/

ALTER TYPE PDI_ob ADD ATTRIBUTE(
  hasSpecialty REF LResearch_ob
)CASCADE;
/

ALTER TYPE AgreementCol2_ob ADD ATTRIBUTE(
  hasStakeholder REF PDI_ob,
  hasLinesOfResearch refLResearch_va
)CASCADE;
/

ALTER TYPE AgreementInt_ob ADD ATTRIBUTE(
  hasAddendums Addendums_tab
)CASCADE;
/

ALTER TYPE Company_ob ADD ATTRIBUTE(
    hasColAgreements AgreementsCol2_tab,
    hasIntAgreements AgreementsInt_tab
)CASCADE;
/

/*###############################################################################
 #                                                                              #
 #                          5. CREEM LES TAULES D'OBJECTES                      #
 #                                                                              #
 ##############################################################################*/

-- ######## DESCRIPCIÓ: finalment, crearem les taules d’objectes (implementació 
-- ########             persistent del disseny Object-Relational al ORDBMS) mitjançant 
-- ########             sentències “CREATE TABLE table OF object_type”.

CREATE TABLE companies OF Company_ob (CIF PRIMARY KEY)
  OBJECT IDENTIFIER IS PRIMARY KEY 
  NESTED TABLE hasColAgreements STORE AS hasColAgreements_nt
  NESTED TABLE hasIntAgreements STORE AS hasIntAgreements_nt
    (NESTED TABLE hasAddendums STORE AS hasAddendums_nt); 
/

CREATE TABLE PDIS OF PDI_ob (NIF PRIMARY KEY)
  /* Si ho activem passa el següent al inserir files a PDIS -> Error report -ORA-22979: cannot INSERT object view REF or user-defined REF. */
  --OBJECT IDENTIFIER IS PRIMARY KEY;
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

CREATE TABLE lResearches OF LResearch_ob (name PRIMARY KEY);
  /* Si ho activem passa el següent al inserir files a PDIS -> Error report -ORA-22979: cannot INSERT object view REF or user-defined REF. */
  --OBJECT IDENTIFIER IS PRIMARY KEY; 
/