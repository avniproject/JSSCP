import RuleHelper from "../RuleHelper";
import {
    FormElementsStatusHelper,
    FormElementStatus,
    FormElementStatusBuilder,
    RuleFactory,
    VisitScheduleBuilder
} from 'rules-config/rules';
import {albendazole} from './utils/visitSchedulingUtils';
import albendazoleTracking from '../../forms/Albendazole Tracking';

const VisitSchedule = RuleFactory(albendazoleTracking.uuid, "VisitSchedule");

@VisitSchedule('c43329ba-f1e5-4b98-8523-3d4f2d160799', 'JSSCP AlbendazoleVisitSchedule', 100.0, {})
class AlbendazoleTrackingViewFilter {
    static exec(programEncounter, visitSchedule = [], scheduleConfig) {
        let scheduleBuilder = RuleHelper.createProgramEncounterVisitScheduleBuilder(programEncounter, visitSchedule);
        RuleHelper.justSchedule(scheduleBuilder, albendazole.getVisitSchedule(albendazole.findNextSlot(programEncounter.earliestVisitDateTime)));
        return scheduleBuilder.getAll();
    }
}

export {
    AlbendazoleTrackingViewFilter
}