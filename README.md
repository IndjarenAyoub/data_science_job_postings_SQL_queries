# Introduction
📊 Dive into the data job market! Focusing on data analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

🔍 SQL queries? Check them out here: [project_sql folder](/project_sql/)

## Database Schema
The database consists of the following tables:

1. company_dim: Contains information about companies, such as company ID, name, website link, and thumbnail.
2. skills_dim: Stores information about skills, including skill ID, skill name, and skill type.
3. job_postings_fact: Manages job postings data, including job ID, company ID, job title, location, salary information, and other job details.
4. skills_job_dim: Represents the many-to-many relationship between job postings and skills, with foreign keys linking to the job postings and skills tables.

## SQL Queries
The repository also includes sample SQL queries that can be run on the database to retrieve useful information, such as:

. Retrieving job postings along with company names.
. Finding average salary rates for each company.
. Getting the number of job postings per skill type.
. Identifying job postings with specific attributes, such as health insurance and work-from-home options.

## Usage
To use the SQL course database, you can follow these steps:

1. Clone or download this repository to your local machine.
2. Import the SQL files into your preferred SQL database management system (e.g., MySQL, PostgreSQL).
3. Run the SQL queries provided in the queries.sql file to retrieve data from the database.

## Contributing
Contributions to this SQL course database repository are welcome! If you have any improvements, bug fixes, or additional SQL queries to share, feel free to open a pull request.

## License
This SQL course database is provided under the MIT License.


