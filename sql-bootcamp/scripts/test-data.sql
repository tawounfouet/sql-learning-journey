-- Quick test queries for the SQLBootcamp database
USE SQLBootcamp;
GO

-- Check if database and tables exist
PRINT '=== Database Information ===';
SELECT 
    DB_NAME() as CurrentDatabase,
    @@VERSION as SQLServerVersion;

PRINT '=== Table Counts ===';
SELECT 'Students' as TableName, COUNT(*) as RecordCount FROM Students;
SELECT 'Courses' as TableName, COUNT(*) as RecordCount FROM Courses;
SELECT 'Enrollments' as TableName, COUNT(*) as RecordCount FROM Enrollments;

PRINT '=== Sample Data Preview ===';
PRINT 'Students:';
SELECT TOP 3 * FROM Students;

PRINT 'Courses:';
SELECT TOP 3 * FROM Courses;

PRINT 'Enrollments with Names:';
SELECT TOP 5 
    s.FirstName + ' ' + s.LastName as StudentName,
    c.CourseName,
    e.Grade
FROM Enrollments e
JOIN Students s ON e.StudentID = s.StudentID
JOIN Courses c ON e.CourseID = c.CourseID;

PRINT '=== Test completed successfully! ===';
