# OurRide API Testing Guide - Postman

## 📥 Import Collection

1. **Open Postman**
2. **Click "Import"** button (top left)
3. **Select Files** tab
4. **Choose** `OurRide_API_Collection.json`
5. **Click "Import"**

## 🌍 Import Environment

1. **Click "Environments"** (left sidebar)
2. **Click "Import"**
3. **Select** `OurRide_Environment.json`
4. **Select "OurRide - Local Development"** environment (top right)

## 🚀 Quick Test Flow

### Step 1: Send OTP
1. Open **"1. Send OTP"** request
2. Update phone number if needed
3. Click **"Send"**
4. Check console logs for OTP (if Twilio not configured)

### Step 2: Verify OTP
1. Open **"3. Verify OTP - Sign In"** or **"4. Verify OTP - Sign Up"**
2. Enter the OTP from console/logs
3. Click **"Send"**
4. ✅ Access token will be automatically saved to environment

### Step 3: Complete Profile (if sign-up)
1. Open **"9. Complete Profile"**
2. Token is automatically included from previous step
3. Fill in profile details
4. Click **"Send"**

## 📋 Request Details

### 1. Send OTP
**Endpoint:** `POST /api/auth/send-otp`

**Request Body:**
```json
{
    "phoneNumber": "1234567890",
    "countryCode": "+1"
}
```

**Expected Response:**
```json
{
    "message": "OTP sent successfully",
    "expiresIn": 300,
    "canResend": false
}
```

**Note:** In development (without Twilio), check application console logs for OTP.

---

### 2. Resend OTP
**Endpoint:** `POST /api/auth/resend-otp`

**Request Body:**
```json
{
    "phoneNumber": "1234567890",
    "countryCode": "+1"
}
```

**Note:** Can only resend after 60-second cooldown period.

---

### 3. Verify OTP - Sign In
**Endpoint:** `POST /api/auth/verify-otp`

**Request Body:**
```json
{
    "phoneNumber": "1234567890",
    "countryCode": "+1",
    "otp": "1234",
    "isSignUp": false
}
```

**Expected Response:**
```json
{
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "tokenType": "Bearer",
    "expiresIn": 86400,
    "user": {
        "id": 1,
        "phoneNumber": "+11234567890",
        "email": "user@example.com",
        "fullName": "John Doe",
        "phoneVerified": true,
        "emailVerified": false
    },
    "profileCompleted": true,
    "requiresProfileCompletion": false
}
```

**✅ Token automatically saved to environment variables**

---

### 4. Verify OTP - Sign Up
**Endpoint:** `POST /api/auth/verify-otp`

**Request Body:**
```json
{
    "phoneNumber": "9876543210",
    "countryCode": "+1",
    "otp": "5678",
    "isSignUp": true
}
```

**Expected Response:**
```json
{
    "accessToken": "...",
    "refreshToken": "...",
    "user": {
        "id": 2,
        "phoneNumber": "+19876543210",
        "phoneVerified": true
    },
    "profileCompleted": false,
    "requiresProfileCompletion": true
}
```

**Note:** After sign-up, user must complete profile.

---

### 5-8. Social Login
**Endpoint:** `POST /api/auth/social-login`

**Request Body (Google Example):**
```json
{
    "provider": "GOOGLE",
    "providerId": "google_user_12345",
    "email": "user@gmail.com",
    "fullName": "John Doe",
    "profileImageUrl": "https://example.com/profile.jpg"
}
```

**Available Providers:**
- `GOOGLE`
- `APPLE`
- `FACEBOOK`
- `X`

---

### 9. Complete Profile
**Endpoint:** `POST /api/auth/complete-profile`

**Headers:**
```
Authorization: Bearer {access_token}
```

**Request Body:**
```json
{
    "fullName": "John Doe",
    "email": "john.doe@example.com",
    "phoneNumber": "1234567890",
    "countryCode": "+1",
    "gender": "MALE",
    "dateOfBirth": "1990-01-15"
}
```

