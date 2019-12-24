import {FormElementsStatusHelper, RuleFactory} from "rules-config/rules";
import {FormElementStatusBuilder} from "rules-config";

const EnrolmentChecklists = RuleFactory("1608c2c0-0334-41a6-aab0-5c61ea1eb069", "Checklists");

@EnrolmentChecklists("5cd0bf6d-1e62-499b-80f4-c72538992abb", "Child vaccination schedule", 1.0)
export class ChildVaccinationChecklist {
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
