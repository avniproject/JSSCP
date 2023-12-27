-- Here, we ensure that all rows in identifier_user_assignment have their prefixes set right
set role jsscp;
select * from identifier_source; -- 8, 33


select * from identifier_user_assignment where identifier_source_id = 33;
-- Nothing needs to be done to source id 33 because all prefixes are done right

select * from identifier_user_assignment where identifier_source_id = 8 and identifier_start not like 'ANC%';
-- Notice that many of these do not have prefixes set. 

update identifier_user_assignment set identifier_start = 'ANC' || identifier_start,
                                      identifier_end = 'ANC' || identifier_end
where identifier_source_id = 8 and identifier_start not like 'ANC%';
-- 11 rows updated


-- Verify that everything is in order
select * from identifier_user_assignment where identifier_source_id = 8 and identifier_start not like 'ANC%';
select * from identifier_user_assignment where identifier_source_id = 8;
