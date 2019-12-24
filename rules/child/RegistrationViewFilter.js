import {FormElementsStatusHelper, FormElementStatusBuilder, RuleFactory} from "rules-config";
import VILLAGE_GRAMPANCHAYAT_MAPPING from '../../data/villageGrampanchayatMapping';
import regForm from '../../forms/JSS Registration Form';

const RegistrationViewFilterAnn = RuleFactory(regForm.uuid, "ViewFilter");

@RegistrationViewFilterAnn("3f3fe5fa-b331-4ce5-8a10-a29fd6ba8f36", "JSSCP Registration View Filter", 1.0, {})
class RegistrationViewFilter {
    static exec(individual, formElementGroup) {
        return FormElementsStatusHelper
            .getFormElementsStatuses(new RegistrationViewFilter(), individual, formElementGroup);
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
    RegistrationViewFilter
}