with audits as (update program_encounter
    set earliest_visit_date_time = ('2020-03-25')::timestamptz,
        max_visit_date_time = ('2020-03-28')::timestamptz
    where id=468400
    returning audit_id)
update audit set last_modified_date_time=current_timestamp,
                 last_modified_by_id=(select id from users where username = 'admin@jsscp')
where id in (select audit_id from audits);

with audits as (update program_encounter
    set earliest_visit_date_time = ('2020-02-01')::timestamptz,
        max_visit_date_time = ('2020-02-28')::timestamptz,
        name ='Albendazole FEB'
    where id=425633
    returning audit_id)
update audit set last_modified_date_time=current_timestamp,
                 last_modified_by_id=(select id from users where username = 'admin@jsscp')
where id in (select audit_id from audits);