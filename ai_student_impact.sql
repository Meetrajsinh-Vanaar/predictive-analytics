DROP TABLE  IF EXISTS ai_student_impact;

DROP TABLE IF EXISTS students CASCADE;

CREATE TABLE students(
	student_id INT PRIMARY KEY,
	Major_Category VARCHAR(50),
	Year_of_Study VARCHAR(50),
	Pre_Semester_GPA NUMERIC (4,2),
	Weekly_GenAI_Hours NUMERIC (5,2),
	Primary_Use_Case VARCHAR(50),
	Prompt_Engineering_Skill VARCHAR(50),
	Tool_Diversity INT, 
	Paid_Subscription BOOLEAN,
	Traditional_Study_Hours	NUMERIC (5,2),
	Perceived_AI_Dependency	INT,
	Institutional_Policy VARCHAR(50),
	Anxiety_Level_During_Exams INT,
	Post_Semester_GPA NUMERIC (4,2),
	Skill_Retention_Score  NUMERIC (5,2),
	Burnout_Risk_Level VARCHAR(50)
);


-- ============================================================
-- Add constraints
-- ============================================================

ALTER TABLE students
  ADD CONSTRAINT chk_gpa CHECK (pre_semester_gpa BETWEEN 0 AND 4),
  ADD CONSTRAINT chk_burnout CHECK (burnout_risk_level IN ('Low','Medium','High'));

  
-- ============================================================
-- Add indexes for columns you'll query most
-- ============================================================

CREATE INDEX idx_major ON students(major_category);
CREATE INDEX idx_burnout ON students(burnout_risk_level);
CREATE INDEX idx_policy ON students(institutional_policy);


-- ============================================================
-- Should return 50000
-- ============================================================

SELECT COUNT (*) FROM students;


-- ============================================================
-- Preview first 5 rows
-- ============================================================

SELECT * FROM students LIMIT 5;


-- ============================================================
-- Check for nulls in columns.:-
-- ============================================================

SELECT * FROM  students
	WHERE student_id IS NULL
  OR
  Major_Category IS NULL
  OR
  Year_of_Study IS NULL
  OR
  Pre_Semester_GPA IS NULL
  OR
  Weekly_GenAI_Hours IS NULL
  OR
  Primary_Use_Case IS NULL
  OR
  Prompt_Engineering_Skill IS NULL
  OR
  Tool_Diversity IS NULL
  OR
  Paid_Subscription IS NULL
  OR
  Traditional_Study_Hours IS NULL
  OR
  Perceived_AI_Dependency IS NULL
  OR
  Institutional_Policy IS NULL
  OR
  Anxiety_Level_During_Exams IS NULL
  OR
  Post_Semester_GPA IS NULL
  OR
  Skill_Retention_Score IS NULL
  OR
  Burnout_Risk_Level IS NULL;

  
-- ============================================================  
-- Quick summary of majors
-- ============================================================

  SELECT Major_Category, COUNT (*) AS total
  	FROM students
 	GROUP BY Major_Category
  	ORDER BY total DESC;


-- ============================================================  
-- Total Students
-- ============================================================

SELECT COUNT(*) AS total_students
FROM students;


-- ============================================================  
-- Average GPA Improvement
-- ============================================================

SELECT
ROUND(AVG(post_semester_gpa - pre_semester_gpa),2)
AS avg_gpa_improvement
FROM students;


-- ============================================================  
-- AI Usage by Major
-- ============================================================

SELECT
major_category,
ROUND(AVG(weekly_genai_hours),2) AS avg_ai_hours
FROM students
GROUP BY major_category
ORDER BY avg_ai_hours DESC;


-- ============================================================  
-- Burnout Risk Distribution
-- ============================================================

SELECT
burnout_risk_level,
COUNT(*) AS total_students
FROM students
GROUP BY burnout_risk_level;


-- ============================================================  
-- GPA Improvement by Year
-- ============================================================

SELECT
year_of_study,
ROUND(AVG(post_semester_gpa - pre_semester_gpa),2)
AS avg_gpa_change
FROM students
GROUP BY year_of_study;

 
-- ============================================================  
-- Paid vs Free Users
-- ============================================================

SELECT
paid_subscription,
COUNT(*) AS total_students
FROM students
GROUP BY paid_subscription;


-- ============================================================  
-- Average AI Hours by Policy
-- ============================================================

SELECT
institutional_policy,
ROUND(AVG(weekly_genai_hours),2)
AS avg_hours
FROM students
GROUP BY institutional_policy;


-- ============================================================  
-- Average Retention Score by Major
-- ============================================================

SELECT
major_category,
ROUND(AVG(skill_retention_score),2)
AS retention_score
FROM students
GROUP BY major_category;


-- ============================================================  
-- Top 10 GPA Improvement
-- ============================================================

SELECT
student_id,
pre_semester_gpa,
post_semester_gpa,
(post_semester_gpa-pre_semester_gpa)
AS improvement
FROM students
ORDER BY improvement DESC
LIMIT 10;


-- ============================================================  
-- Burnout vs AI Usage
-- ============================================================

SELECT
burnout_risk_level,
ROUND(AVG(weekly_genai_hours),2)
AS avg_ai_hours
FROM students
GROUP BY burnout_risk_level;

