set role jsscp;

drop view if exists jsscp_growth_monitoring_visit_view;
create view jsscp_growth_monitoring_visit_view as
(
WITH concepts AS (
    SELECT hstore((array_agg(concept.uuid))::text[], (array_agg(concept.name))::text[]) AS map
    FROM concept
),
     data as (
         select individual.id                                                                          "Ind.Id",
                individual.address_id                                                                  "Ind.address_id",
                individual.uuid                                                                        "Ind.uuid",
                individual.first_name                                                                  "Ind.first_name",
                individual.last_name                                                                   "Ind.last_name",
                g.name                                                                                 "Ind.Gender",
                individual.date_of_birth                                                               "Ind.date_of_birth",
                (extract('Year' from age(date_of_birth)) * 12) + extract('Month' from age(date_of_birth)) +
                round((extract('Day' from age(date_of_birth)) / 30)::numeric, 1)                       "Ind.age_in_months",
                individual.date_of_birth_verified                                                      "Ind.date_of_birth_verified",
                individual.registration_date                                                           "Ind.registration_date",
                individual.facility_id                                                                 "Ind.facility_id",
                a.title                                                                                "Ind.Area",
                individual.is_voided                                                                   "Ind.is_voided",
                op.name                                                                                "Enl.Program Name",
                programEnrolment.id                                                                    "Enl.Id",
                programEnrolment.uuid                                                                  "Enl.uuid",
                programEnrolment.enrolment_date_time                                                   "Enl.enrolment_date_time",
                programEnrolment.is_voided                                                             "Enl.is_voided",
                programEnrolment.program_exit_date_time                                                "Enl.program_exit_date_time",
                programEnrolment.observations as                                                       programEnrolmentObservations,
                oet.name                                                                               "Enc.Type",
                programEncounter.id                                                                    "Enc.Id",
                programEncounter.earliest_visit_date_time                                              "Enc.earliest_visit_date_time",
                programEncounter.encounter_date_time                                                   "Enc.encounter_date_time",
                programEncounter.program_enrolment_id                                                  "Enc.program_enrolment_id",
                programEncounter.uuid                                                                  "Enc.uuid",
                programEncounter.name                                                                  "Enc.name",
                programEncounter.max_visit_date_time                                                   "Enc.max_visit_date_time",
                programEncounter.is_voided                                                             "Enc.is_voided",
                programEncounter.observations as                                                       programEncounterObservations,
                first_value(programEncounter.id)
                over ( partition by programEnrolment.id order by programEncounter.encounter_date_time) first_visit_id,
                last_value(programEncounter.id)
                over ( partition by programEnrolment.id order by programEncounter.encounter_date_time RANGE BETWEEN UNBOUNDED PRECEDING
                    AND UNBOUNDED FOLLOWING)                                                           last_visit_id,
                case
                    when programEnrolment.program_exit_date_time isnull then false
                    else true end             as                                                       is_exited
         from program_encounter programEncounter
                  CROSS JOIN concepts
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
     )
select data."Ind.Id",
       data."Ind.address_id",
       data."Ind.uuid",
       data."Ind.first_name",
       data."Ind.last_name",
       data."Ind.Gender",
       data."Ind.date_of_birth",
       data."Ind.age_in_months",
       data."Ind.date_of_birth_verified",
       data."Ind.registration_date",
       data."Ind.facility_id",
       data."Ind.Area",
       data."Ind.is_voided",
       data."Enl.Program Name",
       data."Enl.Id",
       data."Enl.uuid",
       data."Enl.enrolment_date_time",
       data."Enl.is_voided",
       data."Enl.program_exit_date_time",
       get_coded_string_value(data.programEnrolmentObservations -> '178acfbe-b7e1-4ef5-a48a-0f4b1beabb80',
                              concepts.map)                                                    "Enl.phulwari",
       data."Enc.Type",
       data."Enc.Id",
       data."Enc.earliest_visit_date_time",
       data."Enc.encounter_date_time",
       data."Enc.program_enrolment_id",
       data."Enc.uuid",
       data."Enc.name",
       data."Enc.max_visit_date_time",
       data."Enc.is_voided",
       get_coded_string_value(
                   data.programEncounterObservations -> '9fa4001d-56cb-45c9-8dd6-69e6f36f4c34',
                   concepts.map)::TEXT                                                         "Enc.Skip capturing height",
       (data.programEncounterObservations ->>
        '12684bc5-8064-47a0-9fb7-a1cada81ea03')::TEXT                                          "Enc.Reason for skipping height capture.",
       (data.programEncounterObservations ->> '23bcad9f-ec16-46ec-92f5-e144411e5dec')::NUMERIC "Enc.Height",
       (data.programEncounterObservations ->> '8d947379-7a1d-48b2-8760-88fff6add987')::NUMERIC "Enc.Weight",
       (data.programEncounterObservations ->>
        '8f369b3d-551d-4311-8e4c-7ee54d9e75ab')::NUMERIC                                       "Enc.Weight for age z-score",
       (data.programEncounterObservations ->>
        'b23561f2-d3c4-40f6-a38d-a30fae484fd9')::NUMERIC                                       "Enc.Weight for age Grade",
       get_coded_string_value(
                   data.programEncounterObservations -> 'ff26e3db-2499-426d-ba1e-fc3bf7772b90',
                   concepts.map)::TEXT                                                         "Enc.Weight for age Status",
       (data.programEncounterObservations ->>
        '89defa3b-4924-4a43-85ce-0d3787000ab8')::NUMERIC                                       "Enc.Height for age z-score",
       (data.programEncounterObservations ->>
        '0ba03618-45b9-483d-8ff3-d45dccfc2804')::NUMERIC                                       "Enc.Height for age Grade",
       get_coded_string_value(
                   data.programEncounterObservations -> '60566bc3-018b-409a-82fc-a5d7a2a3e144',
                   concepts.map)::TEXT                                                         "Enc.Height for age Status",
       (data.programEncounterObservations ->>
        '9ee91c02-f965-4045-9248-1b6afaa3a9c9')::NUMERIC                                       "Enc.Weight for height z-score",
       get_coded_string_value(
                   data.programEncounterObservations -> 'ac397a53-f995-4405-bb98-64aade3f352b',
                   concepts.map)::TEXT                                                         "Enc.Weight for Height Status",
       data.first_visit_id,
       data.last_visit_id,
       is_exited
from data
         CROSS JOIN concepts
);

