set role jsscp;
select * from rule where organisation_id = 42 and type = 'Checklists';
update rule set is_voided = true, last_modified_date_time = current_timestamp
    where organisation_id = 42 and type = 'Checklists';
