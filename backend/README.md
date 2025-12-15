# OurRide Backend - Spring Boot Implementation

## Authentication Flow Implementation

This backend implements the complete authentication flow for OurRide mobile app:

### Features:
- ✅ Phone-based authentication with OTP
- ✅ Social login (Google, Apple, Facebook, X)
- ✅ JWT token-based authentication
- ✅ Profile completion after sign-up
- ✅ Remember me functionality
- ✅ OTP resend with cooldown

## Setup Instructions

### 1. Prerequisites
- Java 17+
- Maven 3.6+
- PostgreSQL 12+
- Redis 6+

### 2. Database Setup
```sql
CREATE DATABASE ourride_db;
```

### 3. Environment Variables
Create `.env` file or set environment variables:
```bash
DB_USERNAME=postgres
DB_PASSWORD=root
REDIS_HOST=localhost
REDIS_PORT=6379
JWT_SECRET=your-super-secret-key-minimum-256-bits
TWILIO_ACCOUNT_SID=your_twilio_sid
TWILIO_AUTH_TOKEN=your_twilio_token
TWILIO_PHONE_NUMBER=your_twilio_number
```

### 4. Run Application
```bash
mvn spring-boot:run
```

## API Endpoints

### Authentication

#### Send OTP
```
POST /api/auth/send-otp
Body: {
  "phoneNumber": "1234567890",
  "countryCode": "+1"
}
```

#### Verify OTP
```
POST /api/auth/verify-otp
Body: {
  "phoneNumber": "1234567890",
  "countryCode": "+1",
  "otp": "1234",
  "isSignUp": false
}
```

#### Social Login
```
POST /api/auth/social-login
Body: {
  "provider": "GOOGLE",
  "providerId": "google_user_id",
  "email": "user@example.com",
  "fullName": "John Doe"
}
```

#### Complete Profile
```
POST /api/auth/complete-profile
Headers: Authorization: Bearer <token>
Body: {
  "fullName": "John Doe",
  "email": "john@example.com",
  "phoneNumber": "1234567890",
  "countryCode": "+1",
  "gender": "MALE",
  "dateOfBirth": "1990-01-01"
}
```

## Project Structure

```
backend/
├── src/
│   └── main/
│       ├── java/com/ourride/
│       │   ├── config/          # Configuration classes
│       │   ├── controller/      # REST controllers
│       │   ├── dto/             # Data Transfer Objects
│       │   ├── exception/       # Exception handlers
│       │   ├── model/           # Entity models
│       │   ├── repository/      # JPA repositories
│       │   ├── security/        # Security configuration
│       │   └── service/         # Business logic
│       └── resources/
│           └── application.yml  # Configuration
└── pom.xml
```

## Testing

### Using cURL

#### Send OTP
```bash
curl -X POST http://localhost:8080/api/auth/send-otp \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"1234567890","countryCode":"+1"}'
```

#### Verify OTP
```bash
curl -X POST http://localhost:8080/api/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"1234567890","countryCode":"+1","otp":"1234","isSignUp":false}'
```

## Notes

- OTP is stored in Redis with 5-minute expiration
- JWT tokens are valid for 24 hours (access) and 7 days (refresh)
- In development, OTP is logged to console if Twilio is not configured
- All endpoints use proper validation and error handling

