SELECT UNNEST ([1, 1, 1, 2]) --unnest é usado para deixar essa list na vertical
UNION
SELECT UNNEST ([1, 1, 3])

-- agora, um exemplo prático disso

CREATE TEMP TABLE jobs_2023 AS
SELECT * EXCLUDE (job_id, job_posted_date) --aqui ele tira essas colunas, pois com elas, não haveriam duplicatas
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2023;

CREATE TEMP TABLE jobs_2024 AS
SELECT * EXCLUDE (job_id, job_posted_date)
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2024;

-- Quais empregos aparecem em 2023 ou 2024

SELECT * FROM jobs_2023
UNION
SELECT * FROM jobs_2024;

-- Quais empregos aparecem em 2023 ou 2024, contando duplicatas

SELECT * FROM jobs_2023
UNION ALL
SELECT * FROM jobs_2024;

-- Quais empregos aparecem em 2023, e não em 2024

SELECT * FROM jobs_2023
EXCEPT
SELECT * FROM jobs_2024;

-- Quais empregos aparecem em 2023 e 2024

SELECT * FROM jobs_2023
INTERSECT
SELECT * FROM jobs_2024;