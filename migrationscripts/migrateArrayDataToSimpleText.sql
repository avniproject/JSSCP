set role rise_uat;
select *
from translation;
select *
from concept
where name = 'Municipal corporation/council';



select *
from rule_failure_telemetry
where is_closed = false;

with audits as (
    update rule_failure_telemetry
        set is_closed = true
        where is_closed = false returning audit_id)
update audit
set last_modified_date_time=current_timestamp
where id in (select audit_id from audits)

;




set role jsscp



select observations ->> 'a5ed1d52-4b5a-4c79-974b-0adf2bf9ccb5' as "B-complex Strength"
     , observations ->> '6e96f709-dc8e-4e10-a79f-e908a790d719' as "Becadex (multivitamin) Strength"
     , observations ->> '524abcfb-d2b0-46e4-9c18-c5c380adb862' as "Iron (Fersifol) Strength"
     , observations ->> '6b3c1744-f643-499d-8581-8b0b4a4017bd' as "Paracetamol Strength"
     , observations ->> 'feec4205-8f1e-4b8e-929f-f8c0664e34d4' as "Furosemide Strength"
     , observations ->> 'd6e1be9d-0937-4708-869f-19c816c11d7c' as "Calcium Strength"
     , observations ->> '43ee5933-ba92-4a53-8d51-95423a293302' as "Spironolactone Strength"
     , observations ->> 'd0fbc4d4-943f-46ac-9175-3500245d2a5c' as "Metformin"
     , observations ->> '1fc97791-4ee1-4ece-952f-d7aefd740c2f' as "Glipizide"
     , observations ->> '7ce80a12-333c-4aee-82ab-79c94e008738' as "Gliclazide"
     , observations ->> '01fc8c9d-af91-41ce-9df1-5819acded3e9' as "Glibenclamide"
     , observations ->> 'eb58f9d3-f7aa-43bc-ba22-aa81959e0c28' as "Glimeperide"
     , observations ->> '893f5c62-6a60-40ce-a9e1-4184a9f3fe26' as "Pyoglitazone"
     , observations ->> 'ed22e195-218b-486c-9789-d0686e0c9f3f' as "Rosiglitazone"
     , observations ->> '02ed08ca-ff74-44b0-9f59-018c2776b401' as "Ripaglinide"
     , observations ->> 'd477aa49-db1a-4e62-9a1f-def41e29adda' as "Nateglinide"
     , observations ->> 'eaec610c-2bfb-4029-b67d-ea962d7254ce' as "Diabetes atorvastatin"
     , observations ->> '4b6fd526-bd98-4131-b642-2fabb3ead8a4' as "Tolbutamide"
     , observations ->> '56d918dc-bb81-48b9-8a7d-f40794e14b96' as "Diabetes aspirin"
     , observations ->> 'c3ba40f2-2b52-4088-a490-7d3e0e8f6230' as "Diabetes enalapril"
     , observations ->> 'd0b906ec-8922-42fd-a6f7-53b2008db3da' as "Losartan"
     , observations ->> '8c7c621d-caed-4f7f-bd05-88645881714c' as "Insulin needed"
     , observations ->> '93a77494-4a97-4bd7-8bb1-560f0abd7c2d' as "Sitagliptin Strength"
     , observations ->> '5016912d-5d2e-4bee-82f3-0c4f08fbd0b6' as "Saxagliptin Strength"
     , observations ->> '6ad0f77b-6a81-4b68-987c-8e291c1e067a' as "Linagliptin Strength"
from program_encounter
where encounter_type_id = 728
  and encounter_date_time notnull;



-- Prod
-- 728  Diabetes Followup
-- 836 Sickle cell followup
-- 835 Epilepsy followup
-- 633 Hypertension Followup;

select *
from encounter_type where name in ('Diabetes Followup','Sickle cell followup','Epilepsy followup','Hypertension Followup');

