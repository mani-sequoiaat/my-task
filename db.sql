-- Active: 1743505382754@@14.97.122.243@5432@toll_management_03_mar
SELECT "FleetAgency".s_fleet_error.*
FROM "FleetAgency".s_fleet_error
INNER JOIN "FleetAgency".fleet_agency_brand
ON "FleetAgency".s_fleet_error.brand = "FleetAgency".fleet_agency_brand.brand_name
WHERE 
  (
    (license_plate_number IS NOT NULL 
     AND LENGTH(TRIM(license_plate_number)) > 0 
     AND LENGTH(license_plate_number) <= 12 
     AND license_plate_number !~ '[^A-Za-z0-9-]')
    AND 
    (license_plate_state IS NOT NULL 
     AND LENGTH(TRIM(license_plate_state)) > 0
     AND LENGTH(license_plate_state) = 2
     AND license_plate_state !~ '[^A-Za-z0-9-]') 
    AND
    (year IS NOT NULL AND year >= 1900 AND year <= EXTRACT(YEAR FROM NOW()))
    AND
    (make IS NOT NULL AND LENGTH(TRIM(make)) > 0)
    AND
    (model IS NOT NULL AND LENGTH(TRIM(model)) > 0)
    AND
    (color IS NOT NULL AND LENGTH(TRIM(color)) > 0)
    AND
    (brand IS NOT NULL AND LENGTH(TRIM(brand)) > 0)
  );


SELECT * FROM "FleetAgency".s_fleet
WHERE 
  (license_plate_number IS NULL OR LENGTH(license_plate_number) >= 12 OR license_plate_number ~ '[^A-Za-z0-9 -]')
  OR 
  (license_plate_state IS NULL OR LENGTH(license_plate_state) > 2 OR license_plate_state ~ '[^A-Za-z0-9 -]')
  OR
  (year IS NULL OR year < 1900 OR year > EXTRACT(YEAR FROM NOW()))
  OR 
  (make IS NULL)
  OR
  (model IS NULL)
  OR 
  EXISTS (
    SELECT 1
    FROM "FleetAgency".s_fleet AS duplicates
    WHERE duplicates.license_plate_number = s_fleet.license_plate_number
      AND duplicates.license_plate_state = s_fleet.license_plate_state
      AND duplicates.batch_id = s_fleet.batch_id
      AND duplicates.license_plate_number IS NOT NULL
      AND duplicates.license_plate_state IS NOT NULL
      AND duplicates.batch_id IS NOT NULL
    GROUP BY duplicates.license_plate_number, duplicates.license_plate_state, duplicates.batch_id
    HAVING COUNT(*) > 1
  )
  OR
  NOT EXISTS (
    SELECT 1
    FROM "FleetAgency".fleet_agency_brand fab
    WHERE s_fleet.brand = fab.brand_name
  );

SELECT * FROM "FleetAgency".s_fleet_delta
WHERE 
  (license_plate_number IS NULL OR LENGTH(license_plate_number) >= 12 OR license_plate_number ~ '[^A-Za-z0-9 -]')
  OR 
  (license_plate_state IS NULL OR  LENGTH(license_plate_state) > 2 OR license_plate_state ~ '[^A-Za-z0-9 -]')
  OR
  (year IS NULL OR year < 1900 OR year > EXTRACT(YEAR FROM NOW()))
  OR 
  (make IS NULL )
  OR
  (model IS NULL)
  OR 
  EXISTS (
    SELECT 1
    FROM "FleetAgency".s_fleet_delta AS duplicates
    WHERE duplicates.license_plate_number = "FleetAgency".s_fleet_delta.license_plate_number
      AND duplicates.license_plate_state = "FleetAgency".s_fleet_delta.license_plate_state
	  AND duplicates.batch_id = "FleetAgency".s_fleet_delta.batch_id
      AND duplicates.license_plate_number IS NOT NULL
      AND duplicates.license_plate_state IS NOT NULL
	  AND duplicates.batch_id IS NOT NULL
    GROUP BY duplicates.license_plate_number, duplicates.license_plate_state, duplicates.batch_id
    HAVING COUNT(*) > 1
  )
  OR
  NOT EXISTS (
    SELECT 1
    FROM "FleetAgency".fleet_agency_brand fab
    WHERE s_fleet_delta.brand = fab.brand_name
  );

SELECT * FROM "FleetAgency".fleet_history
WHERE 
  (license_plate_number IS NULL OR LENGTH(license_plate_number) >= 12 OR license_plate_number ~ '[^A-Za-z0-9 -]')
  OR 
  (license_plate_state IS NULL OR LENGTH(license_plate_state) > 2 OR license_plate_state ~ '[^A-Za-z0-9 -]')
  OR 
  (make IS NULL )
  OR
  (model IS NULL )
  OR
  (brand IS NULL )
  OR   
  EXISTS (
    SELECT 1
    FROM "FleetAgency".fleet_history AS duplicates
    WHERE duplicates.license_plate_number = "FleetAgency".fleet_history.license_plate_number
      AND duplicates.license_plate_state = "FleetAgency".fleet_history.license_plate_state
      AND duplicates.license_plate_number IS NOT NULL
      AND duplicates.license_plate_state IS NOT NULL
    GROUP BY duplicates.license_plate_number, duplicates.license_plate_state
    HAVING COUNT(*) > 1
  )
   OR
  NOT EXISTS (
    SELECT 1
    FROM "FleetAgency".fleet_agency_brand fab
    WHERE fleet_history.brand = fab.brand_name
  );

