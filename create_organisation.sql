select create_db_user('jsscp', 'password');

INSERT into organisation (name, db_user, uuid, media_directory)
values ('JSSCP', 'jsscp', 'd3a75adf-e5fb-4262-8681-c5f5eb36a88b', 'jsscp')
ON CONFLICT (uuid) DO NOTHING;