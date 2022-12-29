set role jsscp;



--------Query to get observations with square brackets ----------------------

select id,

       created_date_time,
       last_modified_date_time,
       last_modified_by_id,
       individual_id,
--        observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7',
--        observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1',
--        observations ->> '92671321-abb8-48f8-922a-e18bc4573dde',
--        observations ->> 'd9dfcc36-7caa-4a3a-a9be-d4d4e8487a9d',
       observations ->> '35c8047b-2a33-49ff-a784-2bbd8262c593',
       observations ->> '12f07672-2062-4c14-9a50-71b80bf4f1d2',
       observations ->> '38489a0c-288a-48e5-b11b-f37dacb2ab2a',
       observations ->> 'f5f9be92-48af-48e7-864b-0fba6ddebcbd',
       observations ->> '98c18ba8-fb28-464d-9f4d-6a9de45d3d52',
       observations ->> 'b2743caa-27af-4558-892b-ca4f9a300f7d',
       observations ->> '7c8f1f32-c436-428b-bd9d-1f7ea47d010e',
       observations ->> 'f7c32b97-8223-46ad-806e-670b5841b7bc',
       observations ->> 'bb565c11-6734-4fa8-b414-7f380a81505a',
       observations ->> 'dc0c8fed-5bad-43f4-af27-5c141850b169',
       observations ->> 'e4fcbd27-8b23-46ba-a59e-1aed275f690b',
       observations ->> '8d0a9149-a1a6-4deb-89b9-dcbdfa21fa04',
       observations ->> '5bd89916-3af1-4af7-a79e-9fc795a7c475',
       observations ->> '9b8e1c45-8286-4ad3-b20e-bfae7d3e212e',
       observations ->> '95ca8c1b-c012-428b-83d8-c9a210e19d57',
       observations ->> 'd38544e2-77f3-4f83-ac43-db76e38593b6',
       observations ->> 'a1f42a41-31e2-4522-9901-56d691299a50',
       observations ->> '884b130f-bc81-458a-be2e-07b057cfffe7',
       observations ->> '7c782fc9-f4df-468b-8733-850c33bf96b5',
       observations ->> 'e2498029-fab8-4a47-9d2e-044476fee99f',
       observations ->> '6f7f693c-c892-4cc1-b40a-328b61043e84',
       observations ->> 'f54d53c1-bee2-4db5-8c42-a1e5c1d3a886',
       observations ->> 'a798eba4-1913-46c1-a7dd-a637c72b6dec',
       observations ->> '92613f0f-2455-4cc7-83de-a789b5496b37',
       observations ->> '478caac9-3fba-4fe3-809a-d2d11fdb64d6',
       observations ->> '04459837-ec31-4a40-aed3-d721ab0c8a7a',
       observations ->> '8ec036a6-3c01-4fb1-b704-3ce2e4c032f8',
       observations ->> '8e7106bd-d9ab-48e4-8200-60707101f34f',
       observations ->> '42c7dc3a-8600-4a56-90b6-09d66ae06c8a',
       observations ->> '26f7e262-0db8-4eca-8129-69db3f8b726c',
       observations ->> '36cf7448-d3a6-410f-91f1-f7d8c66395dc',
       observations ->> '77fe272b-9dd1-4593-bd91-7fbe70f6c9e4',
       observations ->> '6fa57b52-ab30-4ec4-be2e-4f1d324cb3a1',
       observations ->> '3c569e77-d6df-4e91-bbc0-45a4f07c208b',
       observations ->> 'ec0e7aad-d67e-44c4-a6eb-a37f7ceddc59',
       observations ->> '01a78d61-5cde-4b37-bb99-fdc1d58e1af1',
       observations ->> '17d3ca96-f549-4889-99be-87fee2aec17f',
       observations ->> '95c763e2-7be1-48d0-8f34-a8c470b4013a',
       observations ->> '0d235663-7a1e-40c5-8691-ac2af61a3112',
       observations ->> '5f7e5069-2ec5-4a0f-af7a-c91a38df72e5',
       observations ->> '902f7ee0-8795-4d0f-8d97-bdde904818ef',
       observations ->> '21ea761f-9b8d-4cc1-8a35-7d71ba2e5e56',
       observations ->> '1f725c69-45f4-4db5-9075-19cf59a23f4e',
       observations ->> 'c74fd564-30b7-4b4b-a7e7-b93cb189f359',
       observations ->> '2e827b9e-76cb-45bd-8207-a85653d6f4af',
       observations ->> 'c7e529b0-fa29-4991-bccd-c0b852d2407a',
       observations ->> 'a39b4ddf-48ef-4dd9-9822-99df97f156f5',
       observations ->> '744a2050-a0f0-4018-86df-60aec8dbdf04',
       observations ->> '174b4a7a-4922-4ddf-bac3-2df700791320',
       observations ->> 'fd6f2d07-04f0-4a4b-b04d-402f14da636b',
       observations ->> 'a1ed40d7-08f0-44c4-ba1e-d0f2f92986eb',
       observations ->> '783b44ef-be94-4f67-930e-80793adeec7b',
       observations ->> '41c27748-f777-43ca-87b3-10551ed560bd',
       observations ->> '257c8daf-b647-452d-bf43-612ab1e31f6e',
       observations ->> 'fe231d34-1762-428d-bb4c-0b3399d2e3f8',
       observations ->> 'e864bbe7-8c60-455e-b91f-85c3a9fe8a74',
       observations ->> '56e2a5ce-fad7-4c2d-8c5e-892448aad876',
       observations ->> '4a2eae52-229d-4e15-a4eb-908303120f3e',
       observations ->> '9cdc9acd-a385-4513-8652-a4ee09408c28',
       observations ->> 'b0c90bb5-de77-4e63-b842-13202195b9ad',
       observations ->> 'e35f569b-6fbf-493d-8b89-032733b4b12e',
       observations ->> 'f89af677-d4c1-41e2-b04e-85fcb89c3d00',
       observations ->> '06204082-7709-41af-9207-d38820262624',
       observations ->> '5e319446-80eb-499b-bac7-5687f34609ce',
       observations ->> '79ac62a8-4355-4fe8-ad6f-beb5b4faa5c7',
       observations ->> '3e1af70f-fb41-4276-a599-0405a4cb13fd',
       observations ->> '0b8c3332-7807-4198-a9af-3b21297fff18',
       observations ->> '4aab6b40-dfc4-4bcb-b413-36689b651a42',
       observations ->> 'f91a06d7-69c5-443f-b97e-60bb981afca7',
       observations ->> 'af513564-2a90-4ae5-b778-a06a3ea92837',
       observations ->> 'c633aee6-6792-4b25-9fd8-dcb018d2a655',
       observations ->> '7866634b-f02b-402f-85d3-cf52965b9149',
       observations ->> '8af0e4cd-5669-42ad-8df5-4fc7e36705e9',
       observations ->> '38da7b7f-01e0-46c5-b6f5-860a1fc7b781',
       observations ->> 'b2d9f5a1-3483-4853-8d2e-27b0b03446ab',
       observations ->> '8d39dc3f-2d89-4e1f-a2d9-8b7ef0881857',
       observations ->> '8875748b-f3d0-4087-af72-829f2835a078',
       observations ->> '614f6b4f-e2c6-4742-9ec7-e645c106e336',
       observations ->> 'f1a5256b-a914-4f82-9c34-e231024dd6cc',
       observations ->> 'f5dfe184-1cd7-4193-8a54-6a90119e5254',
       observations ->> '15fd7ab6-7c71-4265-b2c2-a504ace84758',
       observations ->> '9ebe6fc3-10e0-4669-b8c0-ac2c6109b223',
       observations ->> '1f7bca76-2e88-434d-84d4-41b66cdcba84',
       observations ->> '95b86823-329e-4cc8-8d97-d477d7fc0cc0',
       observations ->> '2b22c914-d355-49b0-833e-21125ab0c430',
       observations ->> '5cd8d685-030c-45c8-aa20-cd169ea0dd6f',
       observations ->> 'a173836e-a0f8-4210-bc02-06aeebef2e8b',
       observations ->> 'b3ae0b19-a4b1-4a80-aba4-510bef92fc6b',
       observations ->> '0da77abb-d8ab-4aa1-9b4d-34ec2e81d14a',
       observations ->> '1fc6f193-1dd7-4def-99ca-876c2b735918',
       observations ->> 'a73e120f-86b1-4cb9-9a04-4733b734c8ec',
       observations ->> 'a180507a-03aa-40bb-bd52-8ba15c197737',
       observations ->> 'ead21767-26dc-47bc-a29c-d4881ff99698',
       observations ->> '73682180-cc42-4742-b27a-7b5177a80223'


