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
 #                                                                              #
 #  INPUT:                                                                      #
 #                                                                              #
 #  N/A                                                                         #
 #                                                                              #
 #                                                                              #
 #  OUTPUT:                                                                     #
 #                                                                              #
 #  Summary at /proc/traceexit showing the amount of times every exit code      #
 #  that has been invocated since the kernel module activation.                 #
 #                                                                              #
 #                                                                              #
 #  USAGE:                                                                      #
 #                                                                              #
 #  See examples/usage.txt                                                      #
 #                                                                              #
 ################################################################################


 _.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(


 ################################################################################
 #                                                                              #
 #                       1. INCLUDES, CONSTANTS & GLOBALS                       #
 #                                                                              #
 ##############################################################################*/



/* 1. DEFINIM ELS TIPUS UDT */

/* 1.1. boolean UDT 

--A ORACLE NO DISPOSEM DE TIPUS BOOL PREDEFINIT -> https://stackoverflow.com/questions/14731971/create-boolean-attribute-in-oracle

CREATE TYPE boolean AS OBJECT (
	boolvar NUMBER(1) NOT NULL 
);*/

--(RECORDAR AFEGIR EL CHECK SEGUENT AL CREAR UNA TAULA QUE UTILITZI EL TIPUS:

--CHECK (value IN (0,1))

/* 1.2. fullname UDT */
CREATE TYPE fullname AS OBJECT (
	name VARCHAR(30),
	surname1 VARCHAR(50),
	surname2 VARCHAR(50)
);

/* 1.3. currentStudiesList Collection type (VARRAY) */
CREATE TYPE currentStudiesList AS VARRAY(10) OF VARCHAR(30);

/* 2. DEFINIM LES CLASSES DEL DIAGRAMA UML COM A TIPUS UDT */

/* 2.1. CLASSE "University" */

CREATE TYPE University_objtyp AS OBJECT(
	name VARCHAR(100)
)FINAL;

--TO-DO: Composition -> es pot implementar amb una taula niuada (NESTED TABLE)

/* 2.2. CLASSE "Company" */

CREATE TYPE Company_objtyp AS OBJECT(
	CIF VARCHAR(9),
	bussinessName VARCHAR(100),
	postalCode INT,
	sector VARCHAR(100),
    univ_ref REF University_objtyp, --IMPLEMENTACIÓ D'INTEGRITAT REFERENCIAL -> (* - 1)
)FINAL;

/* 2.3. CLASSE ABSTRACTA "Agreement" -> CLASSE ASSOCIATIVA. VEURE COM IMPLEMENTAR A PAGS. 68-70 DE "http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.84.7855&rep=rep1&type=pdf */*/
CREATE TYPE Agreement_objtyp AS OBJECT (
	--REF TO University_objtyp
    --REF TO Company_objtyp
	startDate date,
	endDate date
)NOT FINAL NOT INSTANTIABLE;

/* 2.4. SUBCLASSE "AgreementCol" */
CREATE TYPE AgreementCol_objtyp UNDER Agreement (
	goalsDescription VARCHAR(1000),
	extendPeriod VARCHAR(1) --IMPLEMENTACIÓ CUTRE DE BOOLEAN. MILLOR CREAR UN TYPE AMB CHECK(Y,N) i NOT NULL
)FINAL;

/* 2.5. SUBCLASSE "AgreementInt" */

CREATE TYPE AgreementInt_objtyp UNDER Agreement (
	universityManager fullname,
)FINAL;

/* 2.6. CLASSE "PDI" */

CREATE TYPE PDI_objtyp AS OBJECT (
	NIF VARCHAR(9),
	internalID VARCHAR(9),
	completeName fullname,
	department VARCHAR(30),
	incorporationDate date
)FINAL;

/* 2.7. CLASSE "Student" */

CREATE TYPE Student_objtyp AS OBJECT (
	NIF VARCHAR(9),
	internalID VARCHAR(9),
	completeName fullname,
	currentStudies currentStudiesList
)FINAL;

/* 2.8. CLASSE "LResearch" */

CREATE TYPE LResearch_objtyp AS OBJECT (
	name VARCHAR(50),
	goalsDescription VARCHAR (1000),
	startDate date,
	endDate date
)FINAL;

/* 2.9. CLASSE "Staff" */

CREATE TYPE Staff_objtyp AS OBJECT (
	NIF VARCHAR(9),
	completeName fullname
)FINAL;

/* 2.10. CLASSE "Addendum" */

CREATE TYPE Addendum_objtyp AS OBJECT (
	signatureDate date
)FINAL;
