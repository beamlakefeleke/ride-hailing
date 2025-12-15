-- =====================================================
-- OurRide Database Migration Script
-- Version: 8.0.0
-- Description: Create ride_ratings table
-- =====================================================

CREATE TABLE IF NOT EXISTS ride_ratings (
    id BIGSERIAL PRIMARY KEY,
    ride_id BIGINT NOT NULL REFERENCES rides(id) ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    driver_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(ride_id, user_id)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_ride_ratings_ride_id ON ride_ratings(ride_id);
CREATE INDEX IF NOT EXISTS idx_ride_ratings_user_id ON ride_ratings(user_id);
CREATE INDEX IF NOT EXISTS idx_ride_ratings_driver_id ON ride_ratings(driver_id);
CREATE INDEX IF NOT EXISTS idx_ride_ratings_created_at ON ride_ratings(created_at DESC);

-- Comments
COMMENT ON TABLE ride_ratings IS 'User ratings and feedback for completed rides';
COMMENT ON COLUMN ride_ratings.rating IS 'Rating from 1 to 5 stars';

-- Trigger for updated_at
CREATE TRIGGER update_ride_ratings_updated_at
    BEFORE UPDATE ON ride_ratings
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

