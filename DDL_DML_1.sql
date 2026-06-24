USE data_jobs;

DROP DATABASE IF EXISTS jobs_mart; --para reiniciar o processo

CREATE DATABASE IF NOT EXISTS jobs_mart; -- cria database

SHOW DATABASES;

SELECT *
FROM information_schema.schemata;

USE jobs_mart; -- para usar o db jobs_marts

CREATE SCHEMA IF NOT EXISTS staging; -- cria o schema

CREATE TABLE IF NOT EXISTS staging.preferred_roles ( -- cria a tabela, especificando o schema!!
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);

SELECT *
FROM information_schema.tables
WHERE table_catalog = 'jobs_mart';

DROP TABLE IF EXISTS main.preferred_roles;

--inserir valores

INSERT INTO staging.preferred_roles (role_id, role_name)
VALUES
    (1, 'Data Engineer'),
    (2, 'Senior Data Engineer'),
    (3, 'Senior Software Engineer');

-- adicionar coluna na tabela

ALTER TABLE staging.preferred_roles
ADD COLUMN preferred_role BOOLEAN;

SELECT *
FROM staging.preferred_roles;

-- alterar dados de uma coluna

UPDATE staging.preferred_roles
SET preferred_role = TRUE
WHERE role_id = 1 OR role_id = 2;

UPDATE staging.preferred_roles
SET preferred_role = FALSE
WHERE role_id = 3;

-- alterar nomes

ALTER TABLE staging.preferred_roles
RENAME TO priority_roles;

ALTER TABLE staging.priority_roles
RENAME COLUMN preferred_role TO priority_lvl;
 
-- aqui, mudamos o tipo de booleano para inteiro

ALTER TABLE staging.priority_roles
ALTER COLUMN priority_lvl TYPE INTEGER;
