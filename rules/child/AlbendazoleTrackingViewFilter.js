import RuleHelper from "../RuleHelper";
import {
    FormElementsStatusHelper,
    FormElementStatus,
    FormElementStatusBuilder,
    RuleFactory,
    VisitScheduleBuilder
} from 'rules-config/rules';
import {albendazole} from './visitSchedulingUtils';
import albendazoleTracking from '../../forms/Albendazole Tracking';

const VisitSchedule = RuleFactory(albendazoleTracking.uuid, "VisitSchedule");

@VisitSchedule('f40332d7-c880-43ef-8036-f5dc51c26426', 'JSSCP AlbendazoleVisitSchedule', 100.0, {})
export class AlbendazoleTrackingViewFilter {
    static exec(programEncounter, visitSchedule = [], scheduleConfig) {
        let scheduleBuilder = RuleHelper.createProgramEncounterVisitScheduleBuilder(programEncounter, visitSchedule);
        RuleHelper.justSchedule(scheduleBuilder, albendazole.getVisitSchedule(albendazole.findNextSlot(programEncounter.earliestVisitDateTime)));
        return scheduleBuilder.getAll();
    }
}