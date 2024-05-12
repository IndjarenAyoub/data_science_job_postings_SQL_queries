/*
Query Objective:
Determining the most in-demand skills for Data Analysts.

Details:

Perform an inner join between job postings and a similar table as in query 2 to gather relevant data.
Identify the top 5 in-demand skills for Data Analyst roles.
Consider all job postings in the analysis.
Purpose:
This query aims to uncover the top 5 skills with the highest demand in the job market for Data Analyst 
positions. By analyzing the most in-demand skills, this query provides valuable insights for job seekers,
 helping them prioritize skill development and enhance their competitiveness in the job market.
*/

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist' 
    AND job_work_from_home = True 
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 7;