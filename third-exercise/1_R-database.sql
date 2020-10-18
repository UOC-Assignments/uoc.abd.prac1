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
 #  DESCRIPTION: Oracle SQL Script that creates an object-view from attributes  # 
 #  contained in relational tables                                              #
 #                                                                              #
 ################################################################################


 _.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(


/*###############################################################################
 #                                                                              #
 #                            1. RELATIONAL DB PROVIDED                         #
 #                                                                              #
 ##############################################################################*/

CREATE TABLE studies ( 
  stCode VARCHAR(5) NOT NULL, 
  stName VARCHAR(200) NOT NULL, 
  CONSTRAINT studiestPK PRIMARY KEY (stCode) 
);
/

CREATE TABLE professors ( 
  uniCode INTEGER NOT NULL, 
  pfName VARCHAR(200), 
  pfSurname VARCHAR(200),
  CONSTRAINT professorPK PRIMARY KEY(uniCode)

);
/

CREATE TABLE finalProjects ( 
  title VARCHAR(150) NOT NULL, 
  uniCode INTEGER NOT NULL, 
  course VARCHAR(15), CONSTRAINT 
  professorFK FOREIGN KEY (uniCode) REFERENCES professors (uniCode)
);
/

/*###############################################################################
 #                                                                              #
 #                              2. ALTER RELATIONAL DB                          #
 #                                                                              #
 ##############################################################################*/

-- ######## DESCRIPCIÓ: En primer lloc observem que no existeix cap mecanisme 
-- ######## (relació) per a enregistrar els professors que imparteixen un estudi 
-- ######## en concret. Tampoc hi ha cap mecanisme (PK) per a impedir que dos 
-- ######## treballs finals d’un mateix curs i professor s’anomenin tinguin el 
-- ######## mateix títol. Per tant, abans de mapejar la BD relacional al model 
-- ######## objecte-relacional, afegirem les modificacions corresponents . 

ALTER TABLE professors ADD (stCode VARCHAR(5) NOT NULL);
/

ALTER TABLE professors ADD CONSTRAINT studyPK FOREIGN KEY(stCode) REFERENCES Studies (stCode); 
/

ALTER TABLE FinalProjects ADD CONSTRAINT finalProjectPK PRIMARY KEY(title, uniCode, course); 
/

/*###############################################################################
 #                                                                              #
 #                          3. OBJECT-RELATIONAL MAPPING                        #
 #                                                                              #
 ##############################################################################*/

-- ######## DESCRIPCIÓ: First, we must create an object type mapping the relational 
-- ######## data we want to manipulate mirroring the object-oriented features. 

CREATE OR REPLACE TYPE FinalProjects_t AS OBJECT (
  stCode VARCHAR(5),
  stName VARCHAR(200),
  pfName VARCHAR(200), 
  pfSurname VARCHAR(200),
  title VARCHAR(150), 
  course VARCHAR(15)
);
/

/*###############################################################################
 #                                                                              #
 #                                 4. TRIVIAL INSERTS                           #
 #                                                                              #
 ##############################################################################*/

INSERT INTO studies VALUES (
 '05607',
 'Database Architecture'
);

INSERT INTO studies VALUES (
 '05577',
 'Disseny de Sistemes Oeratius'
);

INSERT INTO professors VALUES (
 11111,
 'Maria Teresa',
 'Bordas Garcia',
 '05607'
);

INSERT INTO professors VALUES (
 222222,
 'Enric',
 'Morancho Llena',
 '05577'
);

INSERT INTO finalProjects VALUES (
 'Disseny duna base de dades orientada a objectes i dun TAD en java que realitza operacions sobre la BD',
 11111,
 'Tardor 2020/21'
);

/*###############################################################################
 #                                                                              #
 #                               5. CREATE OBJECT VIEW                          #
 #                                                                              #
 ##############################################################################*/

-- ######## DESCRIPCIÓ: La query realitzada durant la invocació de la vista permet
-- ######## mapar els atributs originals continguts a la BD relacional en els 
-- ######## atributs del tipus objecte "FinalProjects_t"

CREATE OR REPLACE VIEW
FinalProjects_view OF FinalProjects_t WITH OBJECT OID(stCode) AS
  SELECT 
          s.stCode AS STUDIES_CODE,
          s.stName AS STUDIES_NAME,
          p.pfName AS PROFESSOR_NAME,
          p.pfSurname AS PROFESSOR_SURNAME,
          f.title AS PROJECT_TITLE,
          f.course AS PROJECT_COURSE
  FROM    studies s, professors p, finalProjects f 
  WHERE   f.uniCode = p.uniCode AND p.stCode = s.stCode
;
/


/*###############################################################################
 #                                                                              #
 #                                 6. RUN OBJECT VIEW                           #
 #                                                                              #
 ##############################################################################*/

-- ######## DESCRIPCIÓ: Fent un SELECT podem invocar la object-view

SELECT * FROM FinalProjects_view;
