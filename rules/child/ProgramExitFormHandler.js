import {FormElementRule, FormElementStatusBuilder} from "rules-config/rules";
import ChildExitForm from '../../forms/Child Exit';

@FormElementRule({
    name: 'JSSCP Child Exit',
    uuid: '49254135-27b5-43cb-ae51-1acf99e7b9f8',
    formUUID: ChildExitForm.uuid,
    executionOrder: 100.0,
    metadata: {}
})
export class ProgramExitFormHandler {
    static exec(programExit, formElementGroup, today) {
        return FormElementsStatusHelper
            .getFormElementsStatusesWithoutDefaults(new ProgramExitFormHandler(), programExit, formElementGroup, today);
    }

    dateOfDeath(programExit, formElement) {
        const statusBuilder = this._getStatusBuilder(programExit, formElement);
        statusBuilder.show().when.valueInExit("Reason for child exit").containsAnswerConceptName("Death");
        return statusBuilder.build();
    }

    causeOfDeath(programExit, formElement) {
        const statusBuilder = this._getStatusBuilder(programExit, formElement);
        statusBuilder.show().when.valueInExit("Reason for child exit").containsAnswerConceptName("Death");
        return statusBuilder.build();
    }

    placeOfDeath(programExit, formElement) {
        const statusBuilder = this._getStatusBuilder(programExit, formElement);
        statusBuilder.show().when.valueInExit("Reason for child exit").containsAnswerConceptName("Death");
        return statusBuilder.build();
    }

    otherReasonPleaseSpecify(programExit, formElement) {
        const statusBuilder = this._getStatusBuilder(programExit, formElement);
        statusBuilder.show().when.valueInExit("Reason for child exit").containsAnswerConceptName("Other");
        return statusBuilder.build();
    }


    _getStatusBuilder(programExit, formElement) {
        return new FormElementStatusBuilder({
            programEnrolment: programExit,
            formElement
        });
    }
}