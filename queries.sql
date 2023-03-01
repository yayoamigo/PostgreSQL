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

SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Melody Pond';


SELECT a.name
FROM animals a
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Pokemon';

SELECT o.full_name, a.name
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id;

SELECT s.name, COUNT(*) AS count
FROM animals a
JOIN species s ON a.species_id = s.id
GROUP BY s.name;

SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
JOIN species s ON a.species_id = s.id
WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';

SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;

SELECT o.full_name, COUNT(*) AS count
FROM owners o
JOIN animals a ON o.id = a.owner_id
GROUP BY o.full_name
ORDER BY count DESC
LIMIT 1;

-- Who was the last animal seen by William Tatcher?
SELECT a.name 
FROM animals a 
JOIN visits v ON a.id = v.animal_id 
JOIN vets vt ON vt.id = v.vet_id 
WHERE vt.name = 'William Tatcher' 
ORDER BY visit_date DESC 
LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT v.animal_id) 
FROM visits v 
JOIN vets vt ON vt.id = v.vet_id 
WHERE vt.name = 'Stephanie Mendez';

--List all vets and their specialties, including vets with no specialties.
SELECT v.name, COALESCE(array_agg(s.name), '{}') AS specialties
FROM vets v 
LEFT JOIN specializations sp ON sp.vet_id = v.id
LEFT JOIN species s ON s.id = sp.species_id 
GROUP BY v.id;

--List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name 
FROM animals a 
JOIN visits v ON a.id = v.animal_id 
JOIN vets vt ON vt.id = v.vet_id 
WHERE vt.name = 'Stephanie Mendez' AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';


--What animal has the most visits to vets?
SELECT a.name, COUNT(*) as num_visits
FROM animals a 
JOIN visits v ON a.id = v.animal_id 
GROUP BY a.id 
ORDER BY num_visits DESC 
LIMIT 1;

--Who was Maisy Smith's first visit?
SELECT  a.name, v.visit_date 
FROM visits v 
JOIN vets vet ON vet.id = v.vet_id 
JOIN animals a ON a.id = v.animal_id 
WHERE vet.name = 'Maisy Smith' 
ORDER BY v.visit_date ASC 
LIMIT 1;

--Details for most recent visit: animal information, vet information, and date of visit.
SELECT a.name AS animal_name, v.visit_date, v.vet_id, vt.name AS vet_name
FROM visits v 
JOIN animals a ON a.id = v.animal_id 
JOIN vets vt ON vt.id = v.vet_id 
WHERE v.visit_date = (SELECT MAX(visit_date) FROM visits)

--How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) 
FROM visits v 
JOIN animals a ON a.id = v.animal_id 
JOIN vets vt ON vt.id = v.vet_id 
LEFT JOIN specializations sp ON sp.vet_id = vt.id AND sp.species_id = a.species_id 
WHERE sp.vet_id IS NULL;

--What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT s.name, COUNT(*) AS num_visits
FROM visits v 
JOIN animals a ON a.id = v.animal_id 
JOIN specializations sp ON sp.species_id = a.species_id 
JOIN species s ON s.id = sp.species_id 
WHERE v.vet_id = (SELECT id FROM vets WHERE name = 'Maisy Smith') 
GROUP BY s.id 
ORDER BY num_visits DESC 
LIMIT 1;

--Performances
EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animal_id = 4;
EXPLAIN ANALYZE SELECT * FROM visits where vet_id = 2;
EXPLAIN ANALYZE SELECT * FROM owners where email = 'owner_18327@mail.com';

