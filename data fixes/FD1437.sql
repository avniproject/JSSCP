-- FD1437.sql
set role jsscp;

select * from group_role; -- Notice that ids 209 and 210 are duplicates of 48 and 49

select distinct group_role_id from group_subject; --Notice that 209 and 210 are missing

delete from group_role where id in (209, 210);

commit;