@echo off
REM OurRide API - cURL Commands for Windows
REM Base URL
set BASE_URL=http://localhost:8080

echo ==========================================
echo OurRide API Testing - cURL Commands
echo ==========================================
echo.

REM ============================================
REM 1. Send OTP
REM ==========================================
echo 1. Send OTP
echo curl -X POST %BASE_URL%/api/auth/send-otp ^
echo   -H "Content-Type: application/json" ^
echo   -d "{\"phoneNumber\":\"1234567890\",\"countryCode\":\"+1\"}"
echo.

REM ============================================
REM 2. Resend OTP
REM ==========================================
echo 2. Resend OTP
echo curl -X POST %BASE_URL%/api/auth/resend-otp ^
echo   -H "Content-Type: application/json" ^
echo   -d "{\"phoneNumber\":\"1234567890\",\"countryCode\":\"+1\"}"
echo.

REM ============================================
REM 3. Verify OTP - Sign In
REM ==========================================
echo 3. Verify OTP - Sign In
echo curl -X POST %BASE_URL%/api/auth/verify-otp ^
echo   -H "Content-Type: application/json" ^
echo   -d "{\"phoneNumber\":\"1234567890\",\"countryCode\":\"+1\",\"otp\":\"1234\",\"isSignUp\":false}"
echo.

REM ============================================
REM 4. Verify OTP - Sign Up
REM ==========================================
echo 4. Verify OTP - Sign Up
echo curl -X POST %BASE_URL%/api/auth/verify-otp ^
echo   -H "Content-Type: application/json" ^
echo   -d "{\"phoneNumber\":\"9876543210\",\"countryCode\":\"+1\",\"otp\":\"5678\",\"isSignUp\":true}"
echo.

REM ============================================
REM 5. Social Login - Google
REM ==========================================
echo 5. Social Login - Google
echo curl -X POST %BASE_URL%/api/auth/social-login ^
echo   -H "Content-Type: application/json" ^
echo   -d "{\"provider\":\"GOOGLE\",\"providerId\":\"google_user_12345\",\"email\":\"user@gmail.com\",\"fullName\":\"John Doe\"}"
echo.

REM ============================================
REM 6. Complete Profile
REM ==========================================
echo 6. Complete Profile
echo Replace {ACCESS_TOKEN} with actual token
echo curl -X POST %BASE_URL%/api/auth/complete-profile ^
echo   -H "Content-Type: application/json" ^
echo   -H "Authorization: Bearer {ACCESS_TOKEN}" ^
echo   -d "{\"fullName\":\"John Doe\",\"email\":\"john.doe@example.com\",\"phoneNumber\":\"1234567890\",\"countryCode\":\"+1\",\"gender\":\"MALE\",\"dateOfBirth\":\"1990-01-15\"}"
echo.

REM ============================================
REM 7. Refresh Token
REM ==========================================
echo 7. Refresh Token
echo Replace {REFRESH_TOKEN} with actual token
echo curl -X POST %BASE_URL%/api/auth/refresh-token ^
echo   -H "Authorization: Bearer {REFRESH_TOKEN}"
echo.

REM ============================================
REM 8. Check Phone Number
REM ==========================================
echo 8. Check Phone Number
echo curl -X GET "%BASE_URL%/api/auth/check-phone?phoneNumber=1234567890&countryCode=+1"
echo.

echo ==========================================
echo Note: Replace tokens with actual values
echo Check application logs for OTP
echo ==========================================

pause

