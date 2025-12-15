-- =====================================================
-- OurRide Database Migration Script
-- Version: 5.0.0
-- Description: Create drivers table
-- =====================================================

CREATE TABLE IF NOT EXISTS drivers (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    vehicle_type VARCHAR(50) NOT NULL,
    vehicle_number VARCHAR(20) NOT NULL,
    license_number VARCHAR(50) NOT NULL UNIQUE,
    rating DECIMAL(3, 2) NOT NULL DEFAULT 0.00,
    total_rides INTEGER NOT NULL DEFAULT 0,
    is_available BOOLEAN NOT NULL DEFAULT TRUE,
    current_latitude DECIMAL(10, 8),
    current_longitude DECIMAL(11, 8),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_rating CHECK (rating >= 0.00 AND rating <= 5.00),
    CONSTRAINT chk_total_rides CHECK (total_rides >= 0)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_drivers_user_id ON drivers(user_id);
CREATE INDEX IF NOT EXISTS idx_drivers_available ON drivers(is_available) WHERE is_available = TRUE;
CREATE INDEX IF NOT EXISTS idx_drivers_location ON drivers(current_latitude, current_longitude) WHERE current_latitude IS NOT NULL AND current_longitude IS NOT NULL;

-- Comments
COMMENT ON TABLE drivers IS 'Driver information and availability';
COMMENT ON COLUMN drivers.vehicle_type IS 'Vehicle type: CAR, CAR_XL, CAR_PLUS, MOTORBIKE, SCOOTER';
COMMENT ON COLUMN drivers.rating IS 'Average rating from 0.00 to 5.00';

-- Trigger for updated_at
CREATE TRIGGER update_drivers_updated_at
    BEFORE UPDATE ON drivers
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

