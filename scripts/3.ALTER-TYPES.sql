ALTER TYPE Company_ob ADD ATTRIBUTE(
	hasAgreements Agreement_tab	
	-- Potser s'ha d'implementar referenciant directament cada subclasse en comptes de la superclasse?
		-- hasColAgreements AgreementCol_tab
		-- hasIntAgreements AgreementsInt_tab
)CASCADE;

/

ALTER TYPE AgreementCol_ob ADD ATTRIBUTE(
	hasStakeholder REF PDI_ob,
	hasLinesOfResearch refLResearch_va
)CASCADE;

/

ALTER TYPE AgreementInt_ob ADD ATTRIBUTE(
	hasAddendums Addendum_tab
)CASCADE;

/

ALTER TYPE Addendum_ob ADD ATTRIBUTE(
	hasPDIResponsible REF PDI_ob,
	hasStaffAssigned RefStaff_va,
	hasEnrolledStudents RefStudent_va
)CASCADE;

/

ALTER TYPE PDI_ob ADD ATTRIBUTE(
	hasSpecialty REF LResearch_ob
)CASCADE;

/


CREATE TABLE companies OF Company_ob 
    (PRIMARY KEY (CIF)) 
    NESTED TABLE hasAgreements STORE AS hasAgreements_nt
(NESTED TABLE testNestedTable STORE AS hasAddendums_nt); 


ORA-02320: failure in creating storage table for nested table column HASAGREEMENTS
ORA-00904: : invalid identifier
02320. 00000 -  "failure in creating storage table for nested table column %s"
*Cause:    An error occurred while creating the storage table for the
           specified nested table column.
*Action:   See the messages that follow for more details. If the situation
           they describe can be corrected, do so; otherwise contact Oracle
           Support.