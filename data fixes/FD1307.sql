set role jsscp;

select * from program_enrolment where id = 121402;

select observations from program_enrolment where id = 121402;

update program_enrolment set observations = observations || '{"c2e127a0-ddb2-4a17-b826-e7398e6e0d3c": "ANC4202"}' where id = 121402;
update audit set last_modified_date_time = now() where id =2345228;
update program_enrolment set observations = observations || '{"c2e127a0-ddb2-4a17-b826-e7398e6e0d3c": "ANC2082"}' where id = 104444;
update program_enrolment set observations = observations || '{"c2e127a0-ddb2-4a17-b826-e7398e6e0d3c": "ANC4318"}' where id = 137153;
update program_enrolment set observations = observations || '{"c2e127a0-ddb2-4a17-b826-e7398e6e0d3c": "ANC4263"}' where id = 130556;
update program_enrolment set observations = observations || '{"c2e127a0-ddb2-4a17-b826-e7398e6e0d3c": "ANC4234"}' where id = 125824;
update program_enrolment set observations = observations || '{"c2e127a0-ddb2-4a17-b826-e7398e6e0d3c": "ANC4227"}' where id = 125435;

update audit set last_modified_date_time = now() where id in (
2005033,
2830034,
2607435,
2468830,
2459896
    );


select pe.id, pe.legacy_id, pe.enrolment_date_time, a.created_date_time, a.last_modified_date_time, a.created_by_id, a.last_modified_by_id, al.title, i.first_name, i.last_name, pe.id,
       ia.identifier, pe.id, a.id, pe.observations->>'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c' from identifier_assignment ia
                                                                                                     left outer join  program_enrolment pe on ia.program_enrolment_id = pe.id
                                                                                                     left join audit a on pe.audit_id = a.id
                                                                                                     left outer join individual i on pe.individual_id = i.id
                                                                                                     left join address_level al on i.address_id = al.id
where pe.observations->>'c2e127a0-ddb2-4a17-b826-e7398e6e0d3c' is null
  and ia.program_enrolment_id is not null;
