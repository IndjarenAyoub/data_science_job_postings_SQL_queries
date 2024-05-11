/*
Query Objective:
Identifying the skills required for the top-paying Data Scientist positions.

Details:

Utilize the top 10 highest-paying Data Scientist jobs obtained from the initial query.
Determine the specific skills that are required for these roles.
Purpose:
This query aims to provide insight into the specific skill sets demanded by high-paying Data Scientist 
positions. By analyzing the skills required for top-paying jobs, this query helps job seekers understand
which skills they should prioritize developing to align with lucrative salary opportunities within 
the field of Data Science.
*/


WITH jobs_skills AS (
SELECT
    job_id,
    job_title,
    c.name,
    salary_year_avg
FROM
    job_postings_fact j
LEFT JOIN company_dim c ON c.company_id = j.company_id
WHERE 
    job_title_short = 'Data Scientist' AND 
    job_location ='Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
)

SELECT 
    jobs_skills.*,
    sd.skills
FROM 
    jobs_skills
INNER JOIN skills_job_dim sj ON sj.job_id = jobs_skills.job_id
INNER JOIN skills_dim sd ON sd.skill_id = sj.skill_id
ORDER BY
    salary_year_avg DESC;

    