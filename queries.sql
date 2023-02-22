/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name <> 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

BEGIN; -- start the transaction
UPDATE animals SET species = 'unspecified'; -- set the species column to 'unspecified' for all rows
SELECT * FROM animals; -- verify that the change was made
ROLLBACK; -- roll back the transaction
SELECT * FROM animals; -- verify that the species column went back to its original state

BEGIN; -- start the transaction

UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon'; -- set the species column to 'digimon' for all animals with name ending in 'mon'
UPDATE animals SET species = 'pokemon' WHERE species IS NULL; -- set the species column to 'pokemon' for all animals without a species

SELECT * FROM animals; -- verify the changes within the transaction

COMMIT; -- commit the transaction

BEGIN; -- start the transaction

DELETE FROM animals; -- delete all records from the animals table

SELECT COUNT(*) FROM animals; -- verify that all records have been deleted within the transaction

ROLLBACK; -- roll back the transaction

SELECT COUNT(*) FROM animals; -- verify that all records are still present after the rollback

BEGIN; -- start the transaction

DELETE FROM animals WHERE date_of_birth > '2022-01-01'; -- delete all animals born after Jan 1st, 2022

SAVEPOINT my_savepoint; -- create a savepoint for the transaction

UPDATE animals SET weight_kg = weight_kg * -1; -- update all animals' weight to be their weight multiplied by -1

ROLLBACK TO my_savepoint; -- rollback the transaction to the savepoint

UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0; -- update all animals' weights that are negative to be their weight multiplied by -1

COMMIT; -- commit the transaction

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, MAX(escape_attempts) as total_escapes
FROM animals
GROUP BY neutered
ORDER BY total_escapes DESC
LIMIT 1;
SELECT species, MIN(weight_kg), MAX(weight_kg)
FROM animals
GROUP BY species;
SELECT species, AVG(escape_attempts)
FROM animals
WHERE date_of_birth >= '1990/01/01' AND date_of_birth <= '2000/12/31'
GROUP BY species;
