import {FormElementRule, FormElementsStatusHelper, FormElementStatus,} from 'rules-config/rules';
import DefCancelForm from '../../forms/Default Program Encounter Cancellation Form';

@FormElementRule({
    name: 'JSSCP CancellationFormFilters',
    uuid: '17b68675-f261-47d4-8d93-414ac37bf330',
    formUUID: DefCancelForm.uuid,
    executionOrder: 100.0,
    metadata: {}
})
class CancellationFormFilters {
    static exec(encounter, formElementGroup, today) {
        return FormElementsStatusHelper
            .getFormElementsStatusesWithoutDefaults(new CancellationFormFilters(), encounter, formElementGroup, today);
    }

    otherReason(programEncounter, formElement) {
        const cancelReasonObs = programEncounter.findCancelEncounterObservation('Visit cancel reason');
        const answer = cancelReasonObs && cancelReasonObs.getReadableValue();
        return new FormElementStatus(formElement.uuid, answer === 'Other');
    }

}

export {
    CancellationFormFilters
}