--Diabetes followup form---------
set role jsscp
with audits as (
    update program_encounter
        set observations =  jsonb_strip_nulls(observations || jsonb_build_object('a5ed1d52-4b5a-4c79-974b-0adf2bf9ccb5',
                                                                                 (observations -> 'a5ed1d52-4b5a-4c79-974b-0adf2bf9ccb5' ->> 0),--B-complex
                                                                                 '6e96f709-dc8e-4e10-a79f-e908a790d719',
                                                                                 (observations -> '6e96f709-dc8e-4e10-a79f-e908a790d719' ->> 0),--Becadex
                                                                                 '524abcfb-d2b0-46e4-9c18-c5c380adb862',
                                                                                 (observations -> '524abcfb-d2b0-46e4-9c18-c5c380adb862' ->> 0),--Iron
                                                                                 '6b3c1744-f643-499d-8581-8b0b4a4017bd',
                                                                                 (observations -> '6b3c1744-f643-499d-8581-8b0b4a4017bd' ->> 0),--Paracetamol
                                                                                 'feec4205-8f1e-4b8e-929f-f8c0664e34d4',
                                                                                 (observations -> 'feec4205-8f1e-4b8e-929f-f8c0664e34d4' ->> 0),--Furosemide
                                                                                 'd6e1be9d-0937-4708-869f-19c816c11d7c',
                                                                                 (observations -> 'd6e1be9d-0937-4708-869f-19c816c11d7c' ->> 0),--Calcium
                                                                                 '43ee5933-ba92-4a53-8d51-95423a293302',
                                                                                 (observations -> '43ee5933-ba92-4a53-8d51-95423a293302' ->> 0),--Spironolactone
                                                                                 'd0fbc4d4-943f-46ac-9175-3500245d2a5c',
                                                                                 (observations -> 'd0fbc4d4-943f-46ac-9175-3500245d2a5c' ->> 0),--Metformin
                                                                                 '1fc97791-4ee1-4ece-952f-d7aefd740c2f',
                                                                                 (observations -> '1fc97791-4ee1-4ece-952f-d7aefd740c2f' ->> 0),--Glipizide
                                                                                 '7ce80a12-333c-4aee-82ab-79c94e008738',
                                                                                 (observations -> '7ce80a12-333c-4aee-82ab-79c94e008738' ->> 0),--Gliclazide
                                                                                 '01fc8c9d-af91-41ce-9df1-5819acded3e9',
                                                                                 (observations -> '01fc8c9d-af91-41ce-9df1-5819acded3e9' ->> 0),--Glibenclamide
                                                                                 'eb58f9d3-f7aa-43bc-ba22-aa81959e0c28',
                                                                                 (observations -> 'eb58f9d3-f7aa-43bc-ba22-aa81959e0c28' ->> 0),--Glimeperide
                                                                                 '893f5c62-6a60-40ce-a9e1-4184a9f3fe26',
                                                                                 (observations -> '893f5c62-6a60-40ce-a9e1-4184a9f3fe26' ->> 0),--Pyoglitazone
                                                                                 'ed22e195-218b-486c-9789-d0686e0c9f3f',
                                                                                 (observations -> 'ed22e195-218b-486c-9789-d0686e0c9f3f' ->> 0),--Rosiglitazone
                                                                                 '02ed08ca-ff74-44b0-9f59-018c2776b401',
                                                                                 (observations -> '02ed08ca-ff74-44b0-9f59-018c2776b401' ->> 0),--Ripaglinide
                                                                                 'd477aa49-db1a-4e62-9a1f-def41e29adda',
                                                                                 (observations -> 'd477aa49-db1a-4e62-9a1f-def41e29adda' ->> 0),--Nateglinide
                                                                                 'eaec610c-2bfb-4029-b67d-ea962d7254ce',
                                                                                 (observations -> 'eaec610c-2bfb-4029-b67d-ea962d7254ce' ->> 0),--Diabetes atorvastatin
                                                                                 '4b6fd526-bd98-4131-b642-2fabb3ead8a4',
                                                                                 (observations -> '4b6fd526-bd98-4131-b642-2fabb3ead8a4' ->> 0),--Tolbutamide
                                                                                 '56d918dc-bb81-48b9-8a7d-f40794e14b96',
                                                                                 (observations -> '56d918dc-bb81-48b9-8a7d-f40794e14b96' ->> 0),--Diabetes aspirin
                                                                                 'c3ba40f2-2b52-4088-a490-7d3e0e8f6230',
                                                                                 (observations -> 'c3ba40f2-2b52-4088-a490-7d3e0e8f6230' ->> 0),--Diabetes enalapril
                                                                                 'd0b906ec-8922-42fd-a6f7-53b2008db3da',
                                                                                 (observations -> 'd0b906ec-8922-42fd-a6f7-53b2008db3da' ->> 0),--Losartan
                                                                                 '8c7c621d-caed-4f7f-bd05-88645881714c',
                                                                                 (observations -> '8c7c621d-caed-4f7f-bd05-88645881714c' ->> 0),--Insulin needed
                                                                                 '93a77494-4a97-4bd7-8bb1-560f0abd7c2d',
                                                                                 (observations -> '93a77494-4a97-4bd7-8bb1-560f0abd7c2d' ->> 0),--Sitagliptin Strength
                                                                                 '5016912d-5d2e-4bee-82f3-0c4f08fbd0b6',
                                                                                 (observations -> '5016912d-5d2e-4bee-82f3-0c4f08fbd0b6' ->> 0),--Saxagliptin Strength
                                                                                 '6ad0f77b-6a81-4b68-987c-8e291c1e067a',
                                                                                 (observations -> '6ad0f77b-6a81-4b68-987c-8e291c1e067a' ->> 0))--Linagliptin Strength
            )
        where encounter_type_id = 728 and encounter_date_time notnull
        returning audit_id)
