set role jsscp;

-- Observation to move from individual to program_enrolment
-- Birth Order
-- Father's Occupation
-- Father's Education
-- Mother's Occupation
-- Mother's Education
-- Land possession
-- Land area
-- Type of residence
-- Economic Status
-- Any property?
-- Other property
with individual_data as (select id            as ind_id,
                                jsonb_strip_nulls(json_build_object(
                                        '821ba930-505c-4fd3-9f24-66b60ed45bac',
                                        observations -> '821ba930-505c-4fd3-9f24-66b60ed45bac',
                                        'bf564151-63f9-4176-917f-f37de34b9bae',
                                        observations -> 'bf564151-63f9-4176-917f-f37de34b9bae',
                                        'b1001c4d-0449-464a-947f-a04c4fdcc651',
                                        observations -> 'b1001c4d-0449-464a-947f-a04c4fdcc651',
                                        'ea760e4f-c12f-490b-9865-9c6e4510ce64',
                                        observations -> 'ea760e4f-c12f-490b-9865-9c6e4510ce64',
                                        'd98aae1a-ce33-4e51-b031-66e13bc0ba11',
                                        observations -> 'd98aae1a-ce33-4e51-b031-66e13bc0ba11',
                                        'b984ad33-05d8-4621-adf3-152e72a0db1b',
                                        observations -> 'b984ad33-05d8-4621-adf3-152e72a0db1b',
                                        '430ebb19-831d-470d-80eb-7969814f13e4',
                                        observations -> '430ebb19-831d-470d-80eb-7969814f13e4',
                                        'c5d2673b-0f5c-48bf-93e4-f1a1ae820732',
                                        observations -> 'c5d2673b-0f5c-48bf-93e4-f1a1ae820732',
                                        '0c0fc0ee-47ec-4187-9f36-3476f7b67d47',
                                        observations -> '0c0fc0ee-47ec-4187-9f36-3476f7b67d47',
                                        'aa88dba4-4f5d-4d35-9dc1-2390969cc5f3',
                                        observations -> 'aa88dba4-4f5d-4d35-9dc1-2390969cc5f3',
                                        '32609e0f-f3c8-4dcb-af7c-5e8a96e8e89d',
                                        observations -> '32609e0f-f3c8-4dcb-af7c-5e8a96e8e89d'
                                    )::jsonb) as obs_to_migrate
                         from individual),
     audits as (
         update program_enrolment set observations =
                     observations || (select obs_to_migrate from individual_data i where i.ind_id = individual_id)
             returning audit_id
     )
update audit
set last_modified_date_time = current_timestamp,
    last_modified_by_id     = (select id from users where username = 'dataimporter@jsscp')
where audit.id in (select audit_id from audits);
