import {FormElementsStatusHelper, FormElementStatusBuilder, RuleFactory} from "rules-config";
import VILLAGE_GRAMPANCHAYAT_MAPPING from '../../shared/data/villageGrampanchayatMapping';

const RegistrationViewFilter = RuleFactory("e0b78ca2-1205-4e84-9f9b-d97c9b78a917", "ViewFilter");

@RegistrationViewFilter("c2e89483-4bdd-4d39-adf3-88a69579d07d", "JSS Registration View Filter", 1.0, {})
class RegistrationHandlerJSS {
    static exec(individual, formElementGroup) {
        return FormElementsStatusHelper
            .getFormElementsStatuses(new RegistrationHandlerJSS(), individual, formElementGroup);
    }

    gramPanchayat(individual, formElement) {
        const statusBuilder = this._getStatusBuilder(individual, formElement);
        var villageGrampanchayatMappingClone = new Map(VILLAGE_GRAMPANCHAYAT_MAPPING);
        var notToRemove = villageGrampanchayatMappingClone.get(individual.lowestAddressLevel.name);
        villageGrampanchayatMappingClone.delete(individual.lowestAddressLevel.name);
        var oldflatten = _.flatten([...villageGrampanchayatMappingClone.values()]).filter((p) => !_.isEmpty(p));

        const flatten = oldflatten.filter((val) => val !== notToRemove);
        statusBuilder.skipAnswers.apply(statusBuilder, flatten);
        return statusBuilder.build();
    }

    otherGramPanchayatPleaseSpecify(individual, formElement) {
        const statusBuilder = this._getStatusBuilder(individual, formElement);
        statusBuilder.show().when.valueInRegistration("Gram panchayat").containsAnswerConceptName("Other");
        return statusBuilder.build();
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
    RegistrationHandlerJSS
}