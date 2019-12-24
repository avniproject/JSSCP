import {FormElementStatusBuilder, FormElementRule} from "rules-config/rules";
import BirthForm from '../../forms/Birth form';

@FormElementRule({
    name: 'JSSCP BirthViewFilter',
    uuid: 'b34cc4da-2fdd-4a07-ba19-2f1fea7cdd5c',
    formUUID: BirthForm.uuid,
    executionOrder: 100.0,
    metadata: {}
})
class BirthViewFilter {
    static exec(programEncounter, formElementGroup, today) {
        return FormElementsStatusHelper
            .getFormElementsStatusesWithoutDefaults(new BirthViewFilter(), programEncounter, formElementGroup, today);
    }

    whenDidBreastFeedingStart(programEncounter, formElement) {
        const statusBuilder = new FormElementStatusBuilder({
            programEncounter: programEncounter,
            formElement: formElement
        });
        statusBuilder.show().when.valueInEncounter("Breast feeding within 1 hour of birth").is.no;
        return statusBuilder.build();
    }

    otherBirthDefects(programEncounter, formElement) {
        const statusBuilder = new FormElementStatusBuilder({
            programEncounter: programEncounter,
            formElement: formElement
        });
        statusBuilder.show().when.valueInEncounter("Birth Defects").containsAnswerConceptName("Other");
        return statusBuilder.build();
    }

    birthWeight(programEncounter, formElement) {
        const statusBuilder = new FormElementStatusBuilder({programEncounter, formElement});
        statusBuilder.show().when.valueInEnrolment('Birth Weight').is.not.defined;
        return statusBuilder.build();
    }
}

export {
    BirthViewFilter
}