# Migration from GoRide to OurRide

## Package Structure Changes

All package names have been changed from `com.goride` to `com.ourride`.

## Directory Structure Update Required

You need to manually move/rename the following directories:

### Current Structure:
```
backend/src/main/java/com/goride/
```

### New Structure:
```
backend/src/main/java/com/ourride/
```

## Steps to Complete Migration:

1. **Rename the main package directory:**
   ```bash
   # On Windows (PowerShell)
   Rename-Item -Path "backend\src\main\java\com\goride" -NewName "ourride"
   
   # On Linux/Mac
   mv backend/src/main/java/com/goride backend/src/main/java/com/ourride
   ```

2. **Delete the old main application file:**
   - Delete: `backend/src/main/java/com/goride/GorideApplication.java`
   - Use: `backend/src/main/java/com/ourride/OurRideApplication.java`

3. **Update database name:**
   - Old: `goride_db`
   - New: `ourride_db`
   
   ```sql
   CREATE DATABASE ourride_db;
   ```

4. **Rebuild the project:**
   ```bash
   mvn clean install
   ```

## What Has Been Changed:

✅ Package names: `com.goride` → `com.ourride`
✅ Class name: `GorideApplication` → `OurRideApplication`
✅ Database name: `goride_db` → `ourride_db`
✅ Application name: `goride-backend` → `ourride-backend`
✅ Maven artifact: `goride-backend` → `ourride-backend`
✅ All string references: "GoRide" → "OurRide"
✅ Logging configuration updated
✅ README updated

## Files That Need Manual Action:

- Move all files from `com/goride/` to `com/ourride/` directory
- Delete old `GorideApplication.java` file
- Create new database `ourride_db`

All code has been updated with the new naming convention!

