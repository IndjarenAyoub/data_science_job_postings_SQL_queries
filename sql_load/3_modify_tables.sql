/* ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
Database Load Issues (follow if receiving permission denied when running SQL code below)

NOTE: If you are having issues with permissions. And you get error: 

'could not open file "[your file path]\job_postings_fact.csv" for reading: Permission denied.'

1. Open pgAdmin
2. In Object Explorer (left-hand pane), navigate to `sql_course` database
3. Right-click `sql_course` and select `PSQL Tool`
    - This opens a terminal window to write the following code
4. Get the absolute file path of your csv files
    1. Find path by right-clicking a CSV file in VS Code and selecting “Copy Path”
5. Paste the following into `PSQL Tool`, (with the CORRECT file path)

\copy company_dim FROM '[Insert File Path]/company_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_dim FROM '[Insert File Path]/skills_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy job_postings_fact FROM '[Insert File Path]/job_postings_fact.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_job_dim FROM '[Insert File Path]/skills_job_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

*/

-- NOTE: This has been updated from the video to fix issues with encoding

COPY company_dim
FROM 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PostgreSQL 16\company_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');


COPY skills_dim
FROM 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PostgreSQL 16\skills_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY job_postings_fact
FROM 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PostgreSQL 16\job_postings_fact.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_job_dim
FROM 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PostgreSQL 16\skills_job_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');



SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' as date_time,
    EXTRACT(YEAR FROM job_posted_date) AS date_year,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(DAY FROM job_posted_date) AS date_day
FROM job_postings_fact
LIMIT 5;


SELECT *
FROM job_postings_fact





CREATE TABLE january_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;


CREATE TABLE february_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;


SELECT job_posted_date
FROM march_jobs






SELECT 
    job_schedule_type,
    AVG(salary_year_avg) AS average_yearly_salary,
    AVG(salary_hour_avg) AS average_hourly_salary
FROM 
    job_postings_fact
WHERE 
    job_posted_date > '2023-06-01'::DATE
GROUP BY 
    job_schedule_type;






SELECT
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month,
    COUNT(*) AS job_count
FROM 
    job_postings_fact
WHERE 
    job_posted_date BETWEEN '2023-01-01' AND '2024-01-01'
GROUP BY 
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York')
ORDER BY 
    month



SELECT 
    c.company_id,
    c.name AS company_name
FROM 
    company_dim c
LEFT JOIN job_postings_fact j ON c.company_id = j.company_id
WHERE
    j.job_posted_date >= '2023-04-01' AND j.job_posted_date < '2023-07-01'



SELECT 
    COUNT(job_id) AS number_of_jobS,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE job_title_short = 'Data Scientist'
GROUP BY
    location_category;





WITH remote_jobs_skills AS (
SELECT 
    skill_id,
    COUNT(*) AS skill_count
FROM
    skills_job_dim
INNER JOIN job_postings_fact ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE
    job_postings_fact.job_work_from_home = True AND
    job_postings_fact.job_title_short = 'Data Scientist'
GROUP BY
    skill_id
)
SELECT
    skills_dim.skill_id,
    skills AS skill_name,
    skill_count
FROM
    remote_jobs_skills
INNER JOIN skills_dim ON skills_dim.skill_id = remote_jobs_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;


SELECT 
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM    
    february_jobs

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM    
    march_jobs






SELECT
    q1_jobs_postings.job_title_short,
    q1_jobs_postings.job_location,
    q1_jobs_postings.job_via,
    q1_jobs_postings.job_posted_date::DATE,
    q1_jobs_postings.salary_year_avg
FROM (
SELECT *
FROM
    january_jobs
UNION ALL
SELECT *
FROM
    february_jobs
UNION ALL
SELECT *
FROM
    march_jobs
) AS q1_jobs_postings
WHERE
    q1_jobs_postings.salary_year_avg > 70000 AND
    q1_jobs_postings.job_title_short = 'Data Scientist'
ORDER BY q1_jobs_postings.salary_year_avg DESC



