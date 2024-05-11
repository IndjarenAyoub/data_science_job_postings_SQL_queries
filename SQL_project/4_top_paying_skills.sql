/*
Query Objective:
Identifying the top skills based on salary for Data Analyst positions.

Details:

Calculate the average salary associated with each skill for Data Analyst roles.
Focus exclusively on roles with specified salaries, irrespective of location.
Purpose:
This analysis aims to uncover the correlation between different skills and salary levels within 
the Data Analyst domain. By highlighting the skills that have the greatest impact on salary, 
this query assists in identifying the most financially rewarding skills for individuals seeking
 to enter or advance within the field of Data Analysis.
*/


SELECT
    skills,
    ROUND(AVG(salary_year_avg), 2) AS skill_average_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Scientist' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = True
GROUP BY
    skills
ORDER BY
    skill_average_salary DESC
LIMIT 25;