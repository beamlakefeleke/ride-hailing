# OurRide Database Setup Guide

## Overview

This directory contains database setup and migration scripts for the OurRide backend application.

## Files

- `setup.sql` - Initial database creation script
- `reset.sql` - Database reset script (development only)
- `../src/main/resources/db/migration/` - Flyway migration scripts

## Quick Start

### 1. Prerequisites

- PostgreSQL 12+ installed and running
- PostgreSQL superuser access (usually `postgres` user)

### 2. Create Database

#### Option A: Using psql command line
```bash
# Connect to PostgreSQL
psql -U postgres

# Run setup script
\i database/setup.sql
```

#### Option B: Using SQL file directly
```bash
psql -U postgres -f database/setup.sql
```

#### Option C: Manual creation
```sql
CREATE DATABASE ourride_db;
```

### 3. Configure Application

Update `application.yml` with your database credentials:
```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/ourride_db
    username: postgres
    password: your_password
```

### 4. Run Application

Start the Spring Boot application. Flyway will automatically:
- Detect migration scripts
- Execute them in order
- Create all tables and indexes
- Set up triggers and functions

```bash
mvn spring-boot:run
```

## Migration Scripts

Flyway migration scripts are located in:
```
src/main/resources/db/migration/
```

### Current Migrations

- **V1__initial_schema.sql** - Creates users table with all indexes and triggers
- **V2__add_wallet_balance.sql** - Adds wallet balance column to users table

### Migration Naming Convention

Flyway migrations must follow this naming pattern:
```
V{version}__{description}.sql
```

Example: `V1__initial_schema.sql`, `V2__add_wallet_balance.sql`

## Database Schema

### Users Table

| Column | Type | Description |
|--------|------|-------------|
| id | BIGSERIAL | Primary key |
| phone_number | VARCHAR(20) | Unique phone number with country code |
| email | VARCHAR(100) | Unique email address |
| full_name | VARCHAR(100) | User's full name |
| gender | VARCHAR(20) | MALE, FEMALE, OTHER, PREFER_NOT_TO_SAY |
| date_of_birth | DATE | User's date of birth |
| profile_image_url | VARCHAR(500) | URL to profile image |
| password | VARCHAR(255) | Encrypted password |
| auth_provider | VARCHAR(20) | PHONE, GOOGLE, APPLE, FACEBOOK, X |
| provider_id | VARCHAR(200) | Social login provider user ID |
| email_verified | BOOLEAN | Email verification status |
| phone_verified | BOOLEAN | Phone verification status |
| profile_completed | BOOLEAN | Profile completion status |
| active | BOOLEAN | Account active status |
| remember_me | BOOLEAN | Remember me preference |
| wallet_balance | DECIMAL(10,2) | User wallet balance |
| created_at | TIMESTAMP | Account creation timestamp |
| updated_at | TIMESTAMP | Last update timestamp |

### Indexes

- `idx_users_phone_number` - Fast lookup by phone number
- `idx_users_email` - Fast lookup by email
- `idx_users_provider` - Fast lookup for social login
- `idx_users_active` - Filter active users
- `idx_users_created_at` - Sort by creation date
- `idx_users_wallet_balance` - Wallet balance queries

## Development Workflow

### Adding New Migration

1. Create new file in `src/main/resources/db/migration/`
2. Follow naming: `V{next_version}__{description}.sql`
3. Write SQL for your changes
4. Test locally
5. Commit to version control

Example:
```sql
-- V3__add_addresses_table.sql
CREATE TABLE addresses (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    ...
);
```

### Resetting Database (Development Only)

⚠️ **WARNING**: This deletes all data!

```bash
psql -U postgres -d ourride_db -f database/reset.sql
```

Then restart the application to run migrations again.

## Production Considerations

1. **Backup First**: Always backup before running migrations
2. **Test Migrations**: Test on staging environment first
3. **Flyway Clean**: Disabled in production (see `application.yml`)
4. **Migration Order**: Flyway ensures migrations run in order
5. **Rollback**: Plan rollback strategy for each migration

## Troubleshooting

### Migration Failed

1. Check Flyway logs in application output
2. Verify database connection
3. Check migration script syntax
4. Ensure no conflicting migrations

### Reset Flyway History

If you need to reset Flyway migration history (development only):
```sql
DELETE FROM flyway_schema_history;
```

### Check Migration Status

Query Flyway history table:
```sql
SELECT * FROM flyway_schema_history ORDER BY installed_rank;
```

## Connection String Examples

### Local Development
```
jdbc:postgresql://localhost:5432/ourride_db
```

### Docker
```
jdbc:postgresql://postgres:5432/ourride_db
```

### Production
```
jdbc:postgresql://your-host:5432/ourride_db?ssl=true
```

## Environment Variables

Set these in your environment or `.env` file:

```bash
DB_USERNAME=postgres
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432
```

Then update `application.yml`:
```yaml
spring:
  datasource:
    url: jdbc:postgresql://${DB_HOST:localhost}:${DB_PORT:5432}/ourride_db
    username: ${DB_USERNAME:postgres}
    password: ${DB_PASSWORD:postgres}
```

