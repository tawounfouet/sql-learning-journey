-- Script to clean and recreate the SQLBootcamp database
-- Use with caution: This will delete all data!

USE master;
GO

-- Drop database if it exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'SQLBootcamp')
BEGIN
    DROP DATABASE SQLBootcamp;
    PRINT 'Database SQLBootcamp dropped successfully!';
END
GO

-- Create fresh database
CREATE DATABASE SQLBootcamp;
GO

USE SQLBootcamp;
GO

-- Create Students table
CREATE TABLE Students (
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    DateOfBirth DATE,
    CreatedAt DATETIME2 DEFAULT GETDATE()
);

-- Insert sample data
INSERT INTO Students (FirstName, LastName, Email, DateOfBirth)
VALUES 
    ('John', 'Doe', 'john.doe@email.com', '1995-03-15'),
    ('Jane', 'Smith', 'jane.smith@email.com', '1996-07-22'),
    ('Mike', 'Johnson', 'mike.johnson@email.com', '1994-11-08'),
    ('Sarah', 'Wilson', 'sarah.wilson@email.com', '1997-01-30');

-- Create Courses table
CREATE TABLE Courses (
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    CourseName NVARCHAR(100) NOT NULL,
    Credits INT NOT NULL,
    Instructor NVARCHAR(100),
    CreatedAt DATETIME2 DEFAULT GETDATE()
);

-- Insert sample course data
INSERT INTO Courses (CourseName, Credits, Instructor)
VALUES 
    ('SQL Fundamentals', 3, 'Prof. Database'),
    ('Advanced SQL Queries', 4, 'Prof. Query'),
    ('Database Design', 3, 'Prof. Design'),
    ('Data Analysis with SQL', 4, 'Prof. Analytics');

-- Create enrollment table
CREATE TABLE Enrollments (
    EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    EnrollmentDate DATE DEFAULT GETDATE(),
    Grade CHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Insert sample enrollment data
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

PRINT 'Fresh SQLBootcamp database created successfully with sample data!';
