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

CREATE TYPE vfinalPro AS VARRAY(5) OF VARCHAR(150);
/

CREATE OR REPLACE TYPE projstudent AS OBJECT(
  unicode INTEGER, 
  stName VARCHAR(200), 
  stSurname VARCHAR(200), 
  projectPref vfinalPro,
  --MEMBER PROCEDURE display_top_project (SELF IN OUT NOCOPY projstudent),
  MAP MEMBER FUNCTION get_top_project RETURN VARCHAR
);
/

CREATE TABLE tbStudent OF projstudent (unicode PRIMARY KEY);
/
------------------------------------------------------------------------------------

/* V1 */

/*

CREATE OR REPLACE TYPE BODY projstudent AS 
  MAP MEMBER FUNCTION get_top_project RETURN VARCHAR IS 
   BEGIN
     RETURN projectPref(5); --DE MOMENT SUPOSEM QUE SEMPRE HI HAURÀ 5 PROPOSTES DE TREBALL FINAL. SI EM DONA TEMPS IMPLEMENTARÉ UN LOOP QUE VAGI COMPROVANT, DES DE LA DARRERA FINS LA PRIMERA POSICIÓ DEL VARRAY, SI AQUEST CONTÉ UN VALOR NUL. SI = NUL; INDEX--; SINO RETURN PROJECTPREF[INDEX]. SEMPRE SUPOSAREM QUE AL MENYS HI HA UNA PROPOSTA DE TREBALL 
   END;
END;
/

*/

/* V2 */

CREATE OR REPLACE TYPE BODY projstudent AS 
  MAP MEMBER FUNCTION get_top_project RETURN VARCHAR IS    
    --i INT := 0;
  BEGIN
    <<bucle>>
    FOR i IN REVERSE 1..5 
    LOOP
      IF ( projectPref(i) IS NOT NULL ) THEN
        RETURN projectPref(i);
      END IF;
    END LOOP bucle;
    RETURN 'NO RECORDS FOUND';
  END get_top_project;
END;
/

------------------------------------------------------------------------------------


INSERT INTO tbstudent VALUES (
 111111,
 'Freddie',
 'Mercury',
 vfinalPro('treb_pr5','treb_pr4','treb_pr3','treb_pr2','treb_pr1')
);
 
INSERT INTO tbstudent VALUES (
 222222,
 'Jimmy',
 'Hendrix',
 vfinalPro('treb_pr3','treb_pr2','treb_pr1','','')
);

------------------------------------------------------------------------------------



--SELECT ts.get_top_project() from tbStudent ts;

------------------------------------------------------------------------------------

CREATE OR REPLACE TYPE projstudent_vt AS OBJECT (
  uniCode INTEGER,
  stName VARCHAR(200),
  topProject VARCHAR(150)
);
/

CREATE OR REPLACE VIEW
TopProjects_view OF projstudent_vt WITH OBJECT OID(uniCode) AS
  SELECT s.uniCode, s.stName, s.get_top_project()
  FROM tbstudent s
;
/

SELECT * FROM topProjects_view;



