**Gender Options:**
- `MALE`
- `FEMALE`
- `OTHER`
- `PREFER_NOT_TO_SAY`

**Date Format:** `YYYY-MM-DD`

---

### 10. Refresh Token
**Endpoint:** `POST /api/auth/refresh-token`

**Headers:**
```
Authorization: Bearer {refresh_token}
```

**Expected Response:**
```json
{
    "accessToken": "new_access_token...",
    "refreshToken": "new_refresh_token...",
    ...
}
```

**✅ New tokens automatically saved**

---

### 11. Check Phone Number
**Endpoint:** `GET /api/auth/check-phone`

**Query Parameters:**
- `phoneNumber`: 1234567890
- `countryCode`: +1

**Expected Response:**
```json
{
    "exists": false,
    "message": "Phone number available"
}
```

## 🔄 Complete Test Flow Example

### Sign Up Flow:
1. ✅ **Send OTP** → Get OTP from logs
2. ✅ **Verify OTP (Sign Up)** → Get tokens
3. ✅ **Complete Profile** → Finish setup

### Sign In Flow:
1. ✅ **Send OTP** → Get OTP from logs
2. ✅ **Verify OTP (Sign In)** → Get tokens
3. ✅ **Refresh Token** → Test token refresh

### Social Login Flow:
1. ✅ **Social Login (Google)** → Get tokens directly

## 🧪 Testing Tips

### 1. Check OTP in Logs
If Twilio is not configured, OTP will be logged:
```
INFO  OtpService - OTP for +1 1234567890: 1234
```

### 2. Use Environment Variables
- `{{base_url}}` - API base URL (default: http://localhost:8080)
- `{{access_token}}` - Auto-saved after login
- `{{refresh_token}}` - Auto-saved after login
- `{{user_id}}` - Auto-saved user ID

### 3. Test Error Cases
Try these to test validation:
- Empty phone number
- Invalid phone format
- Invalid OTP
- Expired OTP (wait 5 minutes)
- Missing required fields

### 4. Test Authentication
- Try accessing protected endpoints without token
- Try with invalid token
- Test token expiration

## 📊 Expected Status Codes

| Endpoint | Success | Error |
|----------|---------|-------|
| Send OTP | 200 | 400 (validation) |
| Verify OTP | 200 | 400 (invalid OTP) |
| Social Login | 200 | 400 (validation) |
| Complete Profile | 200 | 401 (unauthorized) |
| Refresh Token | 200 | 401 (invalid token) |

## 🔍 Debugging

### Check Response
- **Status Code**: Should be 200 for success
- **Response Body**: Check JSON structure
- **Headers**: Check for error messages

### Common Issues

**1. Connection Refused**
- ✅ Check if backend is running: `http://localhost:8080`
- ✅ Verify port in `application.yml`

**2. Invalid OTP**
- ✅ Check console logs for actual OTP
- ✅ Ensure OTP not expired (5 minutes)
- ✅ Use correct phone number

**3. Unauthorized (401)**
- ✅ Check if token is set in environment
- ✅ Verify token not expired
- ✅ Ensure "Bearer " prefix in Authorization header

**4. Validation Errors (400)**
- ✅ Check request body format
- ✅ Verify all required fields present
- ✅ Check data types match schema

## 📝 Sample Test Data

### Phone Numbers (for testing):
- `1234567890` (US)
- `9876543210` (US)
- `1234567890` (UK with +44)
- `9876543210` (India with +91)

### OTP Values:
- Check application console logs
- Format: 4 digits (e.g., `1234`, `5678`)

### Dates:
- Format: `YYYY-MM-DD`
- Example: `1990-01-15`, `2000-12-25`

## 🎯 Next Steps

After testing authentication:
1. ✅ Verify all endpoints work
2. ✅ Test error scenarios
3. ✅ Verify token persistence
4. ✅ Test profile completion flow
5. ✅ Ready for Flutter app integration!

---

**Happy Testing! 🚀**

