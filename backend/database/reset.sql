-- =====================================================
-- OurRide Database Reset Script
-- WARNING: This will DELETE ALL DATA!
-- Use only in development/testing environments
-- =====================================================

-- Connect to PostgreSQL
\c ourride_db

-- Drop all tables (in correct order to handle foreign keys)
DROP TABLE IF EXISTS users CASCADE;

-- Drop functions
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;

-- Drop sequences
DROP SEQUENCE IF EXISTS users_id_seq CASCADE;

-- Display message
DO $$
BEGIN
    RAISE NOTICE 'Database reset completed. All tables and data have been removed.';
    RAISE NOTICE 'Run the Spring Boot application to recreate schema via Flyway migrations.';
END $$;

