-- =====================================================
-- OurRide Database Migration Script
-- Version: 7.0.0
-- Description: Create wallet_transactions table
-- =====================================================

CREATE TABLE IF NOT EXISTS wallet_transactions (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    transaction_type VARCHAR(20) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50),
    payment_method_details VARCHAR(200),
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    transaction_id VARCHAR(100) UNIQUE,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_transaction_type CHECK (transaction_type IN ('TOP_UP', 'RIDE_PAYMENT', 'REFUND', 'WITHDRAWAL')),
    CONSTRAINT chk_transaction_status CHECK (status IN ('PENDING', 'COMPLETED', 'FAILED', 'CANCELLED'))
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_wallet_transactions_user_id ON wallet_transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_wallet_transactions_type ON wallet_transactions(transaction_type);
CREATE INDEX IF NOT EXISTS idx_wallet_transactions_status ON wallet_transactions(status);
CREATE INDEX IF NOT EXISTS idx_wallet_transactions_created_at ON wallet_transactions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_wallet_transactions_transaction_id ON wallet_transactions(transaction_id) WHERE transaction_id IS NOT NULL;

-- Comments
COMMENT ON TABLE wallet_transactions IS 'Wallet transactions for top-ups, payments, refunds';
COMMENT ON COLUMN wallet_transactions.transaction_type IS 'Type: TOP_UP, RIDE_PAYMENT, REFUND, WITHDRAWAL';
COMMENT ON COLUMN wallet_transactions.status IS 'Status: PENDING, COMPLETED, FAILED, CANCELLED';
COMMENT ON COLUMN wallet_transactions.transaction_id IS 'Unique transaction ID for external payment systems';

-- Trigger for updated_at
CREATE TRIGGER update_wallet_transactions_updated_at
    BEFORE UPDATE ON wallet_transactions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

