#!/bin/bash

# OurRide API - cURL Commands for Testing
# Base URL
BASE_URL="http://localhost:8080"

echo "=========================================="
echo "OurRide API Testing - cURL Commands"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================
# 1. Send OTP
# ============================================
echo -e "${BLUE}1. Send OTP${NC}"
echo "curl -X POST $BASE_URL/api/auth/send-otp \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -d '{\"phoneNumber\":\"1234567890\",\"countryCode\":\"+1\"}'"
echo ""

# Execute (uncomment to run)
# curl -X POST $BASE_URL/api/auth/send-otp \
#   -H "Content-Type: application/json" \
#   -d '{"phoneNumber":"1234567890","countryCode":"+1"}'

echo ""

# ============================================
# 2. Resend OTP
# ============================================
echo -e "${BLUE}2. Resend OTP${NC}"
echo "curl -X POST $BASE_URL/api/auth/resend-otp \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -d '{\"phoneNumber\":\"1234567890\",\"countryCode\":\"+1\"}'"
echo ""

# ============================================
# 3. Verify OTP - Sign In
# ============================================
echo -e "${BLUE}3. Verify OTP - Sign In${NC}"
echo "curl -X POST $BASE_URL/api/auth/verify-otp \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -d '{\"phoneNumber\":\"1234567890\",\"countryCode\":\"+1\",\"otp\":\"1234\",\"isSignUp\":false}'"
echo ""

# ============================================
# 4. Verify OTP - Sign Up
# ============================================
echo -e "${BLUE}4. Verify OTP - Sign Up${NC}"
echo "curl -X POST $BASE_URL/api/auth/verify-otp \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -d '{\"phoneNumber\":\"9876543210\",\"countryCode\":\"+1\",\"otp\":\"5678\",\"isSignUp\":true}'"
echo ""

# ============================================
# 5. Social Login - Google
# ============================================
echo -e "${BLUE}5. Social Login - Google${NC}"
echo "curl -X POST $BASE_URL/api/auth/social-login \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -d '{"
echo "    \"provider\":\"GOOGLE\","
echo "    \"providerId\":\"google_user_12345\","
echo "    \"email\":\"user@gmail.com\","
echo "    \"fullName\":\"John Doe\""
echo "  }'"
echo ""

# ============================================
# 6. Complete Profile
# ============================================
echo -e "${BLUE}6. Complete Profile${NC}"
echo "# Replace {ACCESS_TOKEN} with actual token from verify-otp response"
echo "curl -X POST $BASE_URL/api/auth/complete-profile \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -H 'Authorization: Bearer {ACCESS_TOKEN}' \\"
echo "  -d '{"
echo "    \"fullName\":\"John Doe\","
echo "    \"email\":\"john.doe@example.com\","
echo "    \"phoneNumber\":\"1234567890\","
echo "    \"countryCode\":\"+1\","
echo "    \"gender\":\"MALE\","
echo "    \"dateOfBirth\":\"1990-01-15\""
echo "  }'"
echo ""

# ============================================
# 7. Refresh Token
# ============================================
echo -e "${BLUE}7. Refresh Token${NC}"
echo "# Replace {REFRESH_TOKEN} with actual refresh token"
echo "curl -X POST $BASE_URL/api/auth/refresh-token \\"
echo "  -H 'Authorization: Bearer {REFRESH_TOKEN}'"
echo ""

# ============================================
# 8. Check Phone Number
# ============================================
echo -e "${BLUE}8. Check Phone Number${NC}"
echo "curl -X GET '$BASE_URL/api/auth/check-phone?phoneNumber=1234567890&countryCode=+1'"
echo ""

echo "=========================================="
echo "Note: Replace {ACCESS_TOKEN} and {REFRESH_TOKEN} with actual values"
echo "Check application logs for OTP if Twilio is not configured"
echo "=========================================="