SELECT 
    j.job_id, 
    j.company_id, 
    j.job_title_short, 
    j.job_location
FROM
    job_postings_fact j
JOIN company_dim c ON c.company_id = j.company_id



SELECT 
    job_id,
    company_id,
    job_title_short,
    job_country,
    salary_year_avg
FROM job_postings_fact
WHERE job_work_from_home = True




SELECT 
    c.name,
    AVG(j.salary_year_avg) AS average_salary
FROM job_postings_fact j
JOIN company_dim c ON c.company_id = j.company_id
GROUP BY c.name
ORDER BY average_salary DESC;



SELECT 
    sd.skills,
    COUNT(*) AS skill_count
FROM
    skills_dim sd
JOIN skills_job_dim sj ON sj.skill_id = sd.skill_id
JOIN job_postings_fact j ON j.job_id = sj.job_id
WHERE j.job_work_from_home = True
GROUP BY
    sd.skills
ORDER BY
    skill_count DESC
LIMIT 5;



SELECT 
    c.name,
    COUNT(*) AS job_count
FROM 
    company_dim c
JOIN job_postings_fact j ON j.company_id = c.company_id
GROUP BY
    c.name
ORDER BY job_count DESC
LIMIT 5;



SELECT 
    j.job_id,
    j.job_title,
    COUNT(sj.skill_id) AS skills_count
FROM 
    job_postings_fact j
LEFT JOIN skills_job_dim sj ON sj.job_id = j.job_id 
GROUP BY
    j.job_title, j.job_id
ORDER BY skills_count DESC




SELECT
    EXTRACT(MONTH FROM job_posted_date::DATE) AS month,
    COUNT(*) months_counting
FROM
    job_postings_fact
GROUP BY
    EXTRACT(MONTH FROM job_posted_date::DATE)
ORDER BY 
    months_counting DESC
LIMIT 1;




SELECT DATE_TRUNC('month', job_posted_date) AS month, COUNT(*) AS job_count
FROM job_postings_fact
GROUP BY month
ORDER BY job_count DESC
LIMIT 1;



SELECT 
    job_id,
    job_title_short,
    job_title,
    job_country,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    job_health_insurance = True AND job_work_from_home = True





SELECT
    c.name,
    COUNT(j.job_id) AS total_jobs
FROM
    job_postings_fact j
INNER JOIN company_dim c ON c.company_id = j.company_id
GROUP BY
    c.name
ORDER BY
    total_jobs DESC



SELECT 
    c.name,
    AVG(j.salary_year_avg) AS average_company_salary
FROM
    job_postings_fact j
INNER JOIN company_dim c ON c.company_id = j.company_id
GROUP BY
    c.name
ORDER BY
    average_company_salary DESC





SELECT
    job_id,
    job_title_short,
    job_posted_date::DATE
FROM
    job_postings_fact
ORDER BY
    job_posted_date DESC




SELECT
    c.name,
    j.job_title,
    j.salary_year_avg
FROM
    job_postings_fact j
INNER JOIN company_dim c ON c.company_id = j.company_id
WHERE j.salary_year_avg IS NOT NULL
GROUP BY
    c.name,
    j.job_title,
    j.salary_year_avg
ORDER BY
    j.salary_year_avg DESC
LIMIT 1;



SELECT
    AVG(salary_year_avg) AS overall_average_salary
FROM
    job_postings_fact





SELECT
    sd.skills,
    j.salary_year_avg
FROM 
    job_postings_fact j
INNER JOIN skills_job_dim sj ON sj.job_id = j.job_id
INNER JOIN skills_dim sd ON sd.skill_id = sj.skill_id
WHERE
    j.salary_year_avg > (SELECT
                            AVG(salary_year_avg) AS overall_average_salary
                        FROM
                            job_postings_fact
                        )
GROUP BY
    sd.skills,
    j.salary_year_avg
ORDER BY
    j.salary_year_avg DESC




SELECT
    job_id,
    job_title,
    job_title_short,
    salary_year_avg
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 3;