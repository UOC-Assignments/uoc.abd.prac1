CREATE or REPLACE TYPE Agreement_tab AS TABLE OF Agreement_ob;

/

CREATE or REPLACE TYPE Addendum_tab AS TABLE OF Addendum_ob;

/

CREATE or REPLACE TYPE Student_va AS VARRAY(5) OF Student_ob NOT NULL;

/

CREATE or REPLACE TYPE PDI_tab AS TABLE OF PDI_ob;

/

CREATE OR REPLACE TYPE Staff_va AS VARRAY (100) OF Staff_ob NOT NULL;

/

CREATE or REPLACE TYPE refLResearch_va AS VARRAY(3) OF REF LResearch_ob NOT NULL;

/