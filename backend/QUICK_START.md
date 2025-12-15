# OurRide Backend - Quick Start Guide

## 🚀 Fastest Setup (Using Docker)

### 1. Start Database & Redis
```bash
cd backend
docker-compose up -d postgres redis
```

### 2. Run Application
```bash
mvn spring-boot:run
```

**That's it!** Flyway will automatically:
- ✅ Create database schema
- ✅ Run all migrations
- ✅ Set up tables and indexes

---

## 📋 Manual Setup

### Step 1: Create Database
```bash
psql -U postgres -f database/setup.sql
```

Or manually:
```sql
CREATE DATABASE ourride_db;
```

### Step 2: Configure
Copy `.env.example` to `.env` and update:
```bash
DB_PASSWORD=your_password
JWT_SECRET=your-secret-key-minimum-256-bits
```

### Step 3: Run
```bash
mvn spring-boot:run
```

---

## ✅ Verify Setup

### Check Database
```bash
psql -U postgres -d ourride_db
\dt  # List tables
\d users  # Describe users table
```

### Test API
```bash
curl -X POST http://localhost:8080/api/auth/send-otp \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"1234567890","countryCode":"+1"}'
```

---

## 📁 What Was Created

### Database Migrations
- ✅ `V1__initial_schema.sql` - Users table with indexes
- ✅ `V2__add_wallet_balance.sql` - Wallet balance column

### Setup Scripts
- ✅ `database/setup.sql` - Database creation
- ✅ `database/reset.sql` - Development reset
- ✅ `docker-compose.yml` - Docker setup

### Configuration
- ✅ Flyway enabled in `application.yml`
- ✅ Automatic migration on startup
- ✅ Database validation mode

---

## 🎯 Next Steps

1. ✅ Database setup complete
2. ✅ Migrations configured
3. 🔄 Test authentication endpoints
4. 🔄 Add more features

See `SETUP_GUIDE.md` for detailed documentation.

