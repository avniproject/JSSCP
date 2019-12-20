const rulesConfigInfra = require('rules-config/infra');
const IDI = require('openchs-idi');

module.exports = IDI.configure({
    "name": "jsscp",
    "chs-admin": "admin",
    "org-name": "JSS CP",
    "org-admin": "admin@jsscp",
    "secrets": '../secrets.json',
    "files": {
        "adminUsers": {
            // "prod": [],
            "dev": ["./users/dev-admin-user.json"],
        },
        "forms": [
            "./child/albendazoleTrackingForm.json",
            "./registrationForm.json",
        ],
        "formMappings": ["./formMappings.json"],
        "catchments": {
            "dev": ["catchments.json"],
            "staging": ["catchments.json"],
        },
        "checklistDetails": [],
        "concepts": [
            "./concepts.json",
            "./registrationConcepts.json",
            "./child/enrolmentConcepts.json",
        ],
        "addressLevelTypes" : ["addressLevelTypes.json"],
        "locations": {
            "dev": ["./locations.json"],
            "staging": ["./locations.json"],
        },
        "programs": [],
        "encounterTypes": ["./encounterTypes.json"],
        "operationalEncounterTypes": ["./operationalModules/operationalEncounterTypes.json"],
        "operationalPrograms": ["./operationalModules/operationalPrograms.json"],
        "operationalSubjectTypes": ["./operationalModules/operationalSubjectTypes.json"],
        "users": {
            "dev": ["./users/dev-users.json"]
        },
        "rules": [
            "./rules/index.js",
        ],
        "organisationSql": [
            /* "create_organisation.sql"*/
        ],
        "organisationConfig": ["organisationConfig.json"],
        "translations": [
            "translations/en.json",
            "translations/hi_IN.json",
        ]
    }
}, rulesConfigInfra);

// users
// catchments
// locations
// addressLevelTypes
// create_organisation.sql
// org config
// translations
