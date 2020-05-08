import {AlbendazoleTrackingVisitSchedule} from "./AlbendazoleTrackingVisitSchedule";
import {RuleFactory, VisitScheduleBuilder} from "rules-config";
import defCancelForm from '../../forms/Program Encounter Cancellation Form';
import {gmp} from './utils/visitSchedulingUtils';
import moment from "moment";

const CancelVisitSchedulesAnn = RuleFactory(defCancelForm.uuid, "VisitSchedule");

class GMCancelVisitSchedule {
    static exec(programEncounter, visitSchedule = [], scheduleConfig) {
        if (!programEncounter.programEnrolment.isActive) {
            return [];
        }
        const scheduleBuilder = new VisitScheduleBuilder({
            programEnrolment: programEncounter.programEnrolment
        });
        const dayOfMonth = programEncounter.programEnrolment.findObservation("Day of month for growth monitoring visit").getValue();
        visitSchedule.forEach((vs) => scheduleBuilder.add(vs));
        const year = moment(programEncounter.earliestVisitDateTime).format("YYYY");

        // visits that are scheduled from db for nov & dec 2019 should not schedule next visit
        if (year != 2019) {
            scheduleBuilder.add(gmp.scheduleOnCancel(programEncounter.earliestVisitDateTime, dayOfMonth));
            return scheduleBuilder.getAllUnique("encounterType");
        }
    }
}

const postVisitMap = {
    'Anthropometry Assessment': GMCancelVisitSchedule,
    'Albendazole': AlbendazoleTrackingVisitSchedule
};

@CancelVisitSchedulesAnn("7d8ef038-724d-4571-8a04-6a9a0c609242", "JSSCP CancelVisitSchedules", 100.0)
class CancelVisitSchedules {
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

export {
    CancelVisitSchedules
}