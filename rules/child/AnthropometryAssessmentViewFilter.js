import {FormElementStatusBuilder, FormElementRule, FormElementsStatusHelper} from "rules-config/rules";
import AAForm from '../../forms/Anthropometry Assessment';

@FormElementRule({
    name: 'JSSCP AnthropometryAssessmentViewFilter',
    uuid: '46058460-f776-413c-90af-b64959d6b732',
    formUUID: AAForm.uuid,
    executionOrder: 100.0,
    metadata: {}
})
class AnthropometryAssessmentViewFilter {
    static exec(programEncounter, formElementGroup, today) {
        return FormElementsStatusHelper
            .getFormElementsStatusesWithoutDefaults(new AnthropometryAssessmentViewFilter(), programEncounter, formElementGroup, today);
    }

    height(programEncounter, formElement) {
        const statusBuilder = new FormElementStatusBuilder({
            programEncounter: programEncounter,
            formElement: formElement
        });
        statusBuilder.show().when.valueInEncounter("Skip capturing height").is.notDefined;
        return statusBuilder.build();
    }

    reasonForSkippingHeightCapture(programEncounter, formElement) {
        const statusBuilder = new FormElementStatusBuilder({
            programEncounter: programEncounter,
            formElement: formElement
        });
        statusBuilder.show().when.valueInEncounter("Skip capturing height").is.yes;
        return statusBuilder.build();
    }
}

export {
    AnthropometryAssessmentViewFilter
}