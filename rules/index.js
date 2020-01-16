import _ from 'lodash';

module.exports = _.merge({},
    require('./child/AlbendazoleTrackingVisitSchedule'),
    require('./child/AnthropometryAssessmentViewFilter'),
    require('./child/BirthViewFilter'),
    require('./child/CancelViewFilter'),
    require('./child/CancelVisitSchedules'),
    require('./child/ChildEnrolmentViewFilterAndVisitSchedules'),
    require('./child/ChildPNCViewFilter'),
    require('./child/CommonEncounterDecisions'),
    require('./child/GrowthMonitoringVisitSchedules'),
    require('./child/ProgramExitFormHandler'),
    require('./child/ProgramSummary'),
    require('./child/RegistrationViewFilter'),
    require('./child/Vaccinations'),
    require('./encounterEligibilityCheck')
);
