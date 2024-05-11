/*
Query Objective:
What are the highest-paying remote Data Analyst roles?

Details:

Identify the top 10 highest-paying Data Analyst positions available for remote work.
Focus specifically on job postings with specified salaries, excluding those with null values.
Bonus: Include the names of the companies offering the top 10 roles.
Purpose:
This query aims to shed light on the most lucrative opportunities for Data Analysts, particularly 
those offering remote work options. By highlighting these high-paying roles and providing insights into 
employment options and location flexibility, this query helps Data Analysts make informed career 
decisions.
*/

SELECT
    job_id,
    job_title,
    c.name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact j
LEFT JOIN company_dim c ON c.company_id = j.company_id
WHERE 
    job_title_short = 'Data Scientist' AND 
    job_location ='Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;

