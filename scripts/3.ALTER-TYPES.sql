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
	hasStaffAssigned Staff_va,
	hasEnrolledStudents Student_va,
	hasPDIResponsible REF PDI_ob
)CASCADE;

/

ALTER TYPE PDI_ob ADD ATTRIBUTE(
	hasSpecialty REF LResearch_ob
)CASCADE;

/