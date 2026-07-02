SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER (PARTITION BY job_title_short) AS avg_hourly_by_title
FROM
    job_postings_fact
LIMIT 
    10;

--nesse caso, daria um erro!, mostrando o porque utilizar windows functions

SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg)
FROM
    job_postings_fact
GROUP BY
    job_title_short;

--Outro exemplo

SELECT
    job_id,
    job_title_short,
    company_id,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER (PARTITION BY job_title_short, company_id) AS avg_hourly_by_title
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    RANDOM()
LIMIT 10;

--Exemplo de rank

SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER (ORDER BY salary_hour_avg DESC) AS 
    rank_hourly_avg
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    salary_hour_avg DESC
LIMIT 10;

--Juntando alguns conceitos
--Nesse caso, como fizemos o order by date, os valores de avg de cada job title vão mudando de acordo com o valor anterior,
--ate que no ultimo row de cada job title, aparece o avg real

SELECT
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER (
        PARTITION BY job_title_short
        ORDER BY job_posted_date
        ) 
        AS running_avg_hourly_by_title
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    job_title_short,
    job_posted_date
LIMIT 10;



--juntando mais


SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER (
        PARTITION BY job_title_short
        ORDER BY salary_hour_avg DESC
        ) AS 
    rank_hourly_avg
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    salary_hour_avg DESC,
    job_title_short
LIMIT 10;