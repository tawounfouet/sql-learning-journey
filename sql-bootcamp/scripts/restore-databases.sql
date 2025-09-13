RESTORE DATABASE AdventureWorks2022
FROM DISK = '/var/backups/AdventureWorks2022.bak'
WITH MOVE 'AdventureWorks2022' TO '/var/opt/mssql/data/AdventureWorks2022.mdf',
     MOVE 'AdventureWorks2022_log' TO '/var/opt/mssql/data/AdventureWorks2022_log.ldf',
     REPLACE;
GO

RESTORE DATABASE AdventureWorks2019
FROM DISK = '/var/backups/AdventureWorks2019.bak'
WITH MOVE 'AdventureWorks2019' TO '/var/opt/mssql/data/AdventureWorks2019.mdf',
     MOVE 'AdventureWorks2019_log' TO '/var/opt/mssql/data/AdventureWorks2019_log.ldf',
     REPLACE;
GO



RESTORE DATABASE AdventureWorksDW2022
FROM DISK = '/var/backups/AdventureWorksDW2022.bak'
WITH MOVE 'AdventureWorksDW2022' TO '/var/opt/mssql/data/AdventureWorksDW2022.mdf',
     MOVE 'AdventureWorksDW2022_log' TO '/var/opt/mssql/data/AdventureWorksDW2022_log.ldf',
     REPLACE;
GO

RESTORE DATABASE AdventureWorksLT2022
FROM DISK = '/var/backups/AdventureWorksLT2022.bak'
WITH MOVE 'AdventureWorksLT2022_Data' TO '/var/opt/mssql/data/AdventureWorksLT2022.mdf',
     MOVE 'AdventureWorksLT2022_Log' TO '/var/opt/mssql/data/AdventureWorksLT2022_log.ldf',
     REPLACE;
GO