update audit
set last_modified_date_time = current_timestamp + id * ('1 millisecond' :: interval)
where id in (select audit_id from audits);

select id,observations from program_encounter  where encounter_type_id = 728




--------- 836 Sickle cell followup--------
select *
from concept
where name in ('Hydroxyurea', 'Folic acid', 'Paracetamol', 'Ibuprofen');


select observations ->> '1fe766fa-177a-4f2e-9e45-1a31ef826f41',--Hydroxyurea
       observations ->> 'e56d5686-082d-4703-b975-ccd81307deba', --Folic acid
       observations ->> 'c8c54559-53e9-4b60-a618-ccd1d6447dc2',--Paracetamol
       observations ->> '86798209-cdbe-4aa3-8f16-57474c2d1b9a'--Ibuprofen
from program_encounter
where encounter_type_id = 836
  and encounter_date_time notnull



set role jsscp
with audits as (
    update program_encounter
        set observations = jsonb_strip_nulls(observations || jsonb_build_object('1fe766fa-177a-4f2e-9e45-1a31ef826f41',
                                                                                (observations -> '1fe766fa-177a-4f2e-9e45-1a31ef826f41' ->> 0),--Hydroxyurea
                                                                                'e56d5686-082d-4703-b975-ccd81307deba',
                                                                                (observations -> 'e56d5686-082d-4703-b975-ccd81307deba' ->> 0),--Folic acid
                                                                                'c8c54559-53e9-4b60-a618-ccd1d6447dc2',
                                                                                (observations -> 'c8c54559-53e9-4b60-a618-ccd1d6447dc2' ->> 0),--Paracetamol
                                                                                '86798209-cdbe-4aa3-8f16-57474c2d1b9a',
                                                                                (observations -> '86798209-cdbe-4aa3-8f16-57474c2d1b9a' ->> 0))--Ibuprofen
            )
        where encounter_type_id = 836 and encounter_date_time notnull
        returning audit_id)
