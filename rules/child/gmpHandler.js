import {RuleFactory, VisitScheduleBuilder} from "rules-config";
import moment from 'moment';

const GMVisitSchedule = RuleFactory("d062907a-690c-44ca-b699-f8b2f688b075", "VisitSchedule");
const GMVisitScheduleCan = RuleFactory("aac5c57a-aa01-49bb-ad20-70536dd2907f", "VisitSchedule");

@GMVisitSchedule("44160e78-23fc-46c1-8764-4c84a5847522", "JSS Growth Monitoring Recurring Visit", 100.0)
class GMVisitScheduleJSS {
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

@GMVisitScheduleCan("9f3b2ad9-ece4-4e99-b56a-4d2b8a183aa9", "JSS Growth Monitoring Cancel Visit", 100.0)
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
    GMVisitScheduleJSS,
    GMVisitScheduleCancelled
}
