---------------- For 1st dose of Insuline -----------


----------Enrolments-------

set role jsscp
;
select *
from program;---- 201 diabetes

select id,
       single_select_coded(observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7'),
       observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7',
       *
from program_enrolment
where observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7' notnull and program_id=201
;





update program_enrolment
set observations           = case
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 15
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '15')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 20
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '20')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 25
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '25')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 30
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '30')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 35
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '35')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 40
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '40')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 45
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '45')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 50
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '50')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 55
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '55')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 60
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '60')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 65
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '65')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 70
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '70')
    end
        ,
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where program_id=201 and observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7' notnull;

-----------------------ENCOUNTERS----------------


select id,
       single_select_coded(observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7'),
       observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7',
       *
from program_encounter
where observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7' notnull and encounter_type_id=728
;

select *
from encounter_type; --- 728  Diabetes Followup
select *
from concept where uuid='bb9f5b14-8887-4247-8f8c-a848310e86f7';


update program_encounter
set observations           = case
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 15
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '15')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 20
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '20')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 25
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '25')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 30
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '30')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 35
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '35')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 40
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '40')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 45
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '45')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 50
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '50')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 55
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '55')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 60
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '60')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 65
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '65')
                                 when single_select_coded(
                                                  observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7')::integer = 70
                                     then
                                     jsonb_set(observations, '{bb9f5b14-8887-4247-8f8c-a848310e86f7}',
                                               '70')
    end
        ,
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where encounter_type_id=728 and observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7' notnull
;

----------------------For 2nd dose of Insuline-----------


set role jsscp;



-------------ENROLMENTS---------

select id,
       single_select_coded(observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1'),
       observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1',
       *
from program_enrolment
where observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1' notnull and program_id=201
;





update program_enrolment
set observations           = case
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 15
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '15')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 20
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '20')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 25
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '25')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 30
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '30')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 35
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '35')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 40
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '40')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 45
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '45')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 50
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '50')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 55
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '55')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 60
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '60')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 65
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '65')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 70
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '70')
    end
        ,
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where program_id=201 and observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1' notnull;

---------------_ENCOUNTERS----------

update program_encounter
set observations           = case
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 15
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '15')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 20
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '20')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 25
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '25')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 30
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '30')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 35
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '35')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 40
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '40')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 45
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '45')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 50
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '50')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 55
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '55')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 60
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '60')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 65
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '65')
                                 when single_select_coded(
                                                  observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1')::integer = 70
                                     then
                                     jsonb_set(observations, '{c98962c7-ec44-407f-8d07-e4513ff09fb1}',
                                               '70')
    end
        ,
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where encounter_type_id=728 and observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1' notnull;



