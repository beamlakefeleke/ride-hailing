-- =====================================================
-- OurRide Database Migration Script
-- Version: 2.0.0
-- Description: Add wallet balance column to users table
-- =====================================================

-- Add wallet balance column
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS wallet_balance DECIMAL(10, 2) NOT NULL DEFAULT 0.00;

-- Add index for wallet balance queries
CREATE INDEX IF NOT EXISTS idx_users_wallet_balance ON users(wallet_balance);

-- Add comment
COMMENT ON COLUMN users.wallet_balance IS 'User wallet balance in USD';

