set role jsscp;

drop view if exists jsscp_growth_monitoring_visit_view;
create view jsscp_growth_monitoring_visit_view as (
    select individual.id                                                                                 "Ind.Id",
           individual.address_id                                                                         "Ind.address_id",
           individual.uuid                                                                               "Ind.uuid",
           individual.first_name                                                                         "Ind.first_name",
           individual.last_name                                                                          "Ind.last_name",
           g.name                                                                                        "Ind.Gender",
           individual.date_of_birth                                                                      "Ind.date_of_birth",
           (extract('Year' from age(date_of_birth)) * 12) + extract('Month' from age(date_of_birth)) +
           round((extract('Day' from age(date_of_birth)) / 30)::numeric, 1)                              "Ind.age_in_months",
           individual.date_of_birth_verified                                                             "Ind.date_of_birth_verified",
           individual.registration_date                                                                  "Ind.registration_date",
           individual.facility_id                                                                        "Ind.facility_id",
           a.title                                                                                       "Ind.Area",
           individual.is_voided                                                                          "Ind.is_voided",
           op.name                                                                                       "Enl.Program Name",
           programEnrolment.id                                                                           "Enl.Id",
           programEnrolment.uuid                                                                         "Enl.uuid",
           programEnrolment.enrolment_date_time                                                          "Enl.enrolment_date_time",
           programEnrolment.is_voided                                                                    "Enl.is_voided",
           programEnrolment.program_exit_date_time                                                       "Enl.program_exit_date_time",
           single_select_coded(programEnrolment.observations ->> '178acfbe-b7e1-4ef5-a48a-0f4b1beabb80') "Enl.phulwari",
           oet.name                                                                                      "Enc.Type",
           programEncounter.id                                                                           "Enc.Id",
           programEncounter.earliest_visit_date_time                                                     "Enc.earliest_visit_date_time",
           programEncounter.encounter_date_time                                                          "Enc.encounter_date_time",
           programEncounter.program_enrolment_id                                                         "Enc.program_enrolment_id",
           programEncounter.uuid                                                                         "Enc.uuid",
           programEncounter.name                                                                         "Enc.name",
           programEncounter.max_visit_date_time                                                          "Enc.max_visit_date_time",
           programEncounter.is_voided                                                                    "Enc.is_voided",
           single_select_coded(
                       programEncounter.observations ->> '9fa4001d-56cb-45c9-8dd6-69e6f36f4c34')::TEXT       "Enc.Skip capturing height",
           (programEncounter.observations ->> '12684bc5-8064-47a0-9fb7-a1cada81ea03')::TEXT              "Enc.Reason for skipping height capture.",
           (programEncounter.observations ->> '23bcad9f-ec16-46ec-92f5-e144411e5dec')::NUMERIC           "Enc.Height",
           (programEncounter.observations ->> '8d947379-7a1d-48b2-8760-88fff6add987')::NUMERIC           "Enc.Weight",
           (programEncounter.observations ->> '8f369b3d-551d-4311-8e4c-7ee54d9e75ab')::NUMERIC           "Enc.Weight for age z-score",
           (programEncounter.observations ->> 'b23561f2-d3c4-40f6-a38d-a30fae484fd9')::NUMERIC           "Enc.Weight for age Grade",
           multi_select_coded(
                       programEncounter.observations -> 'ff26e3db-2499-426d-ba1e-fc3bf7772b90')::TEXT        "Enc.Weight for age Status",
           (programEncounter.observations ->> '89defa3b-4924-4a43-85ce-0d3787000ab8')::NUMERIC           "Enc.Height for age z-score",
           (programEncounter.observations ->> '0ba03618-45b9-483d-8ff3-d45dccfc2804')::NUMERIC           "Enc.Height for age Grade",
           single_select_coded(
                       programEncounter.observations ->> '60566bc3-018b-409a-82fc-a5d7a2a3e144')::TEXT       "Enc.Height for age Status",
           (programEncounter.observations ->> '9ee91c02-f965-4045-9248-1b6afaa3a9c9')::NUMERIC           "Enc.Weight for height z-score",
           multi_select_coded(
                       programEncounter.observations -> 'ac397a53-f995-4405-bb98-64aade3f352b')::TEXT        "Enc.Weight for Height Status",
           first_value(programEncounter.id)
           over ( partition by programEnrolment.id order by programEncounter.encounter_date_time)        first_visit_id,
           last_value(programEncounter.id)
           over ( partition by programEnrolment.id order by programEncounter.encounter_date_time RANGE BETWEEN UNBOUNDED PRECEDING
               AND UNBOUNDED FOLLOWING)                                                                  last_visit_id,
           case
               when programEnrolment.program_exit_date_time isnull then false
               else true end as                                                                          is_exited
    from program_encounter programEncounter
             JOIN operational_encounter_type oet on programEncounter.encounter_type_id = oet.encounter_type_id
             JOIN program_enrolment programEnrolment
                  ON programEncounter.program_enrolment_id = programEnrolment.id
             JOIN operational_program op ON op.program_id = programEnrolment.program_id
             JOIN individual ON programEnrolment.individual_id = individual.id
             JOIN gender g ON g.id = individual.gender_id
             JOIN address_level a ON individual.address_id = a.id
    WHERE op.name = 'Phulwari'
      AND oet.name = 'Growth Monitoring'
      AND programEncounter.encounter_date_time IS NOT NULL
      AND programEnrolment.enrolment_date_time IS NOT NULL
      AND programEncounter.cancel_date_time ISNULL
);
