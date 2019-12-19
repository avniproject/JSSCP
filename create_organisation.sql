select create_db_user('jsscp', 'password');

INSERT into organisation (name, db_user, uuid, parent_organisation_id)
values ('JSS CP', 'jsscp', 'd3a75adf-e5fb-4262-8681-c5f5eb36a88b', null)
ON CONFLICT (uuid) DO NOTHING;