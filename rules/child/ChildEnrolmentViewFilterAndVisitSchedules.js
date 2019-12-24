import {FormElementsStatusHelper, FormElementStatusBuilder, RuleFactory, VisitScheduleBuilder} from "rules-config";
import {albendazole} from "./visitSchedulingUtils";
import VILLAGE_PHULWARI_MAPPING from '../../data/villagePhulwariMapping';
import childEnrolment from '../../forms/Child Enrolment';

const EnrolmentViewFilter = RuleFactory(childEnrolment.uuid, "ViewFilter");
const EnrolmentVisitSchedule = RuleFactory(childEnrolment.uuid, "VisitSchedule");

@EnrolmentViewFilter("520bf19c-cce8-4db5-8ab8-1b8ad57d0b75", "JSS Child Enrolment View Filter", 10.0)
export class ChildEnrolmentViewFilter {
    static exec(programEnrolment, formElementGroup) {
        return FormElementsStatusHelper
            .getFormElementsStatusesWithoutDefaults(new ChildEnrolmentViewFilter(), programEnrolment, formElementGroup);
    }

    provideBirthWeight(programEnrolment, formElement) {
        const statusBuilder = this._getStatusBuilder(programEnrolment, formElement);
        statusBuilder.show().when.valueInEnrolment('Registration at child birth').is.yes;
        return statusBuilder.build();
    }

    provideCurrentWeight(programEnrolment, formElement) {
        const statusBuilder = this._getStatusBuilder(programEnrolment, formElement);
        statusBuilder.show().when.valueInEnrolment('Registration at child birth').is.no;
        return statusBuilder.build();
    }

    pleaseSelectTheDisabilities(programEnrolment, formElement) {
        const statusBuilder = this._getStatusBuilder(programEnrolment, formElement);
        statusBuilder.show().when.valueInEnrolment("Is there any developmental delay or disability seen?").containsAnswerConceptName("Yes");
        return statusBuilder.build();
    }

    chronicIllness(programEnrolment, formElement) {
        const statusBuilder = this._getStatusBuilder(programEnrolment, formElement);
        statusBuilder.show().when.valueInEnrolment("Chronic Illness").containsAnswerConceptName("Yes");
        return statusBuilder.build();
    }


    enrolTo(programEnrolment, formElement) {
        const statusBuilder = this._getStatusBuilder(programEnrolment, formElement);
        var villagePhulwariMappingClone = new Map(VILLAGE_PHULWARI_MAPPING);
        var notToRemove = villagePhulwariMappingClone.get(programEnrolment.individual.lowestAddressLevel.name);
        villagePhulwariMappingClone.delete(programEnrolment.individual.lowestAddressLevel.name);

        var oldflatten = _.flatten([...villagePhulwariMappingClone.values()]).filter((p) => !_.isEmpty(p));

        const flatten = _.difference(oldflatten, notToRemove);
        statusBuilder.skipAnswers.apply(statusBuilder, flatten);
        return statusBuilder.build();
    }


    _getStatusBuilder(programEnrolment, formElement) {
        return new FormElementStatusBuilder({programEnrolment, formElement});
    }
}

@EnrolmentVisitSchedule("4603fabd-b1f0-4106-9673-2ce397cbdf2c", "JSS Growth Monitoring First Visit", 100.0)
export class ChildEnrolmentVisitSchedules {
    static exec(programEnrolment, visitSchedule = [], scheduleConfig) {
        const scheduleBuilder = new VisitScheduleBuilder({
            programEnrolment: programEnrolment
        });
        const earliestDate = programEnrolment.enrolmentDateTime;
        const maxDate = programEnrolment.enrolmentDateTime;
        visitSchedule.forEach((vs) => scheduleBuilder.add(vs));
        scheduleBuilder.add({
                name: "Growth Monitoring Visit",
                encounterType: "Anthropometry Assessment",
                earliestDate: earliestDate,
                maxDate: maxDate
            }
        );
        scheduleBuilder.add(albendazole.getVisitSchedule(albendazole.findSlot(programEnrolment.enrolmentDateTime)));
        return scheduleBuilder.getAllUnique("encounterType");
    }
}