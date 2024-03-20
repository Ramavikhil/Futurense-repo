/*health care project*/
create database healthcare;
drop table disease;
DROP TABLE IF EXISTS Disease;
-- word doc 1
-- ps1
SELECT
    CASE
        WHEN FLOOR(DATEDIFF(CURRENT_DATE, p.dob) / 365.25) BETWEEN 0 AND 14 THEN 'Children (00-14 years)'
        WHEN FLOOR(DATEDIFF(CURRENT_DATE, p.dob) / 365.25) BETWEEN 15 AND 24 THEN 'Youth (15-24 years)'
        WHEN FLOOR(DATEDIFF(CURRENT_DATE, p.dob) / 365.25) BETWEEN 25 AND 64 THEN 'Adults (25-64 years)'
        ELSE 'Seniors (65 years and over)'
    END AS AgeCategory,
    COUNT(DISTINCT t.treatmentID) AS NumberOfTreatments
FROM
    Patient p
JOIN
    Treatment t ON p.patientID = t.patientID
WHERE
    YEAR(t.date) = 2022
GROUP BY
    AgeCategory;
    
    -- ps2
    SELECT
    d.diseaseName AS Disease,
    SUM(CASE WHEN pe.gender = 'Male' THEN 1 ELSE 0 END) AS MaleCount,
    SUM(CASE WHEN pe.gender = 'Female' THEN 1 ELSE 0 END) AS FemaleCount,
    CASE
        WHEN SUM(CASE WHEN pe.gender = 'Female' THEN 1 ELSE 0 END) = 0 THEN 'Male Only'
        WHEN SUM(CASE WHEN pe.gender = 'Male' THEN 1 ELSE 0 END) = 0 THEN 'Female Only'
        ELSE CAST(SUM(CASE WHEN pe.gender = 'Male' THEN 1 ELSE 0 END) AS FLOAT) / 
             CAST(SUM(CASE WHEN pe.gender = 'Female' THEN 1 ELSE 0 END) AS FLOAT)
    END AS MaleToFemaleRatio
FROM
    Disease d
JOIN
    Treatment t ON d.diseaseID = t.diseaseID
JOIN
    Patient pa ON t.patientID = pa.patientID
JOIN
    Person pe ON pe.personID = pe.personID
GROUP BY
    d.diseaseName
ORDER BY
    MaleToFemaleRatio DESC;

-- ps3
SELECT
    pe.gender AS Gender,
    COUNT(DISTINCT t.treatmentID) AS NumTreatments,
    COUNT(DISTINCT c.claimID) AS NumClaims,
    CASE
        WHEN COUNT(DISTINCT c.claimID) = 0 THEN NULL
        ELSE CAST(COUNT(DISTINCT t.treatmentID) AS FLOAT) / COUNT(DISTINCT c.claimID)
    END AS TreatmentToClaimRatio
FROM
    Treatment t
JOIN
    Patient pa ON t.patientID = pa.patientID
JOIN
    Person pe ON pe.personID = pe.personID
LEFT JOIN
    Claim c ON t.claimID = c.claimID
GROUP BY
    pe.gender
ORDER BY
    Gender;
    
    -- ps4
    SELECT
    ph.pharmacyName AS PharmacyName,
    SUM(k.quantity) AS TotalQuantity,
    SUM(m.maxPrice * k.quantity) AS TotalMaxRetailPrice,
    SUM(m.maxPrice * (1 - k.discount / 100) * k.quantity) AS TotalPriceAfterDiscount
FROM
    Pharmacy ph
JOIN
    Keep k ON ph.pharmacyID = k.pharmacyID
JOIN
    Medicine m ON k.medicineID = m.medicineID
GROUP BY
    ph.pharmacyName;
    
    -- ps5
    SELECT
    ph.pharmacyName AS PharmacyName,
    MAX(prescription_medicines.num_medicines) AS MaxMedicines,
    MIN(prescription_medicines.num_medicines) AS MinMedicines,
    AVG(prescription_medicines.num_medicines) AS AvgMedicines
FROM
    Pharmacy ph
LEFT JOIN (
    SELECT
        pr.pharmacyID,
        pr.prescriptionID,
        COUNT(*) AS num_medicines
    FROM
        Prescription pr
    JOIN
        Contain c ON pr.prescriptionID = c.prescriptionID
    GROUP BY
        pr.pharmacyID, pr.prescriptionID
) AS prescription_medicines ON ph.pharmacyID = prescription_medicines.pharmacyID
GROUP BY
    ph.pharmacyName;

-- word doc 2
-- Problem Statement 1 Solution
SELECT a.city, 
       COUNT(DISTINCT ph.pharmacyID) AS pharmacy_count,
       COUNT(p.prescriptionID) AS prescription_count,
       COUNT(p.prescriptionID) / COUNT(DISTINCT ph.pharmacyID) AS prescription_ratio
FROM Pharmacy ph
JOIN Address a ON ph.addressID = a.addressID
JOIN Prescription p ON ph.pharmacyID = p.pharmacyID
GROUP BY a.city
HAVING prescription_count > 100
ORDER BY prescription_ratio ASC
LIMIT 3;



-- Problem Statement 2 Solution

SELECT a.city, d.diseaseName, COUNT(t.treatmentID) AS treatment_count
FROM Address a
JOIN Treatment t ON t.patientID IN (
    SELECT p.personID
    FROM Person p
    WHERE p.addressID = a.addressID
)
JOIN Disease d ON t.diseaseID = d.diseaseID
WHERE a.state = 'AL'
GROUP BY a.city, d.diseaseName
ORDER BY treatment_count DESC;


-- Problem Statement 3 Solution

SELECT d.diseaseName,
    (SELECT ip.planName
     FROM InsurancePlan ip
     JOIN Claim c ON ip.uin = c.uin
     JOIN Treatment t ON c.claimID = t.claimID
     JOIN Disease d2 ON t.diseaseID = d2.diseaseID
     WHERE d2.diseaseID = d.diseaseID
     GROUP BY ip.planName
     ORDER BY COUNT(c.claimID) DESC
     LIMIT 1) AS max_claimed_plan,
    (SELECT ip.planName
     FROM InsurancePlan ip
     JOIN Claim c ON ip.uin = c.uin
     JOIN Treatment t ON c.claimID = t.claimID
     JOIN Disease d2 ON t.diseaseID = d2.diseaseID
     WHERE d2.diseaseID = d.diseaseID
     GROUP BY ip.planName
     ORDER BY COUNT(c.claimID) ASC
     LIMIT 1) AS min_claimed_plan
FROM Disease d;


-- Problem Statement 4 Solution
SELECT d.diseaseName, COUNT(DISTINCT pe.addressID) AS household_count
FROM Treatment t
JOIN Disease d ON t.diseaseID = d.diseaseID
JOIN Patient p ON t.patientID = p.patientID
JOIN Person pe ON p.patientID = pe.personID
GROUP BY d.diseaseName
HAVING COUNT(DISTINCT pe.addressID) > 1;
    
-- Problem Statement 5 Solution    
SELECT a.state, COUNT(DISTINCT t.treatmentID) AS treatment_count, COUNT(DISTINCT c.claimID) AS claim_count
FROM Address a
JOIN Person p ON a.addressID = p.addressID
JOIN Patient pa ON p.personID = pa.patientID
JOIN Treatment t ON pa.patientID = t.patientID
LEFT JOIN Claim c ON t.claimID = c.claimID
WHERE t.date BETWEEN '2021-04-01' AND '2022-03-31'
GROUP BY a.state;