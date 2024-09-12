CREATE DATABASE SchoolDB;

USE SchoolDB;
CREATE TABLE StudentGrades(
	studentID INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    subject VARCHAR(100) NOT NULL,
    numeric_grade DECIMAL (5,2) NOT NULL
);

INSERT INTO StudentGrades (student_name, subject, numeric_grade) VALUES
	('Alice Johnson', 'Math', 85.5),
	('Bob Smith', 'Math', 92.0),
	('Charlie Brown', 'Math', 73.4),
	('Daisy Miller', 'Math', 59.9),
	('Evan Lee', 'Math', 88.7);
    
SELECT 
studentID,
student_name,
subject,
numeric_grade,
	CASE
		WHEN numeric_grade >= 90 THEN 'A'
        WHEN numeric_grade >= 80 THEN 'B'
		WHEN numeric_grade >= 70 THEN 'C'
		WHEN numeric_grade >= 60 THEN 'D'
        ELSE 'F'
	END AS 'Student Grades'
FROM studentgrades
ORDER BY numeric_grade DESC;

SELECT 
*,
	CASE
		WHEN numeric_grade >= 90 THEN 'A'
        WHEN numeric_grade >= 80 THEN 'B'
		WHEN numeric_grade >= 70 THEN 'C'
		WHEN numeric_grade >= 60 THEN 'D'
        ELSE 'F'
	END AS 'Student Grades'
FROM studentgrades
ORDER BY numeric_grade DESC;