SELECT * FROM "FleetAgency".fleet
WHERE 
  (license_plate_number IS NULL OR LENGTH(license_plate_number) >= 12 OR license_plate_number ~ '[^A-Za-z0-9 -]')
  OR 
  (license_plate_state IS NULL OR LENGTH(license_plate_state) > 2 OR license_plate_state ~ '[^A-Za-z0-9 -]')
  OR 
  EXISTS (
    SELECT 1
    FROM "FleetAgency".fleet AS duplicates
    WHERE duplicates.license_plate_number = "FleetAgency".fleet.license_plate_number
      AND duplicates.license_plate_state = "FleetAgency".fleet.license_plate_state
      AND duplicates.license_plate_number IS NOT NULL
      AND duplicates.license_plate_state IS NOT NULL
    GROUP BY duplicates.license_plate_number, duplicates.license_plate_state
    HAVING COUNT(*) > 1
  );

SELECT "FleetAgency".s_agreements_error.*
FROM "FleetAgency".s_agreements_error
INNER JOIN "FleetAgency".fleet_agency_brand
ON "FleetAgency".s_agreements_error.brand = "FleetAgency".fleet_agency_brand.brand_name
WHERE 
  (
    (license_plate_number IS NOT NULL 
     AND LENGTH(TRIM(license_plate_number)) > 0 
     AND LENGTH(license_plate_number) <= 12 
     AND license_plate_number !~ '[^A-Za-z0-9-]')
    AND 
    (license_plate_state IS NOT NULL 
     AND LENGTH(TRIM(license_plate_state)) > 0
     AND LENGTH(license_plate_state) = 2
     AND license_plate_state !~ '[^A-Za-z0-9-]') 
    AND
    (make IS NOT NULL AND LENGTH(TRIM(make)) > 0)
    AND
    (model IS NOT NULL AND LENGTH(TRIM(model)) > 0)
    AND
	(brand IS NOT NULL AND LENGTH(TRIM(brand)) > 0)
	AND
	(agreement_number IS NOT NULL AND LENGTH(TRIM(agreement_number))> 0)
	AND
	(checkout_datetime IS NOT NULL )
	AND
	(estimated_checkin_datetime IS NOT NULL)
	AND
	(checkout_datetime < estimated_checkin_datetime)
  );

SELECT * FROM "FleetAgency".s_agreements
WHERE 
  (license_plate_number IS NULL OR LENGTH(license_plate_number) >= 12 OR license_plate_number ~ '[^A-Za-z0-9 -]')
  OR 
  (license_plate_state IS NULL OR  LENGTH(license_plate_state) > 2 OR license_plate_state ~ '[^A-Za-z0-9 -]')
  OR 
  (make IS NULL )
  OR
  (model IS NULL )
  OR
  (agreement_number IS NULL)
  OR
  (brand IS NULL )
  OR 
  EXISTS (
    SELECT 1
    FROM "FleetAgency".s_agreements AS duplicates
    WHERE duplicates.license_plate_number = "FleetAgency".s_agreements.license_plate_number
      AND duplicates.license_plate_state = "FleetAgency".s_agreements.license_plate_state
	  AND duplicates.agreement_number = "FleetAgency".s_agreements.agreement_number
      AND duplicates.license_plate_number IS NOT NULL
      AND duplicates.license_plate_state IS NOT NULL
	  AND duplicates.agreement_number IS NOT NULL
    GROUP BY duplicates.license_plate_number, duplicates.license_plate_state, agreement_number
    HAVING COUNT(*) > 1
  )
   OR
  NOT EXISTS (
    SELECT 1
    FROM "FleetAgency".fleet_agency_brand fab
    WHERE s_agreements.brand = fab.brand_name
  );

SELECT * FROM "FleetAgency".agreements
WHERE 
  (license_plate_number IS NULL OR LENGTH(license_plate_number) >= 12 OR license_plate_number ~ '[^A-Za-z0-9 -]')
  OR 
  (license_plate_state IS NULL OR  LENGTH(license_plate_state) > 2 OR license_plate_state ~ '[^A-Za-z0-9 -]')
  OR
  (agreement_number IS NULL)
  OR
  (brand IS NULL )
  OR
  (checkout_datetime IS NULL)
  OR
  (estimated_checkin_datetime IS NULL)
  OR 
  EXISTS (
    SELECT 1
    FROM "FleetAgency".agreements AS duplicates
    WHERE duplicates.license_plate_number = "FleetAgency".agreements.license_plate_number
      AND duplicates.license_plate_state = "FleetAgency".agreements.license_plate_state
	  AND duplicates.agreement_number = "FleetAgency".agreements.agreement_number
      AND duplicates.license_plate_number IS NOT NULL
      AND duplicates.license_plate_state IS NOT NULL
	  AND duplicates.agreement_number IS NOT NULL
    GROUP BY duplicates.license_plate_number, duplicates.license_plate_state, agreement_number
    HAVING COUNT(*) > 1
  );

