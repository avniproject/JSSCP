insert into program_encounter (observations,
                               earliest_visit_date_time,
                               max_visit_date_time,
                               program_enrolment_id,
                               uuid,
                               version,
                               encounter_type_id,
                               name,
                               organisation_id,
                               audit_id)
select '{}'::jsonb,
       ('2020-01-' || (observations ->> 'd1985def-295c-415c-b563-310946a03762')::FLOAT)::TIMESTAMPTZ,
       ('2020-01-' || (observations ->> 'd1985def-295c-415c-b563-310946a03762')::FLOAT + 3)::TIMESTAMPTZ,
       id,
       uuid_generate_v4(),
       1,
       81,
       'Growth Monitoring Visit',
       42,
       create_audit((select id from users where username = 'dataimporter@jsscp'))
from program_enrolment where program_exit_date_time isnull
union all
select '{}'::jsonb,
       '2020-02-01'::TIMESTAMPTZ,
       '2020-02-28'::TIMESTAMPTZ,
       id,
       uuid_generate_v4(),
       1,
       80,
       'Albendazole FEB',
       42,
       create_audit((select id from users where username = 'dataimporter@jsscp'))
from program_enrolment where program_exit_date_time isnull;