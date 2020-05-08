const rulesConfigInfra = require('rules-config/infra');
const IDI = require('openchs-idi');

module.exports = IDI.configure({
    "name": "jsscp",
    "chs-admin": "admin",
    "org-name": "JSSCP",
    "org-admin": "admin@jsscp",
    "secrets": '../secrets.json',
    "files": {
        "organisation": [
            // this api depends on server upgrade
            // once upgraded remove create_organisation.sql file
            // and uncomment the following
            // "organisation.json"
        ],
        "adminUsers": {
            "dev": ["users/dev-admin-user.json"],
            "staging": ["users/dev-admin-user.json"],
            "uat": ["users/dev-admin-user.json"]
        },
        "forms": [
            'forms/Abortion Followup.json',
            'forms/Abortion.json',
            'forms/Albendazole Tracking.json',
            'forms/ANC Clinic Visit.json',
            'forms/ANC Home Visit.json',
            'forms/Anthropometry Assessment.json',
            'forms/Birth form.json',
            'forms/Checklist Form.json',
            'forms/Child Birth Form.json',
            'forms/Child Enrolment Phulwari.json',
            'forms/Child Enrolment.json',
            'forms/Child Exit.json',
            'forms/Child PNC.json',
            'forms/Child Program PNC.json',
            'forms/Delivery.json',
            'forms/Exit.json',
            'forms/JSSCP Registration Form.json',
            'forms/Lab Investigations.json',
            'forms/Mother PNC.json',
            'forms/Pregnancy Enrolment.json',
            'forms/Program Encounter Cancellation Form.json',
            'forms/Referral Status.json',
            'forms/USG Report.json'
        ],
        "formMappings": ["formMappings.json"],
        "catchments": ["catchments.json"],
        "checklistDetails": [],
        "concepts": [
            "concepts.json",
        ],
        "addressLevelTypes" : ["addressLevelTypes.json"],
        "locations": ["locations.json"],
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
