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
 #                    FILE 6 OF 6: 6-object-type-method.sql                     #
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

CREATE OR REPLACE TYPE vfinalPro AS VARRAY(5) OF VARCHAR(150);
/

CREATE OR REPLACE TYPE projstudent AS OBJECT(
  unicode INTEGER, 
  stName VARCHAR(200), 
  stSurname VARCHAR(200), 
  projectPref vfinalPro,
  MAP MEMBER FUNCTION get_top_project RETURN VARCHAR,
  MEMBER FUNCTION get_student_fullname RETURN VARCHAR
);
/

CREATE TABLE tbStudent OF projstudent (unicode PRIMARY KEY);
/
------------------------------------------------------------------------------------

CREATE OR REPLACE TYPE BODY projstudent AS 
    MAP MEMBER FUNCTION get_top_project RETURN VARCHAR IS    
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
    MEMBER FUNCTION get_student_fullname RETURN VARCHAR IS
      BEGIN
        RETURN (stName || ' ' || StSurname);
      END get_student_fullname;
END;
/

------------------------------------------------------------------------------------


INSERT INTO tbstudent VALUES (
 111111,
 'Freddie',
 'Mercury',
 vfinalPro('TFG prioritat 5','TFG prioritat 4','TFG prioritat 3','TFG prioritat 2','TFG prioritat 1')
);
 
INSERT INTO tbstudent VALUES (
 222222,
 'Jimmy',
 'Hendrix',
 vfinalPro('TFG prioritat 3','TFG prioritat 2','TFG prioritat 1','','')
);

------------------------------------------------------------------------------------


CREATE OR REPLACE TYPE projstudent_vt AS OBJECT (
  uniCode INTEGER,
  stFullName VARCHAR(200),
  topProject VARCHAR(150)
);
/

CREATE OR REPLACE VIEW
TopProjects_view OF projstudent_vt WITH OBJECT OID(uniCode) AS
  SELECT s.uniCode, s.get_student_fullname(), s.get_top_project()
  FROM tbstudent s
;
/

SELECT * FROM topProjects_view;