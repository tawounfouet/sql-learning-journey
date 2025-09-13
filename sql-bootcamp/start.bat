@echo off
REM Windows batch script to start SQL Server with Docker Compose

echo Starting SQL Server Docker container...
docker-compose up -d

echo Waiting for SQL Server to start...
timeout /t 30 /nobreak > nul

echo Checking container status...
docker-compose ps

echo.
echo SQL Server should now be running on localhost:1433
echo Username: sa
echo Password: YourStrong@Passw0rd
echo.
echo To connect using sqlcmd:
echo docker exec -it sql-bootcamp-server /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd
echo.
echo To view logs:
echo docker-compose logs sqlserver
echo.
echo To stop:
echo docker-compose down
