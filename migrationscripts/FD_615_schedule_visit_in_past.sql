
with all_nov_data as (select *,
                             split_part((enl.observations ->> 'd1985def-295c-415c-b563-310946a03762'), '.',
                                        1)::numeric as day
                      from program_enrolment enl
                      where not enl.is_voided
                        and enl.program_exit_date_time isnull
                        and enl.enrolment_date_time < ('2019-11-01')::timestamptz),
     nov_individuals_with_visit as (
         select pe.individual_id
         from program_enrolment pe
                  join program_encounter p on pe.id = p.program_enrolment_id
         where not pe.is_voided
           and pe.program_exit_date_time isnull
           and pe.enrolment_date_time < ('2019-11-01')::timestamptz
           and p.encounter_type_id = 81
           and extract(year from p.earliest_visit_date_time) = 2019
           and extract(month from p.earliest_visit_date_time) = 11
     ),
     nov_individual_with_no_visit as (
         select * from all_nov_data where individual_id not in ((select individual_id from nov_individuals_with_visit))
     ),
     all_dec_data as (select *,
                             split_part((enl.observations ->> 'd1985def-295c-415c-b563-310946a03762'), '.',
                                        1)::numeric as day
                      from program_enrolment enl
                      where not enl.is_voided
                        and enl.program_exit_date_time isnull
                        and enl.enrolment_date_time < ('2019-11-01')::timestamptz),
     dec_individuals_with_visit as (
         select pe.individual_id
         from program_enrolment pe
                  join program_encounter p on pe.id = p.program_enrolment_id
         where not pe.is_voided
           and pe.program_exit_date_time isnull
           and pe.enrolment_date_time < ('2019-11-01')::timestamptz
           and p.encounter_type_id = 81
           and extract(year from p.earliest_visit_date_time) = 2019
           and extract(month from p.earliest_visit_date_time) = 12
     ),
     dec_individual_with_no_visit as (
         select * from all_dec_data where individual_id not in ((select individual_id from dec_individuals_with_visit))
     )
insert
into program_encounter (observations,
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
       concat('11-', enl.day, '-2019')::timestamptz,
       concat('11-', enl.day, '-2019')::timestamptz + interval '3' day,
       enl.id,
       uuid_generate_v4(),
       0,
       81,
       'Growth Monitoring Visit',
       '{}'::jsonb,
       42,
       create_audit((select id from users where username = 'admin@jsscp'))
from nov_individual_with_no_visit enl
where not enl.is_voided
  and enl.program_exit_date_time isnull
  and enl.enrolment_date_time < ('2019-11-01')::timestamptz
union
select '{}'::jsonb,
       concat('12-', enl.day, '-2019')::timestamptz,
       concat('12-', enl.day, '-2019')::timestamptz + interval '3' day,
       enl.id,
       uuid_generate_v4(),
       0,
       81,
       'Growth Monitoring Visit',
       '{}'::jsonb,
       42,
       create_audit((select id from users where username = 'admin@jsscp'))
from dec_individual_with_no_visit enl
where not enl.is_voided
  and enl.program_exit_date_time isnull
  and enl.enrolment_date_time < ('2019-11-01')::timestamptz;



with all_visit_count as (select p.program_enrolment_id as enl_id, count(p.id)
                         from individual i
                                  join program_enrolment pe on i.id = pe.individual_id
                                  join program_encounter p on pe.id = p.program_enrolment_id
                         where not pe.is_voided
                           and pe.program_exit_date_time isnull
                           and pe.enrolment_date_time < ('2019-11-01')::timestamptz
                           and p.encounter_type_id = 81
                           and p.cancel_date_time is null
                           and p.encounter_date_time is null
                         group by 1),
     encounter as (select *
                   from program_encounter
                   where program_enrolment_id in (select enl_id from all_visit_count where count = 2)
                     and encounter_type_id = 81
                     and cancel_date_time is null
                     and encounter_date_time is null
     ),
     partition_encounter as (select *,
                                    id as                                                                       encounter_id,
                                    row_number()
                                    over (partition by program_enrolment_id order by encounter_date_time desc ) rank
                             from encounter),
     audits as (update program_encounter
         set is_voided = true
         where id in (select encounter_id from partition_encounter where rank = 1)
         returning audit_id)
update audit
set last_modified_date_time = current_timestamp,
    last_modified_by_id     = (select id from users where username = 'admin@jsscp')
where id in (select audit_id from audits);