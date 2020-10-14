--CREATE or REPLACE TYPE Agreement_tab AS TABLE OF Agreement_ob;

CREATE or REPLACE TYPE AgreementsInt_tab AS TABLE OF AgreementInt_ob;
/

CREATE or REPLACE TYPE AgreementsTest_tab AS TABLE OF AgreementTest_ob;
/

CREATE or REPLACE TYPE Addendum_tab AS TABLE OF Addendum_ob;
/

CREATE or REPLACE TYPE RefStudent_va AS VARRAY(5) OF REF Student_ob NOT NULL;
/

CREATE OR REPLACE TYPE RefStaff_va AS VARRAY (100) OF REF Staff_ob NOT NULL;
/

CREATE or REPLACE TYPE refLResearch_va AS VARRAY(3) OF REF LResearch_ob NOT NULL;
/