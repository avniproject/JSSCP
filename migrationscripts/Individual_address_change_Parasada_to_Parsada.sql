set role jsscp;
update individual
set address_id=9947,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time=current_timestamp + ((id % 4000) * interval '1 millisecond')

where address_id = 7910;
