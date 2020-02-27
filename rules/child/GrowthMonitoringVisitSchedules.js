import {RuleFactory, VisitScheduleBuilder} from "rules-config";
import AnthropometryAssessmentForm from '../../forms/Anthropometry Assessment';
import {gmp} from '../../rules/child/utils/visitSchedulingUtils';
import moment from "moment";

const GMVisitScheduleAnn = RuleFactory(AnthropometryAssessmentForm.uuid, "VisitSchedule");

@GMVisitScheduleAnn("d537df03-f9ac-467a-91b3-32ab0ce2589d", "JSSCP GMVisitSchedule", 100.0)
class GMVisitSchedule {
    static exec(programEncounter, visitSchedules = [], scheduleConfig) {
        //not scheduling next visit when recording unplanned visit
        if (_.isNil(programEncounter.earliestVisitDateTime)) {
            return [];
        }

        const scheduleBuilder = new VisitScheduleBuilder({
            programEnrolment: programEncounter.programEnrolment
        });

        const dayOfMonth = programEncounter.programEnrolment.findObservation("Day of month for growth monitoring visit").getValue();
        visitSchedules.forEach((vs) => scheduleBuilder.add(vs));
        const year = moment(programEncounter.earliestVisitDateTime).format("YYYY");
       // visits that are scheduled from db for nov & dec 2019 should not schedule next visit
        if (year != 2019) {
            scheduleBuilder.add(gmp.scheduleNext(programEncounter.earliestVisitDateTime, dayOfMonth));
            return scheduleBuilder.getAllUnique("encounterType");
        }


    }
}

export {
    GMVisitSchedule
}