update audit
set last_modified_date_time = current_timestamp + id * ('1 millisecond' :: interval)
where id in (select audit_id from audits);

select id,observations from program_encounter  where encounter_type_id = 836



------------- 835 Epilepsy followup---
set role jsscp
select *
from concept
where name in ('Phenobarbitone dose', 'Carbamezepine dose', 'Phenytoin dose', 'Valproic acid dose');
select *
from concept
where name in ('Phenobarbitone for how many times a days', 'Carbamezepine for how many times a days',
               'Phenytoin for how many times a days', 'Valproic acid for how many times a days');
select observations ->> 'af513564-2a90-4ae5-b778-a06a3ea92837',--Phenobarbitone dose
       observations ->> '7866634b-f02b-402f-85d3-cf52965b9149',--Phenytoin dose
       observations ->> 'a1f42a41-31e2-4522-9901-56d691299a50',--Carbamezepine dose
       observations ->> 'ead21767-26dc-47bc-a29c-d4881ff99698', --Valproic acid dose
       observations ->> '96a67ccd-42ee-4d7c-b344-cab395d06a4b', --Phenobarbitone for how many times a days,
       observations ->> 'c6a22993-d14d-44c3-8eb6-dd55eefe744d', --Carbamezepine for how many times a days,
       observations ->> 'af33a4be-556e-4fa0-82ca-a9810f19865f', --Phenytoin for how many times a days,
       observations ->> 'fcafb97e-2b45-4d64-9d7a-5abd7bd73eb5' --Valproic acid for how many times a days,


from program_encounter
where encounter_type_id = 835
  and encounter_date_time notnull;


set role jsscp
with audits as (
    update program_encounter
        set observations = jsonb_strip_nulls(observations || jsonb_build_object('af513564-2a90-4ae5-b778-a06a3ea92837',
                                                                                (observations -> 'af513564-2a90-4ae5-b778-a06a3ea92837' ->> 0),--Phenobarbitone dose
                                                                                '7866634b-f02b-402f-85d3-cf52965b9149',
                                                                                (observations -> '7866634b-f02b-402f-85d3-cf52965b9149' ->> 0),--Phenytoin dose
                                                                                'a1f42a41-31e2-4522-9901-56d691299a50',
                                                                                (observations -> 'a1f42a41-31e2-4522-9901-56d691299a50' ->> 0),--Carbamezepine dose
                                                                                'ead21767-26dc-47bc-a29c-d4881ff99698',
                                                                                (observations -> 'ead21767-26dc-47bc-a29c-d4881ff99698' ->> 0),--Valproic acid dose
                                                                                '96a67ccd-42ee-4d7c-b344-cab395d06a4b',
                                                                                (observations -> '96a67ccd-42ee-4d7c-b344-cab395d06a4b' ->> 0),--Phenobarbitone for how many times a days,
                                                                                'c6a22993-d14d-44c3-8eb6-dd55eefe744d',
                                                                                (observations -> 'c6a22993-d14d-44c3-8eb6-dd55eefe744d' ->> 0),--Carbamezepine for how many times a days,
                                                                                'af33a4be-556e-4fa0-82ca-a9810f19865f',
                                                                                (observations -> 'af33a4be-556e-4fa0-82ca-a9810f19865f' ->> 0),--Phenytoin for how many times a days,
                                                                                'fcafb97e-2b45-4d64-9d7a-5abd7bd73eb5',
                                                                                (observations -> 'fcafb97e-2b45-4d64-9d7a-5abd7bd73eb5' ->> 0))--Valproic acid for how many times a days
            )
        where encounter_type_id = 835 and encounter_date_time notnull
        returning audit_id)
update audit
set last_modified_date_time = current_timestamp + id * ('1 millisecond' :: interval)
where id in (select audit_id from audits);

select id, observations
from program_encounter
where encounter_type_id = 835


--------- 633 Hypertension Followup-----
set role jsscp

