import _ from 'lodash';

module.exports = _.merge({},
    require('./child/registrationHandler'),
    require('./child/cancelVisitsHandler'),
    require('./child/enrolmentHandler'),
    require('./child/gmpHandler'),
    require('./child/albendazoleTrackingHandler'),
    require('./child/showHeightHandler'),
);
