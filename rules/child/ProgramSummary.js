import {ProgramRule} from 'rules-config/rules';
import Programs from '../../programs.json';

const ChildProgram = Programs.find(x => x.name === 'Child');

@ProgramRule({
    name: "JSSCP ChildProgramSummary",
    uuid: "7846a51b-cee9-4f07-ad71-58ef8ae64e46",
    programUUID: ChildProgram.uuid,
    executionOrder: 100.0,
    metadata: {}
})
class ChildProgramSummary {
    static exec(programEnrolment, summaries, context, today) {
        summaryForObservation("Weight for age z-score", programEnrolment, summaries);
        summaryForObservation("Weight for age Grade", programEnrolment, summaries);
        summaryForObservation("Weight for age Status", programEnrolment, summaries);

        summaryForObservation("Height for age z-score", programEnrolment, summaries);
        summaryForObservation("Height for age Grade", programEnrolment, summaries);
        summaryForObservation("Height for age Status", programEnrolment, summaries);

        summaryForObservation("Weight for height z-score", programEnrolment, summaries);
        summaryForObservation("Weight for Height Status", programEnrolment, summaries);
        return summaries;
    }
}

const summaryForObservation = function (conceptName, programEnrolment, summaries) {
    let observationValue = programEnrolment.findLatestObservationInEntireEnrolment(conceptName);
    if (!_.isNil(observationValue)) {
        summaries.push({name: conceptName, value: observationValue.getValue()});
    }
};

export {
    ChildProgramSummary
}