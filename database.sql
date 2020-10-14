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
 #                       GIT REPO: UOC-Assignments/uoc.abd.prac1"               #
 #                    FILE 1 OF 3: database.sql                                 #
 #                        VERSION: 1.0                                          #
 #                                                                              #
 ################################################################################

 ################################################################################
 #                                                                              #
 #  DESCRIPTION:                                                                #
 #                                                                              #
 #  Implement a Linux Kernel module that keeps track of every exit system call  #
 #  executed and also allows access to a summary from user space (interfacing   #
 #  via procfs).                                                                #
 #                                                                              #
 #                                                                              #
 #  IMPLEMENTATION STRATEGY:                                                    #
 #                                                                              #
 #  Exit System calls monitoring                                                #
 #                                                                              #
 #  In regards to the exit syscall codes monitoring, we only have to call the   #
 #  low-level assembler code which performs the sys_exit call associated tasks  #
 #  from within a new function (new_sys_exit) and then link it to the system    #
 #  calls vector (sys_call_table). Summing-up: this way we bypass the original  #
 #  sys_exit call (original_sys_exit) so we can modify its behaviour (in our    #
 #  case, to keep track of every exit system call executed once the kernel      #
 #  module becomes enabled via insmod traceexit.ko).                            #
 #                                                                              #
 #  Procfs Interface implementation                                             #
 #                                                                              #
 #  The goal is to implement a communication interface between the user memory  #
 #  space and the one associated with the kernel module, so an user will be     #
 #  able to read from the shell (user memory space) the data stored in the      #
 #  physical memory space reserved to the kernel (exit syscalls counters) via   #
 #  the procfs "virtual" interface -> cat /proc/traceexit. Writing operations   #
 #  will be performed from within the module (kernel memory space), so a        #
 #  writing interface from user to kernel space won't be needed.                #
 #                                                                              #
 ################################################################################


 _.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(


/*###############################################################################
 #                                                                              #
 #                   1. DEFINIM ELS TIPUS DE DADES PERSONALITZATS               #
 #                                                                              #
 ##############################################################################*/

-- ######## DESCRIPCIÓ: 1.	En primer lloc crearem els UDT personalitzats (tipus) 
-- ########                 que siguin estrictament necessaris per a declarar els 
-- ########                 atributs de cada UDT.

-- ######## 1.1 - UDT "boolean" (NO UTILITZAT DE MOMENT)
-- ########
-- ######## DESCRIPCIÓ: A Oracle no disposem del tipus "boolean" predefinit:
-- ########             https://stackoverflow.com/questions/14731971/create-boolean-attribute-in-oracle
-- ########             Per tant, l'haurem de definir com a tipus VARCHAR(1) i 
-- ########             seguidament establir una restricció dels valors que pot 
-- ########             tenir l'atribut "boolvar" (Y/N) amb un check a la taula 
-- ########             que utilitzi el tipus de la següent manera:
-- ########             CHECK (value IN (0,1))
-- ########
-- ######## SQL:

			CREATE OR REPLACE TYPE Boolean AS OBJECT (
				boolvar NUMBER(1) NOT NULL 
			);

-- ######## 1.2 - UDT "fullname"
-- ########
-- ######## DESCRIPCIÓ: xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx
-- ########
-- ######## SQL:

			CREATE OR REPLACE TYPE Fullname AS OBJECT (
				name VARCHAR(30),
				surname1 VARCHAR(50),
				surname2 VARCHAR(50)
			);

-- ######## 1.3 - UDT Collection (currentStudiesList VARRAY)
-- ########
-- ######## DESCRIPCIÓ: xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx
-- ########
-- ######## SQL:

			CREATE OR REPLACE TYPE CurrentStudiesList AS VARRAY(10) OF VARCHAR(30);


/*###############################################################################
 #                                                                              #
 #          2. DEFINIM LES CLASSES DEL DIAGRAMA UML COM A TIPUS OBJECTE         #
 #                                                                              #
 ##############################################################################*/ 

-- ######## DESCRIPCIÓ: Seguidament crearem els UDT (tipus objecte) corresponents 
-- ######## a cada classe amb CREATE or REPLACE TYPE className AS OBJECT sense tenir 
-- ######## en compte les associacions entre classes, és a dir, només es crearà 
-- ######## l’esquelet de classes junt als seus atributs.

-- ######## 2.1 - CLASSE "University" 
-- ########
-- ######## DESCRIPCIÓ: xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx
-- ########
-- ######## TO-DO: Composition -> es pot implementar amb una taula niuada (NESTED TABLE)
-- ########
-- ######## SQL:

			CREATE OR REPLACE TYPE University_ob AS OBJECT(
				name VARCHAR(100)
			);

-- ######## 2.2 - CLASSE "Company"
-- ########
-- ######## DESCRIPCIÓ: xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx
-- ########
-- ######## SQL: 

			CREATE OR REPLACE TYPE Company_ob AS OBJECT(
				CIF VARCHAR(9),
				bussinessName VARCHAR(100),
				postalCode INT,
				sector VARCHAR(100)
			);

-- ######## 2.3 - CLASSE ABSTRACTA "Agreement" (SUPERCLASSE NO INSTANCIABLE)
-- ########
-- ######## DESCRIPCIÓ: Classe associativa. Veure com implementar a pags. 68-70 de:
-- ########             http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.84.7855&rep=rep1&type=pdf
-- ########
-- ######## SQL:

			CREATE OR REPLACE TYPE Agreement_ob AS OBJECT(
				startDate date,
				endDate date
			)NOT FINAL;

-- ######## 2.4 - SUBCLASSE DE "Agreement" -> "AgreementCol" 
-- ########
-- ######## DESCRIPCIÓ: xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx
-- ########
-- ######## TO-DO: Atribut "extendPeriod": Implementació cutre de boolean. Millor 
-- ########        crear un type amb check(y,n) i not null
-- ########
-- ######## SQL:

			CREATE OR REPLACE TYPE AgreementCol_ob UNDER Agreement_ob(
				goalsDescription VARCHAR(1000),
				extendPeriod VARCHAR(1) 
			);

-- ######## 2.5 - SUBCLASSE DE "Agreement" -> "AgreementInt" 
-- ########
-- ######## DESCRIPCIÓ: xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx
-- ########
-- ######## SQL: 

			CREATE OR REPLACE TYPE AgreementInt_ob UNDER Agreement_ob(
				universityManager fullname
			);

-- ######## 2.6 - CLASSE "Addendum"
-- ########
-- ######## DESCRIPCIÓ: xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx
-- ########
-- ######## SQL:

			CREATE OR REPLACE TYPE Addendum_ob AS OBJECT (
				signatureDate date
			);

-- ######## 2.7 - CLASSE "Student"
-- ########
-- ######## DESCRIPCIÓ: xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx
-- ########
-- ######## SQL:

			CREATE OR REPLACE TYPE Student_ob AS OBJECT (
				NIF VARCHAR(9),
				internalID VARCHAR(9),
				completeName fullname,
				currentStudies currentStudiesList
			);

-- ######## 2.8 - CLASSE "PDI"
-- ########
-- ######## DESCRIPCIÓ: xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx
-- ########
-- ######## SQL: 

			CREATE OR REPLACE TYPE PDI_ob AS OBJECT(
				NIF VARCHAR(9),
				internalID VARCHAR(9),
				completeName fullname,
				department VARCHAR(30),
				incorporationDate date
			);

-- ######## 2.9 - CLASSE "Staff"
-- ########
-- ######## DESCRIPCIÓ: xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx
-- ########
-- ######## SQL:

			CREATE OR REPLACE TYPE Staff_ob AS OBJECT (
				NIF VARCHAR(9),
				completeName fullname
			);

-- ######## 2.10 - CLASSE "LResearch"
-- ########
-- ######## DESCRIPCIÓ: xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx
-- ########
-- ######## SQL:

			CREATE OR REPLACE TYPE LResearch_ob AS OBJECT (
				name VARCHAR(50),
				goalsDescription VARCHAR (1000),
				startDate date,
				endDate date
			);

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

-- ######## 3.1 - Tipus TABLE "Company_tab"
-- ########
-- ######## SQL:

            CREATE or REPLACE TYPE Company_tab AS TABLE OF Company_ob;

-- ######## 3.2 - Tipus TABLE "AgreementCol_tab"
-- ########
-- ######## SQL:

            CREATE or REPLACE TYPE Agreement_tab AS TABLE OF Agreement_ob;

-- ######## 3.3 - Tipus TABLE "AgreementCol_tab"
-- ########
-- ######## SQL:

            CREATE or REPLACE TYPE AgreementCol_tab AS TABLE OF AgreementCol_ob;

-- ######## 3.4 - Tipus TABLE "Addendum_tab"
-- ########
-- ######## SQL:

            CREATE or REPLACE TYPE Addendum_tab AS TABLE OF Addendum_ob;

-- ######## 3.5 - Tipus VARRAY "Student_va"
-- ########
-- ######## SQL:

            CREATE or REPLACE TYPE Student_va AS VARRAY(5) OF Student_ob;

-- ######## 3.6 - Tipus TABLE "PDI_tab"
-- ########
-- ######## SQL:

            CREATE or REPLACE TYPE PDI_tab AS TABLE OF PDI_ob;

-- ######## 3.7 - Tipus TABLE "Staff_tab"
-- ########
-- ######## SQL:

            CREATE or REPLACE TYPE Staff_tab AS TABLE OF Staff_ob;

-- ######## 3.8 - Tipus VARRAY "LResearch_va"
-- ########
-- ######## SQL:

            CREATE or REPLACE TYPE LResearch_va AS VARRAY(3) OF LResearch_ob;



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
-- ########             Associacions multiple: “0..*” i “1..*” -> Punter (REF) a tipus TABLE (taula niuada)            

-- ######## 4.1 - CLASSE "University"
-- ########
-- ######## SQL: 

			ALTER TYPE University_ob ADD ATTRIBUTE(
				hasAgreements Agreement_tab	
				-- Potser s'ha d'implementar referenciant directament cada subclasse en comptes de la superclasse:
				-- hasColAgreements AgreementCol_tab
				-- hasIntAgreements AgreementsInt_tab
			)CASCADE;

-- ######## 4.2 - CLASSE "Company"
-- ########
-- ######## SQL: 

			ALTER TYPE Company_ob ADD ATTRIBUTE(
				refAgreement REF Agreement_ob
				-- Potser s'ha d'implementar referenciant directament cada subclasse en comptes de la superclasse:
				-- refAgreementsCol REF AgreementCol_ob
				-- refIntAgreementsInt REF AgreementsInt_ob		 
			)CASCADE;

-- ######## 4.3 - CLASSE ABSTRACTA "Agreement" 
-- ########
-- ######## DESCRIPCIÓ: Classe associativa. Veure com implementar a pags. 68-70 de:
-- ########             http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.84.7855&rep=rep1&type=pdf
-- ########
-- ######## SQL:

			ALTER TYPE Agreement_ob ADD ATTRIBUTE(
				refUniversity REF University_ob,
                refCompany REF Company_ob
			)CASCADE;

-- ######## 4.4 - SUBCLASSE DE "Agreement" -> "AgreementCol" 
-- ########
-- ######## SQL:

			ALTER TYPE AgreementCol_ob ADD ATTRIBUTE(
				refPDI REF PDI_ob,
                hasLinesOfResearch LResearch_va
			)CASCADE;

-- ######## 4.5 - SUBCLASSE DE "Agreement" -> "AgreementInt" 
-- ########
-- ######## SQL:

			ALTER TYPE AgreementInt_ob ADD ATTRIBUTE(
                hasAddendums Addendum_tab
			)CASCADE;

-- ######## 4.6 - CLASSE "Addendum"
-- ########
-- ######## SQL:

			ALTER TYPE Addendum_ob ADD ATTRIBUTE(
				hasStaffAssigned Staff_tab,
                hasEnrolledStudents Student_va,
                refPDI REF PDI_ob
			)CASCADE;

-- ######## 4.7 - CLASSE "Student"
-- ########
-- ######## SQL: ERROR COMPILING!

			ALTER TYPE Student_ob ADD ATTRIBUTE(
				isEnrolledInAddendums Addendum_tab
			)CASCADE;

-- ######## 4.8 - CLASSE "PDI"
-- ########
-- ######## SQL:

			ALTER TYPE PDI_ob ADD ATTRIBUTE(
 				isEnrolledInAgreementCol AgreementCol_tab,
                isResponsibleOfAddendums Addendum_tab,
                refLOR REF LResearch_ob
			)CASCADE;

-- ######## 4.9 - CLASSE "Staff"
-- ########
-- ######## SQL: ERROR COMPILING

			ALTER TYPE Staff_ob ADD ATTRIBUTE(
				hasAddendumsAssigned Addendum_tab
			)CASCADE;

-- ######## 4.10 - CLASSE "LResearch"
-- ########
-- ######## SQL:

			ALTER TYPE LResearch_ob ADD ATTRIBUTE(
				hasSpecialists PDI_tab,
                performedByAgreements AgreementCol_tab
			)CASCADE;

/*###############################################################################
 #                                                                              #
 #                          5. CREEM LES TAULES D'OBJECTES                      #
 #                                                                              #
 ##############################################################################*/

-- ######## DESCRIPCIÓ: finalment, crearem les taules d’objectes (implementació 
-- ########             persistent del disseny Object-Relational al ORDBMS) mitjançant 
-- ########             sentències “CREATE TABLE table OF object_type”.

-- ######## 3.0 TAULA "template"

			CREATE OR REPLACE TABLE template OF type(
				foreignKey_ref REF foreignKey REFERENCES class --DEFINIM LES RELACIONS D'INTEGRITAT REFERENCIAL (REF's) 
				OBJECT IDENTIFIER IS PRIMARY KEY;
			);

-- ######## 3.1 TAULA "companies"
-- ########
-- ######## DESCRIPCIÓ: xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx
-- ########
-- ######## SQL:

			CREATE OR REPLACE TABLE companies of Company (
				PRIMARY KEY (CIF),
				OBJECT IDENTIFIER IS PRIMARY KEY;
			);

-- ######## 3.2 TAULA "universities"
-- ########
-- ######## DESCRIPCIÓ: xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx xxxxxxxxxxx xxxxxx
-- ########
-- ######## SQL:

			CREATE OR REPLACE TABLE universities of University (
				company_ref REF Company REFERENCES companies --DEFINIM LES RELACIONS D'INTEGRITAT REFERENCIAL (REF's) 
			);

