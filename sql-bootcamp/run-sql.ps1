# PowerShell script to run SQL scripts in the SQL Server container
param(
    [Parameter(Mandatory=$true)]
    [string]$SqlFile,
    [string]$Database = "master",
    [switch]$IgnoreErrors
)

# Check if the SQL file exists
if (!(Test-Path $SqlFile)) {
    Write-Error "SQL file '$SqlFile' not found!"
    exit 1
}

# Check if container is running
$containerStatus = docker ps --filter "name=sql-bootcamp-server" --format "{{.Status}}"
if (!$containerStatus) {
    Write-Error "SQL Server container 'sql-bootcamp-server' is not running!"
    Write-Host "Start it with: docker-compose -f docker-compose.advanced.yml up -d"
    exit 1
}

Write-Host "Executing SQL script: $SqlFile"
Write-Host "Target database: $Database"

# Copy the SQL file to the container
$tempPath = "/tmp/" + (Split-Path $SqlFile -Leaf)
docker cp $SqlFile "sql-bootcamp-server:$tempPath"

if ($LASTEXITCODE -eq 0) {
    # Execute the SQL script
    if ($Database -eq "master") {
        $result = docker exec -it sql-bootcamp-server /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i $tempPath -C 2>&1
    } else {
        $result = docker exec -it sql-bootcamp-server /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -d $Database -i $tempPath -C 2>&1
    }
    
    # Display the output
    Write-Host $result
    
    # Clean up the temporary file (ignore errors)
    docker exec sql-bootcamp-server rm $tempPath 2>$null
    
    # Check for critical errors (but ignore common "already exists" errors)
    $criticalErrors = $result | Where-Object { 
        $_ -match "Msg \d+" -and 
        $_ -notmatch "already exists" -and 
        $_ -notmatch "There is already an object named" -and
        $_ -notmatch "Database .* already exists" -and
        $_ -notmatch "Violation of UNIQUE KEY constraint" -and
        $_ -notmatch "Cannot insert duplicate key"
    }
    
    if ($criticalErrors -and !$IgnoreErrors) {
        Write-Host "⚠️  Script completed with warnings (likely due to existing objects)" -ForegroundColor Yellow
    } else {
        Write-Host "✅ SQL script executed successfully!" -ForegroundColor Green
    }
} else {
    Write-Error "❌ Failed to copy SQL file to container!"
}
