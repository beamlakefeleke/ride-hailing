-- =====================================================
-- OurRide Database Migration Script
-- Version: 1.0.0
-- Description: Initial database schema for OurRide application
-- =====================================================

-- =====================================================
-- USERS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    full_name VARCHAR(100),
    gender VARCHAR(20),
    date_of_birth DATE,
    profile_image_url VARCHAR(500),
    password VARCHAR(255) NOT NULL,
    auth_provider VARCHAR(20) NOT NULL DEFAULT 'PHONE',
    provider_id VARCHAR(200),
    email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    phone_verified BOOLEAN NOT NULL DEFAULT FALSE,
    profile_completed BOOLEAN NOT NULL DEFAULT FALSE,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    remember_me BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_gender CHECK (gender IN ('MALE', 'FEMALE', 'OTHER', 'PREFER_NOT_TO_SAY') OR gender IS NULL),
    CONSTRAINT chk_auth_provider CHECK (auth_provider IN ('PHONE', 'GOOGLE', 'APPLE', 'FACEBOOK', 'X'))
);

-- Indexes for Users table
CREATE INDEX IF NOT EXISTS idx_users_phone_number ON users(phone_number);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_provider ON users(provider_id, auth_provider) WHERE provider_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_users_active ON users(active) WHERE active = TRUE;
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);

-- =====================================================
-- COMMENTS
-- =====================================================
COMMENT ON TABLE users IS 'User accounts for OurRide application';
COMMENT ON COLUMN users.phone_number IS 'Full phone number with country code (e.g., +11234567890)';
COMMENT ON COLUMN users.auth_provider IS 'Authentication provider: PHONE, GOOGLE, APPLE, FACEBOOK, X';
COMMENT ON COLUMN users.provider_id IS 'User ID from social login provider';
COMMENT ON COLUMN users.password IS 'Encrypted password (empty for phone auth, hashed for social login)';

-- =====================================================
-- TRIGGERS
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update updated_at
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- INITIAL DATA (Optional - for testing)
-- =====================================================
-- Uncomment below if you want to insert test data
/*
INSERT INTO users (
    phone_number, 
    password, 
    auth_provider, 
    phone_verified, 
    active
) VALUES (
    '+11234567890',
    '$2a$10$dummyHashForTesting',
    'PHONE',
    TRUE,
    TRUE
) ON CONFLICT (phone_number) DO NOTHING;
*/

