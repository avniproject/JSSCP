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

drop view if exists jsscp_pregnancy_view;
create view jsscp_pregnancy_view as (
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
           (individual.observations ->> 'ecdf3c54-2808-494d-87be-8fb744d5c3bc')::TEXT              as "Ind.Father/Husband's Name",
           single_select_coded(
                   individual.observations ->> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b')::TEXT       as "Ind.Marital status",
           (individual.observations ->> '9d958124-09bb-466c-a4b4-db8d285def1f')::DATE              as "Ind.Date of marriage",
           single_select_coded(
                   individual.observations ->> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b')::TEXT       as "Ind.Education",
           single_select_coded(
                   individual.observations ->> '20ef261a-f110-4eaa-a592-2a1eeb0bf061')::TEXT       as "Ind.Occupation",
           (individual.observations ->> '4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT              as "Ind.Other occupation",
           single_select_coded(
                   individual.observations ->> 'bab107f6-fc0e-4be7-ab71-658a92d72f35')::TEXT       as "Ind.Whether any disability",
           multi_select_coded(
                   individual.observations -> '7061c675-c2ba-4016-886d-eeb432548378')::TEXT        as "Ind.Type of disability",
           single_select_coded(
                   individual.observations ->> 'd333f2a2-717e-478f-acbc-173bc7374d66')::TEXT       as "Ind.Status of the individual",
           (individual.observations ->> '681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT              as "Ind.Aadhaar ID",
           (individual.observations ->> '0a725832-b21c-4151-b017-7e6af770ba54')::TEXT              as "Ind.Contact Number",
           single_select_coded(
                   individual.observations ->> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b')::TEXT       as "Ind.Smart card (Insurance)",
           (programEnrolment.observations ->> 'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c')::TEXT        as "Enl.ANC Enrolment ID",
           single_select_coded(
                   programEnrolment.observations ->> '58d0a437-17ef-4d58-a36f-9a36b608f5a4')::TEXT as "Enl.Relation with village",
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
           single_select_coded(
                   programEnrolment.observations ->> '1952339b-14b0-447d-b6d7-6bcf18b4af62')::TEXT as "Enl.Last delivery place",
           single_select_coded(
                   programEnrolment.observations ->> '6c771640-52b6-46ea-bd56-0a2670ab7a6d')::TEXT as "Enl.Last delivery outcome",
           single_select_coded(
                   programEnrolment.observations ->> 'f776b045-2fcb-4275-b08e-e3e9039b699e')::TEXT as "Enl.Last delivery gender",
           single_select_coded(
                   programEnrolment.observations ->> '2f68ca5f-c690-4848-aa2e-592d6c7ef4e8')::TEXT as "Enl.Last delivery- Is baby alive?",
           single_select_coded(
                   programEnrolment.observations ->> '26cee30f-b36d-4be2-bec3-9a0904492e52')::TEXT as "Enl.Any High risk condition in previous pregnancy",
           multi_select_coded(
                   programEnrolment.observations -> 'a0aea5a9-7101-48ef-8463-5b376efa61bf')::TEXT  as "Enl.High risk condition in previous pregnancy",
           (programEnrolment.observations ->> '6bdfb87a-fefc-48ea-bcab-8bd05cbae73d')::TEXT        as "Enl.Other high risk condition in previous pregnancy",
           single_select_coded(
                   programEnrolment.observations ->> 'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2')::TEXT as "Enl.Taking medicine for chronic disease",
           multi_select_coded(
                   programEnrolment.observations -> '7d9b6992-ee27-4423-90a5-9ad20400d885')::TEXT  as "Enl.Name of chronic disease",
           (programEnrolment.observations ->> 'a54d0c2c-a054-45a5-a143-9f6c9db3fbbd')::TEXT        as "Enl.Other chronic disease",
           single_select_coded(
                   programEnrolment.observations ->> '1aac0eaf-1c9e-4284-93c3-7212c06a3286')::TEXT as "Enl.Does woman want to continue this pregnancy?",
           single_select_coded(
                   programEnrolment.observations ->> 'b5ebc472-0f32-4128-97f3-0e2571daeaae')::TEXT as "Enl.Send her to nearest antenatal clinic",
           (programEnrolment.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "Enl.Date of next ANC Visit",
           single_select_coded(
                   programEnrolment.observations ->> 'b6f45def-e3f4-4e7b-97ed-68c539b82fa2')::TEXT as "Enl.Send her to hospital for abortion"
    FROM program_enrolment programEnrolment
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
           single_select_coded(
                   individual.observations ->> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b')::TEXT       as "Ind.Marital status",
           (individual.observations ->> '9d958124-09bb-466c-a4b4-db8d285def1f')::DATE              as "Ind.Date of marriage",
           single_select_coded(
                   individual.observations ->> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b')::TEXT       as "Ind.Education",
           single_select_coded(
                   individual.observations ->> '20ef261a-f110-4eaa-a592-2a1eeb0bf061')::TEXT       as "Ind.Occupation",
           (individual.observations ->> '4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT              as "Ind.Other occupation",
           single_select_coded(
                   individual.observations ->> 'bab107f6-fc0e-4be7-ab71-658a92d72f35')::TEXT       as "Ind.Whether any disability",
           multi_select_coded(
                   individual.observations -> '7061c675-c2ba-4016-886d-eeb432548378')::TEXT        as "Ind.Type of disability",
           single_select_coded(
                   individual.observations ->> 'd333f2a2-717e-478f-acbc-173bc7374d66')::TEXT       as "Ind.Status of the individual",
           (individual.observations ->> '681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT              as "Ind.Aadhaar ID",
           (individual.observations ->> '0a725832-b21c-4151-b017-7e6af770ba54')::TEXT              as "Ind.Contact Number",
           single_select_coded(
                   individual.observations ->> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b')::TEXT       as "Ind.Smart card (Insurance)",
           (programEnrolment.observations ->> 'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c')::TEXT        as "Enl.ANC Enrolment ID",
           single_select_coded(
                   programEnrolment.observations ->> '58d0a437-17ef-4d58-a36f-9a36b608f5a4')::TEXT as "Enl.Relation with village",
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
           single_select_coded(
                   programEnrolment.observations ->> '1952339b-14b0-447d-b6d7-6bcf18b4af62')::TEXT as "Enl.Last delivery place",
           single_select_coded(
                   programEnrolment.observations ->> '6c771640-52b6-46ea-bd56-0a2670ab7a6d')::TEXT as "Enl.Last delivery outcome",
           single_select_coded(
                   programEnrolment.observations ->> 'f776b045-2fcb-4275-b08e-e3e9039b699e')::TEXT as "Enl.Last delivery gender",
           single_select_coded(
                   programEnrolment.observations ->> '2f68ca5f-c690-4848-aa2e-592d6c7ef4e8')::TEXT as "Enl.Last delivery- Is baby alive?",
           single_select_coded(
                   programEnrolment.observations ->> '26cee30f-b36d-4be2-bec3-9a0904492e52')::TEXT as "Enl.Any High risk condition in previous pregnancy",
           multi_select_coded(
                   programEnrolment.observations -> 'a0aea5a9-7101-48ef-8463-5b376efa61bf')::TEXT  as "Enl.High risk condition in previous pregnancy",
           (programEnrolment.observations ->> '6bdfb87a-fefc-48ea-bcab-8bd05cbae73d')::TEXT        as "Enl.Other high risk condition in previous pregnancy",
           single_select_coded(
                   programEnrolment.observations ->> 'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2')::TEXT as "Enl.Taking medicine for chronic disease",
           multi_select_coded(
                   programEnrolment.observations -> '7d9b6992-ee27-4423-90a5-9ad20400d885')::TEXT  as "Enl.Name of chronic disease",
           (programEnrolment.observations ->> 'a54d0c2c-a054-45a5-a143-9f6c9db3fbbd')::TEXT        as "Enl.Other chronic disease",
           single_select_coded(
                   programEnrolment.observations ->> '1aac0eaf-1c9e-4284-93c3-7212c06a3286')::TEXT as "Enl.Does woman want to continue this pregnancy?",
           single_select_coded(
                   programEnrolment.observations ->> 'b5ebc472-0f32-4128-97f3-0e2571daeaae')::TEXT as "Enl.Send her to nearest antenatal clinic",
           (programEnrolment.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "Enl.Date of next ANC Visit",
           single_select_coded(
                   programEnrolment.observations ->> 'b6f45def-e3f4-4e7b-97ed-68c539b82fa2')::TEXT as "Enl.Send her to hospital for abortion",
           single_select_coded(
                   programEncounter.observations ->> 'b3e8a85a-c7ca-49b8-9c6f-8bd5ee6bfad1')::TEXT as "Enc.HIV (Elisa)",
           single_select_coded(
                   programEncounter.observations ->> 'f874c217-2fed-41c9-a094-ba6519bd537d')::TEXT as "Enc.Hepatitis B",
           single_select_coded(
                   programEncounter.observations ->> '198d08c6-b742-4b22-97fd-2293472e571e')::TEXT as "Enc.Hb Electrophoresis",
           single_select_coded(
                   programEncounter.observations ->> 'cbe884a3-c5f3-441e-900a-6bc76f3cabca')::TEXT as "Enc.VDRL",
           programEncounter.cancel_date_time                                                          "EncCancel.cancel_date_time",
           single_select_coded(
                   programEncounter.observations ->> 'bf400e7f-8e1b-4052-af49-b0db47b3eb5a')::TEXT as "EncCancel.Visit cancel reason",
           (programEncounter.observations ->> 'd038a9c4-fe96-4c09-b883-c80691427b60')::TEXT        as "EncCancel.Other reason for cancelling",
           (programEncounter.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "EncCancel.Date of next ANC Visit"
    FROM program_encounter programEncounter
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
           single_select_coded(
                   individual.observations ->> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b')::TEXT       as "Ind.Marital status",
           (individual.observations ->> '9d958124-09bb-466c-a4b4-db8d285def1f')::DATE              as "Ind.Date of marriage",
           single_select_coded(
                   individual.observations ->> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b')::TEXT       as "Ind.Education",
           single_select_coded(
                   individual.observations ->> '20ef261a-f110-4eaa-a592-2a1eeb0bf061')::TEXT       as "Ind.Occupation",
           (individual.observations ->> '4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT              as "Ind.Other occupation",
           single_select_coded(
                   individual.observations ->> 'bab107f6-fc0e-4be7-ab71-658a92d72f35')::TEXT       as "Ind.Whether any disability",
           multi_select_coded(
                   individual.observations -> '7061c675-c2ba-4016-886d-eeb432548378')::TEXT        as "Ind.Type of disability",
           single_select_coded(
                   individual.observations ->> 'd333f2a2-717e-478f-acbc-173bc7374d66')::TEXT       as "Ind.Status of the individual",
           (individual.observations ->> '681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT              as "Ind.Aadhaar ID",
           (individual.observations ->> '0a725832-b21c-4151-b017-7e6af770ba54')::TEXT              as "Ind.Contact Number",
           single_select_coded(
                   individual.observations ->> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b')::TEXT       as "Ind.Smart card (Insurance)",
           (programEnrolment.observations ->> 'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c')::TEXT        as "Enl.ANC Enrolment ID",
           single_select_coded(
                   programEnrolment.observations ->> '58d0a437-17ef-4d58-a36f-9a36b608f5a4')::TEXT as "Enl.Relation with village",
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
           single_select_coded(
                   programEnrolment.observations ->> '1952339b-14b0-447d-b6d7-6bcf18b4af62')::TEXT as "Enl.Last delivery place",
           single_select_coded(
                   programEnrolment.observations ->> '6c771640-52b6-46ea-bd56-0a2670ab7a6d')::TEXT as "Enl.Last delivery outcome",
           single_select_coded(
                   programEnrolment.observations ->> 'f776b045-2fcb-4275-b08e-e3e9039b699e')::TEXT as "Enl.Last delivery gender",
           single_select_coded(
                   programEnrolment.observations ->> '2f68ca5f-c690-4848-aa2e-592d6c7ef4e8')::TEXT as "Enl.Last delivery- Is baby alive?",
           single_select_coded(
                   programEnrolment.observations ->> '26cee30f-b36d-4be2-bec3-9a0904492e52')::TEXT as "Enl.Any High risk condition in previous pregnancy",
           multi_select_coded(
                   programEnrolment.observations -> 'a0aea5a9-7101-48ef-8463-5b376efa61bf')::TEXT  as "Enl.High risk condition in previous pregnancy",
           (programEnrolment.observations ->> '6bdfb87a-fefc-48ea-bcab-8bd05cbae73d')::TEXT        as "Enl.Other high risk condition in previous pregnancy",
           single_select_coded(
                   programEnrolment.observations ->> 'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2')::TEXT as "Enl.Taking medicine for chronic disease",
           multi_select_coded(
                   programEnrolment.observations -> '7d9b6992-ee27-4423-90a5-9ad20400d885')::TEXT  as "Enl.Name of chronic disease",
           (programEnrolment.observations ->> 'a54d0c2c-a054-45a5-a143-9f6c9db3fbbd')::TEXT        as "Enl.Other chronic disease",
           single_select_coded(
                   programEnrolment.observations ->> '1aac0eaf-1c9e-4284-93c3-7212c06a3286')::TEXT as "Enl.Does woman want to continue this pregnancy?",
           single_select_coded(
                   programEnrolment.observations ->> 'b5ebc472-0f32-4128-97f3-0e2571daeaae')::TEXT as "Enl.Send her to nearest antenatal clinic",
           (programEnrolment.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "Enl.Date of next ANC Visit",
           single_select_coded(
                   programEnrolment.observations ->> 'b6f45def-e3f4-4e7b-97ed-68c539b82fa2')::TEXT as "Enl.Send her to hospital for abortion",
           (programEncounter.observations ->> '23bcad9f-ec16-46ec-92f5-e144411e5dec')::TEXT        as "Enc.Height",
           (programEncounter.observations ->> '8d947379-7a1d-48b2-8760-88fff6add987')::TEXT        as "Enc.Weight",
           (programEncounter.observations ->> 'a205563d-0ac2-4955-93ac-e2e7adebb56e')::TEXT        as "Enc.BMI",
           (programEncounter.observations ->> '6874d48e-8c2f-4009-992c-1d3ca1678cc6')::TEXT        as "Enc.Blood Pressure (systolic)",
           (programEncounter.observations ->> 'da871f6c-cef0-4191-b307-6751b31ac9ec')::TEXT        as "Enc.Blood Pressure (Diastolic)",
           single_select_coded(
                   programEncounter.observations ->> 'b7be4ddc-14ee-4caf-ab38-e1c87d088688')::TEXT as "Enc.Is mosquito net given",
           single_select_coded(
                   programEncounter.observations ->> '04eecc2b-93eb-49d4-83a4-6629442711ea')::TEXT as "Enc.Is safe delivery kit given",
           multi_select_coded(
                   programEncounter.observations -> '74599453-6fbd-4f8d-bf7f-34faa3c10eb9')::TEXT  as "Enc.New complaint",
           (programEncounter.observations ->> 'dc0c10ca-c151-4c5c-aedc-2b8040dbea52')::TEXT        as "Enc.Other complaint",
           multi_select_coded(
                   programEncounter.observations -> '95dd3094-6c99-4622-8614-bf5d33a509e4')::TEXT  as "Enc.Oedema",
           multi_select_coded(
                   programEncounter.observations -> '2a15dc0b-d6a0-4670-b109-4013789cb403')::TEXT  as "Enc.Abdomen check",
           (programEncounter.observations ->> '9b087651-34e8-4391-aa08-8db73f55d7e6')::TEXT        as "Enc.Current gestational age",
           single_select_coded(
                   programEncounter.observations ->> 'f5ff8848-798a-4b0f-bcaf-33f2d4528f37')::TEXT as "Enc.Fundle Height",
           single_select_coded(
                   programEncounter.observations ->> '69a95145-505b-497a-9fc9-61fcc5d2ff59')::TEXT as "Enc.Position",
           single_select_coded(
                   programEncounter.observations ->> '7c6d3fc6-6a9f-4b44-beef-8c2200da5281')::TEXT as "Enc.FHS",
           (programEncounter.observations ->> '532ae011-4380-4ff5-b7c7-7d163e396221')::TEXT        as "Enc.FHS number",
           single_select_coded(
                   programEncounter.observations ->> '31651632-0acb-4ee5-a0f3-1628bbed456c')::TEXT as "Enc.Foetus movement",
           multi_select_coded(
                   programEncounter.observations -> '7259b0fa-c8d1-4e04-8d13-7dbc05f0169b')::TEXT  as "Enc.Breast examination",
           single_select_coded(
                   programEncounter.observations ->> 'c50c8196-01c9-422f-b917-fd2309adb261')::TEXT as "Enc.Blood group",
           single_select_coded(
                   programEncounter.observations ->> '610db330-fafe-456f-bd58-e062cb6e52e3')::TEXT as "Enc.Sickle prep",
           single_select_coded(
                   programEncounter.observations ->> '78fcebd3-17e5-4621-89be-c580fbf13168')::TEXT as "Enc.Urine Albumin",
           single_select_coded(
                   programEncounter.observations ->> '55ae9e7a-f6ff-4c0b-861c-fd29b6c5c646')::TEXT as "Enc.Urine sugar",
           (programEncounter.observations ->> 'a240115e-47a2-4244-8f74-d13d20f087df')::TEXT        as "Enc.Hb",
           single_select_coded(
                   programEncounter.observations ->> '9a89e9d6-f6e4-4d14-8841-34df9ece70a5')::TEXT as "Enc.Malaria parasite",
           (programEncounter.observations ->> 'd6ac43a2-527d-4168-ba7d-2d233add3a6e')::TEXT        as "Enc.Random Blood Sugar (RBS)",
           (programEncounter.observations ->> 'ae2046a4-015c-44e2-9703-01bc3da13202')::TEXT        as "Enc.Glucose test (75gm Glucose)",
           (programEncounter.observations ->> '0b8bc1f8-43db-4ecb-9677-22709e91681f')::TEXT        as "Enc.Pus Cell",
           (programEncounter.observations ->> 'b59c126f-975b-45e6-8dd6-584dd54e25c9')::TEXT        as "Enc.RBC",
           (programEncounter.observations ->> '0343e35f-afd0-41ce-af93-e69c184b159c')::TEXT        as "Enc.Epithelial cells",
           (programEncounter.observations ->> 'a2b6d675-4c70-4f15-a5ad-b8f5273602f9')::TEXT        as "Enc.Cast",
           single_select_coded(
                   programEncounter.observations ->> '14a023d3-bd25-4343-9d93-34d9f88eb4b3')::TEXT as "Enc.Crystel",
           single_select_coded(
                   programEncounter.observations ->> 'bf1e5598-594c-4444-94e0-9390f5081e41')::TEXT as "Enc.Whether Folic acid given",
           single_select_coded(
                   programEncounter.observations ->> '5740f87b-8cc6-4927-88a2-44636e8f396c')::TEXT as "Enc.Whether IFA given",
           single_select_coded(
                   programEncounter.observations ->> '00de9acc-4ff6-485b-b979-41ff00745d23')::TEXT as "Enc.Whether Calcium given",
           single_select_coded(
                   programEncounter.observations ->> '2a5a3b4d-80c4-4d05-8585-e16966ff0c3e')::TEXT as "Enc.Whether Amala given",
           single_select_coded(
                   programEncounter.observations ->> 'ddeb2311-4a90-4a7c-a698-1cd3db4ff0f3')::TEXT as "Enc.TT 1",
           single_select_coded(
                   programEncounter.observations ->> '858f66e6-1ed3-4c13-9fdf-08f667b092ba')::TEXT as "Enc.TT 2",
           (programEncounter.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "Enc.Date of next ANC Visit",
           single_select_coded(
                   programEncounter.observations ->> '77d122e8-0620-4754-8375-b0cbe329003c')::TEXT as "Enc.Does woman require referral?",
           single_select_coded(
                   programEncounter.observations ->> '80fccb06-a62f-43e8-92eb-358bdb600079')::TEXT as "Enc.Place of referral",
           (programEncounter.observations ->> 'd169efa9-49af-4c84-ae09-b1b7296c62da')::TEXT        as "Enc.Other place of referral",
           multi_select_coded(
                   programEncounter.observations -> '8a56f008-a910-4d6f-b028-a95db330dbf2')::TEXT  as "Enc.Referral reason",
           (programEncounter.observations ->> 'e048675e-eb86-41c2-a47b-aecfa9a3bb8c')::TEXT        as "Enc.Other referral reason",
           programEncounter.cancel_date_time                                                          "EncCancel.cancel_date_time",
           single_select_coded(
                   programEncounter.observations ->> 'bf400e7f-8e1b-4052-af49-b0db47b3eb5a')::TEXT as "EncCancel.Visit cancel reason",
           (programEncounter.observations ->> 'd038a9c4-fe96-4c09-b883-c80691427b60')::TEXT        as "EncCancel.Other reason for cancelling",
           (programEncounter.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "EncCancel.Date of next ANC Visit"
    FROM program_encounter programEncounter
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
           single_select_coded(
                   individual.observations ->> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b')::TEXT       as "Ind.Marital status",
           (individual.observations ->> '9d958124-09bb-466c-a4b4-db8d285def1f')::DATE              as "Ind.Date of marriage",
           single_select_coded(
                   individual.observations ->> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b')::TEXT       as "Ind.Education",
           single_select_coded(
                   individual.observations ->> '20ef261a-f110-4eaa-a592-2a1eeb0bf061')::TEXT       as "Ind.Occupation",
           (individual.observations ->> '4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT              as "Ind.Other occupation",
           single_select_coded(
                   individual.observations ->> 'bab107f6-fc0e-4be7-ab71-658a92d72f35')::TEXT       as "Ind.Whether any disability",
           multi_select_coded(
                   individual.observations -> '7061c675-c2ba-4016-886d-eeb432548378')::TEXT        as "Ind.Type of disability",
           single_select_coded(
                   individual.observations ->> 'd333f2a2-717e-478f-acbc-173bc7374d66')::TEXT       as "Ind.Status of the individual",
           (individual.observations ->> '681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT              as "Ind.Aadhaar ID",
           (individual.observations ->> '0a725832-b21c-4151-b017-7e6af770ba54')::TEXT              as "Ind.Contact Number",
           single_select_coded(
                   individual.observations ->> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b')::TEXT       as "Ind.Smart card (Insurance)",
           (programEnrolment.observations ->> 'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c')::TEXT        as "Enl.ANC Enrolment ID",
           single_select_coded(
                   programEnrolment.observations ->> '58d0a437-17ef-4d58-a36f-9a36b608f5a4')::TEXT as "Enl.Relation with village",
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
           single_select_coded(
                   programEnrolment.observations ->> '1952339b-14b0-447d-b6d7-6bcf18b4af62')::TEXT as "Enl.Last delivery place",
           single_select_coded(
                   programEnrolment.observations ->> '6c771640-52b6-46ea-bd56-0a2670ab7a6d')::TEXT as "Enl.Last delivery outcome",
           single_select_coded(
                   programEnrolment.observations ->> 'f776b045-2fcb-4275-b08e-e3e9039b699e')::TEXT as "Enl.Last delivery gender",
           single_select_coded(
                   programEnrolment.observations ->> '2f68ca5f-c690-4848-aa2e-592d6c7ef4e8')::TEXT as "Enl.Last delivery- Is baby alive?",
           single_select_coded(
                   programEnrolment.observations ->> '26cee30f-b36d-4be2-bec3-9a0904492e52')::TEXT as "Enl.Any High risk condition in previous pregnancy",
           multi_select_coded(
                   programEnrolment.observations -> 'a0aea5a9-7101-48ef-8463-5b376efa61bf')::TEXT  as "Enl.High risk condition in previous pregnancy",
           (programEnrolment.observations ->> '6bdfb87a-fefc-48ea-bcab-8bd05cbae73d')::TEXT        as "Enl.Other high risk condition in previous pregnancy",
           single_select_coded(
                   programEnrolment.observations ->> 'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2')::TEXT as "Enl.Taking medicine for chronic disease",
           multi_select_coded(
                   programEnrolment.observations -> '7d9b6992-ee27-4423-90a5-9ad20400d885')::TEXT  as "Enl.Name of chronic disease",
           (programEnrolment.observations ->> 'a54d0c2c-a054-45a5-a143-9f6c9db3fbbd')::TEXT        as "Enl.Other chronic disease",
           single_select_coded(
                   programEnrolment.observations ->> '1aac0eaf-1c9e-4284-93c3-7212c06a3286')::TEXT as "Enl.Does woman want to continue this pregnancy?",
           single_select_coded(
                   programEnrolment.observations ->> 'b5ebc472-0f32-4128-97f3-0e2571daeaae')::TEXT as "Enl.Send her to nearest antenatal clinic",
           (programEnrolment.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "Enl.Date of next ANC Visit",
           single_select_coded(
                   programEnrolment.observations ->> 'b6f45def-e3f4-4e7b-97ed-68c539b82fa2')::TEXT as "Enl.Send her to hospital for abortion",
           (programEncounter.observations ->> 'eb771b86-8c5b-461f-a9f4-4a4815ebeeb3')::TEXT        as "Enc.FBS",
           (programEncounter.observations ->> '04806ab3-426b-4909-b2c0-65b590f8250c')::TEXT        as "Enc.PP2BS",
           (programEncounter.observations ->> 'f11d4eca-f6ca-4471-9a6b-e1f5d742bc22')::TEXT        as "Enc.HbA1C",
           programEncounter.cancel_date_time                                                          "EncCancel.cancel_date_time"
    FROM program_encounter programEncounter
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
           single_select_coded(
                   individual.observations ->> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b')::TEXT       as "Ind.Marital status",
           (individual.observations ->> '9d958124-09bb-466c-a4b4-db8d285def1f')::DATE              as "Ind.Date of marriage",
           single_select_coded(
                   individual.observations ->> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b')::TEXT       as "Ind.Education",
           single_select_coded(
                   individual.observations ->> '20ef261a-f110-4eaa-a592-2a1eeb0bf061')::TEXT       as "Ind.Occupation",
           (individual.observations ->> '4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT              as "Ind.Other occupation",
           single_select_coded(
                   individual.observations ->> 'bab107f6-fc0e-4be7-ab71-658a92d72f35')::TEXT       as "Ind.Whether any disability",
           multi_select_coded(
                   individual.observations -> '7061c675-c2ba-4016-886d-eeb432548378')::TEXT        as "Ind.Type of disability",
           single_select_coded(
                   individual.observations ->> 'd333f2a2-717e-478f-acbc-173bc7374d66')::TEXT       as "Ind.Status of the individual",
           (individual.observations ->> '681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT              as "Ind.Aadhaar ID",
           (individual.observations ->> '0a725832-b21c-4151-b017-7e6af770ba54')::TEXT              as "Ind.Contact Number",
           single_select_coded(
                   individual.observations ->> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b')::TEXT       as "Ind.Smart card (Insurance)",
           (programEnrolment.observations ->> 'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c')::TEXT        as "Enl.ANC Enrolment ID",
           single_select_coded(
                   programEnrolment.observations ->> '58d0a437-17ef-4d58-a36f-9a36b608f5a4')::TEXT as "Enl.Relation with village",
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
           single_select_coded(
                   programEnrolment.observations ->> '1952339b-14b0-447d-b6d7-6bcf18b4af62')::TEXT as "Enl.Last delivery place",
           single_select_coded(
                   programEnrolment.observations ->> '6c771640-52b6-46ea-bd56-0a2670ab7a6d')::TEXT as "Enl.Last delivery outcome",
           single_select_coded(
                   programEnrolment.observations ->> 'f776b045-2fcb-4275-b08e-e3e9039b699e')::TEXT as "Enl.Last delivery gender",
           single_select_coded(
                   programEnrolment.observations ->> '2f68ca5f-c690-4848-aa2e-592d6c7ef4e8')::TEXT as "Enl.Last delivery- Is baby alive?",
           single_select_coded(
                   programEnrolment.observations ->> '26cee30f-b36d-4be2-bec3-9a0904492e52')::TEXT as "Enl.Any High risk condition in previous pregnancy",
           multi_select_coded(
                   programEnrolment.observations -> 'a0aea5a9-7101-48ef-8463-5b376efa61bf')::TEXT  as "Enl.High risk condition in previous pregnancy",
           (programEnrolment.observations ->> '6bdfb87a-fefc-48ea-bcab-8bd05cbae73d')::TEXT        as "Enl.Other high risk condition in previous pregnancy",
           single_select_coded(
                   programEnrolment.observations ->> 'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2')::TEXT as "Enl.Taking medicine for chronic disease",
           multi_select_coded(
                   programEnrolment.observations -> '7d9b6992-ee27-4423-90a5-9ad20400d885')::TEXT  as "Enl.Name of chronic disease",
           (programEnrolment.observations ->> 'a54d0c2c-a054-45a5-a143-9f6c9db3fbbd')::TEXT        as "Enl.Other chronic disease",
           single_select_coded(
                   programEnrolment.observations ->> '1aac0eaf-1c9e-4284-93c3-7212c06a3286')::TEXT as "Enl.Does woman want to continue this pregnancy?",
           single_select_coded(
                   programEnrolment.observations ->> 'b5ebc472-0f32-4128-97f3-0e2571daeaae')::TEXT as "Enl.Send her to nearest antenatal clinic",
           (programEnrolment.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "Enl.Date of next ANC Visit",
           single_select_coded(
                   programEnrolment.observations ->> 'b6f45def-e3f4-4e7b-97ed-68c539b82fa2')::TEXT as "Enl.Send her to hospital for abortion",
           (programEncounter.observations ->> '3584ab7c-061d-472f-996e-8082bc7ee5b4')::timestamp        as "Enc.Date and time of labour pain started",
           (programEncounter.observations ->> '75f66882-8186-4a8c-b1f3-1f6b2386fef6')::timestamp        as "Enc.Date and time when baby was out",
           (programEncounter.observations ->> '0bcf8d88-f9c5-4e9a-89bb-10f31cfff0a3')::TEXT        as "Enc.Gestational age category",
           single_select_coded(
                   programEncounter.observations ->> 'dea1a2d3-2583-4a77-8723-e64d9e10079e')::TEXT as "Enc.Place of delivery",
           (programEncounter.observations ->> 'ebdc6d6b-4510-4659-b595-a090186d1832')::TEXT        as "Enc.Other place of delivery",
           single_select_coded(
                   programEncounter.observations ->> 'c48b5ece-3daf-4f19-9754-11bd898020fc')::TEXT as "Enc.Type of delivery",
           single_select_coded(
                   programEncounter.observations ->> '11bfa900-973e-49ff-bc2b-cab409d6e938')::TEXT as "Enc.Delivery conducted by",
           (programEncounter.observations ->> '03ae48d3-6d4e-4e39-8194-cb2653c0eaf7')::TEXT        as "Enc.Other who conducted delivery",
           (programEncounter.observations ->> '99ab36e9-ca7f-4627-b0a4-2ca5bef6c4ad')::TEXT        as "Enc.Name of person who conducted delivery",
           (programEncounter.observations ->> '0c0158a5-f13d-4eed-8c9c-56f5a5b37817')::TEXT        as "Enc.Name of village where woman delivered",
           multi_select_coded(
                   programEncounter.observations -> 'c45fa5f8-098d-49af-8119-6a5c55012e1b')::TEXT  as "Enc.Danger signs during the process of labour",
           single_select_coded(
                   programEncounter.observations ->> '68891675-51d5-4a64-9cd6-e19ca54f2c1f')::TEXT as "Enc.Part of foetus that came first",
           single_select_coded(
                   programEncounter.observations ->> '51477c5d-3d96-4b5b-abe0-9350fdcdbd83')::TEXT as "Enc.Colour of amniotic fluid",
           (programEncounter.observations ->> 'ac9f7563-ad2b-4df2-aa1f-6df3a9c50c21')::TEXT        as "Enc.Other colour of amniotic fluid",
           single_select_coded(
                   programEncounter.observations ->> '8a2fa4f0-e202-47a7-ba55-31e8b1649818')::TEXT as "Enc.Was mother given tab. Misoprostol (3 tabs)/ Inj. Oxytocin (on thigh) within 1 minute after the birth?",
           single_select_coded(
                   programEncounter.observations ->> '0291dab0-0e30-485c-b8b2-16570e3ef7bd')::TEXT as "Enc.Was placenta delivered by pulling",
           single_select_coded(
                   programEncounter.observations ->> '8a096d3f-a966-4930-b137-619fd13183d2')::TEXT as "Enc.Was mother given anything to drink?",
           single_select_coded(
                   programEncounter.observations ->> '16c71db0-bdaa-42d0-b247-e9d573f62866')::TEXT as "Enc.Did mother breastfed the baby within 1 hour after the birth",
           single_select_coded(
                   programEncounter.observations ->> 'e693e145-db22-4dca-a5a8-f6f455a52248')::TEXT as "Enc.Was safe delivery kit used for conducting delivery",
           single_select_coded(
                   programEncounter.observations ->> '22ec084c-7141-4828-99c7-2dc56fe11153')::TEXT as "Enc.Did woman receive vitamin A",
           single_select_coded(
                   programEncounter.observations ->> 'd5f2dd94-46c0-4397-88bf-92db83e381d1')::TEXT as "Enc.Were stitches taken for episiotomy",
           programEncounter.cancel_date_time                                                          "EncCancel.cancel_date_time",
           single_select_coded(
                   programEncounter.observations ->> 'bf400e7f-8e1b-4052-af49-b0db47b3eb5a')::TEXT as "EncCancel.Visit cancel reason",
           (programEncounter.observations ->> 'd038a9c4-fe96-4c09-b883-c80691427b60')::TEXT        as "EncCancel.Other reason for cancelling",
           (programEncounter.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "EncCancel.Date of next ANC Visit"
    FROM program_encounter programEncounter
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
           single_select_coded(
                   individual.observations ->> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b')::TEXT       as "Ind.Marital status",
           (individual.observations ->> '9d958124-09bb-466c-a4b4-db8d285def1f')::DATE              as "Ind.Date of marriage",
           single_select_coded(
                   individual.observations ->> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b')::TEXT       as "Ind.Education",
           single_select_coded(
                   individual.observations ->> '20ef261a-f110-4eaa-a592-2a1eeb0bf061')::TEXT       as "Ind.Occupation",
           (individual.observations ->> '4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT              as "Ind.Other occupation",
           single_select_coded(
                   individual.observations ->> 'bab107f6-fc0e-4be7-ab71-658a92d72f35')::TEXT       as "Ind.Whether any disability",
           multi_select_coded(
                   individual.observations -> '7061c675-c2ba-4016-886d-eeb432548378')::TEXT        as "Ind.Type of disability",
           single_select_coded(
                   individual.observations ->> 'd333f2a2-717e-478f-acbc-173bc7374d66')::TEXT       as "Ind.Status of the individual",
           (individual.observations ->> '681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT              as "Ind.Aadhaar ID",
           (individual.observations ->> '0a725832-b21c-4151-b017-7e6af770ba54')::TEXT              as "Ind.Contact Number",
           single_select_coded(
                   individual.observations ->> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b')::TEXT       as "Ind.Smart card (Insurance)",
           (programEnrolment.observations ->> 'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c')::TEXT        as "Enl.ANC Enrolment ID",
           single_select_coded(
                   programEnrolment.observations ->> '58d0a437-17ef-4d58-a36f-9a36b608f5a4')::TEXT as "Enl.Relation with village",
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
           single_select_coded(
                   programEnrolment.observations ->> '1952339b-14b0-447d-b6d7-6bcf18b4af62')::TEXT as "Enl.Last delivery place",
           single_select_coded(
                   programEnrolment.observations ->> '6c771640-52b6-46ea-bd56-0a2670ab7a6d')::TEXT as "Enl.Last delivery outcome",
           single_select_coded(
                   programEnrolment.observations ->> 'f776b045-2fcb-4275-b08e-e3e9039b699e')::TEXT as "Enl.Last delivery gender",
           single_select_coded(
                   programEnrolment.observations ->> '2f68ca5f-c690-4848-aa2e-592d6c7ef4e8')::TEXT as "Enl.Last delivery- Is baby alive?",
           single_select_coded(
                   programEnrolment.observations ->> '26cee30f-b36d-4be2-bec3-9a0904492e52')::TEXT as "Enl.Any High risk condition in previous pregnancy",
           multi_select_coded(
                   programEnrolment.observations -> 'a0aea5a9-7101-48ef-8463-5b376efa61bf')::TEXT  as "Enl.High risk condition in previous pregnancy",
           (programEnrolment.observations ->> '6bdfb87a-fefc-48ea-bcab-8bd05cbae73d')::TEXT        as "Enl.Other high risk condition in previous pregnancy",
           single_select_coded(
                   programEnrolment.observations ->> 'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2')::TEXT as "Enl.Taking medicine for chronic disease",
           multi_select_coded(
                   programEnrolment.observations -> '7d9b6992-ee27-4423-90a5-9ad20400d885')::TEXT  as "Enl.Name of chronic disease",
           (programEnrolment.observations ->> 'a54d0c2c-a054-45a5-a143-9f6c9db3fbbd')::TEXT        as "Enl.Other chronic disease",
           single_select_coded(
                   programEnrolment.observations ->> '1aac0eaf-1c9e-4284-93c3-7212c06a3286')::TEXT as "Enl.Does woman want to continue this pregnancy?",
           single_select_coded(
                   programEnrolment.observations ->> 'b5ebc472-0f32-4128-97f3-0e2571daeaae')::TEXT as "Enl.Send her to nearest antenatal clinic",
           (programEnrolment.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "Enl.Date of next ANC Visit",
           single_select_coded(
                   programEnrolment.observations ->> 'b6f45def-e3f4-4e7b-97ed-68c539b82fa2')::TEXT as "Enl.Send her to hospital for abortion",
           (programEncounter.observations ->> '6cff2f40-fd04-48e1-89d8-497142e20d4d')::DATE        as "Enc.Date and time of abortion",
           single_select_coded(
                   programEncounter.observations ->> 'cb23a7f2-8746-402d-88b7-013a70e01e2b')::TEXT as "Enc.Type of abortion",
           single_select_coded(
                   programEncounter.observations ->> '16e2956e-1265-4e2c-b4ef-eb7568b5c69d')::TEXT as "Enc.Place of Abortion",
           (programEncounter.observations ->> '26d8c447-3c27-4a42-a47a-8b4a2b1946e9')::TEXT        as "Enc.Specify other place of abortion",
           single_select_coded(
                   programEncounter.observations ->> '68740322-f381-4de6-9e06-ad9f93e81f93')::TEXT as "Enc.Abortion done by",
           (programEncounter.observations ->> 'd346b862-6d69-4b1e-b6dc-2cee6036d066')::TEXT        as "Enc.Specify the who other did the abortion",
           single_select_coded(
                   programEncounter.observations ->> 'e1dab606-f18e-4007-940a-5df6f48af91a')::TEXT as "Enc.If self medication, where did woman get the medicine from",
           (programEncounter.observations ->> 'ad707cd2-4ddd-4d5e-89ba-6a9eea4e792d')::TEXT        as "Enc.Other place from where woman got the medicine",
           multi_select_coded(
                   programEncounter.observations -> '3fc12cff-0b61-45f5-af60-93b0f19570da')::TEXT  as "Enc.Complication due to abortion",
           (programEncounter.observations ->> '39633d82-8da1-458e-a759-1d558d3a3a92')::TEXT        as "Enc.Other complication faced due to abortion",
           (programEncounter.observations ->> 'aba42644-f860-4c73-aa0e-8b22c563cbb0')::TEXT        as "Enc.Name of village where woman got abortion done",
           single_select_coded(
                   programEncounter.observations ->> '77d122e8-0620-4754-8375-b0cbe329003c')::TEXT as "Enc.Does woman require referral?",
           single_select_coded(
                   programEncounter.observations ->> '80fccb06-a62f-43e8-92eb-358bdb600079')::TEXT as "Enc.Place of referral",
           (programEncounter.observations ->> 'd169efa9-49af-4c84-ae09-b1b7296c62da')::TEXT        as "Enc.Other place of referral",
           single_select_coded(
                   programEncounter.observations ->> '8a56f008-a910-4d6f-b028-a95db330dbf2')::TEXT as "Enc.Referral reason",
           (programEncounter.observations ->> 'e048675e-eb86-41c2-a47b-aecfa9a3bb8c')::TEXT        as "Enc.Other referral reason",
           programEncounter.cancel_date_time                                                          "EncCancel.cancel_date_time",
           single_select_coded(
                   programEncounter.observations ->> 'bf400e7f-8e1b-4052-af49-b0db47b3eb5a')::TEXT as "EncCancel.Visit cancel reason",
           (programEncounter.observations ->> 'd038a9c4-fe96-4c09-b883-c80691427b60')::TEXT        as "EncCancel.Other reason for cancelling",
           (programEncounter.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "EncCancel.Date of next ANC Visit"
    FROM program_encounter programEncounter
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
           single_select_coded(
                   individual.observations ->> 'bf564151-63f9-4176-917f-f37de34b9bae')::TEXT       as "Ind.Father's Occupation",
           single_select_coded(
                   individual.observations ->> 'b1001c4d-0449-464a-947f-a04c4fdcc651')::TEXT       as "Ind.Father's education Level",
           (individual.observations ->> '74a554d8-5b87-4d27-9ae5-272ab326608f')::TEXT              as "Ind.Mother's Name",
           single_select_coded(
                   individual.observations ->> 'ea760e4f-c12f-490b-9865-9c6e4510ce64')::TEXT       as "Ind.Mother's Occupation",
           single_select_coded(
                   individual.observations ->> 'd98aae1a-ce33-4e51-b031-66e13bc0ba11')::TEXT       as "Ind.Mother's education Level",
           single_select_coded(
                   individual.observations ->> 'b2c60cb8-983c-4e0e-a90d-4b21e87e10bd')::TEXT       as "Ind.Religion",
           single_select_coded(
                   individual.observations ->> '9ad4b520-4e33-4b1b-a056-37ae6418988f')::TEXT       as "Ind.Caste Category",
           single_select_coded(
                   individual.observations ->> '047877ac-dba7-4acf-8c77-97c979c2fc26')::TEXT       as "Ind.Sub Caste",
           (individual.observations ->> 'ae7d54e9-fac0-4898-b334-87664bd055d2')::TEXT              as "Ind.Other sub caste",
           single_select_coded(
                   individual.observations ->> 'eaee156e-8ef3-4148-a80c-a466cd059ae3')::TEXT       as "Ind.Relation to head of the household",
           single_select_coded(
                   individual.observations ->> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b')::TEXT       as "Ind.Marital status",
           (individual.observations ->> '9d958124-09bb-466c-a4b4-db8d285def1f')::DATE              as "Ind.Date of marriage",
           single_select_coded(
                   individual.observations ->> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b')::TEXT       as "Ind.Education",
           single_select_coded(
                   individual.observations ->> '20ef261a-f110-4eaa-a592-2a1eeb0bf061')::TEXT       as "Ind.Occupation",
           single_select_coded(
                   individual.observations ->> '852f4e54-4969-4724-94e0-cddef0ac1f66')::TEXT       as "Ind.Is sterlization operation done?",
           single_select_coded(
                   individual.observations ->> 'bab107f6-fc0e-4be7-ab71-658a92d72f35')::TEXT       as "Ind.Whether any disability",
           (individual.observations ->> 'eda07a4c-14c9-49af-b1d6-deaa695a5d36')::TEXT              as "Ind.Disability",
           single_select_coded(
                   individual.observations ->> 'd333f2a2-717e-478f-acbc-173bc7374d66')::TEXT       as "Ind.Status of the individual",
           (individual.observations ->> '681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT              as "Ind.Aadhaar ID",
           (individual.observations ->> '0a725832-b21c-4151-b017-7e6af770ba54')::TEXT              as "Ind.Contact Number",
           single_select_coded(
                   individual.observations ->> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b')::TEXT       as "Ind.Smart card (Insurance)",
           single_select_coded(
                   individual.observations ->> 'e23ef639-5d54-46bc-811c-ee1886bce81f')::TEXT       as "Ind.Electricity in house",
           single_select_coded(
                   individual.observations ->> 'b984ad33-05d8-4621-adf3-152e72a0db1b')::TEXT       as "Ind.Land possession",
           (individual.observations ->> '430ebb19-831d-470d-80eb-7969814f13e4')::TEXT              as "Ind.Land Area",
           single_select_coded(
                   individual.observations ->> 'c5d2673b-0f5c-48bf-93e4-f1a1ae820732')::TEXT       as "Ind.Type of residence",
           single_select_coded(
                   individual.observations ->> '86fc3018-8eeb-4a58-a9d9-a40fff839305')::TEXT       as "Ind.Ration Card",
           multi_select_coded(
                   individual.observations -> 'aa88dba4-4f5d-4d35-9dc1-2390969cc5f3')::TEXT        as "Ind.Property",
           (individual.observations ->> '32609e0f-f3c8-4dcb-af7c-5e8a96e8e89d')::TEXT              as "Ind.Other property",
           single_select_coded(
                   programEnrolment.observations ->> '58d0a437-17ef-4d58-a36f-9a36b608f5a4')::TEXT as "Enl.Relation with village",
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
           single_select_coded(
                   programEnrolment.observations ->> '1952339b-14b0-447d-b6d7-6bcf18b4af62')::TEXT as "Enl.Last delivery place",
           single_select_coded(
                   programEnrolment.observations ->> '6c771640-52b6-46ea-bd56-0a2670ab7a6d')::TEXT as "Enl.Last delivery outcome",
           single_select_coded(
                   programEnrolment.observations ->> 'f776b045-2fcb-4275-b08e-e3e9039b699e')::TEXT as "Enl.Last delivery gender",
           single_select_coded(
                   programEnrolment.observations ->> '2f68ca5f-c690-4848-aa2e-592d6c7ef4e8')::TEXT as "Enl.Last delivery- Is baby alive?",
           single_select_coded(
                   programEnrolment.observations ->> '26cee30f-b36d-4be2-bec3-9a0904492e52')::TEXT as "Enl.Any High risk condition in previous pregnancy",
           multi_select_coded(
                   programEnrolment.observations -> 'a0aea5a9-7101-48ef-8463-5b376efa61bf')::TEXT  as "Enl.High risk condition in previous pregnancy",
           single_select_coded(
                   programEnrolment.observations ->> 'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2')::TEXT as "Enl.Taking medicine for chronic disease",
           multi_select_coded(
                   programEnrolment.observations -> '7d9b6992-ee27-4423-90a5-9ad20400d885')::TEXT  as "Enl.Name of chronic disease",
           single_select_coded(
                   programEnrolment.observations ->> '1aac0eaf-1c9e-4284-93c3-7212c06a3286')::TEXT as "Enl.Does woman want to continue this pregnancy?",
           single_select_coded(
                   programEnrolment.observations ->> 'b5ebc472-0f32-4128-97f3-0e2571daeaae')::TEXT as "Enl.Send her to hospital for ANC",
           single_select_coded(
                   programEnrolment.observations ->> 'b6f45def-e3f4-4e7b-97ed-68c539b82fa2')::TEXT as "Enl.Send to Hospital for abortion",
           (programEncounter.observations ->> '23bcad9f-ec16-46ec-92f5-e144411e5dec')::TEXT        as "Enc.Height",
           (programEncounter.observations ->> '8d947379-7a1d-48b2-8760-88fff6add987')::TEXT        as "Enc.Weight",
           (programEncounter.observations ->> 'a205563d-0ac2-4955-93ac-e2e7adebb56e')::TEXT        as "Enc.BMI",
           (programEncounter.observations ->> '6874d48e-8c2f-4009-992c-1d3ca1678cc6')::TEXT        as "Enc.Blood Pressure (systolic)",
           (programEncounter.observations ->> 'da871f6c-cef0-4191-b307-6751b31ac9ec')::TEXT        as "Enc.Blood Pressure (Diastolic)",
           single_select_coded(
                   programEncounter.observations ->> 'b7be4ddc-14ee-4caf-ab38-e1c87d088688')::TEXT as "Enc.Is mosquito net given",
           single_select_coded(
                   programEncounter.observations ->> '04eecc2b-93eb-49d4-83a4-6629442711ea')::TEXT as "Enc.Is safe delivery kit given",
           multi_select_coded(
                   programEncounter.observations -> '74599453-6fbd-4f8d-bf7f-34faa3c10eb9')::TEXT  as "Enc.New complaint",
           (programEncounter.observations ->> 'dc0c10ca-c151-4c5c-aedc-2b8040dbea52')::TEXT        as "Enc.Other complaint",
           multi_select_coded(
                   programEncounter.observations -> '95dd3094-6c99-4622-8614-bf5d33a509e4')::TEXT  as "Enc.Oedema",
           single_select_coded(
                   programEncounter.observations ->> '31651632-0acb-4ee5-a0f3-1628bbed456c')::TEXT as "Enc.Foetus movement",
           multi_select_coded(
                   programEncounter.observations -> '7259b0fa-c8d1-4e04-8d13-7dbc05f0169b')::TEXT  as "Enc.Breast examination",
           single_select_coded(
                   programEncounter.observations ->> '78fcebd3-17e5-4621-89be-c580fbf13168')::TEXT as "Enc.Urine Albumin",
           single_select_coded(
                   programEncounter.observations ->> '55ae9e7a-f6ff-4c0b-861c-fd29b6c5c646')::TEXT as "Enc.Urine sugar",
           single_select_coded(
                   programEncounter.observations ->> 'bf1e5598-594c-4444-94e0-9390f5081e41')::TEXT as "Enc.Whether Folic acid given",
           single_select_coded(
                   programEncounter.observations ->> '5740f87b-8cc6-4927-88a2-44636e8f396c')::TEXT as "Enc.Whether IFA given",
           single_select_coded(
                   programEncounter.observations ->> '00de9acc-4ff6-485b-b979-41ff00745d23')::TEXT as "Enc.Whether Calcium given",
           single_select_coded(
                   programEncounter.observations ->> '2a5a3b4d-80c4-4d05-8585-e16966ff0c3e')::TEXT as "Enc.Whether Amala given",
           single_select_coded(
                   programEncounter.observations ->> '77d122e8-0620-4754-8375-b0cbe329003c')::TEXT as "Enc.Does woman require referral?",
           single_select_coded(
                   programEncounter.observations ->> '80fccb06-a62f-43e8-92eb-358bdb600079')::TEXT as "Enc.Place of referral",
           (programEncounter.observations ->> 'd169efa9-49af-4c84-ae09-b1b7296c62da')::TEXT        as "Enc.Other place of referral",
           multi_select_coded(
                   programEncounter.observations -> '8a56f008-a910-4d6f-b028-a95db330dbf2')::TEXT  as "Enc.Referral reason",
           (programEncounter.observations ->> 'e048675e-eb86-41c2-a47b-aecfa9a3bb8c')::TEXT        as "Enc.Other referral reason",
           (programEncounter.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "Enc.Date of next ANC Visit",
           programEncounter.cancel_date_time                                                          "EncCancel.cancel_date_time",
           single_select_coded(
                   programEncounter.observations ->> 'bf400e7f-8e1b-4052-af49-b0db47b3eb5a')::TEXT as "EncCancel.Visit cancel reason",
           (programEncounter.observations ->> 'd038a9c4-fe96-4c09-b883-c80691427b60')::TEXT        as "EncCancel.Other reason for cancelling",
           (programEncounter.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "EncCancel.Date of next ANC Visit"
    FROM program_encounter programEncounter
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
         single_select_coded(individual.observations->>'9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b')::TEXT as "Ind.Marital status",
         (individual.observations->>'9d958124-09bb-466c-a4b4-db8d285def1f')::DATE as "Ind.Date of marriage",
         single_select_coded(individual.observations->>'673d65bd-6dc4-4aac-8e1e-1ee355ac081b')::TEXT as "Ind.Education",
         single_select_coded(individual.observations->>'20ef261a-f110-4eaa-a592-2a1eeb0bf061')::TEXT as "Ind.Occupation",
         (individual.observations->>'4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT as "Ind.Other occupation",
         single_select_coded(individual.observations->>'bab107f6-fc0e-4be7-ab71-658a92d72f35')::TEXT as "Ind.Whether any disability",
         multi_select_coded(individual.observations->'7061c675-c2ba-4016-886d-eeb432548378')::TEXT as "Ind.Type of disability",
         single_select_coded(individual.observations->>'d333f2a2-717e-478f-acbc-173bc7374d66')::TEXT as "Ind.Status of the individual",
         (individual.observations->>'681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT as "Ind.Aadhaar ID",
         (individual.observations->>'0a725832-b21c-4151-b017-7e6af770ba54')::TEXT as "Ind.Contact Number",
         single_select_coded(individual.observations->>'2a445ac8-56e7-4eda-8756-0a9c4fa9a77b')::TEXT as "Ind.Smart card (Insurance)",
         (programEnrolment.observations->>'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c')::TEXT as "Enl.ANC Enrolment ID",
         single_select_coded(programEnrolment.observations->>'58d0a437-17ef-4d58-a36f-9a36b608f5a4')::TEXT as "Enl.Relation with village",
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
         single_select_coded(programEnrolment.observations->>'1952339b-14b0-447d-b6d7-6bcf18b4af62')::TEXT as "Enl.Last delivery place",
         single_select_coded(programEnrolment.observations->>'6c771640-52b6-46ea-bd56-0a2670ab7a6d')::TEXT as "Enl.Last delivery outcome",
         single_select_coded(programEnrolment.observations->>'f776b045-2fcb-4275-b08e-e3e9039b699e')::TEXT as "Enl.Last delivery gender",
         single_select_coded(programEnrolment.observations->>'2f68ca5f-c690-4848-aa2e-592d6c7ef4e8')::TEXT as "Enl.Last delivery- Is baby alive?",
         single_select_coded(programEnrolment.observations->>'26cee30f-b36d-4be2-bec3-9a0904492e52')::TEXT as "Enl.Any High risk condition in previous pregnancy",
         multi_select_coded(programEnrolment.observations->'a0aea5a9-7101-48ef-8463-5b376efa61bf')::TEXT as "Enl.High risk condition in previous pregnancy",
         (programEnrolment.observations->>'6bdfb87a-fefc-48ea-bcab-8bd05cbae73d')::TEXT as "Enl.Other high risk condition in previous pregnancy",
         single_select_coded(programEnrolment.observations->>'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2')::TEXT as "Enl.Taking medicine for chronic disease",
         multi_select_coded(programEnrolment.observations->'7d9b6992-ee27-4423-90a5-9ad20400d885')::TEXT as "Enl.Name of chronic disease",
         (programEnrolment.observations->>'a54d0c2c-a054-45a5-a143-9f6c9db3fbbd')::TEXT as "Enl.Other chronic disease",
         single_select_coded(programEnrolment.observations->>'1aac0eaf-1c9e-4284-93c3-7212c06a3286')::TEXT as "Enl.Does woman want to continue this pregnancy?",
         single_select_coded(programEnrolment.observations->>'b5ebc472-0f32-4128-97f3-0e2571daeaae')::TEXT as "Enl.Send her to nearest antenatal clinic",
         (programEnrolment.observations->>'6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE as "Enl.Date of next ANC Visit",
         single_select_coded(programEnrolment.observations->>'b6f45def-e3f4-4e7b-97ed-68c539b82fa2')::TEXT as "Enl.Send her to hospital for abortion",
         multi_select_coded(programEncounter.observations->'11244ced-b169-493d-a160-2dda1e1db195')::TEXT as "Enc.Mother suffering from",
         (programEncounter.observations->>'70fa7289-d90e-4c07-a4db-3382cce4daf5')::TEXT as "Enc.Other problem mother is suffering from",
         multi_select_coded(programEncounter.observations->'9a31b9a0-18bf-4b3b-87cf-fad47128596b')::TEXT as "Enc.Refer the mother immediately to hospital. Did arrangement was made",
         (programEncounter.observations->>'0c6d2587-382d-4762-8871-b6890d854505')::TEXT as "Enc.Temperature(celcius)",
         (programEncounter.observations->>'630c0fa3-38f7-427d-a8dd-f1417cf1b7dc')::TEXT as "Enc.Pulse",
         (programEncounter.observations->>'6874d48e-8c2f-4009-992c-1d3ca1678cc6')::TEXT as "Enc.Blood Pressure (systolic)",
         (programEncounter.observations->>'da871f6c-cef0-4191-b307-6751b31ac9ec')::TEXT as "Enc.Blood Pressure (Diastolic)",
         single_select_coded(programEncounter.observations->>'7764a974-7ba8-4a13-9ba9-6d8d580f3c99')::TEXT as "Enc.Is there foul smelling discharge PV",
         single_select_coded(programEncounter.observations->>'74c618b3-a4e0-4382-9486-70dbf5752d9d')::TEXT as "Enc.Does mother has seizures?",
         single_select_coded(programEncounter.observations->>'2371bb8d-4561-4396-ba01-14c14f7972ba')::TEXT as "Enc.mother have less breast milk",
         single_select_coded(programEncounter.observations->>'43567d78-ad97-46bc-afa1-8522ec9e0180')::TEXT as "Enc.Does mother has any breast related issue like swelling, cracked nipple etc?",
         single_select_coded(programEncounter.observations->>'be8560c8-beab-4b69-80ea-c6e943939a30')::TEXT as "Enc.mother get the benefit of JSY scheme",
         (programEncounter.observations->>'d8e3c407-af6d-45df-9db1-a40e289452c0')::DATE as "Enc.Date of recieving the JSY scheme benefit",
         single_select_coded(programEncounter.observations->>'0ac30adc-5107-4e30-9b8a-c3ef65904cf5')::TEXT as "Enc.Counselling",
         single_select_coded(programEncounter.observations->>'28d3ae12-a92b-4499-8cce-7471f11d3611')::TEXT as "Enc.Keep baby warm",
         single_select_coded(programEncounter.observations->>'b5255768-9c41-4588-8272-f8a967044992')::TEXT as "Enc.Child PNC - Baby warming - Dos",
         single_select_coded(programEncounter.observations->>'6ae137dd-2b6d-4562-aeea-252b7ae6b869')::TEXT as "Enc.Breastfeeding (counselling)",
         single_select_coded(programEncounter.observations->>'42fe9c19-f279-4a0e-a8ce-8a157357bf8d')::TEXT as "Enc.Sign of good latching(counselling)",
         single_select_coded(programEncounter.observations->>'72bcb84a-893e-436f-b9de-1919d1480421')::TEXT as "Enc.No bath till one day/ 1 week(counselling)",
         single_select_coded(programEncounter.observations->>'83705410-0548-4f92-97a2-8e48bf1275ca')::TEXT as "Enc.Vaccination (counselling)",
         single_select_coded(programEncounter.observations->>'8464b109-5b66-40fc-90ca-5cc9e0ae30fd')::TEXT as "Enc.HBNC checkup (counselling)",
         single_select_coded(programEncounter.observations->>'6af2f841-e483-42d7-83c5-41de4ecb1966')::TEXT as "Enc.PPMC check(counselling)",
         single_select_coded(programEncounter.observations->>'f63d81de-61e4-4894-87d2-cf0fb8a8cd67')::TEXT as "Enc.Seeking care in case of any health problem(counselling)",
         single_select_coded(programEncounter.observations->>'3b8f36ce-3837-455f-bcc0-26558545dd81')::TEXT as "Enc.Family planning (counselling)",
         single_select_coded(programEncounter.observations->>'ca2af807-ec9f-4b33-8ffa-e17075979996')::TEXT as "Enc.refer the woman to SC or ask the SHW to make a home visit",
         single_select_coded(programEncounter.observations->>'c3f8600a-aebf-44ea-967e-ff93c11a5946')::TEXT as "Enc.refer the mother to SC/Ganiyari",
         single_select_coded(programEncounter.observations->>'c75a610f-27c3-4fad-9c26-04887c15436e')::TEXT as "Enc.Referral needed to mother?",
         single_select_coded(programEncounter.observations->>'c470cb18-f902-4b2b-844b-4b6286e36b8d')::TEXT as "Enc.place of referral",
         (programEncounter.observations->>'d169efa9-49af-4c84-ae09-b1b7296c62da')::TEXT as "Enc.Other place of referral",
         single_select_coded(programEncounter.observations->>'8a56f008-a910-4d6f-b028-a95db330dbf2')::TEXT as "Enc.Referral reason",
         (programEncounter.observations->>'e048675e-eb86-41c2-a47b-aecfa9a3bb8c')::TEXT as "Enc.Other referral reason",
         programEncounter.cancel_date_time "EncCancel.cancel_date_time",
         single_select_coded(programEncounter.observations->>'bf400e7f-8e1b-4052-af49-b0db47b3eb5a')::TEXT as "EncCancel.Visit cancel reason",
         (programEncounter.observations->>'d038a9c4-fe96-4c09-b883-c80691427b60')::TEXT as "EncCancel.Other reason for cancelling",
         (programEncounter.observations->>'6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE as "EncCancel.Date of next ANC Visit"

          FROM program_encounter programEncounter
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
                                       single_select_coded(individual.observations->>'9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b')::TEXT as "Ind.Marital status",
                                       (individual.observations->>'9d958124-09bb-466c-a4b4-db8d285def1f')::DATE as "Ind.Date of marriage",
                                       single_select_coded(individual.observations->>'673d65bd-6dc4-4aac-8e1e-1ee355ac081b')::TEXT as "Ind.Education",
                                       single_select_coded(individual.observations->>'20ef261a-f110-4eaa-a592-2a1eeb0bf061')::TEXT as "Ind.Occupation",
                                       (individual.observations->>'4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT as "Ind.Other occupation",
                                       single_select_coded(individual.observations->>'bab107f6-fc0e-4be7-ab71-658a92d72f35')::TEXT as "Ind.Whether any disability",
                                       multi_select_coded(individual.observations->'7061c675-c2ba-4016-886d-eeb432548378')::TEXT as "Ind.Type of disability",
                                       single_select_coded(individual.observations->>'d333f2a2-717e-478f-acbc-173bc7374d66')::TEXT as "Ind.Status of the individual",
                                       (individual.observations->>'681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT as "Ind.Aadhaar ID",
                                       (individual.observations->>'0a725832-b21c-4151-b017-7e6af770ba54')::TEXT as "Ind.Contact Number",
                                       single_select_coded(individual.observations->>'2a445ac8-56e7-4eda-8756-0a9c4fa9a77b')::TEXT as "Ind.Smart card (Insurance)",

                                       single_select_coded(programEncounter.observations->>'918c6eaf-b7ab-4958-aa42-4b0280a3c5e8')::TEXT as "Enc.Whether newborn fed other that exclusive breastfeeding",
                                       multi_select_coded(programEncounter.observations->'761a5ddc-fe17-4393-bb28-ecd45de68f58')::TEXT as "Enc.How was breastfeedig",
                                       (programEncounter.observations->>'30f5bc1c-72b9-438a-8a41-8732e52ca0bf')::DATE as "Enc.Date time of breastfedding after delivery",
                                       multi_select_coded(programEncounter.observations->'ba69923c-e451-41a5-8ed0-62d2078411b9')::TEXT as "Enc.Whether mother have any problem in breastfeeding",
                                       single_select_coded(programEncounter.observations->>'de3329dd-47a0-463c-ab48-03f1199639d8')::TEXT as "Enc.Was temperature recorded?",
                                       (programEncounter.observations->>'d6d8f9d9-d0c5-4574-b779-a8aa08604771')::TEXT as "Enc.Temperature of newborn (celcius)",
                                       multi_select_coded(programEncounter.observations->'1c675de4-83eb-471f-9b55-6b8a0d48c55e')::TEXT as "Enc.Eye of newborn",
                                       (programEncounter.observations->>'8fcbe2ba-80a9-4a32-8573-dbecc62f96f5')::TEXT as "Enc.Other condition of newborn eye",
                                       single_select_coded(programEncounter.observations->>'6be64524-a223-464f-8c68-787c5d6f7e7c')::TEXT as "Enc.Bleeding from chord",
                                       multi_select_coded(programEncounter.observations->'81744917-f99b-41a1-80e9-8057b90073d0')::TEXT as "Enc.Look for birth defects",
                                       multi_select_coded(programEncounter.observations->'c0e51a98-9689-4963-9c29-b8be89053116')::TEXT as "Enc.Look for any danger signs of sepsis within 6 hours",
                                       (programEncounter.observations->>'e8194331-8da1-4eba-85b6-95c704209025')::TEXT as "Enc.Other danger signs of sepsis within 6 hours",
                                       single_select_coded(programEncounter.observations->>'94b7ee05-e0d2-4b9b-92b0-3e8f4ad666da')::TEXT as "Enc.Whether mother wraps the baby in clothes in cold whether",
                                       single_select_coded(programEncounter.observations->>'1bfdc70a-475d-487b-b87b-9f8c422bdadd')::TEXT as "Enc.Whether mother gives skin to skin warmth to baby",
                                       single_select_coded(programEncounter.observations->>'cec9ce0f-d40a-4a8e-ac8b-60e90259c003')::TEXT as "Enc.Whether mother breastfed her child for min 8 times a day",
                                       single_select_coded(programEncounter.observations->>'1d052667-3622-4934-9343-7127729c3aa3')::TEXT as "Enc.Whether baby cries too much urinate less than 6 time a day",
                                       multi_select_coded(programEncounter.observations->'d5b8e6fc-f5cc-45e3-a753-141c9677a491')::TEXT as "Enc.Look for any danger signs of sepsis after 6 hours",
                                       (programEncounter.observations->>'1a68a35d-ad9c-45f3-b3dd-62c04f26be0f')::TEXT as "Enc.Other danger signs of sepsis after 6 hours",
                                       single_select_coded(programEncounter.observations->>'e46f457d-6d84-46b6-9fa6-30e87537154b')::TEXT as "Enc.Whether newborn has swolen eyes or discharge from eyes",
                                       (programEncounter.observations->>'8d947379-7a1d-48b2-8760-88fff6add987')::TEXT as "Enc.Weight",
                                       (programEncounter.observations->>'0c6d2587-382d-4762-8871-b6890d854505')::TEXT as "Enc.Temperature(celcius)",
                                       single_select_coded(programEncounter.observations->>'9359a427-d6de-4f1d-b21e-a55b4aaef0b5')::TEXT as "Enc.Skin - pus filled rashes/boils",
                                       single_select_coded(programEncounter.observations->>'b9961b58-b54e-4329-8f40-fc42a1a5981a')::TEXT as "Enc.Skin - Redness/crack in skin fold",
                                       single_select_coded(programEncounter.observations->>'bbc18a0f-996a-4e3b-b4bf-703cfba2f9df')::TEXT as "Enc.Yellowing of skin/eye",
                                       (programEncounter.observations->>'80c5cefe-804d-45f3-b5b6-93db8b758a96')::TEXT as "Enc.Respiratory Rate",
                                       single_select_coded(programEncounter.observations->>'1f35def8-d31d-4f66-80de-625003c9412c')::TEXT as "Enc.Whether baby die",
                                       (programEncounter.observations->>'338953ea-6d7e-423e-96d6-f52d5aa37072')::DATE as "Enc.Date of Death",
                                       single_select_coded(programEncounter.observations->>'1680e20a-1bf9-4396-ae01-94bb361983c1')::TEXT as "Enc.Referral needed to newborn",
                                       single_select_coded(programEncounter.observations->>'80fccb06-a62f-43e8-92eb-358bdb600079')::TEXT as "Enc.Place of referral",
                                       (programEncounter.observations->>'d169efa9-49af-4c84-ae09-b1b7296c62da')::TEXT as "Enc.Other place of referral",
                                       multi_select_coded(programEncounter.observations->'bed53b48-5e3e-4442-9137-0f2b182fabe5')::TEXT as "Enc.Referral reason for newborn",
                                       (programEncounter.observations->>'e048675e-eb86-41c2-a47b-aecfa9a3bb8c')::TEXT as "Enc.Other referral reason",
                                       single_select_coded(programEncounter.observations->>'fa031cca-7264-420a-b657-0d3d5fc58a9c')::TEXT as "Enc.Counselling Done",
                                       single_select_coded(programEncounter.observations->>'5f577e35-7d23-4cfd-9495-d7442839e3df')::TEXT as "Enc.Tight the tread if there is bleeding",
                                       single_select_coded(programEncounter.observations->>'8f82651a-36a0-4eb6-a7ea-408230d44cd7')::TEXT as "Enc.Show her how to wrap the baby in clothe",
                                       single_select_coded(programEncounter.observations->>'6bcecb5c-5142-4ab4-a563-0c6c7cf0ddf7')::TEXT as "Enc.counsell her about giving kangaroo mother care",
                                       single_select_coded(programEncounter.observations->>'c6c42ef8-1731-410d-ab63-19ca22aec519')::TEXT as "Enc.counsel mother for 2 hourly breast feeding",
                                       single_select_coded(programEncounter.observations->>'70d55d5d-aed6-46fc-bf3a-9d3ba68d6bc1')::TEXT as "Enc.counsel mother for 2 hourly breastfeeding",
                                       single_select_coded(programEncounter.observations->>'66f49885-2429-4fe2-b8d9-5ce1426e20b2')::TEXT as "Enc.ask mother to take Tetracycline medicine from VHW",
                                       single_select_coded(programEncounter.observations->>'7effc9b6-29c0-499c-9c78-2cf6fe796a25')::TEXT as "Enc.give PCM",
                                       single_select_coded(programEncounter.observations->>'dced742e-74bc-4016-83d0-3e0020bedd17')::TEXT as "Enc.tell mother to keep the baby warm and breastfeed frequently",
                                       single_select_coded(programEncounter.observations->>'dde1da1e-56c5-42ad-8577-6b3096948330')::TEXT as "Enc.start treatment of hypothermia and look for sign of sepsis",
                                       single_select_coded(programEncounter.observations->>'b5c8113e-ea16-414c-8d67-82fa0177a909')::TEXT as "Enc.apply GV paint",
                                       single_select_coded(programEncounter.observations->>'c3046ee8-0992-4459-b713-555a947ab6f3')::TEXT as "Enc.refer the baby to Subcenter for yellow skin or eyes",
                                       multi_select_coded(programEncounter.observations->'23664b77-05e2-4baa-8522-68c02314ec21')::TEXT as "Enc.Diagnosis of sepsis",
                                       programEncounter.cancel_date_time "EncCancel.cancel_date_time",
                                       single_select_coded(programEncounter.observations->>'bf400e7f-8e1b-4052-af49-b0db47b3eb5a')::TEXT as "EncCancel.Visit cancel reason",
                                       (programEncounter.observations->>'d038a9c4-fe96-4c09-b883-c80691427b60')::TEXT as "EncCancel.Other reason for cancelling",
                                       (programEncounter.observations->>'6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE as "EncCancel.Date of next ANC Visit"
                                   FROM program_encounter programEncounter
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
              single_select_coded(
                         individual.observations ->> '9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b')::TEXT       as "Ind.Marital status",
              (individual.observations ->> '9d958124-09bb-466c-a4b4-db8d285def1f')::DATE              as "Ind.Date of marriage",
              single_select_coded(
                         individual.observations ->> '673d65bd-6dc4-4aac-8e1e-1ee355ac081b')::TEXT       as "Ind.Education",
              single_select_coded(
                         individual.observations ->> '20ef261a-f110-4eaa-a592-2a1eeb0bf061')::TEXT       as "Ind.Occupation",
              (individual.observations ->> '4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT              as "Ind.Other occupation",
              single_select_coded(
                         individual.observations ->> 'bab107f6-fc0e-4be7-ab71-658a92d72f35')::TEXT       as "Ind.Whether any disability",
              multi_select_coded(
                         individual.observations -> '7061c675-c2ba-4016-886d-eeb432548378')::TEXT        as "Ind.Type of disability",
              single_select_coded(
                         individual.observations ->> 'd333f2a2-717e-478f-acbc-173bc7374d66')::TEXT       as "Ind.Status of the individual",
              (individual.observations ->> '681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT              as "Ind.Aadhaar ID",
              (individual.observations ->> '0a725832-b21c-4151-b017-7e6af770ba54')::TEXT              as "Ind.Contact Number",
              single_select_coded(
                         individual.observations ->> '2a445ac8-56e7-4eda-8756-0a9c4fa9a77b')::TEXT       as "Ind.Smart card (Insurance)",
              (programEnrolment.observations ->> 'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c')::TEXT        as "Enl.ANC Enrolment ID",
              single_select_coded(
                         programEnrolment.observations ->> '58d0a437-17ef-4d58-a36f-9a36b608f5a4')::TEXT as "Enl.Relation with village",
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
              single_select_coded(
                         programEnrolment.observations ->> '1952339b-14b0-447d-b6d7-6bcf18b4af62')::TEXT as "Enl.Last delivery place",
              single_select_coded(
                         programEnrolment.observations ->> '6c771640-52b6-46ea-bd56-0a2670ab7a6d')::TEXT as "Enl.Last delivery outcome",
              single_select_coded(
                         programEnrolment.observations ->> 'f776b045-2fcb-4275-b08e-e3e9039b699e')::TEXT as "Enl.Last delivery gender",
              single_select_coded(
                         programEnrolment.observations ->> '2f68ca5f-c690-4848-aa2e-592d6c7ef4e8')::TEXT as "Enl.Last delivery- Is baby alive?",
              single_select_coded(
                         programEnrolment.observations ->> '26cee30f-b36d-4be2-bec3-9a0904492e52')::TEXT as "Enl.Any High risk condition in previous pregnancy",
              multi_select_coded(
                         programEnrolment.observations -> 'a0aea5a9-7101-48ef-8463-5b376efa61bf')::TEXT  as "Enl.High risk condition in previous pregnancy",
              (programEnrolment.observations ->> '6bdfb87a-fefc-48ea-bcab-8bd05cbae73d')::TEXT        as "Enl.Other high risk condition in previous pregnancy",
              single_select_coded(
                         programEnrolment.observations ->> 'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2')::TEXT as "Enl.Taking medicine for chronic disease",
              multi_select_coded(
                         programEnrolment.observations -> '7d9b6992-ee27-4423-90a5-9ad20400d885')::TEXT  as "Enl.Name of chronic disease",
              (programEnrolment.observations ->> 'a54d0c2c-a054-45a5-a143-9f6c9db3fbbd')::TEXT        as "Enl.Other chronic disease",
              single_select_coded(
                         programEnrolment.observations ->> '1aac0eaf-1c9e-4284-93c3-7212c06a3286')::TEXT as "Enl.Does woman want to continue this pregnancy?",
              single_select_coded(
                         programEnrolment.observations ->> 'b5ebc472-0f32-4128-97f3-0e2571daeaae')::TEXT as "Enl.Send her to nearest antenatal clinic",
              (programEnrolment.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "Enl.Date of next ANC Visit",
              single_select_coded(
                         programEnrolment.observations ->> 'b6f45def-e3f4-4e7b-97ed-68c539b82fa2')::TEXT as "Enl.Send her to hospital for abortion",
              (programEncounter.observations ->> '23bcad9f-ec16-46ec-92f5-e144411e5dec')::TEXT        as "Enc.Height",
              (programEncounter.observations ->> '8d947379-7a1d-48b2-8760-88fff6add987')::TEXT        as "Enc.Weight",
              (programEncounter.observations ->> 'a205563d-0ac2-4955-93ac-e2e7adebb56e')::TEXT        as "Enc.BMI",
              (programEncounter.observations ->> '6874d48e-8c2f-4009-992c-1d3ca1678cc6')::TEXT        as "Enc.Blood Pressure (systolic)",
              (programEncounter.observations ->> 'da871f6c-cef0-4191-b307-6751b31ac9ec')::TEXT        as "Enc.Blood Pressure (Diastolic)",
              single_select_coded(
                         programEncounter.observations ->> 'b7be4ddc-14ee-4caf-ab38-e1c87d088688')::TEXT as "Enc.Is mosquito net given",
              single_select_coded(
                         programEncounter.observations ->> '04eecc2b-93eb-49d4-83a4-6629442711ea')::TEXT as "Enc.Is safe delivery kit given",
              multi_select_coded(
                         programEncounter.observations -> '74599453-6fbd-4f8d-bf7f-34faa3c10eb9')::TEXT  as "Enc.New complaint",
              (programEncounter.observations ->> 'dc0c10ca-c151-4c5c-aedc-2b8040dbea52')::TEXT        as "Enc.Other complaint",
              multi_select_coded(
                         programEncounter.observations -> '95dd3094-6c99-4622-8614-bf5d33a509e4')::TEXT  as "Enc.Oedema",
              multi_select_coded(
                         programEncounter.observations -> '2a15dc0b-d6a0-4670-b109-4013789cb403')::TEXT  as "Enc.Abdomen check",
              (programEncounter.observations ->> '9b087651-34e8-4391-aa08-8db73f55d7e6')::TEXT        as "Enc.Current gestational age",
              single_select_coded(
                         programEncounter.observations ->> 'f5ff8848-798a-4b0f-bcaf-33f2d4528f37')::TEXT as "Enc.Fundle Height",
              single_select_coded(
                         programEncounter.observations ->> '69a95145-505b-497a-9fc9-61fcc5d2ff59')::TEXT as "Enc.Position",
              single_select_coded(
                         programEncounter.observations ->> '7c6d3fc6-6a9f-4b44-beef-8c2200da5281')::TEXT as "Enc.FHS",
              (programEncounter.observations ->> '532ae011-4380-4ff5-b7c7-7d163e396221')::TEXT        as "Enc.FHS number",
              single_select_coded(
                         programEncounter.observations ->> '31651632-0acb-4ee5-a0f3-1628bbed456c')::TEXT as "Enc.Foetus movement",
              multi_select_coded(
                         programEncounter.observations -> '7259b0fa-c8d1-4e04-8d13-7dbc05f0169b')::TEXT  as "Enc.Breast examination",
              single_select_coded(
                         programEncounter.observations ->> 'c50c8196-01c9-422f-b917-fd2309adb261')::TEXT as "Enc.Blood group",
              single_select_coded(
                         programEncounter.observations ->> '610db330-fafe-456f-bd58-e062cb6e52e3')::TEXT as "Enc.Sickle prep",
              single_select_coded(
                         programEncounter.observations ->> '78fcebd3-17e5-4621-89be-c580fbf13168')::TEXT as "Enc.Urine Albumin",
              single_select_coded(
                         programEncounter.observations ->> '55ae9e7a-f6ff-4c0b-861c-fd29b6c5c646')::TEXT as "Enc.Urine sugar",
              (programEncounter.observations ->> 'a240115e-47a2-4244-8f74-d13d20f087df')::TEXT        as "Enc.Hb",
              single_select_coded(
                         programEncounter.observations ->> '9a89e9d6-f6e4-4d14-8841-34df9ece70a5')::TEXT as "Enc.Malaria parasite",
              (programEncounter.observations ->> 'd6ac43a2-527d-4168-ba7d-2d233add3a6e')::TEXT        as "Enc.Random Blood Sugar (RBS)",
              (programEncounter.observations ->> 'ae2046a4-015c-44e2-9703-01bc3da13202')::TEXT        as "Enc.Glucose test (75gm Glucose)",
              (programEncounter.observations ->> '0b8bc1f8-43db-4ecb-9677-22709e91681f')::TEXT        as "Enc.Pus Cell",
              (programEncounter.observations ->> 'b59c126f-975b-45e6-8dd6-584dd54e25c9')::TEXT        as "Enc.RBC",
              (programEncounter.observations ->> '0343e35f-afd0-41ce-af93-e69c184b159c')::TEXT        as "Enc.Epithelial cells",
              (programEncounter.observations ->> 'a2b6d675-4c70-4f15-a5ad-b8f5273602f9')::TEXT        as "Enc.Cast",
              single_select_coded(
                         programEncounter.observations ->> '14a023d3-bd25-4343-9d93-34d9f88eb4b3')::TEXT as "Enc.Crystel",
              single_select_coded(
                         programEncounter.observations ->> 'bf1e5598-594c-4444-94e0-9390f5081e41')::TEXT as "Enc.Whether Folic acid given",
              single_select_coded(
                         programEncounter.observations ->> '5740f87b-8cc6-4927-88a2-44636e8f396c')::TEXT as "Enc.Whether IFA given",
              single_select_coded(
                         programEncounter.observations ->> '00de9acc-4ff6-485b-b979-41ff00745d23')::TEXT as "Enc.Whether Calcium given",
              single_select_coded(
                         programEncounter.observations ->> '2a5a3b4d-80c4-4d05-8585-e16966ff0c3e')::TEXT as "Enc.Whether Amala given",
              single_select_coded(
                         programEncounter.observations ->> 'ddeb2311-4a90-4a7c-a698-1cd3db4ff0f3')::TEXT as "Enc.TT 1",
              single_select_coded(
                         programEncounter.observations ->> '858f66e6-1ed3-4c13-9fdf-08f667b092ba')::TEXT as "Enc.TT 2",
              (programEncounter.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "Enc.Date of next ANC Visit",
              single_select_coded(
                         programEncounter.observations ->> '77d122e8-0620-4754-8375-b0cbe329003c')::TEXT as "Enc.Does woman require referral?",
              single_select_coded(
                         programEncounter.observations ->> '80fccb06-a62f-43e8-92eb-358bdb600079')::TEXT as "Enc.Place of referral",
              (programEncounter.observations ->> 'd169efa9-49af-4c84-ae09-b1b7296c62da')::TEXT        as "Enc.Other place of referral",
              multi_select_coded(
                         programEncounter.observations -> '8a56f008-a910-4d6f-b028-a95db330dbf2')::TEXT  as "Enc.Referral reason",
              (programEncounter.observations ->> 'e048675e-eb86-41c2-a47b-aecfa9a3bb8c')::TEXT        as "Enc.Other referral reason",
              programEncounter.cancel_date_time                                                          "EncCancel.cancel_date_time",
              single_select_coded(
                         programEncounter.observations ->> 'bf400e7f-8e1b-4052-af49-b0db47b3eb5a')::TEXT as "EncCancel.Visit cancel reason",
              (programEncounter.observations ->> 'd038a9c4-fe96-4c09-b883-c80691427b60')::TEXT        as "EncCancel.Other reason for cancelling",
              (programEncounter.observations ->> '6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE        as "EncCancel.Date of next ANC Visit"
       FROM program_encounter programEncounter
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
)

  drop view if exists   jsscp_usg_report_view ;
 create view jsscp_usg_report_view as(
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
                                        single_select_coded(individual.observations->>'9e995ea6-a5f7-410f-adc2-2d2ce6d5e19b')::TEXT as "Ind.Marital status",
                                        (individual.observations->>'9d958124-09bb-466c-a4b4-db8d285def1f')::DATE as "Ind.Date of marriage",
                                        single_select_coded(individual.observations->>'673d65bd-6dc4-4aac-8e1e-1ee355ac081b')::TEXT as "Ind.Education",
                                        single_select_coded(individual.observations->>'20ef261a-f110-4eaa-a592-2a1eeb0bf061')::TEXT as "Ind.Occupation",
                                        (individual.observations->>'4c429211-634e-4c2b-9a31-3f0a395f8f8d')::TEXT as "Ind.Other occupation",
                                        single_select_coded(individual.observations->>'bab107f6-fc0e-4be7-ab71-658a92d72f35')::TEXT as "Ind.Whether any disability",
                                        multi_select_coded(individual.observations->'7061c675-c2ba-4016-886d-eeb432548378')::TEXT as "Ind.Type of disability",
                                        single_select_coded(individual.observations->>'d333f2a2-717e-478f-acbc-173bc7374d66')::TEXT as "Ind.Status of the individual",
                                        (individual.observations->>'681fce2b-ea38-4651-a0b8-2cddd307ade7')::TEXT as "Ind.Aadhaar ID",
                                        (individual.observations->>'0a725832-b21c-4151-b017-7e6af770ba54')::TEXT as "Ind.Contact Number",
                                        single_select_coded(individual.observations->>'2a445ac8-56e7-4eda-8756-0a9c4fa9a77b')::TEXT as "Ind.Smart card (Insurance)",
                                        (programEnrolment.observations->>'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c')::TEXT as "Enl.ANC Enrolment ID",
                                        single_select_coded(programEnrolment.observations->>'58d0a437-17ef-4d58-a36f-9a36b608f5a4')::TEXT as "Enl.Relation with village",
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
                                        single_select_coded(programEnrolment.observations->>'1952339b-14b0-447d-b6d7-6bcf18b4af62')::TEXT as "Enl.Last delivery place",
                                        single_select_coded(programEnrolment.observations->>'6c771640-52b6-46ea-bd56-0a2670ab7a6d')::TEXT as "Enl.Last delivery outcome",
                                        single_select_coded(programEnrolment.observations->>'f776b045-2fcb-4275-b08e-e3e9039b699e')::TEXT as "Enl.Last delivery gender",
                                        single_select_coded(programEnrolment.observations->>'2f68ca5f-c690-4848-aa2e-592d6c7ef4e8')::TEXT as "Enl.Last delivery- Is baby alive?",
                                        single_select_coded(programEnrolment.observations->>'26cee30f-b36d-4be2-bec3-9a0904492e52')::TEXT as "Enl.Any High risk condition in previous pregnancy",
                                        multi_select_coded(programEnrolment.observations->'a0aea5a9-7101-48ef-8463-5b376efa61bf')::TEXT as "Enl.High risk condition in previous pregnancy",
                                        (programEnrolment.observations->>'6bdfb87a-fefc-48ea-bcab-8bd05cbae73d')::TEXT as "Enl.Other high risk condition in previous pregnancy",
                                        single_select_coded(programEnrolment.observations->>'dbdf3b6e-8710-4364-9d0e-d92c1cc41db2')::TEXT as "Enl.Taking medicine for chronic disease",
                                        multi_select_coded(programEnrolment.observations->'7d9b6992-ee27-4423-90a5-9ad20400d885')::TEXT as "Enl.Name of chronic disease",
                                        (programEnrolment.observations->>'a54d0c2c-a054-45a5-a143-9f6c9db3fbbd')::TEXT as "Enl.Other chronic disease",
                                        single_select_coded(programEnrolment.observations->>'1aac0eaf-1c9e-4284-93c3-7212c06a3286')::TEXT as "Enl.Does woman want to continue this pregnancy?",
                                        single_select_coded(programEnrolment.observations->>'b5ebc472-0f32-4128-97f3-0e2571daeaae')::TEXT as "Enl.Send her to nearest antenatal clinic",
                                        (programEnrolment.observations->>'6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE as "Enl.Date of next ANC Visit",
                                        single_select_coded(programEnrolment.observations->>'b6f45def-e3f4-4e7b-97ed-68c539b82fa2')::TEXT as "Enl.Send her to hospital for abortion",
                                        single_select_coded(programEncounter.observations->>'6618dfd6-5df2-4c85-b916-0679bcb9be03')::TEXT as "Enc.Foetus is ok",
                                        single_select_coded(programEncounter.observations->>'e7b5d460-47dd-490b-af0a-a73a19a93a9d')::TEXT as "Enc.Presentation of baby",
                                        single_select_coded(programEncounter.observations->>'9f55f157-c835-4068-a948-c849073d1d86')::TEXT as "Enc.Twin baby",
                                        single_select_coded(programEncounter.observations->>'96499ee7-ad90-4831-a0bd-1fd765f6f6c0')::TEXT as "Enc.Follow USG required",
                                        (programEncounter.observations->>'71efca55-ad55-4814-a16f-44d714c6ecf5')::DATE as "Enc.Date of next USG",
                                        programEncounter.cancel_date_time "EncCancel.cancel_date_time",
                                        single_select_coded(programEncounter.observations->>'bf400e7f-8e1b-4052-af49-b0db47b3eb5a')::TEXT as "EncCancel.Visit cancel reason",
                                        (programEncounter.observations->>'d038a9c4-fe96-4c09-b883-c80691427b60')::TEXT as "EncCancel.Other reason for cancelling",
                                        (programEncounter.observations->>'6e50431c-6cb0-495f-9735-dd431c9970ff')::DATE as "EncCancel.Date of next ANC Visit"
                                    FROM program_encounter programEncounter
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