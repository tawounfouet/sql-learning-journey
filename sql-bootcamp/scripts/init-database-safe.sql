-- Create database only if it doesn't exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'SQLBootcamp')
BEGIN
    CREATE DATABASE SQLBootcamp;
    PRINT 'Database SQLBootcamp created successfully!';
END
ELSE
BEGIN
    PRINT 'Database SQLBootcamp already exists.';
END
GO

USE SQLBootcamp;
GO

-- Create Students table only if it doesn't exist
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Students' AND xtype='U')
BEGIN
    CREATE TABLE Students (
        StudentID INT IDENTITY(1,1) PRIMARY KEY,
        FirstName NVARCHAR(50) NOT NULL,
        LastName NVARCHAR(50) NOT NULL,
        Email NVARCHAR(100) UNIQUE,
        DateOfBirth DATE,
        CreatedAt DATETIME2 DEFAULT GETDATE()
    );
    PRINT 'Students table created successfully!';
END
ELSE
BEGIN
    PRINT 'Students table already exists.';
END
GO

-- Insert sample data only if table is empty
IF NOT EXISTS (SELECT 1 FROM Students)
BEGIN
    INSERT INTO Students (FirstName, LastName, Email, DateOfBirth)
    VALUES 
        ('John', 'Doe', 'john.doe@email.com', '1995-03-15'),
        ('Jane', 'Smith', 'jane.smith@email.com', '1996-07-22'),
        ('Mike', 'Johnson', 'mike.johnson@email.com', '1994-11-08'),
        ('Sarah', 'Wilson', 'sarah.wilson@email.com', '1997-01-30');
    PRINT 'Sample student data inserted successfully!';
END
ELSE
BEGIN
    PRINT 'Students table already contains data.';
END
GO

-- Create Courses table only if it doesn't exist
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Courses' AND xtype='U')
BEGIN
    CREATE TABLE Courses (
        CourseID INT IDENTITY(1,1) PRIMARY KEY,
        CourseName NVARCHAR(100) NOT NULL,
        Credits INT NOT NULL,
        Instructor NVARCHAR(100),
        CreatedAt DATETIME2 DEFAULT GETDATE()
    );
    PRINT 'Courses table created successfully!';
END
ELSE
BEGIN
    PRINT 'Courses table already exists.';
END
GO

-- Insert sample course data only if table is empty
IF NOT EXISTS (SELECT 1 FROM Courses)
BEGIN
    INSERT INTO Courses (CourseName, Credits, Instructor)
    VALUES 
        ('SQL Fundamentals', 3, 'Prof. Database'),
        ('Advanced SQL Queries', 4, 'Prof. Query'),
        ('Database Design', 3, 'Prof. Design'),
        ('Data Analysis with SQL', 4, 'Prof. Analytics');
    PRINT 'Sample course data inserted successfully!';
END
ELSE
BEGIN
    PRINT 'Courses table already contains data.';
END
GO

-- Create Enrollments table only if it doesn't exist
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Enrollments' AND xtype='U')
BEGIN
    CREATE TABLE Enrollments (
        EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,
        StudentID INT NOT NULL,
        CourseID INT NOT NULL,
        EnrollmentDate DATE DEFAULT GETDATE(),
        Grade CHAR(2),
        FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
        FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
    );
    PRINT 'Enrollments table created successfully!';
END
ELSE
BEGIN
    PRINT 'Enrollments table already exists.';
END
GO

-- Insert sample enrollment data only if table is empty
IF NOT EXISTS (SELECT 1 FROM Enrollments)
BEGIN
    INSERT INTO Enrollments (StudentID, CourseID, Grade)
    VALUES 
        (1, 1, 'A'),
        (1, 2, 'B+'),
        (2, 1, 'A-'),
        (2, 3, 'B'),
        (3, 1, 'B+'),
        (3, 4, 'A'),
        (4, 2, 'A-'),
        (4, 4, 'A');
    PRINT 'Sample enrollment data inserted successfully!';
END
ELSE
BEGIN
    PRINT 'Enrollments table already contains data.';
END
GO

PRINT 'Database initialization completed successfully!';
