-- =====================================================
-- OurRide Database Migration Script
-- Version: 4.0.0
-- Description: Create saved_addresses table
-- =====================================================

CREATE TABLE IF NOT EXISTS saved_addresses (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    type VARCHAR(20),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_address_type CHECK (type IN ('HOME', 'OFFICE', 'APARTMENT', 'OTHER') OR type IS NULL)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_saved_addresses_user_id ON saved_addresses(user_id);
CREATE INDEX IF NOT EXISTS idx_saved_addresses_type ON saved_addresses(type) WHERE type IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_saved_addresses_created_at ON saved_addresses(created_at DESC);

-- Comments
COMMENT ON TABLE saved_addresses IS 'User saved addresses for quick access';
COMMENT ON COLUMN saved_addresses.name IS 'User-friendly name (e.g., Home, Office, Mom''s House)';
COMMENT ON COLUMN saved_addresses.type IS 'Address type: HOME, OFFICE, APARTMENT, OTHER';

-- Trigger for updated_at
CREATE TRIGGER update_saved_addresses_updated_at
    BEFORE UPDATE ON saved_addresses
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

