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

select c.businessname,
    nt.startDate AS START_DATE,
    nt.endDate AS END_DATE,
    nt.goalsDescription AS GOALS, 
    nt.extendPeriod AS EXTEND,
    nt.hasLinesOfResearch AS LINES_OF_RESEARCH,
    nt.hasStakeholder.completeName.name AS PDI_NAME,
    nt.hasStakeholder.completeName.surname1 AS PDI_SURNAMENAME
from companies c, table (c.hasColAgreements) nt;

select c.businessname, 
    nt.startDate AS START_DATE,
    nt.endDate AS END_DATE,
    nt.universityManager AS UNIV_MANAGER
from companies c, table (c.hasIntAgreements) nt;

SELECT businessname, cif, postalcode, sector FROM companies;

