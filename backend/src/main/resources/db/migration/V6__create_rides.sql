-- =====================================================
-- OurRide Database Migration Script
-- Version: 6.0.0
-- Description: Create rides table
-- =====================================================

CREATE TABLE IF NOT EXISTS rides (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    driver_id BIGINT REFERENCES drivers(id) ON DELETE SET NULL,
    pickup_latitude DECIMAL(10, 8) NOT NULL,
    pickup_longitude DECIMAL(11, 8) NOT NULL,
    pickup_address TEXT NOT NULL,
    destination_latitude DECIMAL(10, 8) NOT NULL,
    destination_longitude DECIMAL(11, 8) NOT NULL,
    destination_address TEXT NOT NULL,
    ride_type VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    price DECIMAL(10, 2) NOT NULL,
    distance_km DECIMAL(10, 2),
    estimated_duration_minutes INTEGER,
    scheduled_datetime TIMESTAMP,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    cancelled_at TIMESTAMP,
    cancellation_reason TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_ride_type CHECK (ride_type IN ('CAR', 'CAR_XL', 'CAR_PLUS', 'MOTORBIKE', 'SCOOTER')),
    CONSTRAINT chk_ride_status CHECK (status IN ('PENDING', 'DRIVER_ASSIGNED', 'DRIVER_EN_ROUTE', 'ARRIVED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')),
    CONSTRAINT chk_price CHECK (price >= 0.00),
    CONSTRAINT chk_distance CHECK (distance_km IS NULL OR distance_km >= 0.00),
    CONSTRAINT chk_duration CHECK (estimated_duration_minutes IS NULL OR estimated_duration_minutes >= 0)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_rides_user_id ON rides(user_id);
CREATE INDEX IF NOT EXISTS idx_rides_driver_id ON rides(driver_id) WHERE driver_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_rides_status ON rides(status);
CREATE INDEX IF NOT EXISTS idx_rides_created_at ON rides(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_rides_scheduled ON rides(scheduled_datetime) WHERE scheduled_datetime IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_rides_user_status ON rides(user_id, status);

-- Comments
COMMENT ON TABLE rides IS 'Ride bookings and history';
COMMENT ON COLUMN rides.ride_type IS 'Ride type: CAR, CAR_XL, CAR_PLUS, MOTORBIKE, SCOOTER';
COMMENT ON COLUMN rides.status IS 'Ride status: PENDING, DRIVER_ASSIGNED, DRIVER_EN_ROUTE, ARRIVED, IN_PROGRESS, COMPLETED, CANCELLED';
COMMENT ON COLUMN rides.price IS 'Final ride price in USD';

-- Trigger for updated_at
CREATE TRIGGER update_rides_updated_at
    BEFORE UPDATE ON rides
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

