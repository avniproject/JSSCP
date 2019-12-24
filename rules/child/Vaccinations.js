import {FormElementsStatusHelper, RuleFactory} from "rules-config/rules";
import {FormElementStatusBuilder} from "rules-config";
import ChildEnrolmentForm from '../../forms/Child Enrolment';

const EnrolmentChecklists = RuleFactory(ChildEnrolmentForm.uuid, "Checklists");

@EnrolmentChecklists("fb060d4f-6b75-434e-b398-587d04e765bf", "Child vaccination schedule", 1.0)
class ChildVaccinationChecklist {
    static exec(enrolment, checklistDetails) {
        const vaccinationDetails = checklistDetails.find(cd => cd.name === 'Vaccination');
        if (vaccinationDetails === undefined) return [];
        const vaccinationList = {
            baseDate: enrolment.individual.dateOfBirth,
            detail: {uuid: vaccinationDetails.uuid},
            items: vaccinationDetails.items.map(vi => ({
                detail: {uuid: vi.uuid}
            }))
        };
        return [vaccinationList];
    }
}

export {
    ChildVaccinationChecklist
}