from program_encounter

where observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7' like '%[%'
   or observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1' like '%[%'
   or observations ->> '92671321-abb8-48f8-922a-e18bc4573dde' like '%[%'
   or observations ->> 'd9dfcc36-7caa-4a3a-a9be-d4d4e8487a9d' like '%[%'
   or observations ->> '35c8047b-2a33-49ff-a784-2bbd8262c593' like '%[%'
   or observations ->> '12f07672-2062-4c14-9a50-71b80bf4f1d2' like '%[%'
   or observations ->> '38489a0c-288a-48e5-b11b-f37dacb2ab2a' like '%[%'
   or observations ->> 'f5f9be92-48af-48e7-864b-0fba6ddebcbd' like '%[%'
   or observations ->> '98c18ba8-fb28-464d-9f4d-6a9de45d3d52' like '%[%'
   or observations ->> 'b2743caa-27af-4558-892b-ca4f9a300f7d' like '%[%'
   or observations ->> '7c8f1f32-c436-428b-bd9d-1f7ea47d010e' like '%[%'
   or observations ->> 'f7c32b97-8223-46ad-806e-670b5841b7bc' like '%[%'
   or observations ->> 'bb565c11-6734-4fa8-b414-7f380a81505a' like '%[%'
   or observations ->> 'dc0c8fed-5bad-43f4-af27-5c141850b169' like '%[%'
   or observations ->> 'e4fcbd27-8b23-46ba-a59e-1aed275f690b' like '%[%'
   or observations ->> '8d0a9149-a1a6-4deb-89b9-dcbdfa21fa04' like '%[%'
   or observations ->> '5bd89916-3af1-4af7-a79e-9fc795a7c475' like '%[%'
   or observations ->> '9b8e1c45-8286-4ad3-b20e-bfae7d3e212e' like '%[%'
   or observations ->> '95ca8c1b-c012-428b-83d8-c9a210e19d57' like '%[%'
   or observations ->> 'd38544e2-77f3-4f83-ac43-db76e38593b6' like '%[%'
   or observations ->> 'a1f42a41-31e2-4522-9901-56d691299a50' like '%[%'
   or observations ->> '884b130f-bc81-458a-be2e-07b057cfffe7' like '%[%'
   or observations ->> '7c782fc9-f4df-468b-8733-850c33bf96b5' like '%[%'
   or observations ->> 'e2498029-fab8-4a47-9d2e-044476fee99f' like '%[%'
   or observations ->> '6f7f693c-c892-4cc1-b40a-328b61043e84' like '%[%'
   or observations ->> 'f54d53c1-bee2-4db5-8c42-a1e5c1d3a886' like '%[%'
   or observations ->> 'a798eba4-1913-46c1-a7dd-a637c72b6dec' like '%[%'
   or observations ->> '92613f0f-2455-4cc7-83de-a789b5496b37' like '%[%'
   or observations ->> '478caac9-3fba-4fe3-809a-d2d11fdb64d6' like '%[%'
   or observations ->> '04459837-ec31-4a40-aed3-d721ab0c8a7a' like '%[%'
   or observations ->> '8ec036a6-3c01-4fb1-b704-3ce2e4c032f8' like '%[%'
   or observations ->> '8e7106bd-d9ab-48e4-8200-60707101f34f' like '%[%'
   or observations ->> '42c7dc3a-8600-4a56-90b6-09d66ae06c8a' like '%[%'
   or observations ->> '26f7e262-0db8-4eca-8129-69db3f8b726c' like '%[%'
   or observations ->> '36cf7448-d3a6-410f-91f1-f7d8c66395dc' like '%[%'
   or observations ->> '77fe272b-9dd1-4593-bd91-7fbe70f6c9e4' like '%[%'
   or observations ->> '6fa57b52-ab30-4ec4-be2e-4f1d324cb3a1' like '%[%'
   or observations ->> '3c569e77-d6df-4e91-bbc0-45a4f07c208b' like '%[%'
   or observations ->> 'ec0e7aad-d67e-44c4-a6eb-a37f7ceddc59' like '%[%'
   or observations ->> '01a78d61-5cde-4b37-bb99-fdc1d58e1af1' like '%[%'
   or observations ->> '17d3ca96-f549-4889-99be-87fee2aec17f' like '%[%'
   or observations ->> '95c763e2-7be1-48d0-8f34-a8c470b4013a' like '%[%'
   or observations ->> '0d235663-7a1e-40c5-8691-ac2af61a3112' like '%[%'
   or observations ->> '5f7e5069-2ec5-4a0f-af7a-c91a38df72e5' like '%[%'
   or observations ->> '902f7ee0-8795-4d0f-8d97-bdde904818ef' like '%[%'
   or observations ->> '21ea761f-9b8d-4cc1-8a35-7d71ba2e5e56' like '%[%'
   or observations ->> '1f725c69-45f4-4db5-9075-19cf59a23f4e' like '%[%'
   or observations ->> 'c74fd564-30b7-4b4b-a7e7-b93cb189f359' like '%[%'
   or observations ->> '2e827b9e-76cb-45bd-8207-a85653d6f4af' like '%[%'
   or observations ->> 'c7e529b0-fa29-4991-bccd-c0b852d2407a' like '%[%'
   or observations ->> 'a39b4ddf-48ef-4dd9-9822-99df97f156f5' like '%[%'
   or observations ->> '744a2050-a0f0-4018-86df-60aec8dbdf04' like '%[%'
   or observations ->> '174b4a7a-4922-4ddf-bac3-2df700791320' like '%[%'
   or observations ->> 'fd6f2d07-04f0-4a4b-b04d-402f14da636b' like '%[%'
   or observations ->> 'a1ed40d7-08f0-44c4-ba1e-d0f2f92986eb' like '%[%'
   or observations ->> '783b44ef-be94-4f67-930e-80793adeec7b' like '%[%'
   or observations ->> '41c27748-f777-43ca-87b3-10551ed560bd' like '%[%'
   or observations ->> '257c8daf-b647-452d-bf43-612ab1e31f6e' like '%[%'
   or observations ->> 'fe231d34-1762-428d-bb4c-0b3399d2e3f8' like '%[%'
   or observations ->> 'e864bbe7-8c60-455e-b91f-85c3a9fe8a74' like '%[%'
   or observations ->> '56e2a5ce-fad7-4c2d-8c5e-892448aad876' like '%[%'
   or observations ->> '4a2eae52-229d-4e15-a4eb-908303120f3e' like '%[%'
   or observations ->> '9cdc9acd-a385-4513-8652-a4ee09408c28' like '%[%'
   or observations ->> 'b0c90bb5-de77-4e63-b842-13202195b9ad' like '%[%'
   or observations ->> 'e35f569b-6fbf-493d-8b89-032733b4b12e' like '%[%'
   or observations ->> 'f89af677-d4c1-41e2-b04e-85fcb89c3d00' like '%[%'
   or observations ->> '06204082-7709-41af-9207-d38820262624' like '%[%'
   or observations ->> '5e319446-80eb-499b-bac7-5687f34609ce' like '%[%'
   or observations ->> '79ac62a8-4355-4fe8-ad6f-beb5b4faa5c7' like '%[%'
   or observations ->> '3e1af70f-fb41-4276-a599-0405a4cb13fd' like '%[%'
   or observations ->> '0b8c3332-7807-4198-a9af-3b21297fff18' like '%[%'
   or observations ->> '4aab6b40-dfc4-4bcb-b413-36689b651a42' like '%[%'
   or observations ->> 'f91a06d7-69c5-443f-b97e-60bb981afca7' like '%[%'
   or observations ->> 'af513564-2a90-4ae5-b778-a06a3ea92837' like '%[%'
   or observations ->> 'c633aee6-6792-4b25-9fd8-dcb018d2a655' like '%[%'
   or observations ->> '7866634b-f02b-402f-85d3-cf52965b9149' like '%[%'
   or observations ->> '8af0e4cd-5669-42ad-8df5-4fc7e36705e9' like '%[%'
   or observations ->> '38da7b7f-01e0-46c5-b6f5-860a1fc7b781' like '%[%'
   or observations ->> 'b2d9f5a1-3483-4853-8d2e-27b0b03446ab' like '%[%'
   or observations ->> '8d39dc3f-2d89-4e1f-a2d9-8b7ef0881857' like '%[%'
   or observations ->> '8875748b-f3d0-4087-af72-829f2835a078' like '%[%'
   or observations ->> '614f6b4f-e2c6-4742-9ec7-e645c106e336' like '%[%'
   or observations ->> 'f1a5256b-a914-4f82-9c34-e231024dd6cc' like '%[%'
   or observations ->> 'f5dfe184-1cd7-4193-8a54-6a90119e5254' like '%[%'
   or observations ->> '15fd7ab6-7c71-4265-b2c2-a504ace84758' like '%[%'
   or observations ->> '9ebe6fc3-10e0-4669-b8c0-ac2c6109b223' like '%[%'
   or observations ->> '1f7bca76-2e88-434d-84d4-41b66cdcba84' like '%[%'
   or observations ->> '95b86823-329e-4cc8-8d97-d477d7fc0cc0' like '%[%'
   or observations ->> '2b22c914-d355-49b0-833e-21125ab0c430' like '%[%'
   or observations ->> '5cd8d685-030c-45c8-aa20-cd169ea0dd6f' like '%[%'
   or observations ->> 'a173836e-a0f8-4210-bc02-06aeebef2e8b' like '%[%'
   or observations ->> 'b3ae0b19-a4b1-4a80-aba4-510bef92fc6b' like '%[%'
   or observations ->> '0da77abb-d8ab-4aa1-9b4d-34ec2e81d14a' like '%[%'
   or observations ->> '1fc6f193-1dd7-4def-99ca-876c2b735918' like '%[%'
   or observations ->> 'a73e120f-86b1-4cb9-9a04-4733b734c8ec' like '%[%'
   or observations ->> 'a180507a-03aa-40bb-bd52-8ba15c197737' like '%[%'
   or observations ->> 'ead21767-26dc-47bc-a29c-d4881ff99698' like '%[%'
   or observations ->> '73682180-cc42-4742-b27a-7b5177a80223' like '%[%';






   ---------------------------Update query ------------------------

update openchs.public.program_encounter
set observations           = observations || json_build_object('bb9f5b14-8887-4247-8f8c-a848310e86f7',
                                                               replace(
                                                                       btrim(observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'bb9f5b14-8887-4247-8f8c-a848310e86f7' like '%[%';--0
update openchs.public.program_encounter
set observations           = observations || json_build_object('c98962c7-ec44-407f-8d07-e4513ff09fb1',
                                                               replace(
                                                                       btrim(observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'c98962c7-ec44-407f-8d07-e4513ff09fb1' like '%[%';--0

update openchs.public.program_encounter
set observations           = observations || json_build_object('92671321-abb8-48f8-922a-e18bc4573dde',
                                                               replace(
                                                                       btrim(observations ->> '92671321-abb8-48f8-922a-e18bc4573dde', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '92671321-abb8-48f8-922a-e18bc4573dde' like '%[%';--


update openchs.public.program_encounter
set observations           = observations || json_build_object('d9dfcc36-7caa-4a3a-a9be-d4d4e8487a9d',
                                                               replace(
                                                                       btrim(observations ->> 'd9dfcc36-7caa-4a3a-a9be-d4d4e8487a9d', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'd9dfcc36-7caa-4a3a-a9be-d4d4e8487a9d' like '%[%';



update openchs.public.program_encounter
set observations           = observations || json_build_object('35c8047b-2a33-49ff-a784-2bbd8262c593',
                                                               replace(
                                                                       btrim(observations ->> '35c8047b-2a33-49ff-a784-2bbd8262c593', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '35c8047b-2a33-49ff-a784-2bbd8262c593' like '%[%';
-------------------------------------

update openchs.public.program_encounter
set observations           = observations || json_build_object('35c8047b-2a33-49ff-a784-2bbd8262c593',
                                                               replace(
                                                                       btrim(observations ->> '35c8047b-2a33-49ff-a784-2bbd8262c593', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '35c8047b-2a33-49ff-a784-2bbd8262c593' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('12f07672-2062-4c14-9a50-71b80bf4f1d2',
                                                               replace(
                                                                       btrim(observations ->> '12f07672-2062-4c14-9a50-71b80bf4f1d2', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '12f07672-2062-4c14-9a50-71b80bf4f1d2' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('38489a0c-288a-48e5-b11b-f37dacb2ab2a',
                                                               replace(
                                                                       btrim(observations ->> '38489a0c-288a-48e5-b11b-f37dacb2ab2a', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '38489a0c-288a-48e5-b11b-f37dacb2ab2a' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('f5f9be92-48af-48e7-864b-0fba6ddebcbd',
                                                               replace(
                                                                       btrim(observations ->> 'f5f9be92-48af-48e7-864b-0fba6ddebcbd', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'f5f9be92-48af-48e7-864b-0fba6ddebcbd' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('98c18ba8-fb28-464d-9f4d-6a9de45d3d52',
                                                               replace(
                                                                       btrim(observations ->> '98c18ba8-fb28-464d-9f4d-6a9de45d3d52', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '98c18ba8-fb28-464d-9f4d-6a9de45d3d52' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('b2743caa-27af-4558-892b-ca4f9a300f7d',
                                                               replace(
                                                                       btrim(observations ->> 'b2743caa-27af-4558-892b-ca4f9a300f7d', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'b2743caa-27af-4558-892b-ca4f9a300f7d' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('7c8f1f32-c436-428b-bd9d-1f7ea47d010e',
                                                               replace(
                                                                       btrim(observations ->> '7c8f1f32-c436-428b-bd9d-1f7ea47d010e', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '7c8f1f32-c436-428b-bd9d-1f7ea47d010e' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('f7c32b97-8223-46ad-806e-670b5841b7bc',
                                                               replace(
                                                                       btrim(observations ->> 'f7c32b97-8223-46ad-806e-670b5841b7bc', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'f7c32b97-8223-46ad-806e-670b5841b7bc' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('bb565c11-6734-4fa8-b414-7f380a81505a',
                                                               replace(
                                                                       btrim(observations ->> 'bb565c11-6734-4fa8-b414-7f380a81505a', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'bb565c11-6734-4fa8-b414-7f380a81505a' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('dc0c8fed-5bad-43f4-af27-5c141850b169',
                                                               replace(
                                                                       btrim(observations ->> 'dc0c8fed-5bad-43f4-af27-5c141850b169', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'dc0c8fed-5bad-43f4-af27-5c141850b169' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('e4fcbd27-8b23-46ba-a59e-1aed275f690b',
                                                               replace(
                                                                       btrim(observations ->> 'e4fcbd27-8b23-46ba-a59e-1aed275f690b', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'e4fcbd27-8b23-46ba-a59e-1aed275f690b' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('8d0a9149-a1a6-4deb-89b9-dcbdfa21fa04',
                                                               replace(
                                                                       btrim(observations ->> '8d0a9149-a1a6-4deb-89b9-dcbdfa21fa04', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '8d0a9149-a1a6-4deb-89b9-dcbdfa21fa04' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('5bd89916-3af1-4af7-a79e-9fc795a7c475',
                                                               replace(
                                                                       btrim(observations ->> '5bd89916-3af1-4af7-a79e-9fc795a7c475', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '5bd89916-3af1-4af7-a79e-9fc795a7c475' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('9b8e1c45-8286-4ad3-b20e-bfae7d3e212e',
                                                               replace(
                                                                       btrim(observations ->> '9b8e1c45-8286-4ad3-b20e-bfae7d3e212e', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '9b8e1c45-8286-4ad3-b20e-bfae7d3e212e' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('95ca8c1b-c012-428b-83d8-c9a210e19d57',
                                                               replace(
                                                                       btrim(observations ->> '95ca8c1b-c012-428b-83d8-c9a210e19d57', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '95ca8c1b-c012-428b-83d8-c9a210e19d57' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('d38544e2-77f3-4f83-ac43-db76e38593b6',
                                                               replace(
                                                                       btrim(observations ->> 'd38544e2-77f3-4f83-ac43-db76e38593b6', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'd38544e2-77f3-4f83-ac43-db76e38593b6' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('a1f42a41-31e2-4522-9901-56d691299a50',
                                                               replace(
                                                                       btrim(observations ->> 'a1f42a41-31e2-4522-9901-56d691299a50', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'a1f42a41-31e2-4522-9901-56d691299a50' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('884b130f-bc81-458a-be2e-07b057cfffe7',
                                                               replace(
                                                                       btrim(observations ->> '884b130f-bc81-458a-be2e-07b057cfffe7', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '884b130f-bc81-458a-be2e-07b057cfffe7' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('7c782fc9-f4df-468b-8733-850c33bf96b5',
                                                               replace(
                                                                       btrim(observations ->> '7c782fc9-f4df-468b-8733-850c33bf96b5', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '7c782fc9-f4df-468b-8733-850c33bf96b5' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('e2498029-fab8-4a47-9d2e-044476fee99f',
                                                               replace(
                                                                       btrim(observations ->> 'e2498029-fab8-4a47-9d2e-044476fee99f', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'e2498029-fab8-4a47-9d2e-044476fee99f' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('6f7f693c-c892-4cc1-b40a-328b61043e84',
                                                               replace(
                                                                       btrim(observations ->> '6f7f693c-c892-4cc1-b40a-328b61043e84', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '6f7f693c-c892-4cc1-b40a-328b61043e84' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('f54d53c1-bee2-4db5-8c42-a1e5c1d3a886',
                                                               replace(
                                                                       btrim(observations ->> 'f54d53c1-bee2-4db5-8c42-a1e5c1d3a886', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'f54d53c1-bee2-4db5-8c42-a1e5c1d3a886' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('a798eba4-1913-46c1-a7dd-a637c72b6dec',
                                                               replace(
                                                                       btrim(observations ->> 'a798eba4-1913-46c1-a7dd-a637c72b6dec', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'a798eba4-1913-46c1-a7dd-a637c72b6dec' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('92613f0f-2455-4cc7-83de-a789b5496b37',
                                                               replace(
                                                                       btrim(observations ->> '92613f0f-2455-4cc7-83de-a789b5496b37', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '92613f0f-2455-4cc7-83de-a789b5496b37' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('478caac9-3fba-4fe3-809a-d2d11fdb64d6',
                                                               replace(
                                                                       btrim(observations ->> '478caac9-3fba-4fe3-809a-d2d11fdb64d6', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '478caac9-3fba-4fe3-809a-d2d11fdb64d6' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('04459837-ec31-4a40-aed3-d721ab0c8a7a',
                                                               replace(
                                                                       btrim(observations ->> '04459837-ec31-4a40-aed3-d721ab0c8a7a', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '04459837-ec31-4a40-aed3-d721ab0c8a7a' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('8ec036a6-3c01-4fb1-b704-3ce2e4c032f8',
                                                               replace(
                                                                       btrim(observations ->> '8ec036a6-3c01-4fb1-b704-3ce2e4c032f8', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '8ec036a6-3c01-4fb1-b704-3ce2e4c032f8' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('8e7106bd-d9ab-48e4-8200-60707101f34f',
                                                               replace(
                                                                       btrim(observations ->> '8e7106bd-d9ab-48e4-8200-60707101f34f', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '8e7106bd-d9ab-48e4-8200-60707101f34f' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('42c7dc3a-8600-4a56-90b6-09d66ae06c8a',
                                                               replace(
                                                                       btrim(observations ->> '42c7dc3a-8600-4a56-90b6-09d66ae06c8a', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '42c7dc3a-8600-4a56-90b6-09d66ae06c8a' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('26f7e262-0db8-4eca-8129-69db3f8b726c',
                                                               replace(
                                                                       btrim(observations ->> '26f7e262-0db8-4eca-8129-69db3f8b726c', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '26f7e262-0db8-4eca-8129-69db3f8b726c' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('36cf7448-d3a6-410f-91f1-f7d8c66395dc',
                                                               replace(
                                                                       btrim(observations ->> '36cf7448-d3a6-410f-91f1-f7d8c66395dc', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '36cf7448-d3a6-410f-91f1-f7d8c66395dc' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('77fe272b-9dd1-4593-bd91-7fbe70f6c9e4',
                                                               replace(
                                                                       btrim(observations ->> '77fe272b-9dd1-4593-bd91-7fbe70f6c9e4', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '77fe272b-9dd1-4593-bd91-7fbe70f6c9e4' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('6fa57b52-ab30-4ec4-be2e-4f1d324cb3a1',
                                                               replace(
                                                                       btrim(observations ->> '6fa57b52-ab30-4ec4-be2e-4f1d324cb3a1', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '6fa57b52-ab30-4ec4-be2e-4f1d324cb3a1' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('3c569e77-d6df-4e91-bbc0-45a4f07c208b',
                                                               replace(
                                                                       btrim(observations ->> '3c569e77-d6df-4e91-bbc0-45a4f07c208b', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '3c569e77-d6df-4e91-bbc0-45a4f07c208b' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('ec0e7aad-d67e-44c4-a6eb-a37f7ceddc59',
                                                               replace(
                                                                       btrim(observations ->> 'ec0e7aad-d67e-44c4-a6eb-a37f7ceddc59', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'ec0e7aad-d67e-44c4-a6eb-a37f7ceddc59' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('01a78d61-5cde-4b37-bb99-fdc1d58e1af1',
                                                               replace(
                                                                       btrim(observations ->> '01a78d61-5cde-4b37-bb99-fdc1d58e1af1', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '01a78d61-5cde-4b37-bb99-fdc1d58e1af1' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('17d3ca96-f549-4889-99be-87fee2aec17f',
                                                               replace(
                                                                       btrim(observations ->> '17d3ca96-f549-4889-99be-87fee2aec17f', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '17d3ca96-f549-4889-99be-87fee2aec17f' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('95c763e2-7be1-48d0-8f34-a8c470b4013a',
                                                               replace(
                                                                       btrim(observations ->> '95c763e2-7be1-48d0-8f34-a8c470b4013a', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '95c763e2-7be1-48d0-8f34-a8c470b4013a' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('0d235663-7a1e-40c5-8691-ac2af61a3112',
                                                               replace(
                                                                       btrim(observations ->> '0d235663-7a1e-40c5-8691-ac2af61a3112', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '0d235663-7a1e-40c5-8691-ac2af61a3112' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('5f7e5069-2ec5-4a0f-af7a-c91a38df72e5',
                                                               replace(
                                                                       btrim(observations ->> '5f7e5069-2ec5-4a0f-af7a-c91a38df72e5', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '5f7e5069-2ec5-4a0f-af7a-c91a38df72e5' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('902f7ee0-8795-4d0f-8d97-bdde904818ef',
                                                               replace(
                                                                       btrim(observations ->> '902f7ee0-8795-4d0f-8d97-bdde904818ef', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '902f7ee0-8795-4d0f-8d97-bdde904818ef' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('21ea761f-9b8d-4cc1-8a35-7d71ba2e5e56',
                                                               replace(
                                                                       btrim(observations ->> '21ea761f-9b8d-4cc1-8a35-7d71ba2e5e56', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '21ea761f-9b8d-4cc1-8a35-7d71ba2e5e56' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('1f725c69-45f4-4db5-9075-19cf59a23f4e',
                                                               replace(
                                                                       btrim(observations ->> '1f725c69-45f4-4db5-9075-19cf59a23f4e', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '1f725c69-45f4-4db5-9075-19cf59a23f4e' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('c74fd564-30b7-4b4b-a7e7-b93cb189f359',
                                                               replace(
                                                                       btrim(observations ->> 'c74fd564-30b7-4b4b-a7e7-b93cb189f359', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'c74fd564-30b7-4b4b-a7e7-b93cb189f359' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('2e827b9e-76cb-45bd-8207-a85653d6f4af',
                                                               replace(
                                                                       btrim(observations ->> '2e827b9e-76cb-45bd-8207-a85653d6f4af', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '2e827b9e-76cb-45bd-8207-a85653d6f4af' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('c7e529b0-fa29-4991-bccd-c0b852d2407a',
                                                               replace(
                                                                       btrim(observations ->> 'c7e529b0-fa29-4991-bccd-c0b852d2407a', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'c7e529b0-fa29-4991-bccd-c0b852d2407a' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('a39b4ddf-48ef-4dd9-9822-99df97f156f5',
                                                               replace(
                                                                       btrim(observations ->> 'a39b4ddf-48ef-4dd9-9822-99df97f156f5', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'a39b4ddf-48ef-4dd9-9822-99df97f156f5' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('744a2050-a0f0-4018-86df-60aec8dbdf04',
                                                               replace(
                                                                       btrim(observations ->> '744a2050-a0f0-4018-86df-60aec8dbdf04', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '744a2050-a0f0-4018-86df-60aec8dbdf04' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('174b4a7a-4922-4ddf-bac3-2df700791320',
                                                               replace(
                                                                       btrim(observations ->> '174b4a7a-4922-4ddf-bac3-2df700791320', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '174b4a7a-4922-4ddf-bac3-2df700791320' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('fd6f2d07-04f0-4a4b-b04d-402f14da636b',
                                                               replace(
                                                                       btrim(observations ->> 'fd6f2d07-04f0-4a4b-b04d-402f14da636b', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'fd6f2d07-04f0-4a4b-b04d-402f14da636b' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('a1ed40d7-08f0-44c4-ba1e-d0f2f92986eb',
                                                               replace(
                                                                       btrim(observations ->> 'a1ed40d7-08f0-44c4-ba1e-d0f2f92986eb', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'a1ed40d7-08f0-44c4-ba1e-d0f2f92986eb' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('783b44ef-be94-4f67-930e-80793adeec7b',
                                                               replace(
                                                                       btrim(observations ->> '783b44ef-be94-4f67-930e-80793adeec7b', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '783b44ef-be94-4f67-930e-80793adeec7b' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('41c27748-f777-43ca-87b3-10551ed560bd',
                                                               replace(
                                                                       btrim(observations ->> '41c27748-f777-43ca-87b3-10551ed560bd', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '41c27748-f777-43ca-87b3-10551ed560bd' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('257c8daf-b647-452d-bf43-612ab1e31f6e',
                                                               replace(
                                                                       btrim(observations ->> '257c8daf-b647-452d-bf43-612ab1e31f6e', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '257c8daf-b647-452d-bf43-612ab1e31f6e' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('fe231d34-1762-428d-bb4c-0b3399d2e3f8',
                                                               replace(
                                                                       btrim(observations ->> 'fe231d34-1762-428d-bb4c-0b3399d2e3f8', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'fe231d34-1762-428d-bb4c-0b3399d2e3f8' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('e864bbe7-8c60-455e-b91f-85c3a9fe8a74',
                                                               replace(
                                                                       btrim(observations ->> 'e864bbe7-8c60-455e-b91f-85c3a9fe8a74', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'e864bbe7-8c60-455e-b91f-85c3a9fe8a74' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('56e2a5ce-fad7-4c2d-8c5e-892448aad876',
                                                               replace(
                                                                       btrim(observations ->> '56e2a5ce-fad7-4c2d-8c5e-892448aad876', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '56e2a5ce-fad7-4c2d-8c5e-892448aad876' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('4a2eae52-229d-4e15-a4eb-908303120f3e',
                                                               replace(
                                                                       btrim(observations ->> '4a2eae52-229d-4e15-a4eb-908303120f3e', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '4a2eae52-229d-4e15-a4eb-908303120f3e' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('9cdc9acd-a385-4513-8652-a4ee09408c28',
                                                               replace(
                                                                       btrim(observations ->> '9cdc9acd-a385-4513-8652-a4ee09408c28', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '9cdc9acd-a385-4513-8652-a4ee09408c28' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('b0c90bb5-de77-4e63-b842-13202195b9ad',
                                                               replace(
                                                                       btrim(observations ->> 'b0c90bb5-de77-4e63-b842-13202195b9ad', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'b0c90bb5-de77-4e63-b842-13202195b9ad' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('e35f569b-6fbf-493d-8b89-032733b4b12e',
                                                               replace(
                                                                       btrim(observations ->> 'e35f569b-6fbf-493d-8b89-032733b4b12e', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'e35f569b-6fbf-493d-8b89-032733b4b12e' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('f89af677-d4c1-41e2-b04e-85fcb89c3d00',
                                                               replace(
                                                                       btrim(observations ->> 'f89af677-d4c1-41e2-b04e-85fcb89c3d00', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'f89af677-d4c1-41e2-b04e-85fcb89c3d00' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('06204082-7709-41af-9207-d38820262624',
                                                               replace(
                                                                       btrim(observations ->> '06204082-7709-41af-9207-d38820262624', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '06204082-7709-41af-9207-d38820262624' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('5e319446-80eb-499b-bac7-5687f34609ce',
                                                               replace(
                                                                       btrim(observations ->> '5e319446-80eb-499b-bac7-5687f34609ce', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '5e319446-80eb-499b-bac7-5687f34609ce' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('79ac62a8-4355-4fe8-ad6f-beb5b4faa5c7',
                                                               replace(
                                                                       btrim(observations ->> '79ac62a8-4355-4fe8-ad6f-beb5b4faa5c7', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '79ac62a8-4355-4fe8-ad6f-beb5b4faa5c7' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('3e1af70f-fb41-4276-a599-0405a4cb13fd',
                                                               replace(
                                                                       btrim(observations ->> '3e1af70f-fb41-4276-a599-0405a4cb13fd', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '3e1af70f-fb41-4276-a599-0405a4cb13fd' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('0b8c3332-7807-4198-a9af-3b21297fff18',
                                                               replace(
                                                                       btrim(observations ->> '0b8c3332-7807-4198-a9af-3b21297fff18', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '0b8c3332-7807-4198-a9af-3b21297fff18' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('4aab6b40-dfc4-4bcb-b413-36689b651a42',
                                                               replace(
                                                                       btrim(observations ->> '4aab6b40-dfc4-4bcb-b413-36689b651a42', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '4aab6b40-dfc4-4bcb-b413-36689b651a42' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('f91a06d7-69c5-443f-b97e-60bb981afca7',
                                                               replace(
                                                                       btrim(observations ->> 'f91a06d7-69c5-443f-b97e-60bb981afca7', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'f91a06d7-69c5-443f-b97e-60bb981afca7' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('af513564-2a90-4ae5-b778-a06a3ea92837',
                                                               replace(
                                                                       btrim(observations ->> 'af513564-2a90-4ae5-b778-a06a3ea92837', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'af513564-2a90-4ae5-b778-a06a3ea92837' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('c633aee6-6792-4b25-9fd8-dcb018d2a655',
                                                               replace(
                                                                       btrim(observations ->> 'c633aee6-6792-4b25-9fd8-dcb018d2a655', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'c633aee6-6792-4b25-9fd8-dcb018d2a655' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('7866634b-f02b-402f-85d3-cf52965b9149',
                                                               replace(
                                                                       btrim(observations ->> '7866634b-f02b-402f-85d3-cf52965b9149', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '7866634b-f02b-402f-85d3-cf52965b9149' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('8af0e4cd-5669-42ad-8df5-4fc7e36705e9',
                                                               replace(
                                                                       btrim(observations ->> '8af0e4cd-5669-42ad-8df5-4fc7e36705e9', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '8af0e4cd-5669-42ad-8df5-4fc7e36705e9' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('38da7b7f-01e0-46c5-b6f5-860a1fc7b781',
                                                               replace(
                                                                       btrim(observations ->> '38da7b7f-01e0-46c5-b6f5-860a1fc7b781', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '38da7b7f-01e0-46c5-b6f5-860a1fc7b781' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('b2d9f5a1-3483-4853-8d2e-27b0b03446ab',
                                                               replace(
                                                                       btrim(observations ->> 'b2d9f5a1-3483-4853-8d2e-27b0b03446ab', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'b2d9f5a1-3483-4853-8d2e-27b0b03446ab' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('8d39dc3f-2d89-4e1f-a2d9-8b7ef0881857',
                                                               replace(
                                                                       btrim(observations ->> '8d39dc3f-2d89-4e1f-a2d9-8b7ef0881857', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '8d39dc3f-2d89-4e1f-a2d9-8b7ef0881857' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('8875748b-f3d0-4087-af72-829f2835a078',
                                                               replace(
                                                                       btrim(observations ->> '8875748b-f3d0-4087-af72-829f2835a078', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '8875748b-f3d0-4087-af72-829f2835a078' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('614f6b4f-e2c6-4742-9ec7-e645c106e336',
                                                               replace(
                                                                       btrim(observations ->> '614f6b4f-e2c6-4742-9ec7-e645c106e336', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '614f6b4f-e2c6-4742-9ec7-e645c106e336' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('f1a5256b-a914-4f82-9c34-e231024dd6cc',
                                                               replace(
                                                                       btrim(observations ->> 'f1a5256b-a914-4f82-9c34-e231024dd6cc', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'f1a5256b-a914-4f82-9c34-e231024dd6cc' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('f5dfe184-1cd7-4193-8a54-6a90119e5254',
                                                               replace(
                                                                       btrim(observations ->> 'f5dfe184-1cd7-4193-8a54-6a90119e5254', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'f5dfe184-1cd7-4193-8a54-6a90119e5254' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('15fd7ab6-7c71-4265-b2c2-a504ace84758',
                                                               replace(
                                                                       btrim(observations ->> '15fd7ab6-7c71-4265-b2c2-a504ace84758', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '15fd7ab6-7c71-4265-b2c2-a504ace84758' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('9ebe6fc3-10e0-4669-b8c0-ac2c6109b223',
                                                               replace(
                                                                       btrim(observations ->> '9ebe6fc3-10e0-4669-b8c0-ac2c6109b223', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '9ebe6fc3-10e0-4669-b8c0-ac2c6109b223' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('1f7bca76-2e88-434d-84d4-41b66cdcba84',
                                                               replace(
                                                                       btrim(observations ->> '1f7bca76-2e88-434d-84d4-41b66cdcba84', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '1f7bca76-2e88-434d-84d4-41b66cdcba84' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('95b86823-329e-4cc8-8d97-d477d7fc0cc0',
                                                               replace(
                                                                       btrim(observations ->> '95b86823-329e-4cc8-8d97-d477d7fc0cc0', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '95b86823-329e-4cc8-8d97-d477d7fc0cc0' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('2b22c914-d355-49b0-833e-21125ab0c430',
                                                               replace(
                                                                       btrim(observations ->> '2b22c914-d355-49b0-833e-21125ab0c430', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '2b22c914-d355-49b0-833e-21125ab0c430' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('5cd8d685-030c-45c8-aa20-cd169ea0dd6f',
                                                               replace(
                                                                       btrim(observations ->> '5cd8d685-030c-45c8-aa20-cd169ea0dd6f', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '5cd8d685-030c-45c8-aa20-cd169ea0dd6f' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('a173836e-a0f8-4210-bc02-06aeebef2e8b',
                                                               replace(
                                                                       btrim(observations ->> 'a173836e-a0f8-4210-bc02-06aeebef2e8b', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'a173836e-a0f8-4210-bc02-06aeebef2e8b' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('b3ae0b19-a4b1-4a80-aba4-510bef92fc6b',
                                                               replace(
                                                                       btrim(observations ->> 'b3ae0b19-a4b1-4a80-aba4-510bef92fc6b', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'b3ae0b19-a4b1-4a80-aba4-510bef92fc6b' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('0da77abb-d8ab-4aa1-9b4d-34ec2e81d14a',
                                                               replace(
                                                                       btrim(observations ->> '0da77abb-d8ab-4aa1-9b4d-34ec2e81d14a', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '0da77abb-d8ab-4aa1-9b4d-34ec2e81d14a' like '%[%';

update openchs.public.program_encounter
set observations           = observations || json_build_object('1fc6f193-1dd7-4def-99ca-876c2b735918',
                                                               replace(
                                                                       btrim(observations ->> '1fc6f193-1dd7-4def-99ca-876c2b735918', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '1fc6f193-1dd7-4def-99ca-876c2b735918' like '%[%';
-------
update openchs.public.program_encounter
set observations           = observations || json_build_object('a73e120f-86b1-4cb9-9a04-4733b734c8ec',
                                                               replace(
                                                                       btrim(observations ->> 'a73e120f-86b1-4cb9-9a04-4733b734c8ec', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'a73e120f-86b1-4cb9-9a04-4733b734c8ec' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('a180507a-03aa-40bb-bd52-8ba15c197737',
                                                               replace(
                                                                       btrim(observations ->> 'a180507a-03aa-40bb-bd52-8ba15c197737', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'a180507a-03aa-40bb-bd52-8ba15c197737' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('ead21767-26dc-47bc-a29c-d4881ff99698',
                                                               replace(
                                                                       btrim(observations ->> 'ead21767-26dc-47bc-a29c-d4881ff99698', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> 'ead21767-26dc-47bc-a29c-d4881ff99698' like '%[%';
update openchs.public.program_encounter
set observations           = observations || json_build_object('73682180-cc42-4742-b27a-7b5177a80223',
                                                               replace(
                                                                       btrim(observations ->> '73682180-cc42-4742-b27a-7b5177a80223', '[]'),
                                                                       '"', '')::numeric)::jsonb,
    last_modified_by_id=(select id from users where username = 'sachink@jsscp'),
    last_modified_date_time= current_timestamp + ((id % 4000) * interval '1 millisecond')
where observations ->> '73682180-cc42-4742-b27a-7b5177a80223' like '%[%';



