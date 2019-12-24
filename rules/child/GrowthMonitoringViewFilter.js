import {
    FormElementRule,
    FormElementsStatusHelper,
    StatusBuilderAnnotationFactory,
    FormElementStatusBuilder,
    FormElementStatus,
} from 'rules-config/rules';
import {WithName} from "rules-config";
import moment from 'moment';
import _ from 'lodash';
import anthroAss from '../../forms/Anthropometry Assessment';

const WithStatusBuilder = StatusBuilderAnnotationFactory('programEncounter', 'formElement');

@FormElementRule({
    name: 'JSS Growth Monitoring rules',
    uuid: '074121f0-d328-498c-b940-31c087bc0e04',
    formUUID: anthroAss.uuid,
    executionOrder: 100.0,
    metadata: {}
})
class GrowthMonitoringViewFilter {
    static exec(encounter, formElementGroup, today) {
        return FormElementsStatusHelper
            .getFormElementsStatusesWithoutDefaults(new GrowthMonitoringViewFilter(), encounter, formElementGroup, today);
    }

    @WithName("Height")
    one(programEncounter, formElement) {
        if (!_.isNil(programEncounter.earliestVisitDateTime)) {
            const lastEncounterWithHeight = programEncounter.programEnrolment.findLatestPreviousEncounterWithObservationForConcept(programEncounter, "Height");
            const heightNeverCapturedBefore = _.isNil(lastEncounterWithHeight);
            const ageInMonths = programEncounter.programEnrolment.individual.getAgeInMonths(
                moment(programEncounter.earliestVisitDateTime).endOf('month').toDate(), false);
            const ageInMonthMultipleOf6 = ((ageInMonths % 6) === 0);
            const endDate = programEncounter.earliestVisitDateTime;
            const startDate = moment(programEncounter.earliestVisitDateTime).subtract((ageInMonths % 6), 'months').startOf('month').toDate();
            const encBetweenDatesWithHeight = _.chain(programEncounter.programEnrolment.encounters)
                .filter((enc) => (enc.encounterDateTime <= endDate && enc.encounterDateTime >= startDate)
                    && !_.isNil(enc.findObservation("Height")));
            const heightToBeCapturedThisTime = (heightNeverCapturedBefore || (ageInMonthMultipleOf6 && encBetweenDatesWithHeight.value().length === 0) || encBetweenDatesWithHeight.value().length === 0);
            return new FormElementStatus(formElement.uuid, heightToBeCapturedThisTime);
        } else {
            let skipCaptureHeightNotDefinedBuilder = new FormElementStatusBuilder({programEncounter, formElement});
            skipCaptureHeightNotDefinedBuilder.show().valueInEncounter("Skip capturing height").is.notDefined;
            let skipCaptureHeightNotYesBuilder = new FormElementStatusBuilder({programEncounter, formElement});
            skipCaptureHeightNotYesBuilder.show().not.valueInEncounter("Skip capturing height").is.yes;
            return new FormElementStatus(formElement.uuid, (skipCaptureHeightNotDefinedBuilder.build().visibility || skipCaptureHeightNotYesBuilder.build().visibility));
        }
    }

    @WithName("Skip capturing height")
    @WithStatusBuilder
    two([encounter], statusBuilder) {
        if (!_.isNil(encounter.earliestVisitDateTime)) {
            const monthsDiff = moment().diff(encounter.programEnrolment.individual.dateOfBirth, 'months');
            statusBuilder.show().whenItem(1 === 2).is.truthy;
        }
    }
}

export {
    GrowthMonitoringViewFilter
}