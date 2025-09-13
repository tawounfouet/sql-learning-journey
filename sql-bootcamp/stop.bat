@echo off
REM Windows batch script to stop SQL Server Docker container

echo Stopping SQL Server Docker container...
docker-compose down

echo SQL Server container stopped.
echo.
echo To start again, run: start.bat
echo To completely remove data, run: docker-compose down -v
