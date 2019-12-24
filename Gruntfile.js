const rulesConfigInfra = require('rules-config/infra');
const IDI = require('openchs-idi');

module.exports = IDI.configure({
    "name": "jsscp",
    "chs-admin": "admin",
    "org-name": "JSSCP",
    "org-admin": "admin@jsscp",
    "secrets": '../secrets.json',
    "files": {
        "adminUsers": {
            // "prod": [],
            "dev": ["users/dev-admin-user.json"],
        },
        "forms": [
            'forms/Albendazole Tracking.json',
            'forms/Anthropometry Assessment.json',
            'forms/Birth form.json',
            'forms/Child Enrolment.json',
            'forms/Child Exit.json',
            'forms/Child PNC.json',
            'forms/Default Program Encounter Cancellation Form.json',
            'forms/Exit.json',
            'forms/JSS Registration Form.json',
        ],
        "formMappings": ["formMappings.json"],
        "catchments": {
            "dev": ["catchments.json"],
            "staging": ["catchments.json"],
        },
        "checklistDetails": [],
        "concepts": [
            "concepts.json",
        ],
        "addressLevelTypes" : ["addressLevelTypes.json"],
        "locations": {
            "dev": ["locations.json"],
            "staging": ["locations.json"],
        },
        "programs": ["programs.json"],
        "encounterTypes": ["encounterTypes.json"],
        "genders": ["genders.json"],
        "subjectTypes": ["subjectTypes.json"],
        "operationalEncounterTypes": ["operationalEncounterTypes.json"],
        "operationalPrograms": ["operationalPrograms.json"],
        "operationalSubjectTypes": ["operationalSubjectTypes.json"],
        "users": {
            "dev": ["users/dev-users.json"]
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
