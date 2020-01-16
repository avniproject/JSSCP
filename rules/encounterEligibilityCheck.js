import {EncounterEligibilityCheck} from 'rules-config/rules';

@EncounterEligibilityCheck({
    name: 'MonthlyMonitoringEligibility',
    uuid: 'f6936001-f719-42e4-b19c-eb8201ecc6c4',
    encounterTypeUUID: 'e9aa15b8-e9b5-4b5d-9fbb-4d7a89283741',
    executionOrder: 100.0,
    metadata: {}
})
class MonthlyMonitoringEligibility {
    static exec({individual}) {
        return false;
    }
}

@EncounterEligibilityCheck({
    name: 'AlbendazoleEligibility',
    uuid: '95ae1508-caed-4ec8-8fe3-431ea1ee1e81',
    encounterTypeUUID: '72ddfc20-fa6a-4e64-9167-c9bbc28f21fc',
    executionOrder: 100.0,
    metadata: {}
})
class AlbendazoleEligibility {
    static exec({individual}) {
        return false;
    }
}

export {
    MonthlyMonitoringEligibility,
    AlbendazoleEligibility
};