drop view if exists jsscp_pregnancy_view;
create view jsscp_pregnancy_view as (
    WITH concepts AS (
        SELECT hstore((array_agg(concept.uuid))::text[], (array_agg(concept.name))::text[]) AS map
        FROM concept
    )
    SELECT individual.id                                                                              "Ind.Id",
           individual.address_id                                                                      "Ind.address_id",
           individual.uuid                                                                            "Ind.uuid",
           individual.first_name                                                                      "Ind.first_name",
           individual.last_name                                                                       "Ind.last_name",
           g.name                                                                                     "Ind.Gender",
           individual.date_of_birth                                                                   "Ind.date_of_birth",
           individual.date_of_birth_verified                                                          "Ind.date_of_birth_verified",
           individual.registration_date                                                               "Ind.registration_date",
           individual.facility_id                                                                     "Ind.facility_id",
           village.title                                                                              "Ind.village",
           cluster.title                                                                              "Ind.cluster",
           u.name                                                                                     "Enl.username",
           individual.is_voided                                                                       "Ind.is_voided",
           op.name                                                                                    "Enl.Program Name",
           programEnrolment.id                                                                        "Enl.Id",
           programEnrolment.uuid                                                                      "Enl.uuid",
           programEnrolment.enrolment_date_time                                                        "Enl.enrolment_date_time",
           programEnrolment.is_voided                                                                 "Enl.is_voided",
           programEnrolment.program_exit_date_time                                                     "Enl.program_exit_date_time" ,
           (individual.observations ->> 'ecdf3c54-2808-494d-87be-8fb744d5c3bc')::TEXT              as "Ind.Father/Husband's Name",
           get_coded_string_value(
                   individual.observations -> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b', concepts.map)::TEXT       as "Ind.Marital status",
           (individual.observations ->> '9d958124-09bb-466c-a4b4-db8d285def1f')::DATE              as "Ind.Date of marriage",
           get_coded_string_value(
                   individual.observations -> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b', concepts.map)::TEXT       as "Ind.Education",
           get_coded_string_value(
                   individual.observations -> '20ef261a-f110-4eaa-a592-2a1eeb0bf061', concepts.map)::TEXT       as "Ind.Occupation",
           (individual.observations ->> '4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT              as "Ind.Other occupation",
           get_coded_string_value(
                   individual.observations -> 'bab107f6-fc0e-4be7-ab71-658a92d72f35', concepts.map)::TEXT       as "Ind.Whether any disability",
           get_coded_string_value(
                   individual.observations -> '7061c675-c2ba-4016-886d-eeb432548378', concepts.map)::TEXT        as "Ind.Type of disability",
           get_coded_string_value(
                   individual.observations -> 'd333f2a2-717e-478f-acbc-173bc7374d66', concepts.map)::TEXT       as "Ind.Status of the individual",
           (individual.observations ->> '681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT              as "Ind.Aadhaar ID",
           (individual.observations ->> '0a725832-b21c-4151-b017-7e6af770ba54')::TEXT              as "Ind.Contact Number",
           get_coded_string_value(
                   individual.observations -> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b', concepts.map)::TEXT       as "Ind.Smart card (Insurance)",
           (programEnrolment.observations ->> 'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c')::TEXT        as "Enl.ANC Enrolment ID",
           get_coded_string_value(
                   programEnrolment.observations -> '58d0a437-17ef-4d58-a36f-9a36b608f5a4', concepts.map)::TEXT as "Enl.Relation with village",
           (programEnrolment.observations ->> 'aaac11d9-1237-41ac-9cf9-239c1226048a')::TEXT        as "Enl.Other relation with village",
           (programEnrolment.observations ->> '838cdad2-e661-4517-88ca-5b9e8e6c676e')::TEXT        as "Enl.Gravida",
           (programEnrolment.observations ->> '6956e0f7-d31b-4fb5-a3de-bd6251b24f49')::TEXT        as "Enl.Parity",
           (programEnrolment.observations ->> '47bb4fbd-729b-48db-995c-4464e26dd3f3')::TEXT        as "Enl.Live birth",
           (programEnrolment.observations ->> '73e37865-47a7-44ef-8a06-870b79e55fbd')::TEXT        as "Enl.still birth",
           (programEnrolment.observations ->> '1465d2a8-dd5a-4cec-9cc3-ab9c7ba22cc2')::TEXT        as "Enl.number of abortions",
           (programEnrolment.observations ->> '42a98500-3c12-426b-9121-e0e993dbacaf')::TEXT        as "Enl.prganancy,death",
           (programEnrolment.observations ->> '24b4a632-42bd-4847-91f4-7d8e69929581')::TEXT        as "Enl.Death of children within 1 week after delivery",
           (programEnrolment.observations ->> 'c9b244f3-7795-4f5a-a0aa-ccafd1e57b94')::TEXT        as "Enl.Death of children due to congenital abnormality",
           (programEnrolment.observations ->> '814f1780-aa3d-4c46-b881-71face696220')::DATE        as "Enl.Last menstrual period",
           (programEnrolment.observations ->> '730ca106-ece0-495d-8962-f60f38e79d12')::DATE        as "Enl.EDD",
           (programEnrolment.observations ->> 'e817dda1-0cd7-40a9-8d30-06aafbbbbf24')::TEXT        as "Enl.Is women registered within 3 months",
           (programEnrolment.observations ->> '748b7b66-c9ce-496f-b670-9d2896e82c23')::DATE        as "Enl.Last Delivery",
           get_coded_string_value(
                   programEnrolment.observations -> '1952339b-14b0-447d-b6d7-6bcf18b4af62', concepts.map)::TEXT as "Enl.Last delivery place",
           get_coded_string_value(
                   programEnrolment.observations -> '6c771640-52b6-46ea-bd56-0a2670ab7a6d', concepts.map)::TEXT as "Enl.Last delivery outcome",
           get_coded_string_value(
                   programEnrolment.observations -> 'f776b045-2fcb-4275-b08e-e3e9039b699e', concepts.map)::TEXT as "Enl.Last delivery gender",
           get_coded_string_value(
                   programEnrolment.observations -> '2f68ca5f-c690-4848-aa2e-592d6c7ef4e8', concepts.map)::TEXT as "Enl.Last delivery- Is baby alive?",
           get_coded_string_value(
                   programEnrolment.observations -> '26cee30f-b36d-4be2-bec3-9a0904492e52', concepts.map)::TEXT as "Enl.Any High risk condition in previous pregnancy",
           get_coded_string_value(
                   programEnrolment.observations -> 'a0aea5a9-7101-48ef-8463-5b376efa61bf', concepts.map)::TEXT  as "Enl.High risk condition in previous pregnancy",
           (programEnrolment.observations ->> '6bdfb87a-fefc-48ea-bcab-8bd05cbae73d')::TEXT        as "Enl.Other high risk condition in previous pregnancy",
           get_coded_string_value(
                   programEnrolment.observations -> 'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2', concepts.map)::TEXT as "Enl.Taking medicine for chronic disease",
           get_coded_string_value(
                   programEnrolment.observations -> '7d9b6992-ee27-4423-90a5-9ad20400d885', concepts.map)::TEXT  as "Enl.Name of chronic disease",
           (programEnrolment.observations ->> 'a54d0c2c-a054-45a5-a143-9f6c9db3fbbd')::TEXT        as "Enl.Other chronic disease",
           get_coded_string_value(
                   programEnrolment.observations -> '1aac0eaf-1c9e-4284-93c3-7212c06a3286', concepts.map)::TEXT as "Enl.Does woman want to continue this pregnancy?",
           get_coded_string_value(
                   programEnrolment.observations -> 'b5ebc472-0f32-4128-97f3-0e2571daeaae', concepts.map)::TEXT as "Enl.Send her to nearest antenatal clinic",
           (programEnrolment.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "Enl.Date of next ANC Visit",
           get_coded_string_value(
                   programEnrolment.observations -> 'b6f45def-e3f4-4e7b-97ed-68c539b82fa2', concepts.map)::TEXT as "Enl.Send her to hospital for abortion",
           (programEnrolment.program_exit_observations ->> '338953ea-6d7e-423e-96d6-f52d5aa37072')::DATE as "EnlExit.Date of Death"
    FROM program_enrolment programEnrolment
             CROSS JOIN concepts
             LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
             LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
             LEFT OUTER JOIN gender g ON g.id = individual.gender_id
             left join address_level village ON individual.address_id = village.id
             left join address_level cluster on village.parent_id = cluster.id
             LEFT JOIN audit a ON programEnrolment.audit_id = a.id
             LEFT JOIN users u ON a.created_by_id = u.id
    WHERE op.uuid = '369dc9d1-ea43-47cf-9a32-5e98a81b2de4'
      AND programEnrolment.enrolment_date_time IS NOT NULL
);

drop view if exists jsscp_lab_investigation_view;
create view jsscp_lab_investigation_view as (
        WITH concepts AS (
            SELECT hstore((array_agg(concept.uuid))::text[], (array_agg(concept.name))::text[]) AS map
            FROM concept
        )
    SELECT individual.id                                                                              "Ind.Id",
           individual.address_id                                                                      "Ind.address_id",
           individual.uuid                                                                            "Ind.uuid",
           individual.first_name                                                                      "Ind.first_name",
           individual.last_name                                                                       "Ind.last_name",
           g.name                                                                                     "Ind.Gender",
           individual.date_of_birth                                                                   "Ind.date_of_birth",
           individual.date_of_birth_verified                                                          "Ind.date_of_birth_verified",
           individual.registration_date                                                               "Ind.registration_date",
           individual.facility_id                                                                     "Ind.facility_id",
           village.title                                                                              "Ind.village",
           cluster.title                                                                              "Ind.cluster",
           u.name                                                                                     "Enc.username",
           individual.is_voided                                                                       "Ind.is_voided",
           op.name                                                                                    "Enl.Program Name",
           programEnrolment.id                                                                        "Enl.Id",
           programEnrolment.uuid                                                                      "Enl.uuid",
           programEnrolment.is_voided                                                                 "Enl.is_voided",
           oet.name                                                                                   "Enc.Type",
           programEncounter.id                                                                        "Enc.Id",
           programEncounter.earliest_visit_date_time                                                  "Enc.earliest_visit_date_time",
           programEncounter.encounter_date_time                                                       "Enc.encounter_date_time",
           programEncounter.program_enrolment_id                                                      "Enc.program_enrolment_id",
           programEncounter.uuid                                                                      "Enc.uuid",
           programEncounter.name                                                                      "Enc.name",
           programEncounter.max_visit_date_time                                                       "Enc.max_visit_date_time",
           programEncounter.is_voided                                                                 "Enc.is_voided",
           (individual.observations ->> 'ecdf3c54-2808-494d-87be-8fb744d5c3bc')::TEXT              as "Ind.Father/Husband's Name",
           get_coded_string_value(
                   individual.observations -> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b', concepts.map)::TEXT       as "Ind.Marital status",
           (individual.observations ->> '9d958124-09bb-466c-a4b4-db8d285def1f')::DATE              as "Ind.Date of marriage",
           get_coded_string_value(
                   individual.observations -> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b', concepts.map)::TEXT       as "Ind.Education",
           get_coded_string_value(
                   individual.observations -> '20ef261a-f110-4eaa-a592-2a1eeb0bf061', concepts.map)::TEXT       as "Ind.Occupation",
           (individual.observations ->> '4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT              as "Ind.Other occupation",
           get_coded_string_value(
                   individual.observations -> 'bab107f6-fc0e-4be7-ab71-658a92d72f35', concepts.map)::TEXT       as "Ind.Whether any disability",
           get_coded_string_value(
                   individual.observations -> '7061c675-c2ba-4016-886d-eeb432548378', concepts.map)::TEXT        as "Ind.Type of disability",
           get_coded_string_value(
                   individual.observations -> 'd333f2a2-717e-478f-acbc-173bc7374d66', concepts.map)::TEXT       as "Ind.Status of the individual",
           (individual.observations ->> '681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT              as "Ind.Aadhaar ID",
           (individual.observations ->> '0a725832-b21c-4151-b017-7e6af770ba54')::TEXT              as "Ind.Contact Number",
           get_coded_string_value(
                   individual.observations -> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b', concepts.map)::TEXT       as "Ind.Smart card (Insurance)",
           (programEnrolment.observations ->> 'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c')::TEXT        as "Enl.ANC Enrolment ID",
           get_coded_string_value(
                   programEnrolment.observations -> '58d0a437-17ef-4d58-a36f-9a36b608f5a4', concepts.map)::TEXT as "Enl.Relation with village",
           (programEnrolment.observations ->> 'aaac11d9-1237-41ac-9cf9-239c1226048a')::TEXT        as "Enl.Other relation with village",
           (programEnrolment.observations ->> '838cdad2-e661-4517-88ca-5b9e8e6c676e')::TEXT        as "Enl.Gravida",
           (programEnrolment.observations ->> '6956e0f7-d31b-4fb5-a3de-bd6251b24f49')::TEXT        as "Enl.Parity",
           (programEnrolment.observations ->> '47bb4fbd-729b-48db-995c-4464e26dd3f3')::TEXT        as "Enl.Live birth",
           (programEnrolment.observations ->> '73e37865-47a7-44ef-8a06-870b79e55fbd')::TEXT        as "Enl.still birth",
           (programEnrolment.observations ->> '1465d2a8-dd5a-4cec-9cc3-ab9c7ba22cc2')::TEXT        as "Enl.number of abortions",
           (programEnrolment.observations ->> '42a98500-3c12-426b-9121-e0e993dbacaf')::TEXT        as "Enl.prganancy,death",
           (programEnrolment.observations ->> '24b4a632-42bd-4847-91f4-7d8e69929581')::TEXT        as "Enl.Death of children within 1 week after delivery",
           (programEnrolment.observations ->> 'c9b244f3-7795-4f5a-a0aa-ccafd1e57b94')::TEXT        as "Enl.Death of children due to congenital abnormality",
           (programEnrolment.observations ->> '814f1780-aa3d-4c46-b881-71face696220')::DATE        as "Enl.Last menstrual period",
           (programEnrolment.observations ->> '730ca106-ece0-495d-8962-f60f38e79d12')::DATE        as "Enl.EDD",
           (programEnrolment.observations ->> 'e817dda1-0cd7-40a9-8d30-06aafbbbbf24')::TEXT        as "Enl.Is women registered within 3 months",
           (programEnrolment.observations ->> '748b7b66-c9ce-496f-b670-9d2896e82c23')::DATE        as "Enl.Last Delivery",
           get_coded_string_value(
                   programEnrolment.observations -> '1952339b-14b0-447d-b6d7-6bcf18b4af62', concepts.map)::TEXT as "Enl.Last delivery place",
           get_coded_string_value(
                   programEnrolment.observations -> '6c771640-52b6-46ea-bd56-0a2670ab7a6d', concepts.map)::TEXT as "Enl.Last delivery outcome",
           get_coded_string_value(
                   programEnrolment.observations -> 'f776b045-2fcb-4275-b08e-e3e9039b699e', concepts.map)::TEXT as "Enl.Last delivery gender",
           get_coded_string_value(
                   programEnrolment.observations -> '2f68ca5f-c690-4848-aa2e-592d6c7ef4e8', concepts.map)::TEXT as "Enl.Last delivery- Is baby alive?",
           get_coded_string_value(
                   programEnrolment.observations -> '26cee30f-b36d-4be2-bec3-9a0904492e52', concepts.map)::TEXT as "Enl.Any High risk condition in previous pregnancy",
           get_coded_string_value(
                   programEnrolment.observations -> 'a0aea5a9-7101-48ef-8463-5b376efa61bf', concepts.map)::TEXT  as "Enl.High risk condition in previous pregnancy",
           (programEnrolment.observations ->> '6bdfb87a-fefc-48ea-bcab-8bd05cbae73d')::TEXT        as "Enl.Other high risk condition in previous pregnancy",
           get_coded_string_value(
                   programEnrolment.observations -> 'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2', concepts.map)::TEXT as "Enl.Taking medicine for chronic disease",
           get_coded_string_value(
                   programEnrolment.observations -> '7d9b6992-ee27-4423-90a5-9ad20400d885', concepts.map)::TEXT  as "Enl.Name of chronic disease",
           (programEnrolment.observations ->> 'a54d0c2c-a054-45a5-a143-9f6c9db3fbbd')::TEXT        as "Enl.Other chronic disease",
           get_coded_string_value(
                   programEnrolment.observations -> '1aac0eaf-1c9e-4284-93c3-7212c06a3286', concepts.map)::TEXT as "Enl.Does woman want to continue this pregnancy?",
           get_coded_string_value(
                   programEnrolment.observations -> 'b5ebc472-0f32-4128-97f3-0e2571daeaae', concepts.map)::TEXT as "Enl.Send her to nearest antenatal clinic",
           (programEnrolment.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "Enl.Date of next ANC Visit",
           get_coded_string_value(
                   programEnrolment.observations -> 'b6f45def-e3f4-4e7b-97ed-68c539b82fa2', concepts.map)::TEXT as "Enl.Send her to hospital for abortion",
           get_coded_string_value(
                   programEncounter.observations -> 'b3e8a85a-c7ca-49b8-9c6f-8bd5ee6bfad1', concepts.map)::TEXT as "Enc.HIV (Elisa)",
           get_coded_string_value(
                   programEncounter.observations -> 'f874c217-2fed-41c9-a094-ba6519bd537d', concepts.map)::TEXT as "Enc.Hepatitis B",
           get_coded_string_value(
                   programEncounter.observations -> '198d08c6-b742-4b22-97fd-2293472e571e', concepts.map)::TEXT as "Enc.Hb Electrophoresis",
           get_coded_string_value(
                   programEncounter.observations -> 'cbe884a3-c5f3-441e-900a-6bc76f3cabca', concepts.map)::TEXT as "Enc.VDRL",
           programEncounter.cancel_date_time                                                          "EncCancel.cancel_date_time",
           get_coded_string_value(
                   programEncounter.observations -> 'bf400e7f-8e1b-4052-af49-b0db47b3eb5a', concepts.map)::TEXT as "EncCancel.Visit cancel reason",
           (programEncounter.observations ->> 'd038a9c4-fe96-4c09-b883-c80691427b60')::TEXT        as "EncCancel.Other reason for cancelling",
           (programEncounter.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "EncCancel.Date of next ANC Visit"
    FROM program_encounter programEncounter
             CROSS JOIN concepts
             LEFT OUTER JOIN operational_encounter_type oet
                             on programEncounter.encounter_type_id = oet.encounter_type_id
             LEFT OUTER JOIN program_enrolment programEnrolment
                             ON programEncounter.program_enrolment_id = programEnrolment.id
             LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
             LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
             LEFT OUTER JOIN gender g ON g.id = individual.gender_id
             left join address_level village ON individual.address_id = village.id
             left join address_level cluster on village.parent_id = cluster.id
             LEFT JOIN audit a ON programEncounter.audit_id = a.id
             LEFT JOIN users u ON a.created_by_id = u.id
    WHERE op.uuid = '369dc9d1-ea43-47cf-9a32-5e98a81b2de4'
      AND oet.uuid = 'ff14932a-d7d9-4475-adfb-f7ab78e6bce9'
      AND programEncounter.encounter_date_time IS NOT NULL
      AND programEnrolment.enrolment_date_time IS NOT NULL
);

drop view if exists jsscp_anc_clinic_view;
create view jsscp_anc_clinic_view as (
     WITH concepts AS (
         SELECT hstore((array_agg(concept.uuid))::text[], (array_agg(concept.name))::text[]) AS map
         FROM concept
     )
    SELECT individual.id                                                                              "Ind.Id",
           individual.address_id                                                                      "Ind.address_id",
           individual.uuid                                                                            "Ind.uuid",
           individual.first_name                                                                      "Ind.first_name",
           individual.last_name                                                                       "Ind.last_name",
           g.name                                                                                     "Ind.Gender",
           individual.date_of_birth                                                                   "Ind.date_of_birth",
           individual.date_of_birth_verified                                                          "Ind.date_of_birth_verified",
           individual.registration_date                                                               "Ind.registration_date",
           individual.facility_id                                                                     "Ind.facility_id",
           village.title                                                                              "Ind.village",
           cluster.title                                                                              "Ind.cluster",
           u.name                                                                                     "Enc.username",
           individual.is_voided                                                                       "Ind.is_voided",
           op.name                                                                                    "Enl.Program Name",
           programEnrolment.id                                                                        "Enl.Id",
           programEnrolment.uuid                                                                      "Enl.uuid",
           programEnrolment.is_voided                                                                 "Enl.is_voided",
           oet.name                                                                                   "Enc.Type",
           programEncounter.id                                                                        "Enc.Id",
           programEncounter.earliest_visit_date_time                                                  "Enc.earliest_visit_date_time",
           programEncounter.encounter_date_time                                                       "Enc.encounter_date_time",
           programEncounter.program_enrolment_id                                                      "Enc.program_enrolment_id",
           programEncounter.uuid                                                                      "Enc.uuid",
           programEncounter.name                                                                      "Enc.name",
           programEncounter.max_visit_date_time                                                       "Enc.max_visit_date_time",
           programEncounter.is_voided                                                                 "Enc.is_voided",
           (individual.observations ->> 'ecdf3c54-2808-494d-87be-8fb744d5c3bc')::TEXT              as "Ind.Father/Husband's Name",
           get_coded_string_value(
                   individual.observations -> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b', concepts.map)::TEXT       as "Ind.Marital status",
           (individual.observations ->> '9d958124-09bb-466c-a4b4-db8d285def1f')::DATE              as "Ind.Date of marriage",
           get_coded_string_value(
                   individual.observations -> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b', concepts.map)::TEXT       as "Ind.Education",
           get_coded_string_value(
                   individual.observations -> '20ef261a-f110-4eaa-a592-2a1eeb0bf061', concepts.map)::TEXT       as "Ind.Occupation",
           (individual.observations ->> '4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT              as "Ind.Other occupation",
           get_coded_string_value(
                   individual.observations -> 'bab107f6-fc0e-4be7-ab71-658a92d72f35', concepts.map)::TEXT       as "Ind.Whether any disability",
           get_coded_string_value(
                   individual.observations -> '7061c675-c2ba-4016-886d-eeb432548378', concepts.map)::TEXT        as "Ind.Type of disability",
           get_coded_string_value(
                   individual.observations -> 'd333f2a2-717e-478f-acbc-173bc7374d66', concepts.map)::TEXT       as "Ind.Status of the individual",
           (individual.observations ->> '681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT              as "Ind.Aadhaar ID",
           (individual.observations ->> '0a725832-b21c-4151-b017-7e6af770ba54')::TEXT              as "Ind.Contact Number",
           get_coded_string_value(
                   individual.observations -> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b', concepts.map)::TEXT       as "Ind.Smart card (Insurance)",
           (programEnrolment.observations ->> 'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c')::TEXT        as "Enl.ANC Enrolment ID",
           get_coded_string_value(
                   programEnrolment.observations -> '58d0a437-17ef-4d58-a36f-9a36b608f5a4', concepts.map)::TEXT as "Enl.Relation with village",
           (programEnrolment.observations ->> 'aaac11d9-1237-41ac-9cf9-239c1226048a')::TEXT        as "Enl.Other relation with village",
           (programEnrolment.observations ->> '838cdad2-e661-4517-88ca-5b9e8e6c676e')::TEXT        as "Enl.Gravida",
           (programEnrolment.observations ->> '6956e0f7-d31b-4fb5-a3de-bd6251b24f49')::TEXT        as "Enl.Parity",
           (programEnrolment.observations ->> '47bb4fbd-729b-48db-995c-4464e26dd3f3')::TEXT        as "Enl.Live birth",
           (programEnrolment.observations ->> '73e37865-47a7-44ef-8a06-870b79e55fbd')::TEXT        as "Enl.still birth",
           (programEnrolment.observations ->> '1465d2a8-dd5a-4cec-9cc3-ab9c7ba22cc2')::TEXT        as "Enl.number of abortions",
           (programEnrolment.observations ->> '42a98500-3c12-426b-9121-e0e993dbacaf')::TEXT        as "Enl.prganancy,death",
           (programEnrolment.observations ->> '24b4a632-42bd-4847-91f4-7d8e69929581')::TEXT        as "Enl.Death of children within 1 week after delivery",
           (programEnrolment.observations ->> 'c9b244f3-7795-4f5a-a0aa-ccafd1e57b94')::TEXT        as "Enl.Death of children due to congenital abnormality",
           (programEnrolment.observations ->> '814f1780-aa3d-4c46-b881-71face696220')::DATE        as "Enl.Last menstrual period",
           (programEnrolment.observations ->> '730ca106-ece0-495d-8962-f60f38e79d12')::DATE        as "Enl.EDD",
           (programEnrolment.observations ->> 'e817dda1-0cd7-40a9-8d30-06aafbbbbf24')::TEXT        as "Enl.Is women registered within 3 months",
           (programEnrolment.observations ->> '748b7b66-c9ce-496f-b670-9d2896e82c23')::DATE        as "Enl.Last Delivery",
           get_coded_string_value(
                   programEnrolment.observations -> '1952339b-14b0-447d-b6d7-6bcf18b4af62', concepts.map)::TEXT as "Enl.Last delivery place",
           get_coded_string_value(
                   programEnrolment.observations -> '6c771640-52b6-46ea-bd56-0a2670ab7a6d', concepts.map)::TEXT as "Enl.Last delivery outcome",
           get_coded_string_value(
                   programEnrolment.observations -> 'f776b045-2fcb-4275-b08e-e3e9039b699e', concepts.map)::TEXT as "Enl.Last delivery gender",
           get_coded_string_value(
                   programEnrolment.observations -> '2f68ca5f-c690-4848-aa2e-592d6c7ef4e8', concepts.map)::TEXT as "Enl.Last delivery- Is baby alive?",
           get_coded_string_value(
                   programEnrolment.observations -> '26cee30f-b36d-4be2-bec3-9a0904492e52', concepts.map)::TEXT as "Enl.Any High risk condition in previous pregnancy",
           get_coded_string_value(
                   programEnrolment.observations -> 'a0aea5a9-7101-48ef-8463-5b376efa61bf', concepts.map)::TEXT  as "Enl.High risk condition in previous pregnancy",
           (programEnrolment.observations ->> '6bdfb87a-fefc-48ea-bcab-8bd05cbae73d')::TEXT        as "Enl.Other high risk condition in previous pregnancy",
           get_coded_string_value(
                   programEnrolment.observations -> 'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2', concepts.map)::TEXT as "Enl.Taking medicine for chronic disease",
           get_coded_string_value(
                   programEnrolment.observations -> '7d9b6992-ee27-4423-90a5-9ad20400d885', concepts.map)::TEXT  as "Enl.Name of chronic disease",
           (programEnrolment.observations ->> 'a54d0c2c-a054-45a5-a143-9f6c9db3fbbd')::TEXT        as "Enl.Other chronic disease",
           get_coded_string_value(
                   programEnrolment.observations -> '1aac0eaf-1c9e-4284-93c3-7212c06a3286', concepts.map)::TEXT as "Enl.Does woman want to continue this pregnancy?",
           get_coded_string_value(
                   programEnrolment.observations -> 'b5ebc472-0f32-4128-97f3-0e2571daeaae', concepts.map)::TEXT as "Enl.Send her to nearest antenatal clinic",
           (programEnrolment.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "Enl.Date of next ANC Visit",
           get_coded_string_value(
                   programEnrolment.observations -> 'b6f45def-e3f4-4e7b-97ed-68c539b82fa2', concepts.map)::TEXT as "Enl.Send her to hospital for abortion",
           (programEncounter.observations ->> '23bcad9f-ec16-46ec-92f5-e144411e5dec')::TEXT        as "Enc.Height",
           (programEncounter.observations ->> '8d947379-7a1d-48b2-8760-88fff6add987')::TEXT        as "Enc.Weight",
           (programEncounter.observations ->> 'a205563d-0ac2-4955-93ac-e2e7adebb56e')::TEXT        as "Enc.BMI",
           (programEncounter.observations ->> '6874d48e-8c2f-4009-992c-1d3ca1678cc6')::TEXT        as "Enc.Blood Pressure (systolic)",
           (programEncounter.observations ->> 'da871f6c-cef0-4191-b307-6751b31ac9ec')::TEXT        as "Enc.Blood Pressure (Diastolic)",
           get_coded_string_value(
                   programEncounter.observations -> 'b7be4ddc-14ee-4caf-ab38-e1c87d088688', concepts.map)::TEXT as "Enc.Is mosquito net given",
           get_coded_string_value(
                   programEncounter.observations -> '04eecc2b-93eb-49d4-83a4-6629442711ea', concepts.map)::TEXT as "Enc.Is safe delivery kit given",
           get_coded_string_value(
                   programEncounter.observations -> '74599453-6fbd-4f8d-bf7f-34faa3c10eb9', concepts.map)::TEXT  as "Enc.New complaint",
           (programEncounter.observations ->> 'dc0c10ca-c151-4c5c-aedc-2b8040dbea52')::TEXT        as "Enc.Other complaint",
           get_coded_string_value(
                   programEncounter.observations -> '95dd3094-6c99-4622-8614-bf5d33a509e4', concepts.map)::TEXT  as "Enc.Oedema",
           get_coded_string_value(
                   programEncounter.observations -> '2a15dc0b-d6a0-4670-b109-4013789cb403', concepts.map)::TEXT  as "Enc.Abdomen check",
           (programEncounter.observations ->> '9b087651-34e8-4391-aa08-8db73f55d7e6')::TEXT        as "Enc.Current gestational age",
           get_coded_string_value(
                   programEncounter.observations -> 'f5ff8848-798a-4b0f-bcaf-33f2d4528f37', concepts.map)::TEXT as "Enc.Fundle Height",
           get_coded_string_value(
                   programEncounter.observations -> '69a95145-505b-497a-9fc9-61fcc5d2ff59', concepts.map)::TEXT as "Enc.Position",
           get_coded_string_value(
                   programEncounter.observations -> '7c6d3fc6-6a9f-4b44-beef-8c2200da5281', concepts.map)::TEXT as "Enc.FHS",
           (programEncounter.observations ->> '532ae011-4380-4ff5-b7c7-7d163e396221')::TEXT        as "Enc.FHS number",
           get_coded_string_value(
                   programEncounter.observations -> '31651632-0acb-4ee5-a0f3-1628bbed456c', concepts.map)::TEXT as "Enc.Foetus movement",
           get_coded_string_value(
                   programEncounter.observations -> '7259b0fa-c8d1-4e04-8d13-7dbc05f0169b', concepts.map)::TEXT  as "Enc.Breast examination",
           get_coded_string_value(
                   programEncounter.observations -> 'c50c8196-01c9-422f-b917-fd2309adb261', concepts.map)::TEXT as "Enc.Blood group",
           get_coded_string_value(
                   programEncounter.observations -> '610db330-fafe-456f-bd58-e062cb6e52e3', concepts.map)::TEXT as "Enc.Sickle prep",
           get_coded_string_value(
                   programEncounter.observations -> '78fcebd3-17e5-4621-89be-c580fbf13168', concepts.map)::TEXT as "Enc.Urine Albumin",
           get_coded_string_value(
                   programEncounter.observations -> '55ae9e7a-f6ff-4c0b-861c-fd29b6c5c646', concepts.map)::TEXT as "Enc.Urine sugar",
           (programEncounter.observations ->> 'a240115e-47a2-4244-8f74-d13d20f087df')::TEXT        as "Enc.Hb",
           get_coded_string_value(
                   programEncounter.observations -> '9a89e9d6-f6e4-4d14-8841-34df9ece70a5', concepts.map)::TEXT as "Enc.Malaria parasite",
           (programEncounter.observations ->> 'd6ac43a2-527d-4168-ba7d-2d233add3a6e')::TEXT        as "Enc.Random Blood Sugar (RBS)",
           (programEncounter.observations ->> 'ae2046a4-015c-44e2-9703-01bc3da13202')::TEXT        as "Enc.Glucose test (75gm Glucose)",
           (programEncounter.observations ->> '0b8bc1f8-43db-4ecb-9677-22709e91681f')::TEXT        as "Enc.Pus Cell",
           (programEncounter.observations ->> 'b59c126f-975b-45e6-8dd6-584dd54e25c9')::TEXT        as "Enc.RBC",
           (programEncounter.observations ->> '0343e35f-afd0-41ce-af93-e69c184b159c')::TEXT        as "Enc.Epithelial cells",
           (programEncounter.observations ->> 'a2b6d675-4c70-4f15-a5ad-b8f5273602f9')::TEXT        as "Enc.Cast",
           get_coded_string_value(
                   programEncounter.observations -> '14a023d3-bd25-4343-9d93-34d9f88eb4b3', concepts.map)::TEXT as "Enc.Crystel",
           get_coded_string_value(
                   programEncounter.observations -> 'bf1e5598-594c-4444-94e0-9390f5081e41', concepts.map)::TEXT as "Enc.Whether Folic acid given",
           get_coded_string_value(
                   programEncounter.observations -> '5740f87b-8cc6-4927-88a2-44636e8f396c', concepts.map)::TEXT as "Enc.Whether IFA given",
           get_coded_string_value(
                   programEncounter.observations -> '00de9acc-4ff6-485b-b979-41ff00745d23', concepts.map)::TEXT as "Enc.Whether Calcium given",
           get_coded_string_value(
                   programEncounter.observations -> '2a5a3b4d-80c4-4d05-8585-e16966ff0c3e', concepts.map)::TEXT as "Enc.Whether Amala given",
           get_coded_string_value(
                   programEncounter.observations -> 'ddeb2311-4a90-4a7c-a698-1cd3db4ff0f3', concepts.map)::TEXT as "Enc.TT 1",
           get_coded_string_value(
                   programEncounter.observations -> '858f66e6-1ed3-4c13-9fdf-08f667b092ba', concepts.map)::TEXT as "Enc.TT 2",
           (programEncounter.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "Enc.Date of next ANC Visit",
           get_coded_string_value(
                   programEncounter.observations -> '77d122e8-0620-4754-8375-b0cbe329003c', concepts.map)::TEXT as "Enc.Does woman require referral?",
           get_coded_string_value(
                   programEncounter.observations -> '80fccb06-a62f-43e8-92eb-358bdb600079', concepts.map)::TEXT as "Enc.Place of referral",
           (programEncounter.observations ->> 'd169efa9-49af-4c84-ae09-b1b7296c62da')::TEXT        as "Enc.Other place of referral",
           get_coded_string_value(
                   programEncounter.observations -> '8a56f008-a910-4d6f-b028-a95db330dbf2', concepts.map)::TEXT  as "Enc.Referral reason",
           (programEncounter.observations ->> 'e048675e-eb86-41c2-a47b-aecfa9a3bb8c')::TEXT        as "Enc.Other referral reason",
           get_coded_string_value(
                   programEncounter.observations -> '390483c2-fd5f-4044-bfd1-81732b4f6c71', concepts.map)::TEXT  as "Enc.High Risk Conditions",
           programEncounter.cancel_date_time                                                          "EncCancel.cancel_date_time",
           get_coded_string_value(
                   programEncounter.observations -> 'bf400e7f-8e1b-4052-af49-b0db47b3eb5a', concepts.map)::TEXT as "EncCancel.Visit cancel reason",
           (programEncounter.observations ->> 'd038a9c4-fe96-4c09-b883-c80691427b60')::TEXT        as "EncCancel.Other reason for cancelling",
           (programEncounter.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "EncCancel.Date of next ANC Visit"
    FROM program_encounter programEncounter
            CROSS JOIN concepts
             LEFT OUTER JOIN operational_encounter_type oet
                             on programEncounter.encounter_type_id = oet.encounter_type_id
             LEFT OUTER JOIN program_enrolment programEnrolment
                             ON programEncounter.program_enrolment_id = programEnrolment.id
             LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
             LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
             LEFT OUTER JOIN gender g ON g.id = individual.gender_id
             left join address_level village ON individual.address_id = village.id
             left join address_level cluster on village.parent_id = cluster.id
             LEFT JOIN audit a ON programEncounter.audit_id = a.id
             LEFT JOIN users u ON a.created_by_id = u.id
    WHERE op.uuid = '369dc9d1-ea43-47cf-9a32-5e98a81b2de4'
      AND oet.uuid = '1a46cad4-e81a-4170-8161-2c3f66526e62'
      AND programEncounter.encounter_date_time IS NOT NULL
      AND programEnrolment.enrolment_date_time IS NOT NULL
);

drop view if exists jsscp_lab_investigation_result_for_pregnancy_included_diabetes;
create view jsscp_lab_investigation_result_for_pregnancy_included_diabetes as (
      WITH concepts AS (
          SELECT hstore((array_agg(concept.uuid))::text[], (array_agg(concept.name))::text[]) AS map
          FROM concept
      )
    SELECT individual.id                                                                              "Ind.Id",
           individual.address_id                                                                      "Ind.address_id",
           individual.uuid                                                                            "Ind.uuid",
           individual.first_name                                                                      "Ind.first_name",
           individual.last_name                                                                       "Ind.last_name",
           g.name                                                                                     "Ind.Gender",
           individual.date_of_birth                                                                   "Ind.date_of_birth",
           individual.date_of_birth_verified                                                          "Ind.date_of_birth_verified",
           individual.registration_date                                                               "Ind.registration_date",
           individual.facility_id                                                                     "Ind.facility_id",
           village.title                                                                              "Ind.village",
           cluster.title                                                                              "Ind.cluster",
           u.name                                                                                     "Enc.username",
           individual.is_voided                                                                       "Ind.is_voided",
           op.name                                                                                    "Enl.Program Name",
           programEnrolment.id                                                                        "Enl.Id",
           programEnrolment.uuid                                                                      "Enl.uuid",
           programEnrolment.is_voided                                                                 "Enl.is_voided",
           oet.name                                                                                   "Enc.Type",
           programEncounter.id                                                                        "Enc.Id",
           programEncounter.earliest_visit_date_time                                                  "Enc.earliest_visit_date_time",
           programEncounter.encounter_date_time                                                       "Enc.encounter_date_time",
           programEncounter.program_enrolment_id                                                      "Enc.program_enrolment_id",
           programEncounter.uuid                                                                      "Enc.uuid",
           programEncounter.name                                                                      "Enc.name",
           programEncounter.max_visit_date_time                                                       "Enc.max_visit_date_time",
           programEncounter.is_voided                                                                 "Enc.is_voided",
           (individual.observations ->> 'ecdf3c54-2808-494d-87be-8fb744d5c3bc')::TEXT              as "Ind.Father/Husband's Name",
           get_coded_string_value(
                   individual.observations -> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b', concepts.map)::TEXT       as "Ind.Marital status",
           (individual.observations ->> '9d958124-09bb-466c-a4b4-db8d285def1f')::DATE              as "Ind.Date of marriage",
           get_coded_string_value(
                   individual.observations -> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b', concepts.map)::TEXT       as "Ind.Education",
           get_coded_string_value(
                   individual.observations -> '20ef261a-f110-4eaa-a592-2a1eeb0bf061', concepts.map)::TEXT       as "Ind.Occupation",
           (individual.observations ->> '4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT              as "Ind.Other occupation",
           get_coded_string_value(
                   individual.observations -> 'bab107f6-fc0e-4be7-ab71-658a92d72f35', concepts.map)::TEXT       as "Ind.Whether any disability",
           get_coded_string_value(
                   individual.observations -> '7061c675-c2ba-4016-886d-eeb432548378', concepts.map)::TEXT        as "Ind.Type of disability",
           get_coded_string_value(
                   individual.observations -> 'd333f2a2-717e-478f-acbc-173bc7374d66', concepts.map)::TEXT       as "Ind.Status of the individual",
           (individual.observations ->> '681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT              as "Ind.Aadhaar ID",
           (individual.observations ->> '0a725832-b21c-4151-b017-7e6af770ba54')::TEXT              as "Ind.Contact Number",
           get_coded_string_value(
                   individual.observations -> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b', concepts.map)::TEXT       as "Ind.Smart card (Insurance)",
           (programEnrolment.observations ->> 'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c')::TEXT        as "Enl.ANC Enrolment ID",
           get_coded_string_value(
                   programEnrolment.observations -> '58d0a437-17ef-4d58-a36f-9a36b608f5a4', concepts.map)::TEXT as "Enl.Relation with village",
           (programEnrolment.observations ->> 'aaac11d9-1237-41ac-9cf9-239c1226048a')::TEXT        as "Enl.Other relation with village",
           (programEnrolment.observations ->> '838cdad2-e661-4517-88ca-5b9e8e6c676e')::TEXT        as "Enl.Gravida",
           (programEnrolment.observations ->> '6956e0f7-d31b-4fb5-a3de-bd6251b24f49')::TEXT        as "Enl.Parity",
           (programEnrolment.observations ->> '47bb4fbd-729b-48db-995c-4464e26dd3f3')::TEXT        as "Enl.Live birth",
           (programEnrolment.observations ->> '73e37865-47a7-44ef-8a06-870b79e55fbd')::TEXT        as "Enl.still birth",
           (programEnrolment.observations ->> '1465d2a8-dd5a-4cec-9cc3-ab9c7ba22cc2')::TEXT        as "Enl.number of abortions",
           (programEnrolment.observations ->> '42a98500-3c12-426b-9121-e0e993dbacaf')::TEXT        as "Enl.prganancy,death",
           (programEnrolment.observations ->> '24b4a632-42bd-4847-91f4-7d8e69929581')::TEXT        as "Enl.Death of children within 1 week after delivery",
           (programEnrolment.observations ->> 'c9b244f3-7795-4f5a-a0aa-ccafd1e57b94')::TEXT        as "Enl.Death of children due to congenital abnormality",
           (programEnrolment.observations ->> '814f1780-aa3d-4c46-b881-71face696220')::DATE        as "Enl.Last menstrual period",
           (programEnrolment.observations ->> '730ca106-ece0-495d-8962-f60f38e79d12')::DATE        as "Enl.EDD",
           (programEnrolment.observations ->> 'e817dda1-0cd7-40a9-8d30-06aafbbbbf24')::TEXT        as "Enl.Is women registered within 3 months",
           (programEnrolment.observations ->> '748b7b66-c9ce-496f-b670-9d2896e82c23')::DATE        as "Enl.Last Delivery",
           get_coded_string_value(
                   programEnrolment.observations -> '1952339b-14b0-447d-b6d7-6bcf18b4af62', concepts.map)::TEXT as "Enl.Last delivery place",
           get_coded_string_value(
                   programEnrolment.observations -> '6c771640-52b6-46ea-bd56-0a2670ab7a6d', concepts.map)::TEXT as "Enl.Last delivery outcome",
           get_coded_string_value(
                   programEnrolment.observations -> 'f776b045-2fcb-4275-b08e-e3e9039b699e', concepts.map)::TEXT as "Enl.Last delivery gender",
           get_coded_string_value(
                   programEnrolment.observations -> '2f68ca5f-c690-4848-aa2e-592d6c7ef4e8', concepts.map)::TEXT as "Enl.Last delivery- Is baby alive?",
           get_coded_string_value(
                   programEnrolment.observations -> '26cee30f-b36d-4be2-bec3-9a0904492e52', concepts.map)::TEXT as "Enl.Any High risk condition in previous pregnancy",
           get_coded_string_value(
                   programEnrolment.observations -> 'a0aea5a9-7101-48ef-8463-5b376efa61bf', concepts.map)::TEXT  as "Enl.High risk condition in previous pregnancy",
           (programEnrolment.observations ->> '6bdfb87a-fefc-48ea-bcab-8bd05cbae73d')::TEXT        as "Enl.Other high risk condition in previous pregnancy",
           get_coded_string_value(
                   programEnrolment.observations -> 'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2', concepts.map)::TEXT as "Enl.Taking medicine for chronic disease",
           get_coded_string_value(
                   programEnrolment.observations -> '7d9b6992-ee27-4423-90a5-9ad20400d885', concepts.map)::TEXT  as "Enl.Name of chronic disease",
           (programEnrolment.observations ->> 'a54d0c2c-a054-45a5-a143-9f6c9db3fbbd')::TEXT        as "Enl.Other chronic disease",
           get_coded_string_value(
                   programEnrolment.observations -> '1aac0eaf-1c9e-4284-93c3-7212c06a3286', concepts.map)::TEXT as "Enl.Does woman want to continue this pregnancy?",
           get_coded_string_value(
                   programEnrolment.observations -> 'b5ebc472-0f32-4128-97f3-0e2571daeaae', concepts.map)::TEXT as "Enl.Send her to nearest antenatal clinic",
           (programEnrolment.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "Enl.Date of next ANC Visit",
           get_coded_string_value(
                   programEnrolment.observations -> 'b6f45def-e3f4-4e7b-97ed-68c539b82fa2', concepts.map)::TEXT as "Enl.Send her to hospital for abortion",
           (programEncounter.observations ->> 'eb771b86-8c5b-461f-a9f4-4a4815ebeeb3')::TEXT        as "Enc.FBS",
           (programEncounter.observations ->> '04806ab3-426b-4909-b2c0-65b590f8250c')::TEXT        as "Enc.PP2BS",
           (programEncounter.observations ->> 'f11d4eca-f6ca-4471-9a6b-e1f5d742bc22')::TEXT        as "Enc.HbA1C",
           programEncounter.cancel_date_time                                                          "EncCancel.cancel_date_time"
    FROM program_encounter programEncounter
             CROSS JOIN concepts
             LEFT OUTER JOIN operational_encounter_type oet
                             on programEncounter.encounter_type_id = oet.encounter_type_id
             LEFT OUTER JOIN program_enrolment programEnrolment
                             ON programEncounter.program_enrolment_id = programEnrolment.id
             LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
             LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
             LEFT OUTER JOIN gender g ON g.id = individual.gender_id
             left join address_level village ON individual.address_id = village.id
             left join address_level cluster on village.parent_id = cluster.id
             LEFT JOIN audit a ON programEncounter.audit_id = a.id
             LEFT JOIN users u ON a.created_by_id = u.id
    WHERE op.uuid = '369dc9d1-ea43-47cf-9a32-5e98a81b2de4'
      AND oet.uuid = '49e7dad5-dc1c-4068-9cc9-cc31f11652b3'
      AND programEncounter.encounter_date_time IS NOT NULL
      AND programEnrolment.enrolment_date_time IS NOT NULL
);

drop view if exists jsscp_delivery_view;
create view jsscp_delivery_view as (
   WITH concepts AS (
       SELECT hstore((array_agg(concept.uuid))::text[], (array_agg(concept.name))::text[]) AS map
       FROM concept
   )
    SELECT individual.id                                                                              "Ind.Id",
           individual.address_id                                                                      "Ind.address_id",
           individual.uuid                                                                            "Ind.uuid",
           individual.first_name                                                                      "Ind.first_name",
           individual.last_name                                                                       "Ind.last_name",
           g.name                                                                                     "Ind.Gender",
           individual.date_of_birth                                                                   "Ind.date_of_birth",
           individual.date_of_birth_verified                                                          "Ind.date_of_birth_verified",
           individual.registration_date                                                               "Ind.registration_date",
           individual.facility_id                                                                     "Ind.facility_id",
           village.title                                                                              "Ind.village",
           cluster.title                                                                              "Ind.cluster",
           u.name                                                                                     "Enc.username",
           individual.is_voided                                                                       "Ind.is_voided",
           op.name                                                                                    "Enl.Program Name",
           programEnrolment.id                                                                        "Enl.Id",
           programEnrolment.uuid                                                                      "Enl.uuid",
           programEnrolment.is_voided                                                                 "Enl.is_voided",
           oet.name                                                                                   "Enc.Type",
           programEncounter.id                                                                        "Enc.Id",
           programEncounter.earliest_visit_date_time                                                  "Enc.earliest_visit_date_time",
           programEncounter.encounter_date_time                                                       "Enc.encounter_date_time",
           programEncounter.program_enrolment_id                                                      "Enc.program_enrolment_id",
           programEncounter.uuid                                                                      "Enc.uuid",
           programEncounter.name                                                                      "Enc.name",
           programEncounter.max_visit_date_time                                                       "Enc.max_visit_date_time",
           programEncounter.is_voided                                                                 "Enc.is_voided",
           (individual.observations ->> 'ecdf3c54-2808-494d-87be-8fb744d5c3bc')::TEXT              as "Ind.Father/Husband's Name",
           get_coded_string_value(
                   individual.observations -> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b', concepts.map)::TEXT       as "Ind.Marital status",
           (individual.observations ->> '9d958124-09bb-466c-a4b4-db8d285def1f')::DATE              as "Ind.Date of marriage",
           get_coded_string_value(
                   individual.observations -> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b', concepts.map)::TEXT       as "Ind.Education",
           get_coded_string_value(
                   individual.observations -> '20ef261a-f110-4eaa-a592-2a1eeb0bf061', concepts.map)::TEXT       as "Ind.Occupation",
           (individual.observations ->> '4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT              as "Ind.Other occupation",
           get_coded_string_value(
                   individual.observations -> 'bab107f6-fc0e-4be7-ab71-658a92d72f35', concepts.map)::TEXT       as "Ind.Whether any disability",
           get_coded_string_value(
                   individual.observations -> '7061c675-c2ba-4016-886d-eeb432548378', concepts.map)::TEXT        as "Ind.Type of disability",
           get_coded_string_value(
                   individual.observations -> 'd333f2a2-717e-478f-acbc-173bc7374d66', concepts.map)::TEXT       as "Ind.Status of the individual",
           (individual.observations ->> '681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT              as "Ind.Aadhaar ID",
           (individual.observations ->> '0a725832-b21c-4151-b017-7e6af770ba54')::TEXT              as "Ind.Contact Number",
           get_coded_string_value(
                   individual.observations -> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b', concepts.map)::TEXT       as "Ind.Smart card (Insurance)",
           (programEnrolment.observations ->> 'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c')::TEXT        as "Enl.ANC Enrolment ID",
           get_coded_string_value(
                   programEnrolment.observations -> '58d0a437-17ef-4d58-a36f-9a36b608f5a4', concepts.map)::TEXT as "Enl.Relation with village",
           (programEnrolment.observations ->> 'aaac11d9-1237-41ac-9cf9-239c1226048a')::TEXT        as "Enl.Other relation with village",
           (programEnrolment.observations ->> '838cdad2-e661-4517-88ca-5b9e8e6c676e')::TEXT        as "Enl.Gravida",
           (programEnrolment.observations ->> '6956e0f7-d31b-4fb5-a3de-bd6251b24f49')::TEXT        as "Enl.Parity",
           (programEnrolment.observations ->> '47bb4fbd-729b-48db-995c-4464e26dd3f3')::TEXT        as "Enl.Live birth",
           (programEnrolment.observations ->> '73e37865-47a7-44ef-8a06-870b79e55fbd')::TEXT        as "Enl.still birth",
           (programEnrolment.observations ->> '1465d2a8-dd5a-4cec-9cc3-ab9c7ba22cc2')::TEXT        as "Enl.number of abortions",
           (programEnrolment.observations ->> '42a98500-3c12-426b-9121-e0e993dbacaf')::TEXT        as "Enl.prganancy,death",
           (programEnrolment.observations ->> '24b4a632-42bd-4847-91f4-7d8e69929581')::TEXT        as "Enl.Death of children within 1 week after delivery",
           (programEnrolment.observations ->> 'c9b244f3-7795-4f5a-a0aa-ccafd1e57b94')::TEXT        as "Enl.Death of children due to congenital abnormality",
           (programEnrolment.observations ->> '814f1780-aa3d-4c46-b881-71face696220')::DATE        as "Enl.Last menstrual period",
           (programEnrolment.observations ->> '730ca106-ece0-495d-8962-f60f38e79d12')::DATE        as "Enl.EDD",
           (programEnrolment.observations ->> 'e817dda1-0cd7-40a9-8d30-06aafbbbbf24')::TEXT        as "Enl.Is women registered within 3 months",
           (programEnrolment.observations ->> '748b7b66-c9ce-496f-b670-9d2896e82c23')::DATE        as "Enl.Last Delivery",
           get_coded_string_value(
                   programEnrolment.observations -> '1952339b-14b0-447d-b6d7-6bcf18b4af62', concepts.map)::TEXT as "Enl.Last delivery place",
           get_coded_string_value(
                   programEnrolment.observations -> '6c771640-52b6-46ea-bd56-0a2670ab7a6d', concepts.map)::TEXT as "Enl.Last delivery outcome",
           get_coded_string_value(
                   programEnrolment.observations -> 'f776b045-2fcb-4275-b08e-e3e9039b699e', concepts.map)::TEXT as "Enl.Last delivery gender",
           get_coded_string_value(
                   programEnrolment.observations -> '2f68ca5f-c690-4848-aa2e-592d6c7ef4e8', concepts.map)::TEXT as "Enl.Last delivery- Is baby alive?",
           get_coded_string_value(
                   programEnrolment.observations -> '26cee30f-b36d-4be2-bec3-9a0904492e52', concepts.map)::TEXT as "Enl.Any High risk condition in previous pregnancy",
           get_coded_string_value(
                   programEnrolment.observations -> 'a0aea5a9-7101-48ef-8463-5b376efa61bf', concepts.map)::TEXT  as "Enl.High risk condition in previous pregnancy",
           (programEnrolment.observations ->> '6bdfb87a-fefc-48ea-bcab-8bd05cbae73d')::TEXT        as "Enl.Other high risk condition in previous pregnancy",
           get_coded_string_value(
                   programEnrolment.observations -> 'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2', concepts.map)::TEXT as "Enl.Taking medicine for chronic disease",
           get_coded_string_value(
                   programEnrolment.observations -> '7d9b6992-ee27-4423-90a5-9ad20400d885', concepts.map)::TEXT  as "Enl.Name of chronic disease",
           (programEnrolment.observations ->> 'a54d0c2c-a054-45a5-a143-9f6c9db3fbbd')::TEXT        as "Enl.Other chronic disease",
           get_coded_string_value(
                   programEnrolment.observations -> '1aac0eaf-1c9e-4284-93c3-7212c06a3286', concepts.map)::TEXT as "Enl.Does woman want to continue this pregnancy?",
           get_coded_string_value(
                   programEnrolment.observations -> 'b5ebc472-0f32-4128-97f3-0e2571daeaae', concepts.map)::TEXT as "Enl.Send her to nearest antenatal clinic",
           (programEnrolment.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "Enl.Date of next ANC Visit",
           get_coded_string_value(
                   programEnrolment.observations -> 'b6f45def-e3f4-4e7b-97ed-68c539b82fa2', concepts.map)::TEXT as "Enl.Send her to hospital for abortion",
           (programEncounter.observations ->> '3584ab7c-061d-472f-996e-8082bc7ee5b4')::timestamp        as "Enc.Date and time of labour pain started",
           (programEncounter.observations ->> '75f66882-8186-4a8c-b1f3-1f6b2386fef6')::timestamp        as "Enc.Date and time when baby was out",
           (programEncounter.observations ->> '0bcf8d88-f9c5-4e9a-89bb-10f31cfff0a3')::TEXT        as "Enc.Gestational age category",
           get_coded_string_value(
                   programEncounter.observations -> 'dea1a2d3-2583-4a77-8723-e64d9e10079e', concepts.map)::TEXT as "Enc.Place of delivery",
           (programEncounter.observations ->> 'ebdc6d6b-4510-4659-b595-a090186d1832')::TEXT        as "Enc.Other place of delivery",
           get_coded_string_value(
                   programEncounter.observations -> 'c48b5ece-3daf-4f19-9754-11bd898020fc', concepts.map)::TEXT as "Enc.Type of delivery",
           get_coded_string_value(
                   programEncounter.observations -> '11bfa900-973e-49ff-bc2b-cab409d6e938', concepts.map)::TEXT as "Enc.Delivery conducted by",
           (programEncounter.observations ->> '03ae48d3-6d4e-4e39-8194-cb2653c0eaf7')::TEXT        as "Enc.Other who conducted delivery",
           (programEncounter.observations ->> '99ab36e9-ca7f-4627-b0a4-2ca5bef6c4ad')::TEXT        as "Enc.Name of person who conducted delivery",
           (programEncounter.observations ->> '0c0158a5-f13d-4eed-8c9c-56f5a5b37817')::TEXT        as "Enc.Name of village where woman delivered",
           get_coded_string_value(
                   programEncounter.observations -> 'c45fa5f8-098d-49af-8119-6a5c55012e1b', concepts.map)::TEXT  as "Enc.Danger signs during the process of labour",
           get_coded_string_value(
                   programEncounter.observations -> '68891675-51d5-4a64-9cd6-e19ca54f2c1f', concepts.map)::TEXT as "Enc.Part of foetus that came first",
           get_coded_string_value(
                   programEncounter.observations -> '51477c5d-3d96-4b5b-abe0-9350fdcdbd83', concepts.map)::TEXT as "Enc.Colour of amniotic fluid",
           (programEncounter.observations ->> 'ac9f7563-ad2b-4df2-aa1f-6df3a9c50c21')::TEXT        as "Enc.Other colour of amniotic fluid",
           get_coded_string_value(
                   programEncounter.observations -> '8a2fa4f0-e202-47a7-ba55-31e8b1649818', concepts.map)::TEXT as "Enc.Was mother given tab. Misoprostol (3 tabs)/ Inj. Oxytocin (on thigh) within 1 minute after the birth?",
           get_coded_string_value(
                   programEncounter.observations -> '0291dab0-0e30-485c-b8b2-16570e3ef7bd', concepts.map)::TEXT as "Enc.Was placenta delivered by pulling",
           get_coded_string_value(
                   programEncounter.observations -> '8a096d3f-a966-4930-b137-619fd13183d2', concepts.map)::TEXT as "Enc.Was mother given anything to drink?",
           get_coded_string_value(
                   programEncounter.observations -> '16c71db0-bdaa-42d0-b247-e9d573f62866', concepts.map)::TEXT as "Enc.Did mother breastfed the baby within 1 hour after the birth",
           get_coded_string_value(
                   programEncounter.observations -> 'e693e145-db22-4dca-a5a8-f6f455a52248', concepts.map)::TEXT as "Enc.Was safe delivery kit used for conducting delivery",
           get_coded_string_value(
                   programEncounter.observations -> '22ec084c-7141-4828-99c7-2dc56fe11153', concepts.map)::TEXT as "Enc.Did woman receive vitamin A",
           get_coded_string_value(
                   programEncounter.observations -> 'd5f2dd94-46c0-4397-88bf-92db83e381d1', concepts.map)::TEXT as "Enc.Were stitches taken for episiotomy",
           programEncounter.cancel_date_time                                                          "EncCancel.cancel_date_time",
           get_coded_string_value(
                   programEncounter.observations -> 'bf400e7f-8e1b-4052-af49-b0db47b3eb5a', concepts.map)::TEXT as "EncCancel.Visit cancel reason",
           (programEncounter.observations ->> 'd038a9c4-fe96-4c09-b883-c80691427b60')::TEXT        as "EncCancel.Other reason for cancelling",
           (programEncounter.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "EncCancel.Date of next ANC Visit",
           (programEnrolment.program_exit_date_time)::DATE                                         as "Enl.exit_date_time"
    FROM program_encounter programEncounter
             CROSS JOIN concepts
             LEFT OUTER JOIN operational_encounter_type oet
                             on programEncounter.encounter_type_id = oet.encounter_type_id
             LEFT OUTER JOIN program_enrolment programEnrolment
                             ON programEncounter.program_enrolment_id = programEnrolment.id
             LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
             LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
             LEFT OUTER JOIN gender g ON g.id = individual.gender_id
             left join address_level village ON individual.address_id = village.id
             left join address_level cluster on village.parent_id = cluster.id
             LEFT JOIN audit a ON programEncounter.audit_id = a.id
             LEFT JOIN users u ON a.created_by_id = u.id
    WHERE op.uuid = '369dc9d1-ea43-47cf-9a32-5e98a81b2de4'
      AND oet.uuid = 'c05ea806-1704-422f-a6e1-97c577fc95cc'
      AND programEncounter.encounter_date_time IS NOT NULL
      AND programEnrolment.enrolment_date_time IS NOT NULL
);


drop view if exists jsscp_abortion_view;
create view jsscp_abortion_view as (
   WITH concepts AS (
       SELECT hstore((array_agg(concept.uuid))::text[], (array_agg(concept.name))::text[]) AS map
       FROM concept
   )
    SELECT individual.id                                                                              "Ind.Id",
           individual.address_id                                                                      "Ind.address_id",
           individual.uuid                                                                            "Ind.uuid",
           individual.first_name                                                                      "Ind.first_name",
           individual.last_name                                                                       "Ind.last_name",
           g.name                                                                                     "Ind.Gender",
           individual.date_of_birth                                                                   "Ind.date_of_birth",
           individual.date_of_birth_verified                                                          "Ind.date_of_birth_verified",
           individual.registration_date                                                               "Ind.registration_date",
           individual.facility_id                                                                     "Ind.facility_id",
           village.title                                                                              "Ind.village",
           cluster.title                                                                              "Ind.cluster",
           u.name                                                                                     "Enc.username",
           individual.is_voided                                                                       "Ind.is_voided",
           op.name                                                                                    "Enl.Program Name",
           programEnrolment.id                                                                        "Enl.Id",
           programEnrolment.uuid                                                                      "Enl.uuid",
           programEnrolment.is_voided                                                                 "Enl.is_voided",
           programEnrolment.program_exit_date_time                                                    "Enl.program_exit_date_time",
           oet.name                                                                                   "Enc.Type",
           programEncounter.id                                                                        "Enc.Id",
           programEncounter.earliest_visit_date_time                                                  "Enc.earliest_visit_date_time",
           programEncounter.encounter_date_time                                                       "Enc.encounter_date_time",
           programEncounter.program_enrolment_id                                                      "Enc.program_enrolment_id",
           programEncounter.uuid                                                                      "Enc.uuid",
           programEncounter.name                                                                      "Enc.name",
           programEncounter.max_visit_date_time                                                       "Enc.max_visit_date_time",
           programEncounter.is_voided                                                                 "Enc.is_voided",
           (individual.observations ->> 'ecdf3c54-2808-494d-87be-8fb744d5c3bc')::TEXT              as "Ind.Father/Husband's Name",
           get_coded_string_value(
                   individual.observations -> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b', concepts.map)::TEXT       as "Ind.Marital status",
           (individual.observations ->> '9d958124-09bb-466c-a4b4-db8d285def1f')::DATE              as "Ind.Date of marriage",
           get_coded_string_value(
                   individual.observations -> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b', concepts.map)::TEXT       as "Ind.Education",
           get_coded_string_value(
                   individual.observations -> '20ef261a-f110-4eaa-a592-2a1eeb0bf061', concepts.map)::TEXT       as "Ind.Occupation",
           (individual.observations ->> '4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT              as "Ind.Other occupation",
           get_coded_string_value(
                   individual.observations -> 'bab107f6-fc0e-4be7-ab71-658a92d72f35', concepts.map)::TEXT       as "Ind.Whether any disability",
           get_coded_string_value(
                   individual.observations -> '7061c675-c2ba-4016-886d-eeb432548378', concepts.map)::TEXT        as "Ind.Type of disability",
           get_coded_string_value(
                   individual.observations -> 'd333f2a2-717e-478f-acbc-173bc7374d66', concepts.map)::TEXT       as "Ind.Status of the individual",
           (individual.observations ->> '681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT              as "Ind.Aadhaar ID",
           (individual.observations ->> '0a725832-b21c-4151-b017-7e6af770ba54')::TEXT              as "Ind.Contact Number",
           get_coded_string_value(
                   individual.observations -> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b', concepts.map)::TEXT       as "Ind.Smart card (Insurance)",
           (programEnrolment.observations ->> 'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c')::TEXT        as "Enl.ANC Enrolment ID",
           get_coded_string_value(
                   programEnrolment.observations -> '58d0a437-17ef-4d58-a36f-9a36b608f5a4', concepts.map)::TEXT as "Enl.Relation with village",
           (programEnrolment.observations ->> 'aaac11d9-1237-41ac-9cf9-239c1226048a')::TEXT        as "Enl.Other relation with village",
           (programEnrolment.observations ->> '838cdad2-e661-4517-88ca-5b9e8e6c676e')::TEXT        as "Enl.Gravida",
           (programEnrolment.observations ->> '6956e0f7-d31b-4fb5-a3de-bd6251b24f49')::TEXT        as "Enl.Parity",
           (programEnrolment.observations ->> '47bb4fbd-729b-48db-995c-4464e26dd3f3')::TEXT        as "Enl.Live birth",
           (programEnrolment.observations ->> '73e37865-47a7-44ef-8a06-870b79e55fbd')::TEXT        as "Enl.still birth",
           (programEnrolment.observations ->> '1465d2a8-dd5a-4cec-9cc3-ab9c7ba22cc2')::TEXT        as "Enl.number of abortions",
           (programEnrolment.observations ->> '42a98500-3c12-426b-9121-e0e993dbacaf')::TEXT        as "Enl.prganancy,death",
           (programEnrolment.observations ->> '24b4a632-42bd-4847-91f4-7d8e69929581')::TEXT        as "Enl.Death of children within 1 week after delivery",
           (programEnrolment.observations ->> 'c9b244f3-7795-4f5a-a0aa-ccafd1e57b94')::TEXT        as "Enl.Death of children due to congenital abnormality",
           (programEnrolment.observations ->> '814f1780-aa3d-4c46-b881-71face696220')::DATE        as "Enl.Last menstrual period",
           (programEnrolment.observations ->> '730ca106-ece0-495d-8962-f60f38e79d12')::DATE        as "Enl.EDD",
           (programEnrolment.observations ->> 'e817dda1-0cd7-40a9-8d30-06aafbbbbf24')::TEXT        as "Enl.Is women registered within 3 months",
           (programEnrolment.observations ->> '748b7b66-c9ce-496f-b670-9d2896e82c23')::DATE        as "Enl.Last Delivery",
           get_coded_string_value(
                   programEnrolment.observations -> '1952339b-14b0-447d-b6d7-6bcf18b4af62', concepts.map)::TEXT as "Enl.Last delivery place",
           get_coded_string_value(
                   programEnrolment.observations -> '6c771640-52b6-46ea-bd56-0a2670ab7a6d', concepts.map)::TEXT as "Enl.Last delivery outcome",
           get_coded_string_value(
                   programEnrolment.observations -> 'f776b045-2fcb-4275-b08e-e3e9039b699e', concepts.map)::TEXT as "Enl.Last delivery gender",
           get_coded_string_value(
                   programEnrolment.observations -> '2f68ca5f-c690-4848-aa2e-592d6c7ef4e8', concepts.map)::TEXT as "Enl.Last delivery- Is baby alive?",
           get_coded_string_value(
                   programEnrolment.observations -> '26cee30f-b36d-4be2-bec3-9a0904492e52', concepts.map)::TEXT as "Enl.Any High risk condition in previous pregnancy",
           get_coded_string_value(
                   programEnrolment.observations -> 'a0aea5a9-7101-48ef-8463-5b376efa61bf', concepts.map)::TEXT  as "Enl.High risk condition in previous pregnancy",
           (programEnrolment.observations ->> '6bdfb87a-fefc-48ea-bcab-8bd05cbae73d')::TEXT        as "Enl.Other high risk condition in previous pregnancy",
           get_coded_string_value(
                   programEnrolment.observations -> 'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2', concepts.map)::TEXT as "Enl.Taking medicine for chronic disease",
           get_coded_string_value(
                   programEnrolment.observations -> '7d9b6992-ee27-4423-90a5-9ad20400d885', concepts.map)::TEXT  as "Enl.Name of chronic disease",
           (programEnrolment.observations ->> 'a54d0c2c-a054-45a5-a143-9f6c9db3fbbd')::TEXT        as "Enl.Other chronic disease",
           get_coded_string_value(
                   programEnrolment.observations -> '1aac0eaf-1c9e-4284-93c3-7212c06a3286', concepts.map)::TEXT as "Enl.Does woman want to continue this pregnancy?",
           get_coded_string_value(
                   programEnrolment.observations -> 'b5ebc472-0f32-4128-97f3-0e2571daeaae', concepts.map)::TEXT as "Enl.Send her to nearest antenatal clinic",
           (programEnrolment.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "Enl.Date of next ANC Visit",
           get_coded_string_value(
                   programEnrolment.observations -> 'b6f45def-e3f4-4e7b-97ed-68c539b82fa2', concepts.map)::TEXT as "Enl.Send her to hospital for abortion",
           (programEncounter.observations ->> '6cff2f40-fd04-48e1-89d8-497142e20d4d')::DATE        as "Enc.Date and time of abortion",
           get_coded_string_value(
                   programEncounter.observations -> 'cb23a7f2-8746-402d-88b7-013a70e01e2b', concepts.map)::TEXT as "Enc.Type of abortion",
           get_coded_string_value(
                   programEncounter.observations -> '16e2956e-1265-4e2c-b4ef-eb7568b5c69d', concepts.map)::TEXT as "Enc.Place of Abortion",
           (programEncounter.observations ->> '26d8c447-3c27-4a42-a47a-8b4a2b1946e9')::TEXT        as "Enc.Specify other place of abortion",
           get_coded_string_value(
                   programEncounter.observations -> '68740322-f381-4de6-9e06-ad9f93e81f93', concepts.map)::TEXT as "Enc.Abortion done by",
           (programEncounter.observations ->> 'd346b862-6d69-4b1e-b6dc-2cee6036d066')::TEXT        as "Enc.Specify the who other did the abortion",
           get_coded_string_value(
                   programEncounter.observations -> 'e1dab606-f18e-4007-940a-5df6f48af91a', concepts.map)::TEXT as "Enc.If self medication, where did woman get the medicine from",
           (programEncounter.observations ->> 'ad707cd2-4ddd-4d5e-89ba-6a9eea4e792d')::TEXT        as "Enc.Other place from where woman got the medicine",
           get_coded_string_value(
                   programEncounter.observations -> '3fc12cff-0b61-45f5-af60-93b0f19570da', concepts.map)::TEXT  as "Enc.Complication due to abortion",
           (programEncounter.observations ->> '39633d82-8da1-458e-a759-1d558d3a3a92')::TEXT        as "Enc.Other complication faced due to abortion",
           (programEncounter.observations ->> 'aba42644-f860-4c73-aa0e-8b22c563cbb0')::TEXT        as "Enc.Name of village where woman got abortion done",
           get_coded_string_value(
                   programEncounter.observations -> '77d122e8-0620-4754-8375-b0cbe329003c', concepts.map)::TEXT as "Enc.Does woman require referral?",
           get_coded_string_value(
                   programEncounter.observations -> '80fccb06-a62f-43e8-92eb-358bdb600079', concepts.map)::TEXT as "Enc.Place of referral",
           (programEncounter.observations ->> 'd169efa9-49af-4c84-ae09-b1b7296c62da')::TEXT        as "Enc.Other place of referral",
           get_coded_string_value(
                   programEncounter.observations -> '8a56f008-a910-4d6f-b028-a95db330dbf2', concepts.map)::TEXT as "Enc.Referral reason",
           (programEncounter.observations ->> 'e048675e-eb86-41c2-a47b-aecfa9a3bb8c')::TEXT        as "Enc.Other referral reason",
           programEncounter.cancel_date_time                                                          "EncCancel.cancel_date_time",
           get_coded_string_value(
                   programEncounter.observations -> 'bf400e7f-8e1b-4052-af49-b0db47b3eb5a', concepts.map)::TEXT as "EncCancel.Visit cancel reason",
           (programEncounter.observations ->> 'd038a9c4-fe96-4c09-b883-c80691427b60')::TEXT        as "EncCancel.Other reason for cancelling",
           (programEncounter.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "EncCancel.Date of next ANC Visit"
    FROM program_encounter programEncounter
             CROSS JOIN concepts
             LEFT OUTER JOIN operational_encounter_type oet
                             on programEncounter.encounter_type_id = oet.encounter_type_id
             LEFT OUTER JOIN program_enrolment programEnrolment
                             ON programEncounter.program_enrolment_id = programEnrolment.id
             LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
             LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
             LEFT OUTER JOIN gender g ON g.id = individual.gender_id
             left join address_level village ON individual.address_id = village.id
             left join address_level cluster on village.parent_id = cluster.id
             LEFT JOIN audit a ON programEncounter.audit_id = a.id
             LEFT JOIN users u ON a.created_by_id = u.id
    WHERE op.uuid = '369dc9d1-ea43-47cf-9a32-5e98a81b2de4'
      AND oet.uuid = 'd4c47c9a-8f1d-42bf-8238-18cf37f5b2c1'
      AND programEncounter.encounter_date_time IS NOT NULL
      AND programEnrolment.enrolment_date_time IS NOT NULL
);

drop view if exists jsscp_anc_home_visit_view;
create view jsscp_anc_home_visit_view as (
 WITH concepts AS (
     SELECT hstore((array_agg(concept.uuid))::text[], (array_agg(concept.name))::text[]) AS map
     FROM concept
 )
SELECT individual.id                                                                              "Ind.Id",
           individual.address_id                                                                      "Ind.address_id",
           individual.uuid                                                                            "Ind.uuid",
           individual.first_name                                                                      "Ind.first_name",
           individual.last_name                                                                       "Ind.last_name",
           g.name                                                                                     "Ind.Gender",
           individual.date_of_birth                                                                   "Ind.date_of_birth",
           individual.date_of_birth_verified                                                          "Ind.date_of_birth_verified",
           individual.registration_date                                                               "Ind.registration_date",
           individual.facility_id                                                                     "Ind.facility_id",
           a.title                                                                                    "Ind.Area",
           individual.is_voided                                                                       "Ind.is_voided",
           op.name                                                                                    "Enl.Program Name",
           programEnrolment.id                                                                        "Enl.Id",
           programEnrolment.uuid                                                                      "Enl.uuid",
           programEnrolment.is_voided                                                                 "Enl.is_voided",
           oet.name                                                                                   "Enc.Type",
           programEncounter.id                                                                        "Enc.Id",
           programEncounter.earliest_visit_date_time                                                  "Enc.earliest_visit_date_time",
           programEncounter.encounter_date_time                                                       "Enc.encounter_date_time",
           programEncounter.program_enrolment_id                                                      "Enc.program_enrolment_id",
           programEncounter.uuid                                                                      "Enc.uuid",
           programEncounter.name                                                                      "Enc.name",
           programEncounter.max_visit_date_time                                                       "Enc.max_visit_date_time",
           programEncounter.is_voided                                                                 "Enc.is_voided",
           (individual.observations ->> '821ba930-505c-4fd3-9f24-66b60ed45bac')::TEXT              as "Ind.Birth Order",
           (individual.observations ->> '9e6983b8-06ef-4648-b360-6684100b1be1')::TEXT              as "Ind.Father's Name",
           get_coded_string_value(
                   individual.observations -> 'bf564151-63f9-4176-917f-f37de34b9bae', concepts.map)::TEXT       as "Ind.Father's Occupation",
           get_coded_string_value(
                   individual.observations -> 'b1001c4d-0449-464a-947f-a04c4fdcc651', concepts.map)::TEXT       as "Ind.Father's education Level",
           (individual.observations ->> '74a554d8-5b87-4d27-9ae5-272ab326608f')::TEXT              as "Ind.Mother's Name",
           get_coded_string_value(
                   individual.observations -> 'ea760e4f-c12f-490b-9865-9c6e4510ce64', concepts.map)::TEXT       as "Ind.Mother's Occupation",
           get_coded_string_value(
                   individual.observations -> 'd98aae1a-ce33-4e51-b031-66e13bc0ba11', concepts.map)::TEXT       as "Ind.Mother's education Level",
           get_coded_string_value(
                   individual.observations -> 'b2c60cb8-983c-4e0e-a90d-4b21e87e10bd', concepts.map)::TEXT       as "Ind.Religion",
           get_coded_string_value(
                   individual.observations -> '9ad4b520-4e33-4b1b-a056-37ae6418988f', concepts.map)::TEXT       as "Ind.Caste Category",
           get_coded_string_value(
                   individual.observations -> '047877ac-dba7-4acf-8c77-97c979c2fc26', concepts.map)::TEXT       as "Ind.Sub Caste",
           (individual.observations ->> 'ae7d54e9-fac0-4898-b334-87664bd055d2')::TEXT              as "Ind.Other sub caste",
           get_coded_string_value(
                   individual.observations -> 'eaee156e-8ef3-4148-a80c-a466cd059ae3', concepts.map)::TEXT       as "Ind.Relation to head of the household",
           get_coded_string_value(
                   individual.observations -> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b', concepts.map)::TEXT       as "Ind.Marital status",
           (individual.observations ->> '9d958124-09bb-466c-a4b4-db8d285def1f')::DATE              as "Ind.Date of marriage",
           get_coded_string_value(
                   individual.observations -> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b', concepts.map)::TEXT       as "Ind.Education",
           get_coded_string_value(
                   individual.observations -> '20ef261a-f110-4eaa-a592-2a1eeb0bf061', concepts.map)::TEXT       as "Ind.Occupation",
           get_coded_string_value(
                   individual.observations -> '852f4e54-4969-4724-94e0-cddef0ac1f66', concepts.map)::TEXT       as "Ind.Is sterlization operation done?",
           get_coded_string_value(
                   individual.observations -> 'bab107f6-fc0e-4be7-ab71-658a92d72f35', concepts.map)::TEXT       as "Ind.Whether any disability",
           (individual.observations ->> 'eda07a4c-14c9-49af-b1d6-deaa695a5d36')::TEXT              as "Ind.Disability",
           get_coded_string_value(
                   individual.observations -> 'd333f2a2-717e-478f-acbc-173bc7374d66', concepts.map)::TEXT       as "Ind.Status of the individual",
           (individual.observations ->> '681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT              as "Ind.Aadhaar ID",
           (individual.observations ->> '0a725832-b21c-4151-b017-7e6af770ba54')::TEXT              as "Ind.Contact Number",
           get_coded_string_value(
                   individual.observations -> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b', concepts.map)::TEXT       as "Ind.Smart card (Insurance)",
           get_coded_string_value(
                   individual.observations -> 'e23ef639-5d54-46bc-811c-ee1886bce81f', concepts.map)::TEXT       as "Ind.Electricity in house",
           get_coded_string_value(
                   individual.observations -> 'b984ad33-05d8-4621-adf3-152e72a0db1b', concepts.map)::TEXT       as "Ind.Land possession",
           (individual.observations ->> '430ebb19-831d-470d-80eb-7969814f13e4')::TEXT              as "Ind.Land Area",
           get_coded_string_value(
                   individual.observations -> 'c5d2673b-0f5c-48bf-93e4-f1a1ae820732', concepts.map)::TEXT       as "Ind.Type of residence",
           get_coded_string_value(
                   individual.observations -> '86fc3018-8eeb-4a58-a9d9-a40fff839305', concepts.map)::TEXT       as "Ind.Ration Card",
           get_coded_string_value(
                   individual.observations -> 'aa88dba4-4f5d-4d35-9dc1-2390969cc5f3', concepts.map)::TEXT        as "Ind.Property",
           (individual.observations ->> '32609e0f-f3c8-4dcb-af7c-5e8a96e8e89d')::TEXT              as "Ind.Other property",
           get_coded_string_value(
                   programEnrolment.observations -> '58d0a437-17ef-4d58-a36f-9a36b608f5a4', concepts.map)::TEXT as "Enl.Relation with village",
           (programEnrolment.observations ->> '838cdad2-e661-4517-88ca-5b9e8e6c676e')::TEXT        as "Enl.Gravida",
           (programEnrolment.observations ->> '6956e0f7-d31b-4fb5-a3de-bd6251b24f49')::TEXT        as "Enl.Parity",
           (programEnrolment.observations ->> '47bb4fbd-729b-48db-995c-4464e26dd3f3')::TEXT        as "Enl.Live birth",
           (programEnrolment.observations ->> '73e37865-47a7-44ef-8a06-870b79e55fbd')::TEXT        as "Enl.still birth",
           (programEnrolment.observations ->> '1465d2a8-dd5a-4cec-9cc3-ab9c7ba22cc2')::TEXT        as "Enl.number of abortions",
           (programEnrolment.observations ->> '42a98500-3c12-426b-9121-e0e993dbacaf')::TEXT        as "Enl.prganancy,death",
           (programEnrolment.observations ->> '24b4a632-42bd-4847-91f4-7d8e69929581')::TEXT        as "Enl.Death of children within 1 week after delivery",
           (programEnrolment.observations ->> 'c9b244f3-7795-4f5a-a0aa-ccafd1e57b94')::TEXT        as "Enl.Death of children due to congenital abnormality",
           (programEnrolment.observations ->> '814f1780-aa3d-4c46-b881-71face696220')::DATE        as "Enl.Last menstrual period",
           (programEnrolment.observations ->> '730ca106-ece0-495d-8962-f60f38e79d12')::DATE        as "Enl.EDD",
           (programEnrolment.observations ->> 'e817dda1-0cd7-40a9-8d30-06aafbbbbf24')::TEXT        as "Enl.Is women registered within 3 months",
           (programEnrolment.observations ->> '748b7b66-c9ce-496f-b670-9d2896e82c23')::DATE        as "Enl.Last Delivery",
           get_coded_string_value(
                   programEnrolment.observations -> '1952339b-14b0-447d-b6d7-6bcf18b4af62', concepts.map)::TEXT as "Enl.Last delivery place",
           get_coded_string_value(
                   programEnrolment.observations -> '6c771640-52b6-46ea-bd56-0a2670ab7a6d', concepts.map)::TEXT as "Enl.Last delivery outcome",
           get_coded_string_value(
                   programEnrolment.observations -> 'f776b045-2fcb-4275-b08e-e3e9039b699e', concepts.map)::TEXT as "Enl.Last delivery gender",
           get_coded_string_value(
                   programEnrolment.observations -> '2f68ca5f-c690-4848-aa2e-592d6c7ef4e8', concepts.map)::TEXT as "Enl.Last delivery- Is baby alive?",
           get_coded_string_value(
                   programEnrolment.observations -> '26cee30f-b36d-4be2-bec3-9a0904492e52', concepts.map)::TEXT as "Enl.Any High risk condition in previous pregnancy",
           get_coded_string_value(
                   programEnrolment.observations -> 'a0aea5a9-7101-48ef-8463-5b376efa61bf', concepts.map)::TEXT  as "Enl.High risk condition in previous pregnancy",
           get_coded_string_value(
                   programEnrolment.observations -> 'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2', concepts.map)::TEXT as "Enl.Taking medicine for chronic disease",
           get_coded_string_value(
                   programEnrolment.observations -> '7d9b6992-ee27-4423-90a5-9ad20400d885', concepts.map)::TEXT  as "Enl.Name of chronic disease",
           get_coded_string_value(
                   programEnrolment.observations -> '1aac0eaf-1c9e-4284-93c3-7212c06a3286', concepts.map)::TEXT as "Enl.Does woman want to continue this pregnancy?",
           get_coded_string_value(
                   programEnrolment.observations -> 'b5ebc472-0f32-4128-97f3-0e2571daeaae', concepts.map)::TEXT as "Enl.Send her to hospital for ANC",
           get_coded_string_value(
                   programEnrolment.observations -> 'b6f45def-e3f4-4e7b-97ed-68c539b82fa2', concepts.map)::TEXT as "Enl.Send to Hospital for abortion",
           (programEncounter.observations ->> '23bcad9f-ec16-46ec-92f5-e144411e5dec')::TEXT        as "Enc.Height",
           (programEncounter.observations ->> '8d947379-7a1d-48b2-8760-88fff6add987')::TEXT        as "Enc.Weight",
           (programEncounter.observations ->> 'a205563d-0ac2-4955-93ac-e2e7adebb56e')::TEXT        as "Enc.BMI",
           (programEncounter.observations ->> '6874d48e-8c2f-4009-992c-1d3ca1678cc6')::TEXT        as "Enc.Blood Pressure (systolic)",
           (programEncounter.observations ->> 'da871f6c-cef0-4191-b307-6751b31ac9ec')::TEXT        as "Enc.Blood Pressure (Diastolic)",
           get_coded_string_value(
                   programEncounter.observations -> 'b7be4ddc-14ee-4caf-ab38-e1c87d088688', concepts.map)::TEXT as "Enc.Is mosquito net given",
           get_coded_string_value(
                   programEncounter.observations -> '04eecc2b-93eb-49d4-83a4-6629442711ea', concepts.map)::TEXT as "Enc.Is safe delivery kit given",
           get_coded_string_value(
                   programEncounter.observations -> '74599453-6fbd-4f8d-bf7f-34faa3c10eb9', concepts.map)::TEXT  as "Enc.New complaint",
           (programEncounter.observations ->> 'dc0c10ca-c151-4c5c-aedc-2b8040dbea52')::TEXT        as "Enc.Other complaint",
           get_coded_string_value(
                   programEncounter.observations -> '95dd3094-6c99-4622-8614-bf5d33a509e4', concepts.map)::TEXT  as "Enc.Oedema",
           get_coded_string_value(
                   programEncounter.observations -> '31651632-0acb-4ee5-a0f3-1628bbed456c', concepts.map)::TEXT as "Enc.Foetus movement",
           get_coded_string_value(
                   programEncounter.observations -> '7259b0fa-c8d1-4e04-8d13-7dbc05f0169b', concepts.map)::TEXT  as "Enc.Breast examination",
           get_coded_string_value(
                   programEncounter.observations -> '78fcebd3-17e5-4621-89be-c580fbf13168', concepts.map)::TEXT as "Enc.Urine Albumin",
           get_coded_string_value(
                   programEncounter.observations -> '55ae9e7a-f6ff-4c0b-861c-fd29b6c5c646', concepts.map)::TEXT as "Enc.Urine sugar",
           get_coded_string_value(
                   programEncounter.observations -> 'bf1e5598-594c-4444-94e0-9390f5081e41', concepts.map)::TEXT as "Enc.Whether Folic acid given",
           get_coded_string_value(
                   programEncounter.observations -> '5740f87b-8cc6-4927-88a2-44636e8f396c', concepts.map)::TEXT as "Enc.Whether IFA given",
           get_coded_string_value(
                   programEncounter.observations -> '00de9acc-4ff6-485b-b979-41ff00745d23', concepts.map)::TEXT as "Enc.Whether Calcium given",
           get_coded_string_value(
                   programEncounter.observations -> '2a5a3b4d-80c4-4d05-8585-e16966ff0c3e', concepts.map)::TEXT as "Enc.Whether Amala given",
           get_coded_string_value(
                   programEncounter.observations -> '77d122e8-0620-4754-8375-b0cbe329003c', concepts.map)::TEXT as "Enc.Does woman require referral?",
           get_coded_string_value(
                   programEncounter.observations -> '80fccb06-a62f-43e8-92eb-358bdb600079', concepts.map)::TEXT as "Enc.Place of referral",
           (programEncounter.observations ->> 'd169efa9-49af-4c84-ae09-b1b7296c62da')::TEXT        as "Enc.Other place of referral",
           get_coded_string_value(
                   programEncounter.observations -> '8a56f008-a910-4d6f-b028-a95db330dbf2', concepts.map)::TEXT  as "Enc.Referral reason",
           (programEncounter.observations ->> 'e048675e-eb86-41c2-a47b-aecfa9a3bb8c')::TEXT        as "Enc.Other referral reason",
           (programEncounter.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "Enc.Date of next ANC Visit",
           programEncounter.cancel_date_time                                                          "EncCancel.cancel_date_time",
           get_coded_string_value(
                   programEncounter.observations -> 'bf400e7f-8e1b-4052-af49-b0db47b3eb5a', concepts.map)::TEXT as "EncCancel.Visit cancel reason",
           (programEncounter.observations ->> 'd038a9c4-fe96-4c09-b883-c80691427b60')::TEXT        as "EncCancel.Other reason for cancelling",
           (programEncounter.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "EncCancel.Date of next ANC Visit"
    FROM program_encounter programEncounter
             CROSS JOIN concepts
             LEFT OUTER JOIN operational_encounter_type oet
                             on programEncounter.encounter_type_id = oet.encounter_type_id
             LEFT OUTER JOIN program_enrolment programEnrolment
                             ON programEncounter.program_enrolment_id = programEnrolment.id
             LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
             LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
             LEFT OUTER JOIN gender g ON g.id = individual.gender_id
             LEFT OUTER JOIN address_level a ON individual.address_id = a.id
    WHERE op.uuid = '369dc9d1-ea43-47cf-9a32-5e98a81b2de4'
      AND oet.uuid = '4f8e0835-ab29-4f6f-8ec9-aa6f1ec50692'
      AND programEncounter.encounter_date_time IS NOT NULL
      AND programEnrolment.enrolment_date_time IS NOT NULL
);


drop view if exists jsscp_mother_pnc_visit_view;
create view jsscp_mother_pnc_visit_view as (
WITH concepts AS (
   SELECT hstore((array_agg(concept.uuid))::text[], (array_agg(concept.name))::text[]) AS map
   FROM concept
)
SELECT   individual.id "Ind.Id",
         individual.address_id "Ind.address_id",
         individual.uuid "Ind.uuid",
         individual.first_name "Ind.first_name",
         individual.last_name "Ind.last_name",
         g.name "Ind.Gender",
         individual.date_of_birth "Ind.date_of_birth",
         individual.date_of_birth_verified "Ind.date_of_birth_verified",
         individual.registration_date "Ind.registration_date",
         individual.facility_id  "Ind.facility_id",
         village.title  "Ind.village",
         cluster.title  "Ind.cluster",
         u.name "Enc.username",
         individual.is_voided "Ind.is_voided",
         op.name "Enl.Program Name",
         programEnrolment.id  "Enl.Id",
         programEnrolment.uuid  "Enl.uuid",
         programEnrolment.program_exit_date_time "Enl.program_exit_date_time",
         programEnrolment.is_voided "Enl.is_voided",
         oet.name "Enc.Type",
         programEncounter.id "Enc.Id",
         programEncounter.earliest_visit_date_time "Enc.earliest_visit_date_time",
         programEncounter.encounter_date_time "Enc.encounter_date_time",
         programEncounter.program_enrolment_id "Enc.program_enrolment_id",
         programEncounter.uuid "Enc.uuid",
         programEncounter.name "Enc.name",
         programEncounter.max_visit_date_time "Enc.max_visit_date_time",
         programEncounter.is_voided "Enc.is_voided",
         (individual.observations->>'ecdf3c54-2808-494d-87be-8fb744d5c3bc')::TEXT as "Ind.Father/Husband's Name",
         get_coded_string_value(individual.observations-> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b', concepts.map)::TEXT as "Ind.Marital status",
         (individual.observations->>'9d958124-09bb-466c-a4b4-db8d285def1f')::DATE as "Ind.Date of marriage",
         get_coded_string_value(individual.observations-> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b', concepts.map)::TEXT as "Ind.Education",
         get_coded_string_value(individual.observations-> '20ef261a-f110-4eaa-a592-2a1eeb0bf061', concepts.map)::TEXT as "Ind.Occupation",
         (individual.observations->>'4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT as "Ind.Other occupation",
         get_coded_string_value(individual.observations-> 'bab107f6-fc0e-4be7-ab71-658a92d72f35', concepts.map)::TEXT as "Ind.Whether any disability",
         get_coded_string_value(individual.observations->'7061c675-c2ba-4016-886d-eeb432548378', concepts.map)::TEXT as "Ind.Type of disability",
         get_coded_string_value(individual.observations-> 'd333f2a2-717e-478f-acbc-173bc7374d66', concepts.map)::TEXT as "Ind.Status of the individual",
         (individual.observations->>'681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT as "Ind.Aadhaar ID",
         (individual.observations->>'0a725832-b21c-4151-b017-7e6af770ba54')::TEXT as "Ind.Contact Number",
         get_coded_string_value(individual.observations-> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b', concepts.map)::TEXT as "Ind.Smart card (Insurance)",
         (programEnrolment.observations->>'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c')::TEXT as "Enl.ANC Enrolment ID",
         get_coded_string_value(programEnrolment.observations->'58d0a437-17ef-4d58-a36f-9a36b608f5a4', concepts.map)::TEXT as "Enl.Relation with village",
         (programEnrolment.observations->>'aaac11d9-1237-41ac-9cf9-239c1226048a')::TEXT as "Enl.Other relation with village",
         (programEnrolment.observations->>'838cdad2-e661-4517-88ca-5b9e8e6c676e')::TEXT as "Enl.Gravida",
         (programEnrolment.observations->>'6956e0f7-d31b-4fb5-a3de-bd6251b24f49')::TEXT as "Enl.Parity",
         (programEnrolment.observations->>'47bb4fbd-729b-48db-995c-4464e26dd3f3')::TEXT as "Enl.Live birth",
         (programEnrolment.observations->>'73e37865-47a7-44ef-8a06-870b79e55fbd')::TEXT as "Enl.still birth",
         (programEnrolment.observations->>'1465d2a8-dd5a-4cec-9cc3-ab9c7ba22cc2')::TEXT as "Enl.number of abortions",
         (programEnrolment.observations->>'42a98500-3c12-426b-9121-e0e993dbacaf')::TEXT as "Enl.prganancy,death",
         (programEnrolment.observations->>'24b4a632-42bd-4847-91f4-7d8e69929581')::TEXT as "Enl.Death of children within 1 week after delivery",
         (programEnrolment.observations->>'c9b244f3-7795-4f5a-a0aa-ccafd1e57b94')::TEXT as "Enl.Death of children due to congenital abnormality",
         (programEnrolment.observations->>'814f1780-aa3d-4c46-b881-71face696220')::DATE as "Enl.Last menstrual period",
         (programEnrolment.observations->>'730ca106-ece0-495d-8962-f60f38e79d12')::DATE as "Enl.EDD",
         (programEnrolment.observations->>'e817dda1-0cd7-40a9-8d30-06aafbbbbf24')::TEXT as "Enl.Is women registered within 3 months",
         (programEnrolment.observations->>'748b7b66-c9ce-496f-b670-9d2896e82c23')::DATE as "Enl.Last Delivery",
         get_coded_string_value(programEnrolment.observations->'1952339b-14b0-447d-b6d7-6bcf18b4af62', concepts.map)::TEXT as "Enl.Last delivery place",
         get_coded_string_value(programEnrolment.observations->'6c771640-52b6-46ea-bd56-0a2670ab7a6d', concepts.map)::TEXT as "Enl.Last delivery outcome",
         get_coded_string_value(programEnrolment.observations->'f776b045-2fcb-4275-b08e-e3e9039b699e', concepts.map)::TEXT as "Enl.Last delivery gender",
         get_coded_string_value(programEnrolment.observations->'2f68ca5f-c690-4848-aa2e-592d6c7ef4e8', concepts.map)::TEXT as "Enl.Last delivery- Is baby alive?",
         get_coded_string_value(programEnrolment.observations->'26cee30f-b36d-4be2-bec3-9a0904492e52', concepts.map)::TEXT as "Enl.Any High risk condition in previous pregnancy",
         get_coded_string_value(programEnrolment.observations->'a0aea5a9-7101-48ef-8463-5b376efa61bf', concepts.map)::TEXT as "Enl.High risk condition in previous pregnancy",
         (programEnrolment.observations->>'6bdfb87a-fefc-48ea-bcab-8bd05cbae73d')::TEXT as "Enl.Other high risk condition in previous pregnancy",
         get_coded_string_value(programEnrolment.observations->'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2', concepts.map)::TEXT as "Enl.Taking medicine for chronic disease",
         get_coded_string_value(programEnrolment.observations->'7d9b6992-ee27-4423-90a5-9ad20400d885', concepts.map)::TEXT as "Enl.Name of chronic disease",
         (programEnrolment.observations->>'a54d0c2c-a054-45a5-a143-9f6c9db3fbbd')::TEXT as "Enl.Other chronic disease",
         get_coded_string_value(programEnrolment.observations->'1aac0eaf-1c9e-4284-93c3-7212c06a3286', concepts.map)::TEXT as "Enl.Does woman want to continue this pregnancy?",
         get_coded_string_value(programEnrolment.observations->'b5ebc472-0f32-4128-97f3-0e2571daeaae', concepts.map)::TEXT as "Enl.Send her to nearest antenatal clinic",
         (programEnrolment.observations->>'6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE as "Enl.Date of next ANC Visit",
         get_coded_string_value(programEnrolment.observations->'b6f45def-e3f4-4e7b-97ed-68c539b82fa2', concepts.map)::TEXT as "Enl.Send her to hospital for abortion",
         get_coded_string_value(programEncounter.observations-> '11244ced-b169-493d-a160-2dda1e1db195', concepts.map)::TEXT as "Enc.Mother suffering from",
         (programEncounter.observations->>'70fa7289-d90e-4c07-a4db-3382cce4daf5')::TEXT as "Enc.Other problem mother is suffering from",
         get_coded_string_value(programEncounter.observations-> '9a31b9a0-18bf-4b3b-87cf-fad47128596b', concepts.map)::TEXT as "Enc.Refer the mother immediately to hospital. Did arrangement was made",
         (programEncounter.observations->>'0c6d2587-382d-4762-8871-b6890d854505')::TEXT as "Enc.Temperature(celcius)",
         (programEncounter.observations->>'630c0fa3-38f7-427d-a8dd-f1417cf1b7dc')::TEXT as "Enc.Pulse",
         (programEncounter.observations->>'6874d48e-8c2f-4009-992c-1d3ca1678cc6')::TEXT as "Enc.Blood Pressure (systolic)",
         (programEncounter.observations->>'da871f6c-cef0-4191-b307-6751b31ac9ec')::TEXT as "Enc.Blood Pressure (Diastolic)",
         get_coded_string_value(programEncounter.observations-> '7764a974-7ba8-4a13-9ba9-6d8d580f3c99', concepts.map)::TEXT as "Enc.Is there foul smelling discharge PV",
         get_coded_string_value(programEncounter.observations-> '74c618b3-a4e0-4382-9486-70dbf5752d9d', concepts.map)::TEXT as "Enc.Does mother has seizures?",
         get_coded_string_value(programEncounter.observations-> '2371bb8d-4561-4396-ba01-14c14f7972ba', concepts.map)::TEXT as "Enc.mother have less breast milk",
         get_coded_string_value(programEncounter.observations-> '43567d78-ad97-46bc-afa1-8522ec9e0180', concepts.map)::TEXT as "Enc.Does mother has any breast related issue like swelling, cracked nipple etc?",
         get_coded_string_value(programEncounter.observations-> 'be8560c8-beab-4b69-80ea-c6e943939a30', concepts.map)::TEXT as "Enc.mother get the benefit of JSY scheme",
         (programEncounter.observations->>'d8e3c407-af6d-45df-9db1-a40e289452c0')::DATE as "Enc.Date of recieving the JSY scheme benefit",
         get_coded_string_value(programEncounter.observations-> '0ac30adc-5107-4e30-9b8a-c3ef65904cf5', concepts.map)::TEXT as "Enc.Counselling",
         get_coded_string_value(programEncounter.observations-> '28d3ae12-a92b-4499-8cce-7471f11d3611', concepts.map)::TEXT as "Enc.Keep baby warm",
         get_coded_string_value(programEncounter.observations-> 'b5255768-9c41-4588-8272-f8a967044992', concepts.map)::TEXT as "Enc.Child PNC - Baby warming - Dos",
         get_coded_string_value(programEncounter.observations-> '6ae137dd-2b6d-4562-aeea-252b7ae6b869', concepts.map)::TEXT as "Enc.Breastfeeding (counselling)",
         get_coded_string_value(programEncounter.observations-> '42fe9c19-f279-4a0e-a8ce-8a157357bf8d', concepts.map)::TEXT as "Enc.Sign of good latching(counselling)",
         get_coded_string_value(programEncounter.observations-> '72bcb84a-893e-436f-b9de-1919d1480421', concepts.map)::TEXT as "Enc.No bath till one day/ 1 week(counselling)",
         get_coded_string_value(programEncounter.observations-> '83705410-0548-4f92-97a2-8e48bf1275ca', concepts.map)::TEXT as "Enc.Vaccination (counselling)",
         get_coded_string_value(programEncounter.observations-> '8464b109-5b66-40fc-90ca-5cc9e0ae30fd', concepts.map)::TEXT as "Enc.HBNC checkup (counselling)",
         get_coded_string_value(programEncounter.observations-> '6af2f841-e483-42d7-83c5-41de4ecb1966', concepts.map)::TEXT as "Enc.PPMC check(counselling)",
         get_coded_string_value(programEncounter.observations-> 'f63d81de-61e4-4894-87d2-cf0fb8a8cd67', concepts.map)::TEXT as "Enc.Seeking care in case of any health problem(counselling)",
         get_coded_string_value(programEncounter.observations-> '3b8f36ce-3837-455f-bcc0-26558545dd81', concepts.map)::TEXT as "Enc.Family planning (counselling)",
         get_coded_string_value(programEncounter.observations-> 'ca2af807-ec9f-4b33-8ffa-e17075979996', concepts.map)::TEXT as "Enc.refer the woman to SC or ask the SHW to make a home visit",
         get_coded_string_value(programEncounter.observations-> 'c3f8600a-aebf-44ea-967e-ff93c11a5946', concepts.map)::TEXT as "Enc.refer the mother to SC/Ganiyari",
         get_coded_string_value(programEncounter.observations-> 'c75a610f-27c3-4fad-9c26-04887c15436e', concepts.map)::TEXT as "Enc.Referral needed to mother?",
         get_coded_string_value(programEncounter.observations-> 'c470cb18-f902-4b2b-844b-4b6286e36b8d', concepts.map)::TEXT as "Enc.place of referral",
         (programEncounter.observations->>'d169efa9-49af-4c84-ae09-b1b7296c62da')::TEXT as "Enc.Other place of referral",
         get_coded_string_value(programencounter.observations ->'8a56f008-a910-4d6f-b028-a95db330dbf2', concepts.map)::TEXT as "Enc.Referral reason",
         (programEncounter.observations->>'e048675e-eb86-41c2-a47b-aecfa9a3bb8c')::TEXT as "Enc.Other referral reason",
         programEncounter.cancel_date_time "EncCancel.cancel_date_time",
         get_coded_string_value(programEncounter.observations-> 'bf400e7f-8e1b-4052-af49-b0db47b3eb5a', concepts.map)::TEXT as "EncCancel.Visit cancel reason",
         (programEncounter.observations->>'d038a9c4-fe96-4c09-b883-c80691427b60')::TEXT as "EncCancel.Other reason for cancelling",
         (programEncounter.observations->>'6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE as "EncCancel.Date of next ANC Visit"

          FROM program_encounter programEncounter
          CROSS JOIN concepts
          LEFT OUTER JOIN operational_encounter_type oet on programEncounter.encounter_type_id = oet.encounter_type_id
          LEFT OUTER JOIN program_enrolment programEnrolment ON programEncounter.program_enrolment_id = programEnrolment.id
          LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
          LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
          LEFT OUTER JOIN gender g ON g.id = individual.gender_id
          left join address_level village ON individual.address_id = village.id
          left join address_level cluster on village.parent_id = cluster.id
          LEFT JOIN audit a ON programEncounter.audit_id = a.id
          LEFT JOIN users u ON a.created_by_id = u.id

          WHERE op.uuid = '369dc9d1-ea43-47cf-9a32-5e98a81b2de4'
             AND oet.uuid = '331bbb69-4847-46be-bd72-7593ab31ea81'
             AND programEncounter.encounter_date_time IS NOT NULL
             AND programEnrolment.enrolment_date_time IS NOT NULL
);


drop view if exists jsscp_child_pnc_view;
create view jsscp_child_pnc_view as(
                                   WITH concepts AS (
                                       SELECT hstore((array_agg(concept.uuid))::text[], (array_agg(concept.name))::text[]) AS map
                                       FROM concept
                                   )
                                   SELECT
                                       individual.id "Ind.Id",
                                       individual.address_id "Ind.address_id",
                                       individual.uuid "Ind.uuid",
                                       individual.first_name "Ind.first_name",
                                       individual.last_name "Ind.last_name",
                                       g.name "Ind.Gender",
                                       individual.date_of_birth "Ind.date_of_birth",
                                       individual.date_of_birth_verified "Ind.date_of_birth_verified",
                                       individual.registration_date "Ind.registration_date",
                                       individual.facility_id  "Ind.facility_id",

           village.title      "Ind.village",
           cluster.title   "Ind.cluster",
           u.name          "Enc.username",
                                       individual.is_voided "Ind.is_voided",
                                       op.name "Enl.Program Name",
                                       programEnrolment.id  "Enl.Id",
                                       programEnrolment.uuid  "Enl.uuid",
                                       programEnrolment.enrolment_date_time  "Enl.enrolment_date_time",
                                       programEnrolment.program_exit_date_time  "Enl.program_exit_date_time",
                                       programEnrolment.is_voided "Enl.is_voided",
                                       oet.name "Enc.Type",
                                       programEncounter.id "Enc.Id",
                                       programEncounter.earliest_visit_date_time "Enc.earliest_visit_date_time",
                                       programEncounter.encounter_date_time "Enc.encounter_date_time",
                                       programEncounter.program_enrolment_id "Enc.program_enrolment_id",
                                       programEncounter.uuid "Enc.uuid",
                                       programEncounter.name "Enc.name",
                                       programEncounter.max_visit_date_time "Enc.max_visit_date_time",
                                       programEncounter.is_voided "Enc.is_voided",
                                       (individual.observations->>'ecdf3c54-2808-494d-87be-8fb744d5c3bc')::TEXT as "Ind.Father/Husband's Name",
                                       get_coded_string_value(individual.observations-> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b', concepts.map)::TEXT as "Ind.Marital status",
                                       (individual.observations->>'9d958124-09bb-466c-a4b4-db8d285def1f')::DATE as "Ind.Date of marriage",
                                       get_coded_string_value(individual.observations-> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b', concepts.map)::TEXT as "Ind.Education",
                                       get_coded_string_value(individual.observations-> '20ef261a-f110-4eaa-a592-2a1eeb0bf061', concepts.map)::TEXT as "Ind.Occupation",
                                       (individual.observations->>'4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT as "Ind.Other occupation",
                                       get_coded_string_value(individual.observations-> 'bab107f6-fc0e-4be7-ab71-658a92d72f35', concepts.map)::TEXT as "Ind.Whether any disability",
                                       get_coded_string_value(individual.observations->'7061c675-c2ba-4016-886d-eeb432548378', concepts.map)::TEXT as "Ind.Type of disability",
                                       get_coded_string_value(individual.observations-> 'd333f2a2-717e-478f-acbc-173bc7374d66', concepts.map)::TEXT as "Ind.Status of the individual",
                                       (individual.observations->>'681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT as "Ind.Aadhaar ID",
                                       (individual.observations->>'0a725832-b21c-4151-b017-7e6af770ba54')::TEXT as "Ind.Contact Number",
                                       get_coded_string_value(individual.observations-> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b', concepts.map)::TEXT as "Ind.Smart card (Insurance)",

                                       get_coded_string_value(programEncounter.observations-> '918c6eaf-b7ab-4958-aa42-4b0280a3c5e8', concepts.map)::TEXT as "Enc.Whether newborn fed other that exclusive breastfeeding",
                                       get_coded_string_value(programEncounter.observations-> '761a5ddc-fe17-4393-bb28-ecd45de68f58', concepts.map)::TEXT as "Enc.How was breastfeedig",
                                       (programEncounter.observations->>'30f5bc1c-72b9-438a-8a41-8732e52ca0bf')::DATE as "Enc.Date time of breastfedding after delivery",
                                       get_coded_string_value(programEncounter.observations-> 'ba69923c-e451-41a5-8ed0-62d2078411b9', concepts.map)::TEXT as "Enc.Whether mother have any problem in breastfeeding",
                                       get_coded_string_value(programEncounter.observations-> 'de3329dd-47a0-463c-ab48-03f1199639d8', concepts.map)::TEXT as "Enc.Was temperature recorded?",
                                       (programEncounter.observations->>'d6d8f9d9-d0c5-4574-b779-a8aa08604771')::TEXT as "Enc.Temperature of newborn (celcius)",
                                       get_coded_string_value(programEncounter.observations-> '1c675de4-83eb-471f-9b55-6b8a0d48c55e', concepts.map)::TEXT as "Enc.Eye of newborn",
                                       (programEncounter.observations->>'8fcbe2ba-80a9-4a32-8573-dbecc62f96f5')::TEXT as "Enc.Other condition of newborn eye",
                                       get_coded_string_value(programEncounter.observations-> '6be64524-a223-464f-8c68-787c5d6f7e7c', concepts.map)::TEXT as "Enc.Bleeding from chord",
                                       get_coded_string_value(programEncounter.observations-> '81744917-f99b-41a1-80e9-8057b90073d0', concepts.map)::TEXT as "Enc.Look for birth defects",
                                       get_coded_string_value(programEncounter.observations-> 'c0e51a98-9689-4963-9c29-b8be89053116', concepts.map)::TEXT as "Enc.Look for any danger signs of sepsis within 6 hours",
                                       (programEncounter.observations->>'e8194331-8da1-4eba-85b6-95c704209025')::TEXT as "Enc.Other danger signs of sepsis within 6 hours",
                                       get_coded_string_value(programEncounter.observations-> '94b7ee05-e0d2-4b9b-92b0-3e8f4ad666da', concepts.map)::TEXT as "Enc.Whether mother wraps the baby in clothes in cold whether",
                                       get_coded_string_value(programEncounter.observations-> '1bfdc70a-475d-487b-b87b-9f8c422bdadd', concepts.map)::TEXT as "Enc.Whether mother gives skin to skin warmth to baby",
                                       get_coded_string_value(programEncounter.observations-> 'cec9ce0f-d40a-4a8e-ac8b-60e90259c003', concepts.map)::TEXT as "Enc.Whether mother breastfed her child for min 8 times a day",
                                       get_coded_string_value(programEncounter.observations-> '1d052667-3622-4934-9343-7127729c3aa3', concepts.map)::TEXT as "Enc.Whether baby cries too much urinate less than 6 time a day",
                                       get_coded_string_value(programEncounter.observations-> 'd5b8e6fc-f5cc-45e3-a753-141c9677a491', concepts.map)::TEXT as "Enc.Look for any danger signs of sepsis after 6 hours",
                                       (programEncounter.observations->>'1a68a35d-ad9c-45f3-b3dd-62c04f26be0f')::TEXT as "Enc.Other danger signs of sepsis after 6 hours",
                                       get_coded_string_value(programEncounter.observations-> 'e46f457d-6d84-46b6-9fa6-30e87537154b', concepts.map)::TEXT as "Enc.Whether newborn has swolen eyes or discharge from eyes",
                                       (programEncounter.observations->>'8d947379-7a1d-48b2-8760-88fff6add987')::TEXT as "Enc.Weight",
                                       (programEncounter.observations->>'0c6d2587-382d-4762-8871-b6890d854505')::TEXT as "Enc.Temperature(celcius)",
                                       get_coded_string_value(programEncounter.observations-> '9359a427-d6de-4f1d-b21e-a55b4aaef0b5', concepts.map)::TEXT as "Enc.Skin - pus filled rashes/boils",
                                       get_coded_string_value(programEncounter.observations-> 'b9961b58-b54e-4329-8f40-fc42a1a5981a', concepts.map)::TEXT as "Enc.Skin - Redness/crack in skin fold",
                                       get_coded_string_value(programEncounter.observations-> 'bbc18a0f-996a-4e3b-b4bf-703cfba2f9df', concepts.map)::TEXT as "Enc.Yellowing of skin/eye",
                                       (programEncounter.observations->>'80c5cefe-804d-45f3-b5b6-93db8b758a96')::TEXT as "Enc.Respiratory Rate",
                                       get_coded_string_value(programEncounter.observations-> '1f35def8-d31d-4f66-80de-625003c9412c', concepts.map)::TEXT as "Enc.Whether baby die",
                                       (programEncounter.observations->>'338953ea-6d7e-423e-96d6-f52d5aa37072')::DATE as "Enc.Date of Death",
                                       get_coded_string_value(programEncounter.observations-> '1680e20a-1bf9-4396-ae01-94bb361983c1', concepts.map)::TEXT as "Enc.Referral needed to newborn",
                                       get_coded_string_value(programEncounter.observations-> '80fccb06-a62f-43e8-92eb-358bdb600079', concepts.map)::TEXT as "Enc.Place of referral",
                                       (programEncounter.observations->>'d169efa9-49af-4c84-ae09-b1b7296c62da')::TEXT as "Enc.Other place of referral",
                                       get_coded_string_value(programEncounter.observations-> 'bed53b48-5e3e-4442-9137-0f2b182fabe5', concepts.map)::TEXT as "Enc.Referral reason for newborn",
                                       (programEncounter.observations->>'e048675e-eb86-41c2-a47b-aecfa9a3bb8c')::TEXT as "Enc.Other referral reason",
                                       get_coded_string_value(programEncounter.observations-> 'fa031cca-7264-420a-b657-0d3d5fc58a9c', concepts.map)::TEXT as "Enc.Counselling Done",
                                       get_coded_string_value(programEncounter.observations-> '5f577e35-7d23-4cfd-9495-d7442839e3df', concepts.map)::TEXT as "Enc.Tight the tread if there is bleeding",
                                       get_coded_string_value(programEncounter.observations-> '8f82651a-36a0-4eb6-a7ea-408230d44cd7', concepts.map)::TEXT as "Enc.Show her how to wrap the baby in clothe",
                                       get_coded_string_value(programEncounter.observations-> '6bcecb5c-5142-4ab4-a563-0c6c7cf0ddf7', concepts.map)::TEXT as "Enc.counsell her about giving kangaroo mother care",
                                       get_coded_string_value(programEncounter.observations-> 'c6c42ef8-1731-410d-ab63-19ca22aec519', concepts.map)::TEXT as "Enc.counsel mother for 2 hourly breast feeding",
                                       get_coded_string_value(programEncounter.observations-> '70d55d5d-aed6-46fc-bf3a-9d3ba68d6bc1', concepts.map)::TEXT as "Enc.counsel mother for 2 hourly breastfeeding",
                                       get_coded_string_value(programEncounter.observations-> '66f49885-2429-4fe2-b8d9-5ce1426e20b2', concepts.map)::TEXT as "Enc.ask mother to take Tetracycline medicine from VHW",
                                       get_coded_string_value(programEncounter.observations-> '7effc9b6-29c0-499c-9c78-2cf6fe796a25', concepts.map)::TEXT as "Enc.give PCM",
                                       get_coded_string_value(programEncounter.observations-> 'dced742e-74bc-4016-83d0-3e0020bedd17', concepts.map)::TEXT as "Enc.tell mother to keep the baby warm and breastfeed frequently",
                                       get_coded_string_value(programEncounter.observations-> 'dde1da1e-56c5-42ad-8577-6b3096948330', concepts.map)::TEXT as "Enc.start treatment of hypothermia and look for sign of sepsis",
                                       get_coded_string_value(programEncounter.observations-> 'b5c8113e-ea16-414c-8d67-82fa0177a909', concepts.map)::TEXT as "Enc.apply GV paint",
                                       get_coded_string_value(programEncounter.observations-> 'c3046ee8-0992-4459-b713-555a947ab6f3', concepts.map)::TEXT as "Enc.refer the baby to Subcenter for yellow skin or eyes",
                                       get_coded_string_value(programEncounter.observations-> '23664b77-05e2-4baa-8522-68c02314ec21', concepts.map)::TEXT as "Enc.Diagnosis of sepsis",
                                       programEncounter.cancel_date_time "EncCancel.cancel_date_time",
                                       get_coded_string_value(programEncounter.observations-> 'bf400e7f-8e1b-4052-af49-b0db47b3eb5a', concepts.map)::TEXT as "EncCancel.Visit cancel reason",
                                       (programEncounter.observations->>'d038a9c4-fe96-4c09-b883-c80691427b60')::TEXT as "EncCancel.Other reason for cancelling",
                                       (programEncounter.observations->>'6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE as "EncCancel.Date of next ANC Visit"
                                   FROM program_encounter programEncounter
                                            CROSS JOIN concepts
                                            LEFT OUTER JOIN operational_encounter_type oet on programEncounter.encounter_type_id = oet.encounter_type_id
                                            LEFT OUTER JOIN program_enrolment programEnrolment ON programEncounter.program_enrolment_id = programEnrolment.id
                                            LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
                                            LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
                                            LEFT OUTER JOIN gender g ON g.id = individual.gender_id

             left join address_level village ON individual.address_id = village.id
             left join address_level cluster on village.parent_id = cluster.id
             LEFT JOIN audit a ON programEncounter.audit_id = a.id
             LEFT JOIN users u ON a.created_by_id = u.id
                                   WHERE op.uuid = 'bf6c7776-6e85-4700-95b7-429f119d0af5'
                                     AND oet.uuid = '89c40e01-acb2-4c52-aaba-d8c82eb27011'
                                     AND programEncounter.encounter_date_time IS NOT NULL
                                     AND programEnrolment.enrolment_date_time IS NOT NULL);

drop view if exists jsscp_anc_clinic_and_home_view;
create view jsscp_anc_clinic_and_home_view as (
      WITH concepts AS (
          SELECT hstore((array_agg(concept.uuid))::text[], (array_agg(concept.name))::text[]) AS map
          FROM concept
      )
       SELECT individual.id                                                                              "Ind.Id",
              individual.address_id                                                                      "Ind.address_id",
              individual.uuid                                                                            "Ind.uuid",
              individual.first_name                                                                      "Ind.first_name",
              individual.last_name                                                                       "Ind.last_name",
              g.name                                                                                     "Ind.Gender",
              individual.date_of_birth                                                                   "Ind.date_of_birth",
              individual.date_of_birth_verified                                                          "Ind.date_of_birth_verified",
              individual.registration_date                                                               "Ind.registration_date",
              individual.facility_id                                                                     "Ind.facility_id",
              village.title                                                                              "Ind.village",
              cluster.title                                                                              "Ind.cluster",
              u.name                                                                                     "Enc.username",
              individual.is_voided                                                                       "Ind.is_voided",
              op.name                                                                                    "Enl.Program Name",
              programEnrolment.id                                                                        "Enl.Id",
              programEnrolment.uuid                                                                      "Enl.uuid",
              programEnrolment.is_voided                                                                 "Enl.is_voided",
              programenrolment.program_exit_date_time                                                    "Enl.program_exit_date_time",
              oet.name                                                                                   "Enc.Type",
              programEncounter.id                                                                        "Enc.Id",
              programEncounter.earliest_visit_date_time                                                  "Enc.earliest_visit_date_time",
              programEncounter.encounter_date_time                                                       "Enc.encounter_date_time",
              programEncounter.program_enrolment_id                                                      "Enc.program_enrolment_id",
              programEncounter.uuid                                                                      "Enc.uuid",
              programEncounter.name                                                                      "Enc.name",
              programEncounter.max_visit_date_time                                                       "Enc.max_visit_date_time",
              programEncounter.is_voided                                                                 "Enc.is_voided",
              (individual.observations ->> 'ecdf3c54-2808-494d-87be-8fb744d5c3bc')::TEXT              as "Ind.Father/Husband's Name",
              get_coded_string_value(
                   individual.observations -> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b', concepts.map)::TEXT       as "Ind.Marital status",
              (individual.observations ->> '9d958124-09bb-466c-a4b4-db8d285def1f')::DATE              as "Ind.Date of marriage",
              get_coded_string_value(
                   individual.observations -> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b', concepts.map)::TEXT       as "Ind.Education",
              get_coded_string_value(
                   individual.observations -> '20ef261a-f110-4eaa-a592-2a1eeb0bf061', concepts.map)::TEXT       as "Ind.Occupation",
              (individual.observations ->> '4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT              as "Ind.Other occupation",
              get_coded_string_value(
                   individual.observations -> 'bab107f6-fc0e-4be7-ab71-658a92d72f35', concepts.map)::TEXT       as "Ind.Whether any disability",
              get_coded_string_value(
                         individual.observations -> '7061c675-c2ba-4016-886d-eeb432548378', concepts.map)::TEXT        as "Ind.Type of disability",
              get_coded_string_value(
                   individual.observations -> 'd333f2a2-717e-478f-acbc-173bc7374d66', concepts.map)::TEXT       as "Ind.Status of the individual",
              (individual.observations ->> '681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT              as "Ind.Aadhaar ID",
              (individual.observations ->> '0a725832-b21c-4151-b017-7e6af770ba54')::TEXT              as "Ind.Contact Number",
              get_coded_string_value(
                   individual.observations -> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b', concepts.map)::TEXT       as "Ind.Smart card (Insurance)",
              (programEnrolment.observations ->> 'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c')::TEXT        as "Enl.ANC Enrolment ID",
              get_coded_string_value(
                   programEnrolment.observations -> '58d0a437-17ef-4d58-a36f-9a36b608f5a4', concepts.map)::TEXT as "Enl.Relation with village",
              (programEnrolment.observations ->> 'aaac11d9-1237-41ac-9cf9-239c1226048a')::TEXT        as "Enl.Other relation with village",
              (programEnrolment.observations ->> '838cdad2-e661-4517-88ca-5b9e8e6c676e')::TEXT        as "Enl.Gravida",
              (programEnrolment.observations ->> '6956e0f7-d31b-4fb5-a3de-bd6251b24f49')::TEXT        as "Enl.Parity",
              (programEnrolment.observations ->> '47bb4fbd-729b-48db-995c-4464e26dd3f3')::TEXT        as "Enl.Live birth",
              (programEnrolment.observations ->> '73e37865-47a7-44ef-8a06-870b79e55fbd')::TEXT        as "Enl.still birth",
              (programEnrolment.observations ->> '1465d2a8-dd5a-4cec-9cc3-ab9c7ba22cc2')::TEXT        as "Enl.number of abortions",
              (programEnrolment.observations ->> '42a98500-3c12-426b-9121-e0e993dbacaf')::TEXT        as "Enl.prganancy,death",
              (programEnrolment.observations ->> '24b4a632-42bd-4847-91f4-7d8e69929581')::TEXT        as "Enl.Death of children within 1 week after delivery",
              (programEnrolment.observations ->> 'c9b244f3-7795-4f5a-a0aa-ccafd1e57b94')::TEXT        as "Enl.Death of children due to congenital abnormality",
              (programEnrolment.observations ->> '814f1780-aa3d-4c46-b881-71face696220')::DATE        as "Enl.Last menstrual period",
              (programEnrolment.observations ->> '730ca106-ece0-495d-8962-f60f38e79d12')::DATE        as "Enl.EDD",
              (programEnrolment.observations ->> 'e817dda1-0cd7-40a9-8d30-06aafbbbbf24')::TEXT        as "Enl.Is women registered within 3 months",
              (programEnrolment.observations ->> '748b7b66-c9ce-496f-b670-9d2896e82c23')::DATE        as "Enl.Last Delivery",
              get_coded_string_value(
                   programEnrolment.observations -> '1952339b-14b0-447d-b6d7-6bcf18b4af62', concepts.map)::TEXT as "Enl.Last delivery place",
              get_coded_string_value(
                   programEnrolment.observations -> '6c771640-52b6-46ea-bd56-0a2670ab7a6d', concepts.map)::TEXT as "Enl.Last delivery outcome",
              get_coded_string_value(
                   programEnrolment.observations -> 'f776b045-2fcb-4275-b08e-e3e9039b699e', concepts.map)::TEXT as "Enl.Last delivery gender",
              get_coded_string_value(
                   programEnrolment.observations -> '2f68ca5f-c690-4848-aa2e-592d6c7ef4e8', concepts.map)::TEXT as "Enl.Last delivery- Is baby alive?",
              get_coded_string_value(
                   programEnrolment.observations -> '26cee30f-b36d-4be2-bec3-9a0904492e52', concepts.map)::TEXT as "Enl.Any High risk condition in previous pregnancy",
              get_coded_string_value(
                   programEnrolment.observations -> 'a0aea5a9-7101-48ef-8463-5b376efa61bf', concepts.map)::TEXT  as "Enl.High risk condition in previous pregnancy",
              (programEnrolment.observations ->> '6bdfb87a-fefc-48ea-bcab-8bd05cbae73d')::TEXT        as "Enl.Other high risk condition in previous pregnancy",
              get_coded_string_value(
                   programEnrolment.observations -> 'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2', concepts.map)::TEXT as "Enl.Taking medicine for chronic disease",
              get_coded_string_value(
                   programEnrolment.observations -> '7d9b6992-ee27-4423-90a5-9ad20400d885', concepts.map)::TEXT  as "Enl.Name of chronic disease",
              (programEnrolment.observations ->> 'a54d0c2c-a054-45a5-a143-9f6c9db3fbbd')::TEXT        as "Enl.Other chronic disease",
              get_coded_string_value(
                   programEnrolment.observations -> '1aac0eaf-1c9e-4284-93c3-7212c06a3286', concepts.map)::TEXT as "Enl.Does woman want to continue this pregnancy?",
              get_coded_string_value(
                   programEnrolment.observations -> 'b5ebc472-0f32-4128-97f3-0e2571daeaae', concepts.map)::TEXT as "Enl.Send her to nearest antenatal clinic",
              (programEnrolment.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "Enl.Date of next ANC Visit",
              get_coded_string_value(
                   programEnrolment.observations -> 'b6f45def-e3f4-4e7b-97ed-68c539b82fa2', concepts.map)::TEXT as "Enl.Send her to hospital for abortion",
              (programEncounter.observations ->> '23bcad9f-ec16-46ec-92f5-e144411e5dec')::TEXT        as "Enc.Height",
              (programEncounter.observations ->> '8d947379-7a1d-48b2-8760-88fff6add987')::TEXT        as "Enc.Weight",
              (programEncounter.observations ->> 'a205563d-0ac2-4955-93ac-e2e7adebb56e')::TEXT        as "Enc.BMI",
              (programEncounter.observations ->> '6874d48e-8c2f-4009-992c-1d3ca1678cc6')::TEXT        as "Enc.Blood Pressure (systolic)",
              (programEncounter.observations ->> 'da871f6c-cef0-4191-b307-6751b31ac9ec')::TEXT        as "Enc.Blood Pressure (Diastolic)",
              get_coded_string_value(
                   programEncounter.observations -> 'b7be4ddc-14ee-4caf-ab38-e1c87d088688', concepts.map)::TEXT as "Enc.Is mosquito net given",
              get_coded_string_value(
                   programEncounter.observations -> '04eecc2b-93eb-49d4-83a4-6629442711ea', concepts.map)::TEXT as "Enc.Is safe delivery kit given",
              get_coded_string_value(
                   programEncounter.observations -> '74599453-6fbd-4f8d-bf7f-34faa3c10eb9', concepts.map)::TEXT  as "Enc.New complaint",
              (programEncounter.observations ->> 'dc0c10ca-c151-4c5c-aedc-2b8040dbea52')::TEXT        as "Enc.Other complaint",
              get_coded_string_value(
                   programEncounter.observations -> '95dd3094-6c99-4622-8614-bf5d33a509e4', concepts.map)::TEXT  as "Enc.Oedema",
              get_coded_string_value(
                   programEncounter.observations -> '2a15dc0b-d6a0-4670-b109-4013789cb403', concepts.map)::TEXT  as "Enc.Abdomen check",
              (programEncounter.observations ->> '9b087651-34e8-4391-aa08-8db73f55d7e6')::TEXT        as "Enc.Current gestational age",
              get_coded_string_value(
                   programEncounter.observations -> 'f5ff8848-798a-4b0f-bcaf-33f2d4528f37', concepts.map)::TEXT as "Enc.Fundle Height",
              get_coded_string_value(
                   programEncounter.observations -> '69a95145-505b-497a-9fc9-61fcc5d2ff59', concepts.map)::TEXT as "Enc.Position",
              get_coded_string_value(
                   programEncounter.observations -> '7c6d3fc6-6a9f-4b44-beef-8c2200da5281', concepts.map)::TEXT as "Enc.FHS",
              (programEncounter.observations ->> '532ae011-4380-4ff5-b7c7-7d163e396221')::TEXT        as "Enc.FHS number",
              get_coded_string_value(
                   programEncounter.observations -> '31651632-0acb-4ee5-a0f3-1628bbed456c', concepts.map)::TEXT as "Enc.Foetus movement",
              get_coded_string_value(
                   programEncounter.observations -> '7259b0fa-c8d1-4e04-8d13-7dbc05f0169b', concepts.map)::TEXT  as "Enc.Breast examination",
              get_coded_string_value(
                   programEncounter.observations -> 'c50c8196-01c9-422f-b917-fd2309adb261', concepts.map)::TEXT as "Enc.Blood group",
              get_coded_string_value(
                   programEncounter.observations -> '610db330-fafe-456f-bd58-e062cb6e52e3', concepts.map)::TEXT as "Enc.Sickle prep",
              get_coded_string_value(
                   programEncounter.observations -> '78fcebd3-17e5-4621-89be-c580fbf13168', concepts.map)::TEXT as "Enc.Urine Albumin",
              get_coded_string_value(
                   programEncounter.observations -> '55ae9e7a-f6ff-4c0b-861c-fd29b6c5c646', concepts.map)::TEXT as "Enc.Urine sugar",
              (programEncounter.observations ->> 'a240115e-47a2-4244-8f74-d13d20f087df')::TEXT        as "Enc.Hb",
              get_coded_string_value(
                   programEncounter.observations -> '9a89e9d6-f6e4-4d14-8841-34df9ece70a5', concepts.map)::TEXT as "Enc.Malaria parasite",
              (programEncounter.observations ->> 'd6ac43a2-527d-4168-ba7d-2d233add3a6e')::TEXT        as "Enc.Random Blood Sugar (RBS)",
              (programEncounter.observations ->> 'ae2046a4-015c-44e2-9703-01bc3da13202')::TEXT        as "Enc.Glucose test (75gm Glucose)",
              (programEncounter.observations ->> '0b8bc1f8-43db-4ecb-9677-22709e91681f')::TEXT        as "Enc.Pus Cell",
              (programEncounter.observations ->> 'b59c126f-975b-45e6-8dd6-584dd54e25c9')::TEXT        as "Enc.RBC",
              (programEncounter.observations ->> '0343e35f-afd0-41ce-af93-e69c184b159c')::TEXT        as "Enc.Epithelial cells",
              (programEncounter.observations ->> 'a2b6d675-4c70-4f15-a5ad-b8f5273602f9')::TEXT        as "Enc.Cast",
              get_coded_string_value(
                   programEncounter.observations -> '14a023d3-bd25-4343-9d93-34d9f88eb4b3', concepts.map)::TEXT as "Enc.Crystel",
              get_coded_string_value(
                   programEncounter.observations -> 'bf1e5598-594c-4444-94e0-9390f5081e41', concepts.map)::TEXT as "Enc.Whether Folic acid given",
              get_coded_string_value(
                   programEncounter.observations -> '5740f87b-8cc6-4927-88a2-44636e8f396c', concepts.map)::TEXT as "Enc.Whether IFA given",
              get_coded_string_value(
                   programEncounter.observations -> '00de9acc-4ff6-485b-b979-41ff00745d23', concepts.map)::TEXT as "Enc.Whether Calcium given",
              get_coded_string_value(
                   programEncounter.observations -> '2a5a3b4d-80c4-4d05-8585-e16966ff0c3e', concepts.map)::TEXT as "Enc.Whether Amala given",
              get_coded_string_value(
                   programEncounter.observations -> 'ddeb2311-4a90-4a7c-a698-1cd3db4ff0f3', concepts.map)::TEXT as "Enc.TT 1",
              get_coded_string_value(
                   programEncounter.observations -> '858f66e6-1ed3-4c13-9fdf-08f667b092ba', concepts.map)::TEXT as "Enc.TT 2",
              (programEncounter.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "Enc.Date of next ANC Visit",
              get_coded_string_value(
                   programEncounter.observations -> '77d122e8-0620-4754-8375-b0cbe329003c', concepts.map)::TEXT as "Enc.Does woman require referral?",
              get_coded_string_value(
                   programEncounter.observations -> '80fccb06-a62f-43e8-92eb-358bdb600079', concepts.map)::TEXT as "Enc.Place of referral",
              (programEncounter.observations ->> 'd169efa9-49af-4c84-ae09-b1b7296c62da')::TEXT        as "Enc.Other place of referral",
              get_coded_string_value(
                   programEncounter.observations -> '8a56f008-a910-4d6f-b028-a95db330dbf2', concepts.map)::TEXT  as "Enc.Referral reason",
              (programEncounter.observations ->> 'e048675e-eb86-41c2-a47b-aecfa9a3bb8c')::TEXT        as "Enc.Other referral reason",
              programEncounter.cancel_date_time                                                          "EncCancel.cancel_date_time",
              get_coded_string_value(
                   programEncounter.observations -> 'bf400e7f-8e1b-4052-af49-b0db47b3eb5a', concepts.map)::TEXT as "EncCancel.Visit cancel reason",
              (programEncounter.observations ->> 'd038a9c4-fe96-4c09-b883-c80691427b60')::TEXT        as "EncCancel.Other reason for cancelling",
              (programEncounter.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "EncCancel.Date of next ANC Visit",
              abs(TRUNC(DATE_PART('day',
                              encounter_date_time - (programEnrolment.observations ->> '814f1780-aa3d-4c46-b881-71face696220')::timestamp) /
                    7))                                                                         as ga_weeks
       FROM program_encounter programEncounter
                CROSS JOIN concepts
                LEFT OUTER JOIN operational_encounter_type oet
                                   on programEncounter.encounter_type_id = oet.encounter_type_id
                   LEFT OUTER JOIN program_enrolment programEnrolment
                                   ON programEncounter.program_enrolment_id = programEnrolment.id
                   LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
                   LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
                   LEFT OUTER JOIN gender g ON g.id = individual.gender_id
                   left join address_level village ON individual.address_id = village.id
                   left join address_level cluster on village.parent_id = cluster.id
                   LEFT JOIN audit a ON programEncounter.audit_id = a.id
                   LEFT JOIN users u ON a.created_by_id = u.id
       WHERE op.uuid = '369dc9d1-ea43-47cf-9a32-5e98a81b2de4'
         AND (oet.name = 'ANC Clinic Visit'or oet.name = 'ANC Home Visit')
         AND programEncounter.encounter_date_time IS NOT NULL
         AND programEnrolment.enrolment_date_time IS NOT NULL
);

  drop view if exists   jsscp_usg_report_view ;
 create view jsscp_usg_report_view as(
                                    --[Data Extract Report]
                                     WITH concepts AS (
                                         SELECT hstore((array_agg(concept.uuid))::text[], (array_agg(concept.name))::text[]) AS map
                                         FROM concept
                                     )
                                    SELECT
                                        individual.id "Ind.Id",
                                        individual.address_id "Ind.address_id",
                                        individual.uuid "Ind.uuid",
                                        individual.first_name "Ind.first_name",
                                        individual.last_name "Ind.last_name",
                                        g.name "Ind.Gender",
                                        individual.date_of_birth "Ind.date_of_birth",
                                        individual.date_of_birth_verified "Ind.date_of_birth_verified",
                                        individual.registration_date "Ind.registration_date",
                                        individual.facility_id  "Ind.facility_id",
                                        a.title "Ind.Area",
                                        individual.is_voided "Ind.is_voided",
                                        op.name "Enl.Program Name",
                                        programEnrolment.id  "Enl.Id",
                                        programEnrolment.uuid  "Enl.uuid",
                                        programEnrolment.is_voided "Enl.is_voided",
                                        oet.name "Enc.Type",
                                        programEncounter.id "Enc.Id",
                                        programEncounter.earliest_visit_date_time "Enc.earliest_visit_date_time",
                                        programEncounter.encounter_date_time "Enc.encounter_date_time",
                                        programEncounter.program_enrolment_id "Enc.program_enrolment_id",
                                        programEncounter.uuid "Enc.uuid",
                                        programEncounter.name "Enc.name",
                                        programEncounter.max_visit_date_time "Enc.max_visit_date_time",
                                        programEncounter.is_voided "Enc.is_voided",
                                        (individual.observations->>'ecdf3c54-2808-494d-87be-8fb744d5c3bc')::TEXT as "Ind.Father/Husband's Name",
                                        get_coded_string_value(individual.observations-> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b', concepts.map)::TEXT as "Ind.Marital status",
                                        (individual.observations->>'9d958124-09bb-466c-a4b4-db8d285def1f')::DATE as "Ind.Date of marriage",
                                        get_coded_string_value(individual.observations-> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b', concepts.map)::TEXT as "Ind.Education",
                                        get_coded_string_value(individual.observations-> '20ef261a-f110-4eaa-a592-2a1eeb0bf061', concepts.map)::TEXT as "Ind.Occupation",
                                        (individual.observations->>'4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT as "Ind.Other occupation",
                                        get_coded_string_value(individual.observations-> 'bab107f6-fc0e-4be7-ab71-658a92d72f35', concepts.map)::TEXT as "Ind.Whether any disability",
                                        get_coded_string_value(individual.observations->'7061c675-c2ba-4016-886d-eeb432548378', concepts.map)::TEXT as "Ind.Type of disability",
                                        get_coded_string_value(individual.observations-> 'd333f2a2-717e-478f-acbc-173bc7374d66', concepts.map)::TEXT as "Ind.Status of the individual",
                                        (individual.observations->>'681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT as "Ind.Aadhaar ID",
                                        (individual.observations->>'0a725832-b21c-4151-b017-7e6af770ba54')::TEXT as "Ind.Contact Number",
                                        get_coded_string_value(individual.observations-> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b', concepts.map)::TEXT as "Ind.Smart card (Insurance)",
                                        (programEnrolment.observations->>'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c')::TEXT as "Enl.ANC Enrolment ID",
                                        get_coded_string_value(programEnrolment.observations->'58d0a437-17ef-4d58-a36f-9a36b608f5a4', concepts.map)::TEXT as "Enl.Relation with village",
                                        (programEnrolment.observations->>'aaac11d9-1237-41ac-9cf9-239c1226048a')::TEXT as "Enl.Other relation with village",
                                        (programEnrolment.observations->>'838cdad2-e661-4517-88ca-5b9e8e6c676e')::TEXT as "Enl.Gravida",
                                        (programEnrolment.observations->>'6956e0f7-d31b-4fb5-a3de-bd6251b24f49')::TEXT as "Enl.Parity",
                                        (programEnrolment.observations->>'47bb4fbd-729b-48db-995c-4464e26dd3f3')::TEXT as "Enl.Live birth",
                                        (programEnrolment.observations->>'73e37865-47a7-44ef-8a06-870b79e55fbd')::TEXT as "Enl.still birth",
                                        (programEnrolment.observations->>'1465d2a8-dd5a-4cec-9cc3-ab9c7ba22cc2')::TEXT as "Enl.number of abortions",
                                        (programEnrolment.observations->>'42a98500-3c12-426b-9121-e0e993dbacaf')::TEXT as "Enl.prganancy,death",
                                        (programEnrolment.observations->>'24b4a632-42bd-4847-91f4-7d8e69929581')::TEXT as "Enl.Death of children within 1 week after delivery",
                                        (programEnrolment.observations->>'c9b244f3-7795-4f5a-a0aa-ccafd1e57b94')::TEXT as "Enl.Death of children due to congenital abnormality",
                                        (programEnrolment.observations->>'814f1780-aa3d-4c46-b881-71face696220')::DATE as "Enl.Last menstrual period",
                                        (programEnrolment.observations->>'730ca106-ece0-495d-8962-f60f38e79d12')::DATE as "Enl.EDD",
                                        (programEnrolment.observations->>'e817dda1-0cd7-40a9-8d30-06aafbbbbf24')::TEXT as "Enl.Is women registered within 3 months",
                                        (programEnrolment.observations->>'748b7b66-c9ce-496f-b670-9d2896e82c23')::DATE as "Enl.Last Delivery",
                                        get_coded_string_value(programEnrolment.observations->'1952339b-14b0-447d-b6d7-6bcf18b4af62', concepts.map)::TEXT as "Enl.Last delivery place",
                                        get_coded_string_value(programEnrolment.observations->'6c771640-52b6-46ea-bd56-0a2670ab7a6d', concepts.map)::TEXT as "Enl.Last delivery outcome",
                                        get_coded_string_value(programEnrolment.observations->'f776b045-2fcb-4275-b08e-e3e9039b699e', concepts.map)::TEXT as "Enl.Last delivery gender",
                                        get_coded_string_value(programEnrolment.observations->'2f68ca5f-c690-4848-aa2e-592d6c7ef4e8', concepts.map)::TEXT as "Enl.Last delivery- Is baby alive?",
                                        get_coded_string_value(programEnrolment.observations->'26cee30f-b36d-4be2-bec3-9a0904492e52', concepts.map)::TEXT as "Enl.Any High risk condition in previous pregnancy",
                                        get_coded_string_value(programEnrolment.observations->'a0aea5a9-7101-48ef-8463-5b376efa61bf', concepts.map)::TEXT as "Enl.High risk condition in previous pregnancy",
                                        (programEnrolment.observations->>'6bdfb87a-fefc-48ea-bcab-8bd05cbae73d')::TEXT as "Enl.Other high risk condition in previous pregnancy",
                                        get_coded_string_value(programEnrolment.observations->'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2', concepts.map)::TEXT as "Enl.Taking medicine for chronic disease",
                                        get_coded_string_value(programEnrolment.observations->'7d9b6992-ee27-4423-90a5-9ad20400d885', concepts.map)::TEXT as "Enl.Name of chronic disease",
                                        (programEnrolment.observations->>'a54d0c2c-a054-45a5-a143-9f6c9db3fbbd')::TEXT as "Enl.Other chronic disease",
                                        get_coded_string_value(programEnrolment.observations->'1aac0eaf-1c9e-4284-93c3-7212c06a3286', concepts.map)::TEXT as "Enl.Does woman want to continue this pregnancy?",
                                        get_coded_string_value(programEnrolment.observations->'b5ebc472-0f32-4128-97f3-0e2571daeaae', concepts.map)::TEXT as "Enl.Send her to nearest antenatal clinic",
                                        (programEnrolment.observations->>'6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE as "Enl.Date of next ANC Visit",
                                        get_coded_string_value(programEnrolment.observations->'b6f45def-e3f4-4e7b-97ed-68c539b82fa2', concepts.map)::TEXT as "Enl.Send her to hospital for abortion",
                                        get_coded_string_value(programEncounter.observations-> '6618dfd6-5df2-4c85-b916-0679bcb9be03', concepts.map)::TEXT as "Enc.Foetus is ok",
                                        get_coded_string_value(programEncounter.observations-> 'e7b5d460-47dd-490b-af0a-a73a19a93a9d', concepts.map)::TEXT as "Enc.Presentation of baby",
                                        get_coded_string_value(programEncounter.observations-> '9f55f157-c835-4068-a948-c849073d1d86', concepts.map)::TEXT as "Enc.Twin baby",
                                        get_coded_string_value(programEncounter.observations-> '96499ee7-ad90-4831-a0bd-1fd765f6f6c0', concepts.map)::TEXT as "Enc.Follow USG required",
                                        (programEncounter.observations->>'71efca55-ad55-4814-a16f-44d714c6ecf5')::DATE as "Enc.Date of next USG",
                                        programEncounter.cancel_date_time "EncCancel.cancel_date_time",
                                        get_coded_string_value(programEncounter.observations-> 'bf400e7f-8e1b-4052-af49-b0db47b3eb5a', concepts.map)::TEXT as "EncCancel.Visit cancel reason",
                                        (programEncounter.observations->>'d038a9c4-fe96-4c09-b883-c80691427b60')::TEXT as "EncCancel.Other reason for cancelling",
                                        (programEncounter.observations->>'6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE as "EncCancel.Date of next ANC Visit"
                                    FROM program_encounter programEncounter
                                             CROSS JOIN concepts
                                             LEFT OUTER JOIN operational_encounter_type oet on programEncounter.encounter_type_id = oet.encounter_type_id
                                             LEFT OUTER JOIN program_enrolment programEnrolment ON programEncounter.program_enrolment_id = programEnrolment.id
                                             LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
                                             LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
                                             LEFT OUTER JOIN gender g ON g.id = individual.gender_id
                                             LEFT OUTER JOIN address_level a ON individual.address_id = a.id
                                    WHERE op.uuid = '369dc9d1-ea43-47cf-9a32-5e98a81b2de4'
                                      AND oet.uuid = 'a1021d7f-7d93-4fa2-b766-09ec2733c9ff'
                                      AND programEncounter.encounter_date_time IS NOT NULL
                                      AND programEnrolment.enrolment_date_time IS NOT NULL);


drop view if exists jsscp_child_birth_view;
create view jsscp_child_birth_view as (
  WITH concepts AS (
      SELECT hstore((array_agg(concept.uuid))::text[], (array_agg(concept.name))::text[]) AS map
      FROM concept
  )
    SELECT  individual.id "Ind.Id",
            individual.address_id "Ind.address_id",
            individual.uuid "Ind.uuid",
            individual.first_name "Ind.first_name",
            individual.last_name "Ind.last_name",
            g.name "Ind.Gender",
            individual.date_of_birth "Ind.date_of_birth",
            individual.date_of_birth_verified "Ind.date_of_birth_verified",
            individual.registration_date "Ind.registration_date",
            individual.facility_id  "Ind.facility_id",
            village.title      "Ind.village",
            cluster.title      "Ind.cluster",
            u.name    "Enc.username",
            individual.is_voided "Ind.is_voided",
            op.name "Enl.Program Name",
            programEnrolment.id  "Enl.Id",
            programEnrolment.uuid  "Enl.uuid",
            programEnrolment.is_voided "Enl.is_voided",
            programEnrolment.program_exit_date_time "Enl.program_exit_date_time",
            oet.name "Enc.Type",
            programEncounter.id "Enc.Id",
            programEncounter.earliest_visit_date_time "Enc.earliest_visit_date_time",
            programEncounter.encounter_date_time "Enc.encounter_date_time",
            programEncounter.program_enrolment_id "Enc.program_enrolment_id",
            programEncounter.uuid "Enc.uuid",  programEncounter.name "Enc.name",
            programEncounter.max_visit_date_time "Enc.max_visit_date_time",
            programEncounter.is_voided "Enc.is_voided",
            (individual.observations->>'0aec1658-5ae8-4517-be2d-81a89974d143')::TEXT as "Ind.Non programme village name",
            (individual.observations->>'ecdf3c54-2808-494d-87be-8fb744d5c3bc')::TEXT as "Ind.Father/Husband's Name",
            get_coded_string_value(individual.observations-> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b', concepts.map)::TEXT as "Ind.Marital status",
            (individual.observations->>'9d958124-09bb-466c-a4b4-db8d285def1f')::DATE as "Ind.Date of marriage",
            get_coded_string_value(individual.observations-> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b', concepts.map)::TEXT as "Ind.Education",
            get_coded_string_value(individual.observations-> '20ef261a-f110-4eaa-a592-2a1eeb0bf061', concepts.map)::TEXT as "Ind.Occupation",
            (individual.observations->>'4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT as "Ind.Other occupation",
            get_coded_string_value(individual.observations-> 'bab107f6-fc0e-4be7-ab71-658a92d72f35', concepts.map)::TEXT as "Ind.Whether any disability",
            get_coded_string_value(individual.observations->'7061c675-c2ba-4016-886d-eeb432548378', concepts.map)::TEXT as "Ind.Type of disability",
            get_coded_string_value(individual.observations-> 'd333f2a2-717e-478f-acbc-173bc7374d66', concepts.map)::TEXT as "Ind.Status of the individual",
            (individual.observations->>'681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT as "Ind.Aadhaar ID",
            (individual.observations->>'0a725832-b21c-4151-b017-7e6af770ba54')::TEXT as "Ind.Contact Number",
            get_coded_string_value(individual.observations-> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b', concepts.map)::TEXT as "Ind.Smart card (Insurance)",
            (programEncounter.observations->>'24a9549b-05fc-4899-b861-b5c0e54b7340')::TEXT as "Enc.Birth Weight",
            get_coded_string_value(programEncounter.observations-> '7cecaf08-1a00-41a6-965b-015b89aa66ba', concepts.map)::TEXT as "Enc.Whether baby cleaned and dried immediately after birth",
            get_coded_string_value(programEncounter.observations-> 'cdd45c89-b7be-4131-a6c0-48e8b82926c4', concepts.map)::TEXT as "Enc.Whether baby wrapped in warm clothes",
            get_coded_string_value(programEncounter.observations-> '734e9cd5-3df4-4cfd-bca4-aa842af2c84e', concepts.map)::TEXT as "Enc.Diagnosis of baby immediately after birth",
            get_coded_string_value(programEncounter.observations-> '426f1fbd-6211-47dc-9b58-05a94d8dd713', concepts.map)::TEXT as "Enc.Newborn cry",
            get_coded_string_value(programEncounter.observations-> '63495af0-0150-48a0-b52d-9656a8671f1b', concepts.map)::TEXT as "Enc.Newborn breathing",
            get_coded_string_value(programEncounter.observations-> '5b885356-ac8a-4e5c-bc6d-32ac05079d62', concepts.map)::TEXT as "Enc.Newborn movement",
            get_coded_string_value(programEncounter.observations-> 'e2282953-329a-400f-aa12-7b1065a42f7a', concepts.map)::TEXT as "Enc.If baby was not breathing for 30 seconds, was any action taken",
            get_coded_string_value(programEncounter.observations-> 'a11eea1e-4529-4bf1-a8b2-734e38a590bb', concepts.map)::TEXT as "Enc.Whether mucus extractor used",
            get_coded_string_value(programEncounter.observations-> '62fa4db7-448a-48fe-b5d4-5feb00752153', concepts.map)::TEXT as "Enc.What was the outcome of action",
            get_coded_string_value(programEncounter.observations-> 'e4d30772-e360-4824-9acb-e417bb5b264e', concepts.map)::TEXT as "Enc.Newborn cried",
            get_coded_string_value(programEncounter.observations-> 'f23c5d63-f73c-40e7-a4d0-9ebecf2a701c', concepts.map)::TEXT as "Enc.Newborn breath",
            get_coded_string_value(programEncounter.observations-> '0c06c507-6676-4083-a862-2b0d80327262', concepts.map)::TEXT as "Enc.Newborn movements",
            programEncounter.cancel_date_time "EncCancel.cancel_date_time",
            get_coded_string_value(programEncounter.observations-> 'bf400e7f-8e1b-4052-af49-b0db47b3eb5a', concepts.map)::TEXT as "EncCancel.Visit cancel reason",
            (programEncounter.observations->>'d038a9c4-fe96-4c09-b883-c80691427b60')::TEXT as "EncCancel.Other reason for cancelling",
            (programEnrolment.program_exit_observations ->> '338953ea-6d7e-423e-96d6-f52d5aa37072')::DATE as "EnlExit.Date of Death"
            FROM program_encounter programEncounter
            CROSS JOIN concepts
            LEFT OUTER JOIN operational_encounter_type oet on programEncounter.encounter_type_id = oet.encounter_type_id
            LEFT OUTER JOIN program_enrolment programEnrolment ON programEncounter.program_enrolment_id = programEnrolment.id
            LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
            LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
            LEFT OUTER JOIN gender g ON g.id = individual.gender_id  left join address_level village ON individual.address_id = village.id
             left join address_level cluster on village.parent_id = cluster.id
             LEFT JOIN audit a ON programEncounter.audit_id = a.id
             LEFT JOIN users u ON a.created_by_id = u.id


            WHERE op.uuid = 'bf6c7776-6e85-4700-95b7-429f119d0af5'
            AND oet.uuid = '86a2d0cb-62d0-4277-ba07-7a7e8b6c67ce'
            AND programEncounter.encounter_date_time IS NOT NULL
            AND programEnrolment.enrolment_date_time IS NOT NULL
);

drop view if exists jsscp_child_referral_status_view;
create view jsscp_child_referral_status_view as (
                                                WITH concepts AS (
                                                    SELECT hstore((array_agg(concept.uuid))::text[], (array_agg(concept.name))::text[]) AS map
                                                    FROM concept
                                                )
                                                SELECT
                                                    individual.id "Ind.Id",
                                                    individual.address_id "Ind.address_id",
                                                    individual.uuid "Ind.uuid",
                                                    individual.first_name "Ind.first_name",
                                                    individual.last_name "Ind.last_name",
                                                    g.name "Ind.Gender",
                                                    individual.date_of_birth "Ind.date_of_birth",
                                                    individual.date_of_birth_verified "Ind.date_of_birth_verified",
                                                    individual.registration_date "Ind.registration_date",
                                                    individual.facility_id  "Ind.facility_id",
                                                    a.title "Ind.Area",
                                                    individual.is_voided "Ind.is_voided",
                                                    op.name "Enl.Program Name",
                                                    programEnrolment.id  "Enl.Id",
                                                    programEnrolment.uuid  "Enl.uuid",
                                                    programEnrolment.is_voided "Enl.is_voided",
                                                    oet.name "Enc.Type",
                                                    programEncounter.id "Enc.Id",
                                                    programEncounter.earliest_visit_date_time "Enc.earliest_visit_date_time",
                                                    programEncounter.encounter_date_time "Enc.encounter_date_time",
                                                    programEncounter.program_enrolment_id "Enc.program_enrolment_id",
                                                    programEncounter.uuid "Enc.uuid",
                                                    programEncounter.name "Enc.name",
                                                    programEncounter.max_visit_date_time "Enc.max_visit_date_time",
                                                    programEncounter.is_voided "Enc.is_voided",
                                                    (individual.observations->>'ecdf3c54-2808-494d-87be-8fb744d5c3bc')::TEXT as "Ind.Father/Husband's Name",
                                                    get_coded_string_value(individual.observations-> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b', concepts.map)::TEXT as "Ind.Marital status",
                                                    (individual.observations->>'9d958124-09bb-466c-a4b4-db8d285def1f')::DATE as "Ind.Date of marriage",
                                                    get_coded_string_value(individual.observations-> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b', concepts.map)::TEXT as "Ind.Education",
                                                    get_coded_string_value(individual.observations-> '20ef261a-f110-4eaa-a592-2a1eeb0bf061', concepts.map)::TEXT as "Ind.Occupation",
                                                    (individual.observations->>'4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT as "Ind.Other occupation",
                                                    get_coded_string_value(individual.observations-> 'bab107f6-fc0e-4be7-ab71-658a92d72f35', concepts.map)::TEXT as "Ind.Whether any disability",
                                                    get_coded_string_value(individual.observations->'7061c675-c2ba-4016-886d-eeb432548378', concepts.map)::TEXT as "Ind.Type of disability",
                                                    get_coded_string_value(individual.observations-> 'd333f2a2-717e-478f-acbc-173bc7374d66', concepts.map)::TEXT as "Ind.Status of the individual",
                                                    (individual.observations->>'681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT as "Ind.Aadhaar ID",
                                                    (individual.observations->>'0a725832-b21c-4151-b017-7e6af770ba54')::TEXT as "Ind.Contact Number",
                                                    get_coded_string_value(individual.observations-> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b', concepts.map)::TEXT as "Ind.Smart card (Insurance)",

                                                    get_coded_string_value(programEncounter.observations-> '4671094b-4fe9-42d4-a933-6cc7d0320209', concepts.map)::TEXT as "Enc.Status of referral -1",
                                                    (programEncounter.observations->>'e76c8b20-7de0-4cdb-ab9f-3df35452ad27')::TEXT as "Enc.Other status of referral -1",
                                                    get_coded_string_value(programEncounter.observations-> '9c049865-30c3-4a1f-958f-76e39714e1cd', concepts.map)::TEXT as "Enc.Status of referral -2",
                                                    (programEncounter.observations->>'35a163f3-8632-48d9-9a8c-1b369839942c')::TEXT as "Enc.Other status of referral -2",
                                                    programEncounter.cancel_date_time "EncCancel.cancel_date_time",
                                                    get_coded_string_value(programEncounter.observations-> 'bf400e7f-8e1b-4052-af49-b0db47b3eb5a', concepts.map)::TEXT as "EncCancel.Visit cancel reason",
                                                    (programEncounter.observations->>'d038a9c4-fe96-4c09-b883-c80691427b60')::TEXT as "EncCancel.Other reason for cancelling",
                                                    (programEncounter.observations->>'6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE as "EncCancel.Date of next ANC Visit"
                                                FROM program_encounter programEncounter
                                                         CROSS JOIN concepts
                                                         LEFT OUTER JOIN operational_encounter_type oet on programEncounter.encounter_type_id = oet.encounter_type_id
                                                         LEFT OUTER JOIN program_enrolment programEnrolment ON programEncounter.program_enrolment_id = programEnrolment.id
                                                         LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
                                                         LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
                                                         LEFT OUTER JOIN gender g ON g.id = individual.gender_id
                                                         LEFT OUTER JOIN address_level a ON individual.address_id = a.id
                                                WHERE op.uuid = 'bf6c7776-6e85-4700-95b7-429f119d0af5'
                                                  AND oet.uuid = 'f346a977-cc22-478a-9237-a08c4219e592'
                                                  AND programEncounter.encounter_date_time IS NOT NULL
                                                  AND programEnrolment.enrolment_date_time IS NOT NULL
                                                    );

drop view if exists jsscp_mother_referral_status_view;
create view jsscp_mother_referral_status_view as (
                                                 WITH concepts AS (
                                                     SELECT hstore((array_agg(concept.uuid))::text[], (array_agg(concept.name))::text[]) AS map
                                                     FROM concept
                                                 )
                                                  --[Data Extract Report]
                                                 SELECT
                                                     individual.id "Ind.Id",
                                                     individual.address_id "Ind.address_id",
                                                     individual.uuid "Ind.uuid",
                                                     individual.first_name "Ind.first_name",
                                                     individual.last_name "Ind.last_name",
                                                     g.name "Ind.Gender",
                                                     individual.date_of_birth "Ind.date_of_birth",
                                                     individual.date_of_birth_verified "Ind.date_of_birth_verified",
                                                     individual.registration_date "Ind.registration_date",
                                                     individual.facility_id  "Ind.facility_id",
                                                     a.title "Ind.Area",
                                                     individual.is_voided "Ind.is_voided",
                                                     op.name "Enl.Program Name",
                                                     programEnrolment.id  "Enl.Id",
                                                     programEnrolment.uuid  "Enl.uuid",
                                                     programEnrolment.is_voided "Enl.is_voided",
                                                     oet.name "Enc.Type",
                                                     programEncounter.id "Enc.Id",
                                                     programEncounter.earliest_visit_date_time "Enc.earliest_visit_date_time",
                                                     programEncounter.encounter_date_time "Enc.encounter_date_time",
                                                     programEncounter.program_enrolment_id "Enc.program_enrolment_id",
                                                     programEncounter.uuid "Enc.uuid",
                                                     programEncounter.name "Enc.name",
                                                     programEncounter.max_visit_date_time "Enc.max_visit_date_time",
                                                     programEncounter.is_voided "Enc.is_voided",
                                                     (individual.observations->>'ecdf3c54-2808-494d-87be-8fb744d5c3bc')::TEXT as "Ind.Father/Husband's Name",
                                                     get_coded_string_value(individual.observations-> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b', concepts.map)::TEXT as "Ind.Marital status",
                                                     (individual.observations->>'9d958124-09bb-466c-a4b4-db8d285def1f')::DATE as "Ind.Date of marriage",
                                                     get_coded_string_value(individual.observations-> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b', concepts.map)::TEXT as "Ind.Education",
                                                     get_coded_string_value(individual.observations-> '20ef261a-f110-4eaa-a592-2a1eeb0bf061', concepts.map)::TEXT as "Ind.Occupation",
                                                     (individual.observations->>'4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT as "Ind.Other occupation",
                                                     get_coded_string_value(individual.observations-> 'bab107f6-fc0e-4be7-ab71-658a92d72f35', concepts.map)::TEXT as "Ind.Whether any disability",
                                                     get_coded_string_value(individual.observations->'7061c675-c2ba-4016-886d-eeb432548378', concepts.map)::TEXT as "Ind.Type of disability",
                                                     get_coded_string_value(individual.observations-> 'd333f2a2-717e-478f-acbc-173bc7374d66', concepts.map)::TEXT as "Ind.Status of the individual",
                                                     (individual.observations->>'681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT as "Ind.Aadhaar ID",
                                                     (individual.observations->>'0a725832-b21c-4151-b017-7e6af770ba54')::TEXT as "Ind.Contact Number",
                                                     get_coded_string_value(individual.observations-> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b', concepts.map)::TEXT as "Ind.Smart card (Insurance)",
                                                     (programEnrolment.observations->>'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c')::TEXT as "Enl.ANC Enrolment ID",
                                                     get_coded_string_value(programEnrolment.observations->'58d0a437-17ef-4d58-a36f-9a36b608f5a4', concepts.map)::TEXT as "Enl.Relation with village",
                                                     (programEnrolment.observations->>'aaac11d9-1237-41ac-9cf9-239c1226048a')::TEXT as "Enl.Other relation with village",
                                                     (programEnrolment.observations->>'838cdad2-e661-4517-88ca-5b9e8e6c676e')::TEXT as "Enl.Gravida",
                                                     (programEnrolment.observations->>'6956e0f7-d31b-4fb5-a3de-bd6251b24f49')::TEXT as "Enl.Parity",
                                                     (programEnrolment.observations->>'47bb4fbd-729b-48db-995c-4464e26dd3f3')::TEXT as "Enl.Live birth",
                                                     (programEnrolment.observations->>'73e37865-47a7-44ef-8a06-870b79e55fbd')::TEXT as "Enl.still birth",
                                                     (programEnrolment.observations->>'1465d2a8-dd5a-4cec-9cc3-ab9c7ba22cc2')::TEXT as "Enl.number of abortions",
                                                     (programEnrolment.observations->>'42a98500-3c12-426b-9121-e0e993dbacaf')::TEXT as "Enl.prganancy,death",
                                                     (programEnrolment.observations->>'24b4a632-42bd-4847-91f4-7d8e69929581')::TEXT as "Enl.Death of children within 1 week after delivery",
                                                     (programEnrolment.observations->>'c9b244f3-7795-4f5a-a0aa-ccafd1e57b94')::TEXT as "Enl.Death of children due to congenital abnormality",
                                                     (programEnrolment.observations->>'814f1780-aa3d-4c46-b881-71face696220')::DATE as "Enl.Last menstrual period",
                                                     (programEnrolment.observations->>'730ca106-ece0-495d-8962-f60f38e79d12')::DATE as "Enl.EDD",
                                                     (programEnrolment.observations->>'e817dda1-0cd7-40a9-8d30-06aafbbbbf24')::TEXT as "Enl.Is women registered within 3 months",
                                                     (programEnrolment.observations->>'748b7b66-c9ce-496f-b670-9d2896e82c23')::DATE as "Enl.Last Delivery",
                                                     get_coded_string_value(programEnrolment.observations->'1952339b-14b0-447d-b6d7-6bcf18b4af62', concepts.map)::TEXT as "Enl.Last delivery place",
                                                     get_coded_string_value(programEnrolment.observations->'6c771640-52b6-46ea-bd56-0a2670ab7a6d', concepts.map)::TEXT as "Enl.Last delivery outcome",
                                                     get_coded_string_value(programEnrolment.observations->'f776b045-2fcb-4275-b08e-e3e9039b699e', concepts.map)::TEXT as "Enl.Last delivery gender",
                                                     get_coded_string_value(programEnrolment.observations->'2f68ca5f-c690-4848-aa2e-592d6c7ef4e8', concepts.map)::TEXT as "Enl.Last delivery- Is baby alive?",
                                                     get_coded_string_value(programEnrolment.observations->'26cee30f-b36d-4be2-bec3-9a0904492e52', concepts.map)::TEXT as "Enl.Any High risk condition in previous pregnancy",
                                                     get_coded_string_value(programEnrolment.observations->'a0aea5a9-7101-48ef-8463-5b376efa61bf', concepts.map)::TEXT as "Enl.High risk condition in previous pregnancy",
                                                     (programEnrolment.observations->>'6bdfb87a-fefc-48ea-bcab-8bd05cbae73d')::TEXT as "Enl.Other high risk condition in previous pregnancy",
                                                     get_coded_string_value(programEnrolment.observations->'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2', concepts.map)::TEXT as "Enl.Taking medicine for chronic disease",
                                                     get_coded_string_value(programEnrolment.observations->'7d9b6992-ee27-4423-90a5-9ad20400d885', concepts.map)::TEXT as "Enl.Name of chronic disease",
                                                     (programEnrolment.observations->>'a54d0c2c-a054-45a5-a143-9f6c9db3fbbd')::TEXT as "Enl.Other chronic disease",
                                                     get_coded_string_value(programEnrolment.observations->'1aac0eaf-1c9e-4284-93c3-7212c06a3286', concepts.map)::TEXT as "Enl.Does woman want to continue this pregnancy?",
                                                     get_coded_string_value(programEnrolment.observations->'b5ebc472-0f32-4128-97f3-0e2571daeaae', concepts.map)::TEXT as "Enl.Send her to nearest antenatal clinic",
                                                     (programEnrolment.observations->>'6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE as "Enl.Date of next ANC Visit",
                                                     get_coded_string_value(programEnrolment.observations->'b6f45def-e3f4-4e7b-97ed-68c539b82fa2', concepts.map)::TEXT as "Enl.Send her to hospital for abortion",
                                                     get_coded_string_value(programEncounter.observations-> '4671094b-4fe9-42d4-a933-6cc7d0320209', concepts.map)::TEXT as "Enc.Status of referral -1",
                                                     (programEncounter.observations->>'e76c8b20-7de0-4cdb-ab9f-3df35452ad27')::TEXT as "Enc.Other status of referral -1",
                                                     get_coded_string_value(programEncounter.observations-> '9c049865-30c3-4a1f-958f-76e39714e1cd', concepts.map)::TEXT as "Enc.Status of referral -2",
                                                     (programEncounter.observations->>'35a163f3-8632-48d9-9a8c-1b369839942c')::TEXT as "Enc.Other status of referral -2",
                                                     programEncounter.cancel_date_time "EncCancel.cancel_date_time",
                                                     get_coded_string_value(programEncounter.observations-> 'bf400e7f-8e1b-4052-af49-b0db47b3eb5a', concepts.map)::TEXT as "EncCancel.Visit cancel reason",
                                                     (programEncounter.observations->>'d038a9c4-fe96-4c09-b883-c80691427b60')::TEXT as "EncCancel.Other reason for cancelling",
                                                     (programEncounter.observations->>'6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE as "EncCancel.Date of next ANC Visit"
                                                 FROM program_encounter programEncounter
                                                          CROSS JOIN concepts
                                                          LEFT OUTER JOIN operational_encounter_type oet on programEncounter.encounter_type_id = oet.encounter_type_id
                                                          LEFT OUTER JOIN program_enrolment programEnrolment ON programEncounter.program_enrolment_id = programEnrolment.id
                                                          LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
                                                          LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
                                                          LEFT OUTER JOIN gender g ON g.id = individual.gender_id
                                                          LEFT OUTER JOIN address_level a ON individual.address_id = a.id
                                                 WHERE op.uuid = '369dc9d1-ea43-47cf-9a32-5e98a81b2de4'
                                                   AND oet.uuid = 'f346a977-cc22-478a-9237-a08c4219e592'
                                                   AND programEncounter.encounter_date_time IS NOT NULL
                                                   AND programEnrolment.enrolment_date_time IS NOT NULL   )
;
drop view if exists jsscp_abortion_followup_view;
create view jsscp_abortion_followup_view as (
                                            WITH concepts AS (
                                                SELECT hstore((array_agg(concept.uuid))::text[], (array_agg(concept.name))::text[]) AS map
                                                FROM concept
                                            )
                                                 --[Data Extract Report]
                                                 SELECT
                                                     individual.id "Ind.Id",
                                                     individual.address_id "Ind.address_id",
                                                     individual.uuid "Ind.uuid",
                                                     individual.first_name "Ind.first_name",
                                                     individual.last_name "Ind.last_name",
                                                     g.name "Ind.Gender",
                                                     individual.date_of_birth "Ind.date_of_birth",
                                                     individual.date_of_birth_verified "Ind.date_of_birth_verified",
                                                     individual.registration_date "Ind.registration_date",
                                                     individual.facility_id  "Ind.facility_id",
                                                     a.title "Ind.Area",
                                                     individual.is_voided "Ind.is_voided",
                                                     op.name "Enl.Program Name",
                                                     programEnrolment.id  "Enl.Id",
                                                     programEnrolment.uuid  "Enl.uuid",
                                                     programEnrolment.is_voided "Enl.is_voided",
                                                     oet.name "Enc.Type",
                                                     programEncounter.id "Enc.Id",
                                                     programEncounter.earliest_visit_date_time "Enc.earliest_visit_date_time",
                                                     programEncounter.encounter_date_time "Enc.encounter_date_time",
                                                     programEncounter.program_enrolment_id "Enc.program_enrolment_id",
                                                     programEncounter.uuid "Enc.uuid",
                                                     programEncounter.name "Enc.name",
                                                     programEncounter.max_visit_date_time "Enc.max_visit_date_time",
                                                     programEncounter.is_voided "Enc.is_voided",
                                                     (individual.observations->>'ecdf3c54-2808-494d-87be-8fb744d5c3bc')::TEXT as "Ind.Father/Husband's Name",
                                                     get_coded_string_value(individual.observations-> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b', concepts.map)::TEXT as "Ind.Marital status",
                                                     (individual.observations->>'9d958124-09bb-466c-a4b4-db8d285def1f')::DATE as "Ind.Date of marriage",
                                                     get_coded_string_value(individual.observations-> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b', concepts.map)::TEXT as "Ind.Education",
                                                     get_coded_string_value(individual.observations-> '20ef261a-f110-4eaa-a592-2a1eeb0bf061', concepts.map)::TEXT as "Ind.Occupation",
                                                     (individual.observations->>'4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT as "Ind.Other occupation",
                                                     get_coded_string_value(individual.observations-> 'bab107f6-fc0e-4be7-ab71-658a92d72f35', concepts.map)::TEXT as "Ind.Whether any disability",
                                                     get_coded_string_value(individual.observations->'7061c675-c2ba-4016-886d-eeb432548378', concepts.map)::TEXT as "Ind.Type of disability",
                                                     get_coded_string_value(individual.observations-> 'd333f2a2-717e-478f-acbc-173bc7374d66', concepts.map)::TEXT as "Ind.Status of the individual",
                                                     (individual.observations->>'681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT as "Ind.Aadhaar ID",
                                                     (individual.observations->>'0a725832-b21c-4151-b017-7e6af770ba54')::TEXT as "Ind.Contact Number",
                                                     get_coded_string_value(individual.observations-> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b', concepts.map)::TEXT as "Ind.Smart card (Insurance)",
                                                     (programEnrolment.observations->>'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c')::TEXT as "Enl.ANC Enrolment ID",
                                                     get_coded_string_value(programEnrolment.observations->'58d0a437-17ef-4d58-a36f-9a36b608f5a4', concepts.map)::TEXT as "Enl.Relation with village",
                                                     (programEnrolment.observations->>'aaac11d9-1237-41ac-9cf9-239c1226048a')::TEXT as "Enl.Other relation with village",
                                                     (programEnrolment.observations->>'838cdad2-e661-4517-88ca-5b9e8e6c676e')::TEXT as "Enl.Gravida",
                                                     (programEnrolment.observations->>'6956e0f7-d31b-4fb5-a3de-bd6251b24f49')::TEXT as "Enl.Parity",
                                                     (programEnrolment.observations->>'47bb4fbd-729b-48db-995c-4464e26dd3f3')::TEXT as "Enl.Live birth",
                                                     (programEnrolment.observations->>'73e37865-47a7-44ef-8a06-870b79e55fbd')::TEXT as "Enl.still birth",
                                                     (programEnrolment.observations->>'1465d2a8-dd5a-4cec-9cc3-ab9c7ba22cc2')::TEXT as "Enl.number of abortions",
                                                     (programEnrolment.observations->>'42a98500-3c12-426b-9121-e0e993dbacaf')::TEXT as "Enl.prganancy,death",
                                                     (programEnrolment.observations->>'24b4a632-42bd-4847-91f4-7d8e69929581')::TEXT as "Enl.Death of children within 1 week after delivery",
                                                     (programEnrolment.observations->>'c9b244f3-7795-4f5a-a0aa-ccafd1e57b94')::TEXT as "Enl.Death of children due to congenital abnormality",
                                                     (programEnrolment.observations->>'814f1780-aa3d-4c46-b881-71face696220')::DATE as "Enl.Last menstrual period",
                                                     (programEnrolment.observations->>'730ca106-ece0-495d-8962-f60f38e79d12')::DATE as "Enl.EDD",
                                                     (programEnrolment.observations->>'e817dda1-0cd7-40a9-8d30-06aafbbbbf24')::TEXT as "Enl.Is women registered within 3 months",
                                                     (programEnrolment.observations->>'748b7b66-c9ce-496f-b670-9d2896e82c23')::DATE as "Enl.Last Delivery",
                                                     get_coded_string_value(programEnrolment.observations->'1952339b-14b0-447d-b6d7-6bcf18b4af62', concepts.map)::TEXT as "Enl.Last delivery place",
                                                     get_coded_string_value(programEnrolment.observations->'6c771640-52b6-46ea-bd56-0a2670ab7a6d', concepts.map)::TEXT as "Enl.Last delivery outcome",
                                                     get_coded_string_value(programEnrolment.observations->'f776b045-2fcb-4275-b08e-e3e9039b699e', concepts.map)::TEXT as "Enl.Last delivery gender",
                                                     get_coded_string_value(programEnrolment.observations->'2f68ca5f-c690-4848-aa2e-592d6c7ef4e8', concepts.map)::TEXT as "Enl.Last delivery- Is baby alive?",
                                                     get_coded_string_value(programEnrolment.observations->'26cee30f-b36d-4be2-bec3-9a0904492e52', concepts.map)::TEXT as "Enl.Any High risk condition in previous pregnancy",
                                                     get_coded_string_value(programEnrolment.observations->'a0aea5a9-7101-48ef-8463-5b376efa61bf', concepts.map)::TEXT as "Enl.High risk condition in previous pregnancy",
                                                     (programEnrolment.observations->>'6bdfb87a-fefc-48ea-bcab-8bd05cbae73d')::TEXT as "Enl.Other high risk condition in previous pregnancy",
                                                     get_coded_string_value(programEnrolment.observations->'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2', concepts.map)::TEXT as "Enl.Taking medicine for chronic disease",
                                                     get_coded_string_value(programEnrolment.observations->'7d9b6992-ee27-4423-90a5-9ad20400d885', concepts.map)::TEXT as "Enl.Name of chronic disease",
                                                     (programEnrolment.observations->>'a54d0c2c-a054-45a5-a143-9f6c9db3fbbd')::TEXT as "Enl.Other chronic disease",
                                                     get_coded_string_value(programEnrolment.observations->'1aac0eaf-1c9e-4284-93c3-7212c06a3286', concepts.map)::TEXT as "Enl.Does woman want to continue this pregnancy?",
                                                     get_coded_string_value(programEnrolment.observations->'b5ebc472-0f32-4128-97f3-0e2571daeaae', concepts.map)::TEXT as "Enl.Send her to nearest antenatal clinic",
                                                     (programEnrolment.observations->>'6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE as "Enl.Date of next ANC Visit",
                                                     get_coded_string_value(programEnrolment.observations->'b6f45def-e3f4-4e7b-97ed-68c539b82fa2', concepts.map)::TEXT as "Enl.Send her to hospital for abortion",
                                                     (programEncounter.observations->>'0f3c0b07-0014-468d-b01d-9fa1fb60801a')::TEXT as "Enc.How many times a day does mother change the clothes?",
                                                     (programEncounter.observations->>'0c6d2587-382d-4762-8871-b6890d854505')::TEXT as "Enc.Temperature(celcius)",
                                                     (programEncounter.observations->>'630c0fa3-38f7-427d-a8dd-f1417cf1b7dc')::TEXT as "Enc.Pulse",
                                                     (programEncounter.observations->>'6874d48e-8c2f-4009-992c-1d3ca1678cc6')::TEXT as "Enc.Blood Pressure (systolic)",
                                                     (programEncounter.observations->>'da871f6c-cef0-4191-b307-6751b31ac9ec')::TEXT as "Enc.Blood Pressure (Diastolic)",
                                                     get_coded_string_value(programEncounter.observations-> '7764a974-7ba8-4a13-9ba9-6d8d580f3c99', concepts.map)::TEXT as "Enc.Is there foul smelling discharge PV",
                                                     get_coded_string_value(programEncounter.observations-> '74c618b3-a4e0-4382-9486-70dbf5752d9d', concepts.map)::TEXT as "Enc.Does mother has seizures?",
                                                     get_coded_string_value(programEncounter.observations-> '43567d78-ad97-46bc-afa1-8522ec9e0180', concepts.map)::TEXT as "Enc.Does mother has any breast related issue like swelling etc?",
                                                     get_coded_string_value(programEncounter.observations-> '77d122e8-0620-4754-8375-b0cbe329003c', concepts.map)::TEXT as "Enc.Does woman require referral?",
                                                     get_coded_string_value(programEncounter.observations-> '80fccb06-a62f-43e8-92eb-358bdb600079', concepts.map)::TEXT as "Enc.Place of referral",
                                                     (programEncounter.observations->>'d169efa9-49af-4c84-ae09-b1b7296c62da')::TEXT as "Enc.Other place of referral",
                                                     get_coded_string_value(programEncounter.observations-> '8a56f008-a910-4d6f-b028-a95db330dbf2', concepts.map)::TEXT as "Enc.Referral reason",
                                                     (programEncounter.observations->>'e048675e-eb86-41c2-a47b-aecfa9a3bb8c')::TEXT as "Enc.Other referral reason",
                                                     get_coded_string_value(programEncounter.observations-> '0ac30adc-5107-4e30-9b8a-c3ef65904cf5', concepts.map)::TEXT as "Enc.Counselling",
                                                     get_coded_string_value(programEncounter.observations-> 'dfe26772-b418-4741-a80b-30fcbe452b5f', concepts.map)::TEXT as "Enc.Family Planning Benefits for Women",
                                                     get_coded_string_value(programEncounter.observations-> 'af57d463-f260-4a58-8b08-18f754d0a5e2', concepts.map)::TEXT as "Enc.The benefits of family planning to the child",
                                                     get_coded_string_value(programEncounter.observations-> '99593b34-a7f6-445f-aa59-7550f8c0f648', concepts.map)::TEXT as "Enc.Risks of not adopting family planning",
                                                     get_coded_string_value(programEncounter.observations-> '9aa87afd-8d1f-4870-9638-7a3b6aefa36d', concepts.map)::TEXT as "Enc.The exact time and interval of pregnancy",
                                                     get_coded_string_value(programEncounter.observations-> '2e5288f0-1f4b-4c72-bd6d-ae4fa072a1d9', concepts.map)::TEXT as "Enc.When is the possibility of next pregnancy after delivery?",
                                                     get_coded_string_value(programEncounter.observations-> 'd833658b-ce1f-412d-bc34-086f8d1ba50d', concepts.map)::TEXT as "Enc.Have you thought about using any contraceptive",
                                                     get_coded_string_value(programEncounter.observations-> '1d7ed26e-17f8-4d27-b5e5-a0fc61336032', concepts.map)::TEXT as "Enc.If she had not thought about any contraceptive method",
                                                     get_coded_string_value(programEncounter.observations-> '35829406-7047-40a4-a970-17d029f49562', concepts.map)::TEXT as "Enc.Provide detailed information about the chosen contraceptive",
                                                     get_coded_string_value(programEncounter.observations-> '65cf7297-98ff-4405-b1df-336325f4d96e', concepts.map)::TEXT as "Enc.Repeat key points once again",
                                                     get_coded_string_value(programEncounter.observations-> '3eeb5be5-a74b-4cf4-805f-3b8549a5daef', concepts.map)::TEXT as "Enc.Give information about misconception of contraceptiv method",
                                                     get_coded_string_value(programEncounter.observations-> '48b372a3-b491-4c45-8d14-b99e5515daf2', concepts.map)::TEXT as "Enc.Motivate men to adopt contraceptive method",
                                                     get_coded_string_value(programEncounter.observations-> '338bf574-680c-4d8b-94f9-aa2b768dadeb', concepts.map)::TEXT as "Enc.refer mother to subcenter or ask SHW to see sepsis sign",
                                                     get_coded_string_value(programEncounter.observations-> 'ca2af807-ec9f-4b33-8ffa-e17075979996', concepts.map)::TEXT as "Enc.refer the woman to SC or ask the SHW to make a home visit",
                                                     get_coded_string_value(programEncounter.observations-> 'c3f8600a-aebf-44ea-967e-ff93c11a5946', concepts.map)::TEXT as "Enc.refer the mother to SC/Ganiyari",
                                                     get_coded_string_value(programEncounter.observations-> '1ade5184-6907-4187-9186-abd12caacf05', concepts.map)::TEXT as "Enc.Womane want to use any family plannig",
                                                     programEncounter.cancel_date_time "EncCancel.cancel_date_time",
                                                     get_coded_string_value(programEncounter.observations-> 'bf400e7f-8e1b-4052-af49-b0db47b3eb5a', concepts.map)::TEXT as "EncCancel.Visit cancel reason",
                                                     (programEncounter.observations->>'d038a9c4-fe96-4c09-b883-c80691427b60')::TEXT as "EncCancel.Other reason for cancelling",
                                                     (programEncounter.observations->>'6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE as "EncCancel.Date of next ANC Visit"
                                                 FROM program_encounter programEncounter
                                                          CROSS JOIN concepts
                                                          LEFT OUTER JOIN operational_encounter_type oet on programEncounter.encounter_type_id = oet.encounter_type_id
                                                          LEFT OUTER JOIN program_enrolment programEnrolment ON programEncounter.program_enrolment_id = programEnrolment.id
                                                          LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
                                                          LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
                                                          LEFT OUTER JOIN gender g ON g.id = individual.gender_id
                                                          LEFT OUTER JOIN address_level a ON individual.address_id = a.id
                                                 WHERE op.uuid = '369dc9d1-ea43-47cf-9a32-5e98a81b2de4'
                                                   AND oet.uuid = '15357ea0-b858-430f-9001-6effa4b76414'
                                                   AND programEncounter.encounter_date_time IS NOT NULL
                                                   AND programEnrolment.enrolment_date_time IS NOT NULL  );

drop view if exists jsscp_child_enrolment_view;
create view jsscp_child_enrolment_view as (
      WITH concepts AS (
          SELECT hstore((array_agg(concept.uuid))::text[], (array_agg(concept.name))::text[]) AS map
          FROM concept
      )
       SELECT  individual.id "Ind.Id",
               individual.address_id "Ind.address_id",
               individual.uuid "Ind.uuid",
               individual.first_name "Ind.first_name",
               individual.last_name "Ind.last_name",
               g.name "Ind.Gender",
               individual.date_of_birth "Ind.date_of_birth",
               individual.date_of_birth_verified "Ind.date_of_birth_verified",
               individual.registration_date "Ind.registration_date",
               individual.facility_id  "Ind.facility_id",
               village.title      "Ind.village",
               cluster.title      "Ind.cluster",
               u.name    "Enl.username",
               individual.is_voided "Ind.is_voided",
               op.name "Enl.Program Name",
               programEnrolment.id  "Enl.Id",
               programEnrolment.uuid  "Enl.uuid",
               programEnrolment.is_voided "Enl.is_voided",
               programEnrolment.program_exit_date_time "Enl.program_exit_date_time",
               (individual.observations->>'0aec1658-5ae8-4517-be2d-81a89974d143')::TEXT as "Ind.Non programme village name",
               (individual.observations->>'ecdf3c54-2808-494d-87be-8fb744d5c3bc')::TEXT as "Ind.Father/Husband's Name",
               get_coded_string_value(individual.observations-> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b', concepts.map)::TEXT as "Ind.Marital status",
               (individual.observations->>'9d958124-09bb-466c-a4b4-db8d285def1f')::DATE as "Ind.Date of marriage",
               get_coded_string_value(individual.observations-> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b', concepts.map)::TEXT as "Ind.Education",
               get_coded_string_value(individual.observations-> '20ef261a-f110-4eaa-a592-2a1eeb0bf061', concepts.map)::TEXT as "Ind.Occupation",
               (individual.observations->>'4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT as "Ind.Other occupation",
               get_coded_string_value(individual.observations-> 'bab107f6-fc0e-4be7-ab71-658a92d72f35', concepts.map)::TEXT as "Ind.Whether any disability",
               get_coded_string_value(individual.observations->'7061c675-c2ba-4016-886d-eeb432548378', concepts.map)::TEXT as "Ind.Type of disability",
               get_coded_string_value(individual.observations-> 'd333f2a2-717e-478f-acbc-173bc7374d66', concepts.map)::TEXT as "Ind.Status of the individual",
               (individual.observations->>'681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT as "Ind.Aadhaar ID",
               (individual.observations->>'0a725832-b21c-4151-b017-7e6af770ba54')::TEXT as "Ind.Contact Number",
               get_coded_string_value(individual.observations-> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b', concepts.map)::TEXT as "Ind.Smart card (Insurance)",
               (programEnrolment.program_exit_observations ->> '338953ea-6d7e-423e-96d6-f52d5aa37072')::DATE as "EnlExit.Date of Death"
       FROM program_enrolment programEnrolment
                CROSS JOIN concepts
                LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
                   LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
                   LEFT OUTER JOIN gender g ON g.id = individual.gender_id  left join address_level village ON individual.address_id = village.id
                   left join address_level cluster on village.parent_id = cluster.id
                   LEFT JOIN audit a ON programEnrolment.audit_id = a.id
                   LEFT JOIN users u ON a.created_by_id = u.id
       WHERE op.uuid = 'bf6c7776-6e85-4700-95b7-429f119d0af5'
         AND programEnrolment.enrolment_date_time IS NOT NULL
);
