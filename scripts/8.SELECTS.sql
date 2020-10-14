/* COMPROVEM QUE LES NOVES FILES DE SUBTIPUS AGREEMENTCOL AFEGIDA A LA TAULA NIUADA D'OBJECTES 
DE TIPUS AGREEMENT CONTENEN ATRIBUTS CORRESPONENTS AL SUBTIPUS MITJANÇANT LA SENTENCIA "TREAT" */
--select treat(value(t1) as subtype_t).attribute from table t1;

select c.businessname, 
    treat(value(nt) as AgreementCol_ob).goalsDescription AS GOALS, 
    treat(value(nt) as AgreementCol_ob).extendPeriod AS EXTEND,
    treat(value(nt) as AgreementCol_ob).hasLinesOfResearch AS LINES_OF_RESEARCH,
    treat(value(nt) as AgreementCol_ob).hasStakeholder.completeName.name AS PDI_NAME,
    treat(value(nt) as AgreementCol_ob).hasStakeholder.completeName.surname1 AS PDI_SURNAMENAME
from companies c, table (c.hasAgreements) nt;


CREATE INDEX agreements_idx ON hasAgreements_nt(startDate);