select c.name, c.uuid
from form_element
         left join concept c on form_element.name = c.name
where form_element_group_id = 2423
  and form_element.name like ('%Strength')
  and form_element.is_voided = false;
;
select *
from concept where uuid='e1fa78a9-5fea-4cda-858f-eda71d72e523';
select observations ->> 'e1fa78a9-5fea-4cda-858f-eda71d72e523' as "Aspirin Strength"
     , observations ->> 'a38c0c25-8525-49fe-b1aa-0550f3feaee6' as "Atorvastatin Strength"
     , observations ->> '524abcfb-d2b0-46e4-9c18-c5c380adb862' as "Iron (Fersifol) Strength"
     , observations ->> '6b3c1744-f643-499d-8581-8b0b4a4017bd' as "Paracetamol Strength"
     , observations ->> 'feec4205-8f1e-4b8e-929f-f8c0664e34d4' as "Furosemide Strength"
     , observations ->> '43ee5933-ba92-4a53-8d51-95423a293302' as "Spironolactone Strength"
     , observations ->> '973c7298-b68d-4459-8ada-c8f91a7c7bb8' as "Ramipril Strength"
     , observations ->> '89ce82a0-3c5b-4a1d-a47e-f83e1db12775' as "Metoprolol Strength"
     , observations ->> 'af3ac496-6398-41fb-b61a-9074bdc752c6' as "Clonidine Strength"
     , observations ->> '94513b3b-b4e2-4f9c-9354-6399b6fd657c' as "Prazosin Strength"
     , observations ->> '6e96f709-dc8e-4e10-a79f-e908a790d719' as "Becadex (multivitamin) Strength"
     , observations ->> '1fe0da8d-569f-4f94-a308-c1321c5a0c7b' as "Amlodipin Strength"
     , observations ->> 'd6e1be9d-0937-4708-869f-19c816c11d7c' as "Calcium Strength"
     , observations ->> 'a5ed1d52-4b5a-4c79-974b-0adf2bf9ccb5' as "B-complex Strength"
     , observations ->> 'a3d5391e-e199-4121-8d42-6ff14f50a299' as "Nefedipin SR Strength"
     , observations ->> '99653b2a-e994-4d63-afaa-10c277ee0235' as "Enalapril Strength"
     , observations ->> '449316d4-8391-4de9-9c96-18637b9572a6' as "Hydrochlorothiazide (HCT) Strength"
     , observations ->> 'e3cab964-f906-4a94-8598-6dab62a19a95' as "Atenolol Strength"
     , observations ->> '55c272e7-5d2b-4cf2-ab96-d9c4de76a6b0' as "Nefedipin Strength"
     , observations ->> '0914d979-72a6-49ef-a37b-0bb7df2068c0' as "Methyldopa Strength"

from program_encounter
where encounter_type_id = 633
  and encounter_date_time notnull;



