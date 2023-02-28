/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    date_of_birth DATE,
    escape_attempts INTEGER,
    neutered BOOLEAN,
    weight_kg DECIMAL(10, 2)
);

ALTER TABLE animals ADD COLUMN species VARCHAR(255);

CREATE TABLE owners (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(255),
  age INTEGER
);

CREATE TABLE species (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

-- Remove the species column
ALTER TABLE animals DROP COLUMN species;

-- Add a species_id column as a foreign key referencing the species table
ALTER TABLE animals ADD COLUMN species_id INTEGER REFERENCES species(id);

-- Add an owner_id column as a foreign key referencing the owners table
ALTER TABLE animals ADD COLUMN owner_id INTEGER REFERENCES owners(id);

CREATE TABLE vets (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  age INTEGER,
  date_of_graduation DATE
);

CREATE TABLE specializations (
    vet_id INTEGER REFERENCES vets(id),
    species_id INTEGER REFERENCES species(id),
    PRIMARY KEY (vet_id, species_id)
);


CREATE TABLE visits (
    id SERIAL PRIMARY KEY,
    animal_id INTEGER,
    vet_id INTEGER,
    visit_date DATE,
    FOREIGN KEY (animal_id) REFERENCES animals(id),
    FOREIGN KEY (vet_id) REFERENCES vets(id)
);

-- PERFORMANCE

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

-- Add index for SELECT COUNT(*) FROM visits where animal_id = 4;
CREATE INDEX animals_id_asc ON visits(animals_id ASC);

-- Add index for SELECT * FROM visits where vet_id = 2;
CREATE INDEX vets_id_asc ON visits(vet_id ASC);

-- Add index for SELECT * FROM owners where email = 'owner_18327@mail.com';
CREATE INDEX email_asc ON owners(email ASC);