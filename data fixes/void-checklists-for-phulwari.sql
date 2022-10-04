set role jsscp;
begin transaction;
update checklist set is_voided = true, last_modified_date_time = current_timestamp + (id * interval '1 millisecond'), last_modified_by_id = 4186
where id in (
    select checklist.id from checklist
                                 join program_enrolment on checklist.program_enrolment_id = program_enrolment.id
    where checklist.organisation_id = 42 and program_enrolment.program_id = 12 and checklist.is_voided = false
);

update checklist_item set is_voided = true, last_modified_date_time = current_timestamp + (id * interval '1 millisecond'), last_modified_by_id = 4186
where id in (
    select checklist_item.id from checklist_item
                                      join checklist on checklist_item.checklist_id = checklist.id
                                      join program_enrolment on checklist.program_enrolment_id = program_enrolment.id
    where checklist.organisation_id = 42 and program_enrolment.program_id = 12 and checklist_item.is_voided = false
);
commit;
