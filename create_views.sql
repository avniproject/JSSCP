set role jsscp;

drop view if exists jsscp_growth_monitoring_view;
create view jsscp_growth_monitoring_view as (
    with encounters_with_visit_number as (
        select individual.id                                                                           "Ind.Id",
               individual.address_id                                                                   "Ind.address_id",
               individual.uuid                                                                         "Ind.uuid",
               individual.first_name                                                                   "Ind.first_name",
               individual.last_name                                                                    "Ind.last_name",
               g.name                                                                                  "Ind.Gender",
               individual.date_of_birth                                                                "Ind.date_of_birth",
               (extract('Year' from age(date_of_birth)) * 12) + extract('Month' from age(date_of_birth)) +
               round((extract('Day' from age(date_of_birth)) / 30)::numeric, 1)                        "Ind.age_in_months",
               individual.date_of_birth_verified                                                       "Ind.date_of_birth_verified",
               individual.registration_date                                                            "Ind.registration_date",
               individual.facility_id                                                                  "Ind.facility_id",
               a.title                                                                                 "Ind.Area",
               individual.is_voided                                                                    "Ind.is_voided",
               op.name                                                                                 "Enl.Program Name",
               programEnrolment.id                                                                     "Enl.Id",
               programEnrolment.uuid                                                                   "Enl.uuid",
               programEnrolment.enrolment_date_time                                                    "Enl.enrolment_date_time",
               programEnrolment.is_voided                                                              "Enl.is_voided",
               programEnrolment.program_exit_date_time                                                 "Enl.program_exit_date_time",
               oet.name                                                                                "Enc.Type",
               programEncounter.id                                                                     "Enc.Id",
               programEncounter.earliest_visit_date_time                                               "Enc.earliest_visit_date_time",
               programEncounter.encounter_date_time                                                    "Enc.encounter_date_time",
               programEncounter.program_enrolment_id                                                   "Enc.program_enrolment_id",
               programEncounter.uuid                                                                   "Enc.uuid",
               programEncounter.name                                                                   "Enc.name",
               programEncounter.max_visit_date_time                                                    "Enc.max_visit_date_time",
               programEncounter.is_voided                                                              "Enc.is_voided",
               (individual.observations ->> '821ba930-505c-4fd3-9f24-66b60ed45bac')::TEXT              "Ind.Birth Order",
               (individual.observations ->> '9e6983b8-06ef-4648-b360-6684100b1be1')::TEXT              "Ind.Father's Name",
               single_select_coded(
                       individual.observations ->> 'bf564151-63f9-4176-917f-f37de34b9bae')::TEXT       "Ind.Father's Occupation",
               single_select_coded(
                       individual.observations ->> 'b1001c4d-0449-464a-947f-a04c4fdcc651')::TEXT       "Ind.Father's education Level",
               (individual.observations ->> '74a554d8-5b87-4d27-9ae5-272ab326608f')::TEXT              "Ind.Mother's Name",
               single_select_coded(
                       individual.observations ->> 'ea760e4f-c12f-490b-9865-9c6e4510ce64')::TEXT       "Ind.Mother's Occupation",
               single_select_coded(
                       individual.observations ->> 'd98aae1a-ce33-4e51-b031-66e13bc0ba11')::TEXT       "Ind.Mother's education Level",
               single_select_coded(
                       individual.observations ->> '9ad4b520-4e33-4b1b-a056-37ae6418988f')::TEXT       "Ind.Caste Category",
               single_select_coded(
                       individual.observations ->> '047877ac-dba7-4acf-8c77-97c979c2fc26')::TEXT       "Ind.Sub Caste",
               (individual.observations ->> 'ae7d54e9-fac0-4898-b334-87664bd055d2')::TEXT              "Ind.Other sub caste",
               single_select_coded(
                       individual.observations ->> 'b984ad33-05d8-4621-adf3-152e72a0db1b')::TEXT       "Ind.Land possession",
               (individual.observations ->> '430ebb19-831d-470d-80eb-7969814f13e4')::TEXT              "Ind.Land Area",
               single_select_coded(
                       individual.observations ->> 'c5d2673b-0f5c-48bf-93e4-f1a1ae820732')::TEXT       "Ind.Type of residence",
               single_select_coded(
                       individual.observations ->> '86fc3018-8eeb-4a58-a9d9-a40fff839305')::TEXT       "Ind.Ration Card",
               multi_select_coded(
                       individual.observations -> 'aa88dba4-4f5d-4d35-9dc1-2390969cc5f3')::TEXT        "Ind.Property",
               (individual.observations ->> '32609e0f-f3c8-4dcb-af7c-5e8a96e8e89d')::TEXT              "Ind.Other property",
               single_select_coded(
                       programEnrolment.observations ->> '178acfbe-b7e1-4ef5-a48a-0f4b1beabb80')::TEXT "Enl.Phulwari",
               single_select_coded(
                       programEnrolment.observations ->> '8a7cfa70-2e10-4ff9-88b1-516c94c8efbb')::TEXT "Enl.Is baby exclusively breastfeeding",
               single_select_coded(
                       programEnrolment.observations ->> '7b84dc32-b074-43f0-b9e8-9bfaf3742dc3')::TEXT "Enl.Is there any developmental delay or disability seen?",
               multi_select_coded(
                       programEnrolment.observations -> 'ebc49a98-a98b-4a78-8f66-f124e91c8d5c')::TEXT  "Enl.Child Disabilities",
               single_select_coded(
                       programEnrolment.observations ->> 'ea57f134-ab0e-417b-a514-2e66e75a13f4')::TEXT "Enl.Chronic Illness",
               (programEnrolment.observations ->> '460746b0-f290-4d6d-8296-ddf8e2a82648')::TEXT        "Enl.Other Chronic Illness",
               (programEnrolment.observations ->> 'd1985def-295c-415c-b563-310946a03762')::TEXT        "Enl.Day of month for growth monitoring visit",
               single_select_coded(
                       programEncounter.observations ->> '9fa4001d-56cb-45c9-8dd6-69e6f36f4c34')::TEXT "Enc.Skip capturing height",
               (programEncounter.observations ->> '12684bc5-8064-47a0-9fb7-a1cada81ea03')::TEXT        "Enc.Reason for skipping height capture.",
               (programEncounter.observations ->> '23bcad9f-ec16-46ec-92f5-e144411e5dec')::NUMERIC     "Enc.Height",
               (programEncounter.observations ->> '8d947379-7a1d-48b2-8760-88fff6add987')::NUMERIC     "Enc.Weight",
               (programEncounter.observations ->> '8f369b3d-551d-4311-8e4c-7ee54d9e75ab')::NUMERIC     "Enc.Weight for age z-score",
               (programEncounter.observations ->> 'b23561f2-d3c4-40f6-a38d-a30fae484fd9')::NUMERIC     "Enc.Weight for age Grade",
               single_select_coded(
                       programEncounter.observations ->> 'ff26e3db-2499-426d-ba1e-fc3bf7772b90')::TEXT "Enc.Weight for age Status",
               (programEncounter.observations ->> '89defa3b-4924-4a43-85ce-0d3787000ab8')::NUMERIC     "Enc.Height for age z-score",
               (programEncounter.observations ->> '0ba03618-45b9-483d-8ff3-d45dccfc2804')::NUMERIC     "Enc.Height for age Grade",
               single_select_coded(
                       programEncounter.observations ->> '60566bc3-018b-409a-82fc-a5d7a2a3e144')::TEXT "Enc.Height for age Status",
               (programEncounter.observations ->> '9ee91c02-f965-4045-9248-1b6afaa3a9c9')::NUMERIC     "Enc.Weight for height z-score",
               single_select_coded(
                       programEncounter.observations ->> 'ac397a53-f995-4405-bb98-64aade3f352b')::TEXT "Enc.Weight for Height Status",
               row_number()
               over (partition by individual.id order by programEncounter.encounter_date_time desc)    visit_number_desc,
               row_number()
               over (partition by individual.id order by programEncounter.encounter_date_time)         visit_number
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
          AND programEncounter.cancel_date_time ISNULL)

    select *,
           case
               when visit_number = 1 then true
               else false end as is_first,
           case
               when visit_number_desc = 1 then true
               else false end as is_latest,
           case
               when "Enl.program_exit_date_time" isnull then false
               else true end  as is_exited
    from encounters_with_visit_number
);

set role none;
