import {FormElementsStatusHelper, FormElementStatusBuilder, RuleFactory} from "rules-config";
import regForm from '../../forms/JSSCP Registration Form';

const RegistrationViewFilterAnn = RuleFactory(regForm.uuid, "ViewFilter");

@RegistrationViewFilterAnn("3f3fe5fa-b331-4ce5-8a10-a29fd6ba8f36", "JSSCP Registration View Filter", 1.0, {})
class RegistrationViewFilter {
    static exec(individual, formElementGroup) {
        return FormElementsStatusHelper
            .getFormElementsStatuses(new RegistrationViewFilter(), individual, formElementGroup);
    }

    otherSubCastePleaseSpecify(individual, formElement) {
        const statusBuilder = this._getStatusBuilder(individual, formElement);
        statusBuilder.show().when.valueInRegistration("Sub Caste").containsAnswerConceptName("Other");
        return statusBuilder.build();
    }

    landArea(individual, formElement) {
        const statusBuilder = this._getStatusBuilder(individual, formElement);
        statusBuilder.show().when.valueInRegistration("Land possession").containsAnswerConceptName("Yes");
        return statusBuilder.build();
    }

    otherPropertyPleaseSpecify(individual, formElement) {
        const statusBuilder = this._getStatusBuilder(individual, formElement);
        statusBuilder.show().when.valueInRegistration("Property").containsAnswerConceptName("Other");
        return statusBuilder.build();
    }

    _getStatusBuilder(individual, formElement) {
        return new FormElementStatusBuilder({individual, formElement});
    }
}

export {
    RegistrationViewFilter
}