set role jsscp
with audits as (
    update program_encounter
        set observations = jsonb_strip_nulls(observations || jsonb_build_object('e1fa78a9-5fea-4cda-858f-eda71d72e523',
                                                                                (observations -> 'e1fa78a9-5fea-4cda-858f-eda71d72e523' ->> 0),--Aspirin Strength
                                                                                'a38c0c25-8525-49fe-b1aa-0550f3feaee6',
                                                                                (observations -> 'a38c0c25-8525-49fe-b1aa-0550f3feaee6' ->> 0),--Atorvastatin Strength
                                                                                '524abcfb-d2b0-46e4-9c18-c5c380adb862',
                                                                                (observations -> '524abcfb-d2b0-46e4-9c18-c5c380adb862' ->> 0),--Iron (Fersifol) Strength
                                                                                '6b3c1744-f643-499d-8581-8b0b4a4017bd',
                                                                                (observations -> '6b3c1744-f643-499d-8581-8b0b4a4017bd' ->> 0),--Paracetamol Strength
                                                                                'feec4205-8f1e-4b8e-929f-f8c0664e34d4',
                                                                                (observations -> 'feec4205-8f1e-4b8e-929f-f8c0664e34d4' ->> 0),--Furosemide Strength
                                                                                '43ee5933-ba92-4a53-8d51-95423a293302',
                                                                                (observations -> '43ee5933-ba92-4a53-8d51-95423a293302' ->> 0),--Spironolactone Strength
                                                                                '973c7298-b68d-4459-8ada-c8f91a7c7bb8',
                                                                                (observations -> '973c7298-b68d-4459-8ada-c8f91a7c7bb8' ->> 0),--Ramipril Strength
                                                                                '89ce82a0-3c5b-4a1d-a47e-f83e1db12775',
                                                                                (observations -> '89ce82a0-3c5b-4a1d-a47e-f83e1db12775' ->> 0),--Metoprolol Strength
                                                                                'af3ac496-6398-41fb-b61a-9074bdc752c6',
                                                                                (observations -> 'af3ac496-6398-41fb-b61a-9074bdc752c6' ->> 0),--Clonidine Strength
                                                                                '94513b3b-b4e2-4f9c-9354-6399b6fd657c',
                                                                                (observations -> '94513b3b-b4e2-4f9c-9354-6399b6fd657c' ->> 0),--Prazosin Strength
                                                                                '6e96f709-dc8e-4e10-a79f-e908a790d719',
                                                                                (observations -> '6e96f709-dc8e-4e10-a79f-e908a790d719' ->> 0),--Becadex (multivitamin) Strength
                                                                                '1fe0da8d-569f-4f94-a308-c1321c5a0c7b',
                                                                                (observations -> '1fe0da8d-569f-4f94-a308-c1321c5a0c7b' ->> 0),--Amlodipin Strength
                                                                                'd6e1be9d-0937-4708-869f-19c816c11d7c',
                                                                                (observations -> 'd6e1be9d-0937-4708-869f-19c816c11d7c' ->> 0),--Calcium Strength
                                                                                'a5ed1d52-4b5a-4c79-974b-0adf2bf9ccb5',
                                                                                (observations -> 'a5ed1d52-4b5a-4c79-974b-0adf2bf9ccb5' ->> 0),--B-complex Strength
                                                                                'a3d5391e-e199-4121-8d42-6ff14f50a299',
                                                                                (observations -> 'a3d5391e-e199-4121-8d42-6ff14f50a299' ->> 0),--Nefedipin SR
                                                                                '99653b2a-e994-4d63-afaa-10c277ee0235',
                                                                                (observations -> '99653b2a-e994-4d63-afaa-10c277ee0235' ->> 0),--Enalapril Strength
                                                                                '449316d4-8391-4de9-9c96-18637b9572a6',
                                                                                (observations -> '449316d4-8391-4de9-9c96-18637b9572a6' ->> 0),--Hydrochlorothiazide (HCT) Strength
                                                                                'e3cab964-f906-4a94-8598-6dab62a19a95',
                                                                                (observations -> 'e3cab964-f906-4a94-8598-6dab62a19a95' ->> 0),--Atenolol Strength
                                                                                '55c272e7-5d2b-4cf2-ab96-d9c4de76a6b0',
                                                                                (observations -> '55c272e7-5d2b-4cf2-ab96-d9c4de76a6b0' ->> 0),--Nefedipin Strength
                                                                                '0914d979-72a6-49ef-a37b-0bb7df2068c0',
                                                                                (observations -> '0914d979-72a6-49ef-a37b-0bb7df2068c0' ->> 0))--Methyldopa Strength
            )
        where encounter_type_id = 633 and encounter_date_time notnull
        returning audit_id)
update audit
set last_modified_date_time = current_timestamp + id * ('1 millisecond' :: interval)
where id in (select audit_id from audits);


select id, observations
from program_encounter
where encounter_type_id = 633

