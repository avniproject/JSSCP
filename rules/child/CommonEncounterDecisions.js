import _ from "lodash";
import {complicationsBuilder as ComplicationsBuilder, FormElementsStatusHelper, RuleFactory} from "rules-config/rules";
import {FormElementStatusBuilder} from "rules-config";

import ChildPNCForm from '../../forms/Child PNC';
import BirhtForm from '../../forms/Birth form';
import AnthropometryAssessmentForm from '../../forms/Anthropometry Assessment';

import {immediateReferralAdvice, referralAdvice} from "./utils/referral";
import generateHighRiskConditionAdvice from "./utils/highRisk";
import {findObs, addIfRequired, getDecisions as anthropometricDecisions} from "./utils/anthropometricDecision"
import zScores from "./utils/zScoreCalculator";

const ChildPNC = RuleFactory(ChildPNCForm.uuid, "Decision");
const Birth = RuleFactory(BirhtForm.uuid, "Decision");
const Anthro = RuleFactory(AnthropometryAssessmentForm.uuid, "Decision");

@ChildPNC("79a9f14a-1e8c-40b1-850c-1ff39923b2fd", "JSSCP ChildPNCDecisions", 1.0, {})
class ChildPNCDecisions {
    static exec(programEncounter, decisions, context, today) {
        return getDecisions(programEncounter, today);
    }
}

@Birth("241078cd-49ed-4a65-a78c-65ce35007416", "JSSCP BirthDecisions", 1.0, {})
class BirthDecisions {
    static exec(programEncounter, decisions, context, today) {
        return getDecisions(programEncounter, today);
    }
}

@Anthro("4f06dc33-981a-4439-b5a6-56934c272526", "JSSCP AnthroDecisions", 1.0, {})
class AnthroDecisions {
    static exec(programEncounter, _decisions, context, today) {
        const decisions = getDecisions(programEncounter, today);
        const weight = findObs(programEncounter, "Weight");
        const height = findObs(programEncounter, "Height");

        const zScoresForChild = zScores(programEncounter.programEnrolment.individual, programEncounter.encounterDateTime, weight, height);
        addIfRequired(decisions.encounterDecisions, "Weight for age z-score", zScoresForChild.wfa);
        addIfRequired(decisions.encounterDecisions, "Height for age z-score", zScoresForChild.hfa);
        addIfRequired(decisions.encounterDecisions, "Weight for height z-score", zScoresForChild.wfh);
        return decisions;
    }
}

const getDecisions = (programEncounter, today) => {
    if (programEncounter.encounterType.name === 'Birth' || programEncounter.encounterType.name === 'Child PNC') {
        let decisions = [
            recommendations(programEncounter.programEnrolment, programEncounter),
            immediateReferralAdvice(programEncounter.programEnrolment, programEncounter, today),
            referralAdvice(programEncounter.programEnrolment, programEncounter, today)
        ];

        let highRiskConditions = generateHighRiskConditionAdvice(programEncounter.programEnrolment, programEncounter, today);
        if (!_.isEmpty(highRiskConditions.value)) {
            decisions.push(highRiskConditions);
        }

        return {
            enrolmentDecisions: [],
            encounterDecisions: programEncounter.encounterType.name !== 'Birth' ?
                decisions.concat(anthropometricDecisions(programEncounter).encounterDecisions)
                : decisions
        }
    }
    else if (programEncounter.encounterType.name === 'Anthropometry Assessment') {
        return anthropometricDecisions(programEncounter);
    }
    else return {enrolmentDecisions: [], encounterDecisions: []};
}

const recommendations = (enrolment, encounter) => {
    const recommendationBuilder = new ComplicationsBuilder({
        programEnrolment: enrolment,
        programEncounter: encounter,
        complicationsConcept: 'Recommendations'
    });

    recommendationBuilder.addComplication("Keep the baby warm")
        .when.valueInEncounter("Child Pulse").lessThan(60)
        .or.when.valueInEncounter("Child Pulse").greaterThan(100)
        .or.when.valueInEncounter("Child Respiratory Rate").lessThan(30)
        .or.when.valueInEncounter("Child Respiratory Rate").greaterThan(60)
    ;

    recommendationBuilder.addComplication("Keep the baby warm by giving mother's skin to skin contact and covering the baby's head, hands and feet with a cap, gloves and socks resp.")
        .when.valueInEncounter("Child Temperature").lessThan(97.5)
    ;

    recommendationBuilder.addComplication("Give exclusive breast feeding")
        .when.valueInEncounter("Child Temperature").lessThan(97.5);

    recommendationBuilder.addComplication("Give exclusive breast feeding")
        .when.encounterType.equals("Child PNC")
        .and.valueInEncounter("Is baby exclusively breastfeeding").containsAnswerConceptName("No");

    return recommendationBuilder.getComplications();
};

export {
    ChildPNCDecisions,
    BirthDecisions,
    AnthroDecisions
}