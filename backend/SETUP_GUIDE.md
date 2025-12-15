# OurRide Backend Setup Guide

Complete setup guide for OurRide backend with database migrations.

## Prerequisites

- **Java 17+** - [Download](https://adoptium.net/)
- **Maven 3.6+** - [Download](https://maven.apache.org/download.cgi)
- **PostgreSQL 12+** - [Download](https://www.postgresql.org/download/)
- **Redis 6+** - [Download](https://redis.io/download) (Optional for development)

## Quick Setup (5 Minutes)

### Option 1: Using Docker (Recommended)

1. **Start Database and Redis:**
   ```bash
   cd backend
   docker-compose up -d postgres redis
   ```

2. **Wait for services to be healthy:**
   ```bash
   docker-compose ps
   ```

3. **Run Application:**
   ```bash
   mvn spring-boot:run
   ```

Flyway will automatically create the database schema on first run!

### Option 2: Manual Setup

#### Step 1: Install PostgreSQL

**Windows:**
- Download from [PostgreSQL Website](https://www.postgresql.org/download/windows/)
- Install with default settings
- Remember the postgres user password

**Mac:**
```bash
brew install postgresql@15
brew services start postgresql@15
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
```

#### Step 2: Create Database

**Option A: Using Setup Script**
```bash
psql -U postgres -f database/setup.sql
```

**Option B: Manual Creation**
```bash
psql -U postgres
```

Then run:
```sql
CREATE DATABASE ourride_db;
\q
```

#### Step 3: Install Redis (Optional for Development)

**Windows:**
- Download from [Redis for Windows](https://github.com/microsoftarchive/redis/releases)
- Or use WSL2

**Mac:**
```bash
brew install redis
brew services start redis
```

**Linux:**
```bash
sudo apt install redis-server
sudo systemctl start redis
```

#### Step 4: Configure Environment

1. **Copy environment template:**
   ```bash
   cp .env.example .env
   ```

2. **Update `.env` with your values:**
   ```bash
   DB_USERNAME=postgres
   DB_PASSWORD=root
   JWT_SECRET=your-secret-key-minimum-256-bits
   ```

3. **Or set environment variables directly:**
   ```bash
   export DB_PASSWORD=your_password
   export JWT_SECRET=your-secret-key
   ```

#### Step 5: Run Application

```bash
mvn clean install
mvn spring-boot:run
```

The application will:
- ✅ Connect to PostgreSQL
- ✅ Run Flyway migrations automatically
- ✅ Create all tables and indexes
- ✅ Start on http://localhost:8080

## Verify Setup

### Check Database

```bash
psql -U postgres -d ourride_db
```

```sql
-- Check tables
\dt

-- Check users table structure
\d users

-- Check Flyway migration history
SELECT * FROM flyway_schema_history;
```

### Test API Endpoints

```bash
# Health check (if actuator is enabled)
curl http://localhost:8080/actuator/health

# Send OTP
curl -X POST http://localhost:8080/api/auth/send-otp \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"1234567890","countryCode":"+1"}'
```

## Project Structure

```
backend/
├── src/
│   └── main/
│       ├── java/com/ourride/
│       │   ├── config/          # Configuration
│       │   ├── controller/      # REST Controllers
│       │   ├── dto/             # Data Transfer Objects
│       │   ├── exception/       # Exception Handlers
│       │   ├── model/           # Entity Models
│       │   ├── repository/     # JPA Repositories
│       │   ├── security/        # Security Configuration
│       │   └── service/         # Business Logic
│       └── resources/
│           ├── application.yml  # Application Config
│           └── db/
│               └── migration/  # Flyway Migrations
│                   ├── V1__initial_schema.sql
│                   └── V2__add_wallet_balance.sql
├── database/
│   ├── setup.sql               # Database setup
│   ├── reset.sql               # Database reset (dev only)
│   └── README.md               # Database docs
├── docker-compose.yml          # Docker setup
├── .env.example               # Environment template
├── pom.xml                    # Maven config
└── SETUP_GUIDE.md            # This file
```

## Database Migrations

### How Flyway Works

1. **On Application Start**: Flyway scans `db/migration/` folder
2. **Checks History**: Queries `flyway_schema_history` table
3. **Runs New Migrations**: Executes any migrations not yet run
4. **Version Control**: Each migration has a version number

### Migration Files

- `V1__initial_schema.sql` - Creates users table
- `V2__add_wallet_balance.sql` - Adds wallet balance

### Adding New Migration

1. Create file: `V3__your_description.sql`
2. Write SQL changes
3. Restart application
4. Flyway runs it automatically

Example:
```sql
-- V3__add_addresses_table.sql
CREATE TABLE addresses (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    address_line1 VARCHAR(255),
    city VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Configuration

### Application Configuration

Edit `src/main/resources/application.yml`:

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/ourride_db
    username: ${DB_USERNAME:postgres}
    password: ${DB_PASSWORD:postgres}
  
  flyway:
    enabled: true
    locations: classpath:db/migration
```

### Environment Variables

Set these in your environment or `.env` file:

```bash
# Database
DB_USERNAME=postgres
DB_PASSWORD=your_password

# JWT
JWT_SECRET=your-secret-key-minimum-256-bits

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# Twilio (Optional)
TWILIO_ACCOUNT_SID=your_sid
TWILIO_AUTH_TOKEN=your_token
TWILIO_PHONE_NUMBER=your_number
```

## Troubleshooting

### Database Connection Failed

**Error:** `Connection refused` or `Authentication failed`

**Solution:**
1. Check PostgreSQL is running: `pg_isready` or `docker-compose ps`
2. Verify credentials in `application.yml`
3. Check firewall settings
4. Ensure database exists: `psql -U postgres -l`

### Migration Failed

**Error:** `Migration checksum mismatch` or `Migration failed`

**Solution:**
1. Check migration SQL syntax
2. Verify no conflicting migrations
3. Check Flyway logs in application output
4. If needed, repair: `mvn flyway:repair` (if Flyway Maven plugin added)

### Redis Connection Failed

**Error:** `Unable to connect to Redis`

**Solution:**
1. Check Redis is running: `redis-cli ping`
2. Verify Redis host/port in `application.yml`
3. For development, Redis is optional - OTP will be logged to console

### Port Already in Use

**Error:** `Port 8080 is already in use`

**Solution:**
1. Change port in `application.yml`:
   ```yaml
   server:
     port: 8081
   ```
2. Or stop the process using port 8080

## Development Workflow

### Daily Development

1. **Start Services:**
   ```bash
   docker-compose up -d postgres redis
   ```

2. **Run Application:**
   ```bash
   mvn spring-boot:run
   ```

3. **Make Changes:**
   - Code changes auto-reload (with devtools)
   - Database changes require new migration

4. **Stop Services:**
   ```bash
   docker-compose down
   ```

### Adding New Features

1. Create entity/model
2. Create repository
3. Create service
4. Create controller
5. If database changes needed, create migration
6. Test endpoints

### Database Changes

1. Create migration file: `V{next}__description.sql`
2. Write SQL for changes
3. Test locally
4. Commit to version control
5. Deploy - Flyway runs automatically

## Production Deployment

### Pre-Deployment Checklist

- [ ] Change `JWT_SECRET` to strong random value
- [ ] Update database credentials
- [ ] Set `spring.jpa.hibernate.ddl-auto=validate`
- [ ] Disable Flyway clean: `spring.flyway.clean-disabled=true`
- [ ] Enable SSL for database connection
- [ ] Set up database backups
- [ ] Configure Redis persistence
- [ ] Set up monitoring and logging

### Production Configuration

Create `application-prod.yml`:

```yaml
spring:
  datasource:
    url: jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME}?ssl=true
    username: ${DB_USERNAME}
    password: ${DB_PASSWORD}
  
  jpa:
    hibernate:
      ddl-auto: validate
  
  flyway:
    enabled: true
    clean-disabled: true

logging:
  level:
    com.ourride: INFO
    org.springframework: WARN
```

Run with:
```bash
mvn spring-boot:run -Dspring-boot.run.profiles=prod
```

## Next Steps

1. ✅ Database setup complete
2. ✅ Migrations configured
3. 🔄 Test authentication endpoints
4. 🔄 Add more features (rides, payments, etc.)
5. 🔄 Set up CI/CD pipeline

## Support

For issues or questions:
1. Check logs: `tail -f logs/application.log`
2. Check database: `psql -U postgres -d ourride_db`
3. Check Flyway status: Query `flyway_schema_history` table

---

**Happy Coding! 🚀**

