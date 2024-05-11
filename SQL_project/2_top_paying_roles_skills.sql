/*
Question: What skills are required for the top-paying data Scientist jobs?
- Use the top 10 highest-paying Data Scientist jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills, 
    helping job seekers understand which skills to develop that align with top salaries
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

    