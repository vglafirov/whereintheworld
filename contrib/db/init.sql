-- Create a database
CREATE DATABASE whereintheworld;

-- Create user and grant all permissions to database
CREATE USER whereintheworld WITH PASSWORD 'whereintheworld';
ALTER ROLE whereintheworld SUPERUSER;