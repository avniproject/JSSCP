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
        //Child program summaries are added from core so deleting from here
        //otherwise it shows same name two times in program summary
        return summaries;
    }
}

export {
    ChildProgramSummary
}