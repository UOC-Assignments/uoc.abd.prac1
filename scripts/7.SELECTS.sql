/* DEPRECATED IN v6B - 
COMPROVEM QUE LES NOVES FILES DE SUBTIPUS AGREEMENTCOL AFEGIDA A LA TAULA NIUADA D'OBJECTES 
DE TIPUS AGREEMENT CONTENEN ATRIBUTS CORRESPONENTS AL SUBTIPUS MITJANÇANT LA SENTENCIA "TREAT" */
--select treat(value(t1) as subtype_t).attribute from table t1;

/* select c.businessname, 
    treat(value(nt) as AgreementCol_ob).goalsDescription AS GOALS, 
    treat(value(nt) as AgreementCol_ob).extendPeriod AS EXTEND,
    treat(value(nt) as AgreementCol_ob).hasLinesOfResearch AS LINES_OF_RESEARCH,
    treat(value(nt) as AgreementCol_ob).hasStakeholder.completeName.name AS PDI_NAME,
    treat(value(nt) as AgreementCol_ob).hasStakeholder.completeName.surname1 AS PDI_SURNAMENAME
from companies c, table (c.hasAgreements) nt; */

/* SELECCIONAR ALGUNES COLUMNES DE CADA FILA DE LA TAULA NIUADA "hasColAgreements_nt" 

BUG #002 -> SI NO S'EXECUTA DOS COPS LA CONSULTA, LES DADES DEL VARRAY "hasLinesOfResearch" 
apareixen com a null (potser indexar ajuda, o declarar clau primaria com a object id)
*/

/* 1. Colaboration Agreements: SELECT ROWS FROM NESTED TABLE (companies.hasColAgreements_nt) */

select c.businessname,
    nt.startDate AS START_DATE,
    nt.endDate AS END_DATE,
    nt.goalsDescription AS GOALS, 
    nt.extendPeriod AS EXTEND,
    nt.hasLinesOfResearch AS LINES_OF_RESEARCH,
    nt.hasStakeholder.completeName.name AS PDI_NAME,
    nt.hasStakeholder.completeName.surname1 AS PDI_SURNAMENAME
from companies c, table (c.hasColAgreements) nt;

/* 2. Internship Agreements: SELECT ROWS FROM MULTILEVEL NESTED TABLE - OUTER TABLE (companies.hasIntAgreements_nt) */

select c.businessname, 
    nt.startDate AS START_DATE,
    nt.endDate AS END_DATE,
    nt.universityManager AS UNIV_MANAGER,
    nt.hasAddendums AS ADDENDUMS_NT
from companies c, table (c.hasIntAgreements) nt;

/* 3. Internship Agreements - Related Addendums: SELECT ROWS FROM MULTILEVEL NESTED TABLE - INNER TABLE (companies.hasIntAgreements.hasAddendums_nt) */

select c.businessName AS COMPANY,
    nt1.universityManager AS UNIV_MANAGER,
    nt2.hasPDIResponsible AS PDI_RESPONSIBLE,
    nt2.hasStaffAssigned AS STAFF,
    nt2.hasEnrolledStudents AS STUDENTS
from companies c, table (c.hasIntAgreements) nt1, table (nt1.hasAddendums) nt2
where c.businessname like 'IBM' AND nt1.startDate = '01/January/2015' AND nt1.endDate = '01/January/2020';