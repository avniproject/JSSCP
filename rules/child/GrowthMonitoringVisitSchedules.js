import {RuleFactory, VisitScheduleBuilder} from "rules-config";
import moment from 'moment';
import anthropom from '../../forms/Anthropometry Assessment';
import defCancel from '../../forms/Default Program Encounter Cancellation Form';

const GMVisitScheduleAnn = RuleFactory(anthropom.uuid, "VisitSchedule");
const GMVisitScheduleCancelledAnn = RuleFactory(defCancel.uuid, "VisitSchedule");

@GMVisitScheduleAnn("d537df03-f9ac-467a-91b3-32ab0ce2589d", "JSSCP GMVisitSchedule", 100.0)
class GMVisitSchedule {
    static exec(programEncounter, visitSchedule = [], scheduleConfig) {

        //not scheduling next visit when recording unplanned visit
        if(_.isNil(programEncounter.earliestVisitDateTime)){
            return [];
        }

        const scheduleBuilder = new VisitScheduleBuilder({
            programEnrolment: programEncounter.programEnrolment
        });
        const scheduledDateTime = programEncounter.earliestVisitDateTime;
        const scheduledDate = moment(scheduledDateTime).date();
        const encounterDateTime = programEncounter.encounterDateTime;
        const dayOfMonth = programEncounter.programEnrolment.findObservation("Day of month for growth monitoring visit").getValue();
        var monthForNextVisit = moment(scheduledDateTime).month() + 1;
        var earliestDate = moment(scheduledDateTime).month(monthForNextVisit).date(dayOfMonth).toDate();
        if(moment(earliestDate).month() !== monthForNextVisit){
            earliestDate = moment(scheduledDateTime).add(1, 'M').endOf('month').toDate();
        }
        const maxDate = moment(earliestDate).add(3, 'days').toDate();
        visitSchedule.forEach((vs) => scheduleBuilder.add(vs));
        scheduleBuilder.add({
                name: "Growth Monitoring Visit",
                encounterType: "Anthropometry Assessment",
                earliestDate: earliestDate,
                maxDate: maxDate
            }
        );
        return scheduleBuilder.getAllUnique("encounterType");

    }
}

@GMVisitScheduleCancelledAnn("0cc7c4cd-335d-4caf-92f2-8bbdb2ea443e", "JSSCP GMVisitScheduleCancelled", 100.0)
class GMVisitScheduleCancelled {

    static exec(programEncounter, visitSchedule = [], scheduleConfig) {

        const scheduleBuilder = new VisitScheduleBuilder({
            programEnrolment: programEncounter.programEnrolment
        });
        const scheduledDateTime = programEncounter.earliestVisitDateTime;
        const scheduledDate = moment(scheduledDateTime).date();
        const encounterDateTime = programEncounter.encounterDateTime;
        const dayOfMonth = programEncounter.programEnrolment.findObservation("Day of month for growth monitoring visit").getValue();
        var monthForNextVisit = moment(scheduledDateTime).month() + 1;
        var earliestDate = moment(scheduledDateTime).month(monthForNextVisit).date(dayOfMonth).toDate();
        if(moment(earliestDate).month() !== monthForNextVisit){
            earliestDate = moment(scheduledDateTime).add(1, 'M').endOf('month').toDate();
        }
        const maxDate = moment(earliestDate).add(3, 'days').toDate();
        visitSchedule.forEach((vs) => scheduleBuilder.add(vs));
        scheduleBuilder.add({
                name: "Growth Monitoring Visit",
                encounterType: "Anthropometry Assessment",
                earliestDate: earliestDate,
                maxDate: maxDate
            }
        );
        return scheduleBuilder.getAllUnique("encounterType");
    }
}
export {
    GMVisitSchedule,
    GMVisitScheduleCancelled
}