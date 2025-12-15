# Create OurRide Database

## Database Name: `ourride_db`

## Quick Setup Methods

### Method 1: Using psql Command Line

1. **Open PowerShell/Terminal**
2. **Connect to PostgreSQL:**
   ```bash
   psql -U postgres
   ```
   (Enter your PostgreSQL password when prompted)

3. **Create the database:**
   ```sql
   CREATE DATABASE ourride_db;
   ```

4. **Verify it was created:**
   ```sql
   \l
   ```
   (Look for `ourride_db` in the list)

5. **Exit psql:**
   ```sql
   \q
   ```

---

### Method 2: Using SQL Script

1. **Run the setup script:**
   ```bash
   psql -U postgres -f database/setup.sql
   ```

---

### Method 3: Using Docker Compose (Recommended)

If you're using Docker:

```bash
cd backend
docker-compose up -d
```

This will automatically create the `ourride_db` database.

---

### Method 4: Using pgAdmin (GUI)

1. Open pgAdmin
2. Connect to your PostgreSQL server
3. Right-click on "Databases" → "Create" → "Database"
4. Name: `ourride_db`
5. Owner: `postgres`
6. Click "Save"

---

## Verify Database Connection

After creating the database, test the connection:

```bash
psql -U postgres -d ourride_db
```

If successful, you'll see:
```
psql (version)
Type "help" for help.

ourride_db=#
```

---

## Troubleshooting

### Error: "password authentication failed"
- Check your PostgreSQL password
- Default password in config: `postgres`
- Update `application.yml` if your password is different

### Error: "database does not exist"
- Make sure you created the database first
- Check database name spelling: `ourride_db`

### Error: "could not connect to server"
- Make sure PostgreSQL is running
- Check if port 5432 is correct
- Verify PostgreSQL service is started

---

## Next Steps

After creating the database:
1. ✅ Database created: `ourride_db`
2. ✅ Start Spring Boot application
3. ✅ Flyway will automatically create tables
4. ✅ Ready to test API endpoints!

