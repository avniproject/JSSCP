import _ from 'lodash';

module.exports = _.merge({},
    require('./child/RegistrationViewFilter'),
    require('./child/CancelVisitSchedules'),
    require('./child/ChildEnrolmentViewFilterAndVisitSchedules'),
    require('./child/GrowthMonitoringVisitSchedules'),
    require('./child/AlbendazoleTrackingViewFilter'),
    require('./child/GrowthMonitoringViewFilter'),
);
