-- Allow null phone_number for social logins
ALTER TABLE users
    ALTER COLUMN phone_number DROP NOT NULL;

