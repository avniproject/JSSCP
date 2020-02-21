set role jsscp;

with enlrolment_data as(select *, split_part((enl.observations ->> 'd1985def-295c-415c-b563-310946a03762'), '.' , 1)::numeric as day from program_enrolment enl where not enl.is_voided
  and enl.program_exit_date_time isnull
  and enl.enrolment_date_time < ('2019-11-01')::timestamptz)
insert into program_encounter (observations,
                               earliest_visit_date_time,
                               max_visit_date_time,
                               program_enrolment_id,
                               uuid,
                               version,
                               encounter_type_id,
                               name,
                               cancel_observations,
                               organisation_id,
                               audit_id)
select '{}'::jsonb,
       concat('11-', enl.day,'-2019')::timestamptz,
       concat('11-',enl.day,'-2019')::timestamptz + interval '3' day,
       enl.id,
       uuid_generate_v4(),
       0,
       81,
       'Growth Monitoring Visit',
       '{}'::jsonb,
       42,
       create_audit((select id from users where username = 'admin@jsscp'))
from enlrolment_data enl where not enl.is_voided and enl.program_exit_date_time isnull and enl.enrolment_date_time < ('2019-11-01')::timestamptz
union
select '{}'::jsonb,
       concat('12-',enl.day,'-2019')::timestamptz,
       concat('12-',enl.day,'-2019')::timestamptz + interval '3' day,
       enl.id,
       uuid_generate_v4(),
       0,
       81,
       'Growth Monitoring Visit',
       '{}'::jsonb,
       42,
       create_audit((select id from users where username = 'admin@jsscp'))
from enlrolment_data enl where not enl.is_voided  and enl.program_exit_date_time isnull and enl.enrolment_date_time < ('2019-11-01')::timestamptz;
