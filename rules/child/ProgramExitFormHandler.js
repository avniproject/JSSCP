import {FormElementRule, FormElementStatusBuilder, FormElementsStatusHelper} from "rules-config/rules";
import ChildExitForm from '../../forms/Child Exit';

@FormElementRule({
    name: 'JSSCP Child Exit',
    uuid: '2135d7cb-e1d2-415a-a4bf-e755f076cf50',
    formUUID: ChildExitForm.uuid,
    executionOrder: 100.0,
    metadata: {}
})
class ProgramExitFormHandler {
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
export {
    ProgramExitFormHandler
}