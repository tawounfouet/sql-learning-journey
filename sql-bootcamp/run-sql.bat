@echo off
REM Batch script to run SQL scripts in the SQL Server container
REM Usage: run-sql.bat <path-to-sql-file> [database-name]

if "%1"=="" (
    echo Usage: run-sql.bat ^<path-to-sql-file^> [database-name]
    echo Example: run-sql.bat scripts\init-database.sql
    echo Example: run-sql.bat scripts\query.sql SQLBootcamp
    exit /b 1
)

set SQL_FILE=%1
set DATABASE=%2
if "%DATABASE%"=="" set DATABASE=master

REM Check if SQL file exists
if not exist "%SQL_FILE%" (
    echo Error: SQL file '%SQL_FILE%' not found!
    exit /b 1
)

REM Check if container is running
docker ps --filter "name=sql-bootcamp-server" --format "{{.Status}}" > nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Error: SQL Server container 'sql-bootcamp-server' is not running!
    echo Start it with: docker-compose -f docker-compose.advanced.yml up -d
    exit /b 1
)

echo Executing SQL script: %SQL_FILE%
echo Target database: %DATABASE%

REM Get just the filename for the temp path
for %%f in ("%SQL_FILE%") do set FILENAME=%%~nxf
set TEMP_PATH=/tmp/%FILENAME%

REM Copy the SQL file to the container
docker cp "%SQL_FILE%" "sql-bootcamp-server:%TEMP_PATH%"
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to copy SQL file to container!
    exit /b 1
)

REM Execute the SQL script
if "%DATABASE%"=="master" (
    docker exec -it sql-bootcamp-server /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i %TEMP_PATH% -C
) else (
    docker exec -it sql-bootcamp-server /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -d %DATABASE% -i %TEMP_PATH% -C
)

REM Clean up the temporary file
docker exec sql-bootcamp-server rm %TEMP_PATH%

if %ERRORLEVEL% equ 0 (
    echo.
    echo ✅ SQL script executed successfully!
) else (
    echo.
    echo ❌ SQL script execution failed!
)
