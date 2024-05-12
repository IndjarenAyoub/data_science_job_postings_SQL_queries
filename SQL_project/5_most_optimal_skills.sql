/*
Query Objective:
Identifying the most optimal skills to learn for Data Scientists.

Details:

Analyze skills that are both in high demand and associated with high average salaries for 
Data Scientist roles.
Focus specifically on remote positions with specified salaries.
Purpose:
This analysis targets skills that offer a combination of job security (due to high demand) 
and financial benefits (due to high salaries), providing strategic insights for individuals seeking 
to develop their careers in data science. By identifying these optimal skills, individuals can make 
informed decisions about skill acquisition and prioritize areas of study for career advancement.
*/

WITH most_in_demand AS (
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist' 
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills_dim.skill_id,
    skills_dim.skills
ORDER BY
    demand_count DESC
),
most_paying AS (
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
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
    skills_dim.skill_id,
    skills_dim.skills
ORDER BY
    skill_average_salary DESC
)
SELECT
    most_in_demand.skill_id,
    most_in_demand.skills,
    demand_count,
    skill_average_salary
FROM most_in_demand
INNER JOIN most_paying ON most_paying.skill_id = most_in_demand.skill_id
ORDER BY
    demand_count DESC,
    skill_average_salary DESC
LIMIT 10

/*
Analysis Summary:
The most optimal skills for Data Scientists are as follows:

1. Python:
   - Demand Count: 763
   - Average Salary: $143,827.93

2. SQL:
   - Demand Count: 591
   - Average Salary: $142,832.59

3. R:
   - Demand Count: 394
   - Average Salary: $137,885.37

4. Tableau:
   - Demand Count: 219
   - Average Salary: $146,970.05

5. AWS:
   - Demand Count: 217
   - Average Salary: $149,629.96

6. Spark:
   - Demand Count: 149
   - Average Salary: $150,188.49

7. TensorFlow:
   - Demand Count: 126
   - Average Salary: $151,536.49

8. Azure:
   - Demand Count: 122
   - Average Salary: $142,305.83

9. PyTorch:
   - Demand Count: 115
   - Average Salary: $152,602.70

10. Pandas:
    - Demand Count: 113
    - Average Salary: $144,815.95

This breakdown provides valuable insights into the most optimal skills for Data Scientists, 
guiding individuals in their career development and skill acquisition endeavors.
*/



-- rewriting this same query more concisely

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(salary_year_avg), 2) AS skill_average_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Scientist' 
    AND salary_year_avg IS NOT NULL 
    AND job_work_from_home = True
GROUP BY
    skills_dim.skill_id,
    skills_dim.skills
HAVING COUNT(skills_job_dim.job_id) > 10
ORDER BY
    demand_count DESC,
    skill_average_salary DESC
LIMIT 10
