ALTER TYPE Company_ob ADD ATTRIBUTE(
    hasIntAgreements AgreementsInt_tab,
	hasTestAgreements AgreementsTest_tab
)CASCADE;
/

ALTER TYPE AgreementInt_ob ADD ATTRIBUTE(
	hasAddendums Addendum_tab
)CASCADE;
/

ALTER TYPE AgreementTest_ob ADD ATTRIBUTE(
	hasStakeholder REF PDI_ob,
	hasLinesOfResearch refLResearch_va
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