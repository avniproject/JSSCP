import {AlbendazoleTrackingViewFilter} from "./AlbendazoleTrackingViewFilter";
import {RuleFactory, VisitScheduleBuilder} from "rules-config";
import defCancelForm from '../../forms/Default Program Encounter Cancellation Form';

const postVisitMap = {
    'Anthropometry Assessment': GMCancelVisitSchedule,
    'Albendazole': AlbendazoleTrackingViewFilter
};
const CancelVisitSchedulesAnn = RuleFactory(defCancelForm.uuid, "VisitSchedule");

class GMCancelVisitSchedule {
    static exec(programEncounter, visitSchedule = [], scheduleConfig) {
        if(!programEncounter.programEnrolment.isActive){
            return [];
        }
        const scheduleBuilder = new VisitScheduleBuilder({
            programEnrolment: programEncounter.programEnrolment
        });
        const scheduledDateTime = programEncounter.earliestVisitDateTime;
        const scheduledDate = moment(scheduledDateTime).date();
        const dayOfMonth = programEncounter.programEnrolment.findObservation("Day of month for growth monitoring visit").getValue();
        const monthForNextVisit = scheduledDate < dayOfMonth ? moment(scheduledDateTime).month() : moment(scheduledDateTime).month() + 1;
        const earliestDate = moment(scheduledDateTime).month(monthForNextVisit).date(dayOfMonth).toDate();
        const maxDate = moment(scheduledDateTime).month(monthForNextVisit).date(dayOfMonth).add(3, 'days').toDate();
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

@CancelVisitSchedulesAnn("f58963fe-87d5-4344-ad5e-9770f89d60cf", "JSS Growth Monitoring Next Visit", 100.0)
export class CancelVisitSchedules {
    static exec(programEncounter, visitSchedule = [], scheduleConfig) {
        let visitCancelReason = programEncounter.findCancelEncounterObservationReadableValue('Visit cancel reason');
        if (visitCancelReason === 'Program exit') {
            return visitSchedule;
        }
        let postVisit = postVisitMap[programEncounter.encounterType.name];
        if (!_.isNil(postVisit)) {
            return postVisit.exec(programEncounter, visitSchedule);
        }
        return visitSchedule;
    }
}