# Introduction
📊 Dive into the data job market! Focusing on data scientist roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data science.

🔍 SQL queries? Check them out here: [project_sql folder](/SQL_project/)

# Background
Driven by a quest to navigate the data science job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data scientist jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data scientists?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
For my deep dive into the data science job market, I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** My go-to for database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project aimed at investigating specific aspects of the data science job market. Here’s how I approached each question:

### 1. Top Paying Data Scientist Jobs
To identify the highest-paying roles, I filtered data scientist positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

-- sql
SELECT	
	job_id,
	job_title,
	job_location,
	job_schedule_type,
	salary_year_avg,
	job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Scientist' AND 
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;


Here's the breakdown of the top data scientist jobs in 2023:
- **Wide Salary Range:** Top 10 paying data scientist roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data scientist to Director of Analytics, reflecting varied roles and specializations within data science.

![Top Paying Roles](assets\top_paying_jobs.png)
*Bar graph visualizing the salary for the top 10 salaries for data scientists.

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
```sql
WITH top_paying_jobs AS (
    SELECT	
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Scientist' AND 
        job_location = 'Anywhere' AND 
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```
Here's the breakdown of the most demanded skills for the top 10 highest paying data scientist jobs in 2023:
- **Python** is leading with a bold count of 4.
- **SQL** follows closely with a bold count of 3.
- **AWS** is also highly sought after, with a bold count of 2.
Other skills like **Pytorch**, **Tensorflow**, **Spark**, and **Java** show varying degrees of demand.

![Top Paying Skills](assets\Count_Skills_Top_10_Paying_Jobs.png)
*Bar graph visualizing the count of skills for the top 10 paying jobs for data scientists.

### 3. In-Demand Skills for Data Scientists

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist' 
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```
Here's the breakdown of the most demanded skills for data scientists in 2023
- **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- **Programming** and **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.


| Skills   | Demand Count |
|----------|--------------|
| Python   | 763          |
| SQL      | 591          |
| R        | 394          |
| SAS      | 220          |
| tableau  | 219          |

*Table of the demand for the top 5 skills in data science job postings*

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```
Here's a breakdown of the results for top paying skills for Data Scientists:
- **Specialized Tools Dominate:** TDemand is high for expertise in specialized tools like GDPR compliance, Selenium, OpenCV, and others, indicating a focus on specific data-related tasks.
- **Programming Proficiency Pays Off:** Proficiency in programming languages such as Golang, Solidity, Rust, and others is highly valued, emphasizing the importance of coding skills in data science roles.
- **Emerging Technologies Gain Traction:** Skills like Solidity and Rust suggest a growing demand for data scientists with expertise in emerging technologies like blockchain and system programming, reflecting evolving industry needs.

| Skills                | Average Salary ($) |
|-----------------------|-------------------:|
| GDPR                  |            217737  |
| golang                |            208750  |
| atlassian             |            189700  |
| selenium              |            160515  |
| opencv                |            172500  |
| neo4g                 |            172655  |
| microstrategy         |            153750  |
| dynamodb              |            169670  |
| php                   |            168125  |
| tidyverse             |            165512  |

*Table of the average salary for the top 10 paying skills for data scientists*

### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 10;

```

| skill_id | skills    | demand_count | skill_average_salary |
|----------|-----------|--------------|----------------------|
| 26       | c         | 48           | 164864               |
| 8        | go        | 57           | 164691               |
| 187      | qlik      | 15           | 164484               |
| 185      | looker    | 57           | 158714               |
| 96       | airflow   | 23           | 157414               |
| 77       | bigquery  | 36           | 157142               |
| 3        | scala     | 56           | 156701               |
| 81       | gcp       | 59           | 155810               |
| 80       | snowflake | 72           | 152686               |
| 101      | pytorch   | 115          | 152602               |


*Table of the most 10 optimal skills for data scientist sorted by salary*

Here's a breakdown of the most optimal skills for Data Scientists in 2023: 
- **High-Demand Programming Languages:** Among the programming languages listed, skills in C and Go stand out with demand counts of 48 and 57 respectively. Despite their relatively lower demand compared to other languages, their average salaries are notably high, reaching $164,864 for C and $164,691 for Go, suggesting a niche demand for expertise in these languages.
- **Data Visualization Tools:** Looker emerges as a significant skill with a demand count of 57 and an average salary of $158,714 , indicating its importance in data visualization and analytics projects.
- **Workflow Management Tools:**  Airflow skills, with a demand count of 23 and an average salary of $157,414.13, showcase their significance in managing data workflows efficiently.
- **Cloud Services:** GCP (Google Cloud Platform) skills, with a demand count of 59 and an average salary of $155,810 , highlight expertise in cloud-based data solutions within the Google ecosystem.
- **Data Warehousing Platforms:** Snowflake stands out with a demand count of 72 and an average salary of $152,686.88, emphasizing its importance as a cloud-based data warehouse platform.
- **Machine Learning Framework:** PyTorch skills, with the highest demand count of 115 and an average salary of $152,602 , are highly valued in the field of machine learning and artificial intelligence.

# What I Learned

Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

- **🧩 Complex Query Crafting:** Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.
- **📊 Data Aggregation:** Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.
- **💡 Analytical Wizardry:** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

# Conclusions

### Insights
From the analysis, several general insights emerged:

1. **Top-Paying Data Scientist Jobs**: The highest-paying jobs for data scientists that allow remote work offer a wide range of salaries, the highest at $550,000!
2. **Skills for Top-Paying Jobs**: High-paying data scientist jobs require advanced proficiency in Python, R and SQL, suggesting that they are the most critical skills for earning a top salary.
3. **Most In-Demand Skills**: Python is also the most demanded skill in the data science job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as GDPR and Selenium, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value**: C and GO leads the most in demand skills with high average salaries, positioning themselves as some of the most optimal skills for data scientists to learn to maximize their market value.

### Closing Thoughts

This project enhanced my SQL skills and provided valuable insights into the data scientist job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data scientists can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data science.

