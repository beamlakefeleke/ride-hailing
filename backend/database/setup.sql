-- =====================================================
-- OurRide Database Setup Script
-- Description: Creates database and user for OurRide application
-- =====================================================

-- Connect to PostgreSQL as superuser (postgres)
-- Run this script as: psql -U postgres -f setup.sql

-- =====================================================
-- CREATE DATABASE
-- =====================================================
-- Drop database if exists (use with caution in production)
-- DROP DATABASE IF EXISTS ourride_db;

CREATE DATABASE ourride_db
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TEMPLATE = template0
    CONNECTION LIMIT = -1;

-- =====================================================
-- CREATE APPLICATION USER (Optional)
-- =====================================================
-- Uncomment below if you want a dedicated database user
/*
CREATE USER ourride_user WITH PASSWORD 'ourride_password';
GRANT ALL PRIVILEGES ON DATABASE ourride_db TO ourride_user;
*/

-- =====================================================
-- CONNECT TO NEW DATABASE
-- =====================================================
\c ourride_db

-- =====================================================
-- CREATE EXTENSIONS
-- =====================================================
-- Enable UUID extension if needed in future
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enable PostGIS for location services (if needed)
-- CREATE EXTENSION IF NOT EXISTS postgis;

-- =====================================================
-- GRANT PERMISSIONS (if using dedicated user)
-- =====================================================
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ourride_user;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ourride_user;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO ourride_user;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO ourride_user;

-- =====================================================
-- VERIFY SETUP
-- =====================================================
SELECT 
    datname as "Database Name",
    pg_size_pretty(pg_database_size(datname)) as "Size"
FROM pg_database 
WHERE datname = 'ourride_db';

-- Display success message
DO $$
BEGIN
    RAISE NOTICE 'OurRide database setup completed successfully!';
    RAISE NOTICE 'Database: ourride_db';
    RAISE NOTICE 'Next step: Run the Spring Boot application to execute Flyway migrations.';
END $$;

