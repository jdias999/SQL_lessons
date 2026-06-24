SELECT
    job_title_short,
    salary_hour_avg,
    CASE
        WHEN salary_hour_avg < 25 THEN 'Low Salary'
        WHEN salary_hour_avg < 50 THEN 'Medium Salary'
        ELSE 'High'
    END AS salary_category
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
LIMIT 10;
