set role jsscp;

--Register the Phulwaris
insert into individual (uuid, address_id, observations, version, registration_date, organisation_id, first_name,
                        audit_id, subject_type_id, date_of_birth_verified, is_voided)

select distinct on (enl.observations ->> '178acfbe-b7e1-4ef5-a48a-0f4b1beabb80', child.address_id) uuid_generate_v4(),
                                                                                                   child.address_id,
                                                                                                   jsonb_build_object('d1985def-295c-415c-b563-310946a03762',
                                                                                                                      (enl.observations ->> 'd1985def-295c-415c-b563-310946a03762')::numeric),
                                                                                                   0,
                                                                                                   now()::date,
                                                                                                   (select id from organisation where name = 'JSSCP'),
                                                                                                   single_select_coded(
                                                                                                               enl.observations ->> '178acfbe-b7e1-4ef5-a48a-0f4b1beabb80'),
                                                                                                   (create_audit((select id from users where username = 'dataimporter@jsscp'::text))),
                                                                                                   (select id from subject_type where name = 'Phulwari'),
                                                                                                   false,
                                                                                                   false
from program_enrolment enl
         join individual child on enl.individual_id = child.id
         join address_level village on village.id = child.address_id
         left join individual phulwari on phulwari.first_name = single_select_coded(
            enl.observations ->> '178acfbe-b7e1-4ef5-a48a-0f4b1beabb80')
    and phulwari.address_id = child.address_id
where enl.observations ->> '178acfbe-b7e1-4ef5-a48a-0f4b1beabb80' notnull
  and enl.program_id = (select id from program where name = 'Phulwari')
  and phulwari.id isnull
  and not enl.is_voided
  and not child.is_voided;

--Next we need to add children to their respective phulwari group

-- these many entries(members) will be done in the group subject table
select count(*)
from program_enrolment enl
         join individual i on enl.individual_id = i.id
where enl.observations ->> '178acfbe-b7e1-4ef5-a48a-0f4b1beabb80' notnull
  and program_exit_date_time isnull
  and not enl.is_voided
  and not i.is_voided
  and individual_id not in (select member_subject_id from group_subject where not group_subject.is_voided);

---MIGRATION SCRIPT-------
--Add the members to the Phulwari group
insert into group_subject(uuid, group_subject_id, member_subject_id, group_role_id, membership_start_date,
                          organisation_id, audit_id, version)
select distinct on (child.id)
       uuid_generate_v4(),
       phulwari.id,
       child.id,
       (select gr.id from group_role gr where gr.role = 'Phulwari Child'),
       current_timestamp,
       (select id from organisation where name = 'JSSCP'),
       create_audit((select id from users where username = 'dataimporter@jsscp')),
       0
from program_enrolment enl
         join individual child on enl.individual_id = child.id
         join individual phulwari
              on phulwari.first_name = single_select_coded(enl.observations ->> '178acfbe-b7e1-4ef5-a48a-0f4b1beabb80')
where program_id = (select id from program where name = 'Phulwari')
  and child.subject_type_id = (select id from subject_type where name = 'Individual')
  and phulwari.subject_type_id = (select id from subject_type where name = 'Phulwari')
  and child.id not in (select member_subject_id from group_subject where not group_subject.is_voided)
  and phulwari.address_id = child.address_id
  and program_exit_date_time isnull
  and not enl.is_voided
  and not child.is_voided
  and not phulwari.is_voided;

--Check the count there should be 0 such child now
select count(*)
from program_enrolment enl
         join individual i on enl.individual_id = i.id
where enl.observations ->> '178acfbe-b7e1-4ef5-a48a-0f4b1beabb80' notnull
  and program_exit_date_time isnull
  and not enl.is_voided
  and not i.is_voided
  and individual_id not in (select member_subject_id from group_subject where not group_subject.is_voided);

