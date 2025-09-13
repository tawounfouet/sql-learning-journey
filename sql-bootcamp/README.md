# SQL Server Docker Compose Setup

This repository contains a Docker Compose configuration for running SQL Server for your SQL bootcamp learning environment.

## Prerequisites

- Docker Desktop installed on your system
- Docker Compose (included with Docker Desktop)
- PowerShell execution policy configured (for Windows users)

### Setting up PowerShell Execution Policy (Windows)

To use the provided PowerShell scripts, you need to allow script execution:

```powershell
# Run this command in PowerShell as Administrator or for current user
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**What this does:**
- Allows locally created scripts to run
- Still requires downloaded scripts to be signed
- Only affects the current user (safer than system-wide changes)

**Alternative execution policies:**
- `Restricted` (default): No scripts allowed
- `RemoteSigned`: Local scripts OK, downloaded scripts need signature
- `Unrestricted`: All scripts allowed (less secure)

## Quick Start

1. **Start SQL Server:**
   ```bash
   docker-compose up -d
   ```

2. **Check if the container is running:**
   ```bash
   docker-compose ps
   ```

3. **View logs:**
   ```bash
   docker-compose logs sqlserver
   ```

4. **Stop the SQL Server:**
   ```bash
   docker-compose down
   ```

## Configuration

### Default Settings
- **Server:** localhost:1433
- **Username:** sa
- **Password:** YourStrong@Passw0rd
- **Database:** SQLBootcamp (created by init script)

### Environment Variables
You can modify the settings in the `.env` file:
- `SA_PASSWORD`: SQL Server SA password (must be strong)
- `MSSQL_PID`: SQL Server edition (Express, Developer, Standard, Enterprise)
- `HOST_PORT`: Port to expose SQL Server on (default: 1433)

## Connecting to SQL Server

### Using SQL Server Management Studio (SSMS)
- Server name: `localhost,1433` or `127.0.0.1,1433`
- Authentication: SQL Server Authentication
- Login: `sa`
- Password: `YourStrong@Passw0rd`

### Using Azure Data Studio
- Connection type: Microsoft SQL Server
- Server: `localhost,1433`
- Authentication type: SQL Login
- User name: `sa`
- Password: `YourStrong@Passw0rd`

### Using sqlcmd (Command Line)
```powershell
docker exec -it sql-bootcamp-server /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -C
```

## Sample Database

The setup includes a sample database called `SQLBootcamp` with the following tables:
- **Students**: Sample student records
- **Courses**: Sample course information
- **Enrollments**: Student course enrollments (demonstrates relationships)

You can run the initialization script manually:

### Using the provided scripts (Recommended):
```powershell
# Windows PowerShell - Safe initialization (handles existing objects)
.\run-sql.ps1 scripts\init-database-safe.sql

# Windows PowerShell - Reset database (WARNING: deletes all data)
.\run-sql.ps1 scripts\reset-database.sql

# Windows Command Prompt
run-sql.bat scripts\init-database-safe.sql
```

**Note**: If you see error messages about "already exists" or "duplicate key", this is normal when running the script multiple times. The script will still complete successfully.

## Available Scripts

### PowerShell Scripts
- **`run-sql.ps1`**: Universal script to execute any SQL file in the container
  ```powershell
  .\run-sql.ps1 <sql-file> [database-name]
  ```

### Batch Scripts  
- **`run-sql.bat`**: Windows batch version for command prompt users
- **`start.bat`**: Quick start script for SQL Server
- **`stop.bat`**: Quick stop script for SQL Server

### SQL Scripts
- **`scripts/init-database-safe.sql`**: Safe initialization (handles existing objects)
- **`scripts/reset-database.sql`**: Complete database reset (⚠️ deletes all data)
- **`scripts/test-data.sql`**: Verify database setup and view sample data
- **`scripts/init-database.sql`**: Original initialization script

### Manual execution:
```powershell
# Copy script to container and execute
docker cp scripts/init-database.sql sql-bootcamp-server:/tmp/init-database.sql
docker exec -it sql-bootcamp-server /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i /tmp/init-database.sql -C
```

## Data Persistence

The SQL Server data is persisted in a Docker volume named `sqlserver_data`. This means your data will survive container restarts and updates.

To completely remove all data:
```bash
docker-compose down -v
```

## Troubleshooting

### Container won't start
1. Check if port 1433 is already in use
2. Verify the SA password meets complexity requirements
3. Check Docker logs: `docker-compose logs sqlserver`

### Can't connect to SQL Server
1. Wait for the container to fully start (can take 30-60 seconds)
2. Check health status: `docker-compose ps`
3. Verify the password and connection details

### Reset everything
```bash
docker-compose down -v
docker-compose up -d
```

### PowerShell Script Issues

**Error: "Execution of scripts is disabled"**
```powershell
# Solution: Set execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Error: "Cannot be loaded because running scripts is disabled"**
```powershell
# Check current policy
Get-ExecutionPolicy

# If restricted, change it
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Redirection not supported (`<` operator)**
- PowerShell doesn't support `<` redirection like Bash
- Use our provided scripts: `.\run-sql.ps1 script.sql`
- Or use: `Get-Content script.sql | docker exec -i container sqlcmd ...`

## Useful Commands

- **Execute SQL commands directly:**
  ```powershell
  docker exec -it sql-bootcamp-server /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -Q "SELECT @@VERSION" -C
  ```

- **Access container shell:**
  ```powershell
  docker exec -it sql-bootcamp-server bash
  ```

- **View real-time logs:**
  ```powershell
  docker-compose logs -f sqlserver
  ```

- **Quick database test:**
  ```powershell
  .\run-sql.ps1 scripts\test-data.sql
  ```

## Security Notes

⚠️ **Important**: The default password in this setup is for development/learning purposes only. For production use:
1. Use a strong, unique password
2. Consider using Docker secrets
3. Restrict network access
4. Enable SSL/TLS encryption
