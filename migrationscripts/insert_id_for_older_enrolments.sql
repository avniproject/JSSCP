set role jsscp;

with ids as (
    select upper(LEFT(coalesce(phulwari.first_name, ''), 3)) || upper(LEFT(coalesce(al.title, ''), 3)) || 'PH0' || row_number() over (order by enl.id) + 100 as enrolment_number,
           enl.id as enl_id
    from program_enrolment enl
             join individual i on enl.individual_id = i.id
             left join address_level al on i.address_id = al.id
             left join group_subject group_subject on i.id = group_subject.member_subject_id
             left join individual phulwari on phulwari.id = group_subject.group_subject_id
    where not i.is_voided
      and not enl.is_voided
      and enl.program_id = (select id from program where name = 'Phulwari')
),
     audits as (
         update program_enrolment enl set observations =
                     enl.observations || jsonb_build_object('8d18c122-45b8-4c9d-8b50-36fecbe20182', enrolment_number)
             from ids
             where ids.enl_id = enl.id
             returning enl.audit_id
     )
update audit
set last_modified_date_time = current_timestamp + (id/1000) * interval '1 millisecond'
where id in (
    select audit_id
    from audits
);

select observations ->> '8d18c122-45b8-4c9d-8b50-36fecbe20182'
from program_enrolment
where observations ->> '8d18c122-45b8-4c9d-8b50-36fecbe20182' notnull;
