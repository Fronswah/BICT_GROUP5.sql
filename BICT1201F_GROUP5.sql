-- ============================================================
--  COMP 102 – INTRODUCTION TO DATABASE
--  Project: Design and Implementation of a Public Service
--           Database System Using MySQL
--  Option A: Public Health Clinic Records System
--  SDG 3: Good Health and Well-being
--  Limkokwing University of Creative Technology – Sierra Leone
-- ============================================================

-- ============================================================
-- SECTION 1: DATABASE CREATION
-- ============================================================

DROP DATABASE IF EXISTS public_health_clinic;
CREATE DATABASE public_health_clinic;
USE public_health_clinic;

-- ============================================================
-- SECTION 2: TABLE CREATION WITH CONSTRAINTS
-- ============================================================

-- Table 1: Clinic
CREATE TABLE Clinic (
    clinic_id       INT             NOT NULL AUTO_INCREMENT,
    clinic_name     VARCHAR(100)    NOT NULL,
    location        VARCHAR(150)    NOT NULL,
    district        VARCHAR(50)     NOT NULL,
    phone_number    VARCHAR(20)     NOT NULL,
    email           VARCHAR(100),
    operating_hours VARCHAR(50)     NOT NULL DEFAULT '08:00 - 17:00',
    PRIMARY KEY (clinic_id)
);

-- Table 2: Staff
CREATE TABLE Staff (
    staff_id        INT             NOT NULL AUTO_INCREMENT,
    clinic_id       INT             NOT NULL,
    first_name      VARCHAR(50)     NOT NULL,
    last_name       VARCHAR(50)     NOT NULL,
    role            ENUM('Doctor','Nurse','Pharmacist','Lab Technician','Receptionist') NOT NULL,
    gender          ENUM('Male','Female','Other') NOT NULL,
    phone_number    VARCHAR(20)     NOT NULL,
    email           VARCHAR(100),
    date_hired      DATE            NOT NULL,
    PRIMARY KEY (staff_id),
    FOREIGN KEY (clinic_id) REFERENCES Clinic(clinic_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table 3: Patient
CREATE TABLE Patient (
    patient_id      INT             NOT NULL AUTO_INCREMENT,
    first_name      VARCHAR(50)     NOT NULL,
    last_name       VARCHAR(50)     NOT NULL,
    date_of_birth   DATE            NOT NULL,
    gender          ENUM('Male','Female','Other') NOT NULL,
    address         VARCHAR(200)    NOT NULL,
    phone_number    VARCHAR(20)     NOT NULL,
    blood_type      ENUM('A+','A-','B+','B-','AB+','AB-','O+','O-'),
    registration_date DATE          NOT NULL DEFAULT (CURRENT_DATE),
    PRIMARY KEY (patient_id)
);

-- Table 4: Appointment
CREATE TABLE Appointment (
    appointment_id  INT             NOT NULL AUTO_INCREMENT,
    patient_id      INT             NOT NULL,
    staff_id        INT             NOT NULL,
    clinic_id       INT             NOT NULL,
    appointment_date DATE           NOT NULL,
    appointment_time TIME           NOT NULL,
    reason          VARCHAR(255)    NOT NULL,
    status          ENUM('Scheduled','Completed','Cancelled','No-Show') NOT NULL DEFAULT 'Scheduled',
    notes           TEXT,
    PRIMARY KEY (appointment_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (clinic_id) REFERENCES Clinic(clinic_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table 5: MedicalRecord
CREATE TABLE MedicalRecord (
    record_id       INT             NOT NULL AUTO_INCREMENT,
    patient_id      INT             NOT NULL,
    appointment_id  INT             NOT NULL,
    diagnosis       VARCHAR(255)    NOT NULL,
    treatment       TEXT            NOT NULL,
    record_date     DATE            NOT NULL,
    follow_up_date  DATE,
    PRIMARY KEY (record_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table 6: Medicine
CREATE TABLE Medicine (
    medicine_id     INT             NOT NULL AUTO_INCREMENT,
    medicine_name   VARCHAR(100)    NOT NULL,
    category        VARCHAR(50)     NOT NULL,
    unit            VARCHAR(20)     NOT NULL DEFAULT 'Tablet',
    stock_quantity  INT             NOT NULL DEFAULT 0,
    unit_price      DECIMAL(10,2)   NOT NULL,
    PRIMARY KEY (medicine_id)
);

-- Table 7: Prescription
CREATE TABLE Prescription (
    prescription_id INT             NOT NULL AUTO_INCREMENT,
    record_id       INT             NOT NULL,
    medicine_id     INT             NOT NULL,
    dosage          VARCHAR(100)    NOT NULL,
    duration_days   INT             NOT NULL,
    quantity_issued INT             NOT NULL,
    PRIMARY KEY (prescription_id),
    FOREIGN KEY (record_id) REFERENCES MedicalRecord(record_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (medicine_id) REFERENCES Medicine(medicine_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table 8: Billing
CREATE TABLE Billing (
    bill_id         INT             NOT NULL AUTO_INCREMENT,
    patient_id      INT             NOT NULL,
    appointment_id  INT             NOT NULL,
    total_amount    DECIMAL(10,2)   NOT NULL,
    amount_paid     DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    payment_status  ENUM('Paid','Partial','Unpaid') NOT NULL DEFAULT 'Unpaid',
    payment_date    DATE,
    payment_method  ENUM('Cash','Mobile Money','Insurance','Free') NOT NULL DEFAULT 'Cash',
    PRIMARY KEY (bill_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ============================================================
-- SECTION 3: SAMPLE DATA INSERTION
-- ============================================================

-- Insert Clinics
INSERT INTO Clinic (clinic_name, location, district, phone_number, email, operating_hours) VALUES
('Lunsar Community Health Clinic',  'Main Road, Lunsar',         'Port Loko',  '+23278123456', 'lunsar@mohsw.gov.sl',    '08:00 - 17:00'),
('Makeni General Clinic',           '12 Teko Road, Makeni',      'Bombali',    '+23277234567', 'makeni@mohsw.gov.sl',    '07:30 - 18:00'),
('Freetown Central Health Centre',  '5 Siaka Stevens St, FTown', 'Western',    '+23276345678', 'freetown@mohsw.gov.sl',  '08:00 - 20:00'),
('Bo District Clinic',              'Bo Town Centre, Bo',        'Bo',         '+23275456789', 'bo@mohsw.gov.sl',        '08:00 - 17:00'),
('Kenema Health Post',              'Dama Road, Kenema',         'Kenema',     '+23279567890', 'kenema@mohsw.gov.sl',    '08:00 - 17:00');

-- Insert Staff
INSERT INTO Staff (clinic_id, first_name, last_name, role, gender, phone_number, email, date_hired) VALUES
(1, 'Ibrahim',   'Kamara',    'Doctor',        'Male',   '+23278111001', 'i.kamara@clinic.sl',   '2020-03-15'),
(1, 'Aminata',   'Koroma',    'Nurse',         'Female', '+23278111002', 'a.koroma@clinic.sl',   '2021-06-01'),
(1, 'Mohamed',   'Bangura',   'Pharmacist',    'Male',   '+23278111003', 'm.bangura@clinic.sl',  '2021-09-10'),
(2, 'Fatmata',   'Sesay',     'Doctor',        'Female', '+23277111004', 'f.sesay@clinic.sl',    '2019-01-20'),
(2, 'Joseph',    'Conteh',    'Nurse',         'Male',   '+23277111005', 'j.conteh@clinic.sl',   '2022-02-14'),
(3, 'Mariama',   'Turay',     'Doctor',        'Female', '+23276111006', 'm.turay@clinic.sl',    '2018-07-05'),
(3, 'David',     'Williams',  'Lab Technician','Male',   '+23276111007', 'd.williams@clinic.sl', '2020-11-30'),
(4, 'Hawa',      'Jalloh',    'Doctor',        'Female', '+23275111008', 'h.jalloh@clinic.sl',   '2021-04-18'),
(5, 'Alpha',     'Mansaray',  'Nurse',         'Male',   '+23279111009', 'a.mansaray@clinic.sl', '2023-01-09'),
(1, 'Isata',     'Kanu',      'Receptionist',  'Female', '+23278111010', 'i.kanu@clinic.sl',     '2022-08-22');

-- Insert Patients
INSERT INTO Patient (first_name, last_name, date_of_birth, gender, address, phone_number, blood_type, registration_date) VALUES
('Sorie',      'Kamara',   '1990-04-12', 'Male',   'Lunsar Town, Port Loko',     '+23278200001', 'O+',  '2023-01-10'),
('Kadiatou',   'Koroma',   '1985-08-23', 'Female', '15 Main Street, Makeni',     '+23277200002', 'A+',  '2023-02-15'),
('Mohamed',    'Sesay',    '2000-01-05', 'Male',   'Freetown, Western Area',     '+23276200003', 'B+',  '2023-03-20'),
('Mariama',    'Bangura',  '1978-11-30', 'Female', 'Bo Town, Bo District',       '+23275200004', 'AB-', '2023-03-22'),
('Alhaji',     'Conteh',   '1965-07-18', 'Male',   'Kenema Town, Kenema',        '+23279200005', 'O-',  '2023-04-05'),
('Fatmata',    'Turay',    '1995-12-09', 'Female', 'Lunsar, Port Loko',          '+23278200006', 'A-',  '2023-05-11'),
('Ibrahim',    'Jalloh',   '2005-03-14', 'Male',   'Makeni, Bombali District',   '+23277200007', 'B-',  '2023-06-01'),
('Aminata',    'Mansaray', '1982-09-27', 'Female', 'Freetown, Western Area',     '+23276200008', 'O+',  '2023-06-15'),
('Saidu',      'Kanu',     '1970-06-02', 'Male',   'Bo Town, Bo District',       '+23275200009', 'A+',  '2023-07-03'),
('Hawa',       'Fofanah',  '1999-02-20', 'Female', 'Kenema Town, Kenema',        '+23279200010', 'AB+', '2023-07-20');

-- Insert Appointments
INSERT INTO Appointment (patient_id, staff_id, clinic_id, appointment_date, appointment_time, reason, status, notes) VALUES
(1,  1, 1, '2024-01-10', '09:00:00', 'Malaria symptoms',              'Completed', 'Fever and chills for 3 days'),
(2,  4, 2, '2024-01-12', '10:30:00', 'Routine antenatal check-up',    'Completed', '6 months pregnant'),
(3,  6, 3, '2024-01-15', '08:30:00', 'Chest pain and coughing',       'Completed', 'Persistent cough for 1 week'),
(4,  8, 4, '2024-01-18', '11:00:00', 'High blood pressure check',     'Completed', 'Known hypertension patient'),
(5,  1, 1, '2024-01-20', '09:30:00', 'Diabetes follow-up',            'Completed', 'Monthly check-up'),
(6,  4, 2, '2024-02-01', '14:00:00', 'Skin rash and itching',         'Completed', 'Rash on arms and neck'),
(7,  6, 3, '2024-02-05', '08:00:00', 'Typhoid fever',                 'Completed', 'High fever and stomach pain'),
(8,  8, 4, '2024-02-10', '10:00:00', 'Malaria symptoms',              'Completed', 'Headache and joint pain'),
(9,  1, 1, '2024-02-15', '13:00:00', 'Eye infection',                 'Completed', 'Red eyes and discharge'),
(10, 4, 2, '2024-02-20', '09:00:00', 'Routine check-up',              'Completed', 'General wellness visit'),
(1,  1, 1, '2024-03-01', '09:00:00', 'Malaria follow-up',             'Completed', 'Post-treatment review'),
(3,  6, 3, '2024-03-05', '11:00:00', 'TB screening',                  'Scheduled', NULL),
(5,  1, 1, '2024-03-10', '10:00:00', 'Diabetes management',           'Scheduled', NULL),
(2,  4, 2, '2024-03-12', '14:00:00', 'Post-natal check-up',           'Scheduled', NULL),
(7,  6, 3, '2024-03-15', '09:30:00', 'Typhoid follow-up',             'Cancelled', 'Patient cancelled');

-- Insert Medical Records
INSERT INTO MedicalRecord (patient_id, appointment_id, diagnosis, treatment, record_date, follow_up_date) VALUES
(1,  1,  'Malaria (Plasmodium falciparum)',  'Artemether-Lumefantrine for 3 days, rest and hydration',     '2024-01-10', '2024-01-17'),
(2,  2,  'Normal Pregnancy – 24 weeks',     'Iron and Folic Acid supplements, dietary advice',             '2024-01-12', '2024-02-12'),
(3,  3,  'Pulmonary Tuberculosis (suspected)','Sputum test ordered, isolation advised, referral to TB centre','2024-01-15', '2024-01-22'),
(4,  4,  'Hypertension Stage 2',            'Amlodipine 10mg daily, low-salt diet recommended',            '2024-01-18', '2024-02-18'),
(5,  5,  'Type 2 Diabetes Mellitus',        'Metformin 500mg twice daily, blood sugar monitoring',         '2024-01-20', '2024-02-20'),
(6,  6,  'Allergic Dermatitis',             'Cetirizine 10mg once daily, avoid allergens, topical cream',  '2024-02-01', '2024-02-15'),
(7,  7,  'Typhoid Fever',                   'Ciprofloxacin 500mg twice daily for 7 days, oral rehydration','2024-02-05', '2024-02-12'),
(8,  8,  'Malaria (Plasmodium vivax)',       'Chloroquine 3-day course, rest and fluids',                   '2024-02-10', '2024-02-17'),
(9,  9,  'Conjunctivitis (Bacterial)',       'Chloramphenicol eye drops 4x daily for 5 days',              '2024-02-15', '2024-02-22'),
(10, 10, 'General Health – Normal',         'No treatment required. Lifestyle counselling given',           '2024-02-20', NULL),
(1,  11, 'Malaria – Resolved',              'Treatment complete. Patient discharged as recovered',          '2024-03-01', NULL);

-- Insert Medicines
INSERT INTO Medicine (medicine_name, category, unit, stock_quantity, unit_price) VALUES
('Artemether-Lumefantrine (AL)',  'Antimalarial',       'Tablet',  500,  2500.00),
('Chloroquine',                   'Antimalarial',       'Tablet',  300,  500.00),
('Metformin 500mg',               'Antidiabetic',       'Tablet',  400,  1000.00),
('Amlodipine 10mg',               'Antihypertensive',   'Tablet',  250,  1500.00),
('Ciprofloxacin 500mg',           'Antibiotic',         'Tablet',  350,  2000.00),
('Cetirizine 10mg',               'Antihistamine',      'Tablet',  200,  750.00),
('Chloramphenicol Eye Drops',     'Ophthalmic',         'Bottle',  100,  5000.00),
('Folic Acid',                    'Supplement',         'Tablet',  600,  300.00),
('Ferrous Sulfate (Iron)',         'Supplement',         'Tablet',  600,  400.00),
('ORS (Oral Rehydration Salts)',  'Rehydration',        'Sachet',  800,  200.00),
('Paracetamol 500mg',             'Analgesic',          'Tablet', 1000,  150.00),
('Amoxicillin 500mg',             'Antibiotic',         'Tablet',  450,  1200.00);

-- Insert Prescriptions
INSERT INTO Prescription (record_id, medicine_id, dosage, duration_days, quantity_issued) VALUES
(1,  1,  '4 tablets stat, then 4 tablets after 8, 24, 36, 48 hours',   3,   24),
(1,  11, '1000mg every 6 hours',                                        3,   12),
(2,  8,  '1 tablet daily',                                              30,  30),
(2,  9,  '1 tablet daily',                                              30,  30),
(4,  4,  '10mg once daily',                                             30,  30),
(5,  3,  '500mg twice daily',                                           30,  60),
(6,  6,  '10mg once daily at night',                                    14,  14),
(7,  5,  '500mg twice daily',                                           7,   14),
(7,  10, 'Mix 1 sachet in 200ml water, drink after each loose stool',  3,   6),
(8,  2,  '600mg on day 1, 300mg on day 2, 300mg on day 3',            3,   9),
(9,  7,  '2 drops in each eye, 4 times daily',                         5,   1),
(11, 11, '500mg every 8 hours as needed',                              5,   15);

-- Insert Billing
INSERT INTO Billing (patient_id, appointment_id, total_amount, amount_paid, payment_status, payment_date, payment_method) VALUES
(1,  1,  25000.00, 25000.00, 'Paid',    '2024-01-10', 'Cash'),
(2,  2,  10000.00, 10000.00, 'Paid',    '2024-01-12', 'Free'),
(3,  3,  30000.00, 15000.00, 'Partial', '2024-01-15', 'Mobile Money'),
(4,  4,  20000.00, 20000.00, 'Paid',    '2024-01-18', 'Insurance'),
(5,  5,  15000.00, 15000.00, 'Paid',    '2024-01-20', 'Cash'),
(6,  6,  18000.00, 0.00,     'Unpaid',  NULL,         'Cash'),
(7,  7,  22000.00, 22000.00, 'Paid',    '2024-02-05', 'Mobile Money'),
(8,  8,  20000.00, 10000.00, 'Partial', '2024-02-10', 'Cash'),
(9,  9,  12000.00, 12000.00, 'Paid',    '2024-02-15', 'Cash'),
(10, 10, 5000.00,  5000.00,  'Paid',    '2024-02-20', 'Cash'),
(1,  11, 5000.00,  5000.00,  'Paid',    '2024-03-01', 'Cash');

-- ============================================================
-- SECTION 4: DATA MANIPULATION – UPDATE AND DELETE
-- ============================================================

-- UPDATE: Mark a patient's appointment bill as fully paid
UPDATE Billing
SET amount_paid = 30000.00,
    payment_status = 'Paid',
    payment_date = '2024-01-22',
    payment_method = 'Mobile Money'
WHERE bill_id = 3;

-- UPDATE: Update stock quantity after dispensing medicines
UPDATE Medicine
SET stock_quantity = stock_quantity - 24
WHERE medicine_id = 1;  -- AL tablets dispensed

-- UPDATE: Change appointment status to No-Show
UPDATE Appointment
SET status = 'No-Show'
WHERE appointment_id = 15;

-- UPDATE: Correct a patient's phone number
UPDATE Patient
SET phone_number = '+23278200011'
WHERE patient_id = 6;

-- DELETE: Remove a cancelled appointment record (safe delete – no child records)
-- First verify it has no medical records attached (appointment 15 was cancelled/no-show)
DELETE FROM Appointment
WHERE appointment_id = 15 AND status IN ('Cancelled', 'No-Show');

-- ============================================================
-- SECTION 5: SQL QUERIES
-- ============================================================

-- QUERY 1: SELECT all patients with their full details (ORDER BY last name)
SELECT
    patient_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    date_of_birth,
    gender,
    blood_type,
    phone_number,
    registration_date
FROM Patient
ORDER BY last_name ASC;

-- QUERY 2: Filter – Find all completed appointments at Clinic 1 (Lunsar)
SELECT
    a.appointment_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    CONCAT(s.first_name, ' ', s.last_name) AS doctor_name,
    a.appointment_date,
    a.appointment_time,
    a.reason,
    a.status
FROM Appointment a
JOIN Patient p ON a.patient_id = p.patient_id
JOIN Staff   s ON a.staff_id   = s.staff_id
WHERE a.clinic_id = 1 AND a.status = 'Completed'
ORDER BY a.appointment_date ASC;

-- QUERY 3: Filter – Find all unpaid or partial bills (outstanding balances)
SELECT
    b.bill_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    b.total_amount,
    b.amount_paid,
    (b.total_amount - b.amount_paid)        AS outstanding_balance,
    b.payment_status
FROM Billing b
JOIN Patient p ON b.patient_id = p.patient_id
WHERE b.payment_status IN ('Unpaid', 'Partial')
ORDER BY outstanding_balance DESC;

-- QUERY 4: Aggregate – COUNT total appointments per clinic
SELECT
    c.clinic_name,
    COUNT(a.appointment_id) AS total_appointments
FROM Clinic c
LEFT JOIN Appointment a ON c.clinic_id = a.clinic_id
GROUP BY c.clinic_id, c.clinic_name
ORDER BY total_appointments DESC;

-- QUERY 5: Aggregate – SUM total revenue collected per clinic
SELECT
    c.clinic_name,
    SUM(b.total_amount)  AS total_billed,
    SUM(b.amount_paid)   AS total_collected,
    SUM(b.total_amount - b.amount_paid) AS total_outstanding
FROM Billing b
JOIN Appointment a ON b.appointment_id = a.appointment_id
JOIN Clinic c      ON a.clinic_id      = c.clinic_id
GROUP BY c.clinic_id, c.clinic_name
ORDER BY total_collected DESC;

-- QUERY 6: Aggregate – AVG billing amount per payment method
SELECT
    payment_method,
    COUNT(*)                        AS total_transactions,
    AVG(total_amount)               AS average_bill_amount,
    SUM(amount_paid)                AS total_paid
FROM Billing
GROUP BY payment_method
ORDER BY total_paid DESC;

-- QUERY 7: Aggregate – Total medicines prescribed per patient
SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    COUNT(pr.prescription_id)              AS total_prescriptions,
    SUM(pr.quantity_issued)                AS total_medicines_issued
FROM Patient p
JOIN MedicalRecord mr  ON p.patient_id  = mr.patient_id
JOIN Prescription  pr  ON mr.record_id  = pr.record_id
GROUP BY p.patient_id, patient_name
ORDER BY total_medicines_issued DESC;

-- QUERY 8: LIMIT – Top 5 most commonly prescribed medicines
SELECT
    m.medicine_name,
    m.category,
    COUNT(pr.prescription_id) AS times_prescribed,
    SUM(pr.quantity_issued)   AS total_units_dispensed
FROM Medicine m
JOIN Prescription pr ON m.medicine_id = pr.medicine_id
GROUP BY m.medicine_id, m.medicine_name, m.category
ORDER BY times_prescribed DESC
LIMIT 5;

-- QUERY 9: Real-life scenario – Patients diagnosed with Malaria
SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    mr.diagnosis,
    mr.record_date,
    mr.follow_up_date,
    CONCAT(s.first_name, ' ', s.last_name) AS treating_doctor
FROM MedicalRecord mr
JOIN Patient     p ON mr.patient_id     = p.patient_id
JOIN Appointment a ON mr.appointment_id = a.appointment_id
JOIN Staff       s ON a.staff_id        = s.staff_id
WHERE mr.diagnosis LIKE '%Malaria%'
ORDER BY mr.record_date ASC;

-- QUERY 10: Real-life scenario – Medicines running low (stock < 200)
SELECT
    medicine_id,
    medicine_name,
    category,
    stock_quantity,
    unit_price
FROM Medicine
WHERE stock_quantity < 200
ORDER BY stock_quantity ASC;

-- QUERY 11: LIMIT – Most recent 5 patient registrations
SELECT
    patient_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    gender,
    phone_number,
    registration_date
FROM Patient
ORDER BY registration_date DESC
LIMIT 5;

-- QUERY 12: Real-life scenario – Patients with upcoming scheduled appointments
SELECT
    CONCAT(p.first_name, ' ', p.last_name)  AS patient_name,
    p.phone_number,
    a.appointment_date,
    a.appointment_time,
    a.reason,
    c.clinic_name,
    CONCAT(s.first_name, ' ', s.last_name)  AS assigned_doctor
FROM Appointment a
JOIN Patient p ON a.patient_id = p.patient_id
JOIN Clinic  c ON a.clinic_id  = c.clinic_id
JOIN Staff   s ON a.staff_id   = s.staff_id
WHERE a.status = 'Scheduled'
ORDER BY a.appointment_date ASC;

-- ============================================================
-- SECTION 6: USER MANAGEMENT
-- ============================================================

-- Create user accounts for group members
-- Each user is given appropriate access based on their role

-- Admin user (full access)
CREATE USER IF NOT EXISTS 'clinic_admin'@'localhost' IDENTIFIED BY 'Admin@Clinic2024';
GRANT ALL PRIVILEGES ON public_health_clinic.* TO 'clinic_admin'@'localhost';

-- Doctor user (can view and insert medical records, read patient info)
CREATE USER IF NOT EXISTS 'clinic_doctor'@'localhost' IDENTIFIED BY 'Doctor@Clinic2024';
GRANT SELECT, INSERT ON public_health_clinic.Patient         TO 'clinic_doctor'@'localhost';
GRANT SELECT, INSERT ON public_health_clinic.MedicalRecord   TO 'clinic_doctor'@'localhost';
GRANT SELECT, INSERT ON public_health_clinic.Appointment     TO 'clinic_doctor'@'localhost';
GRANT SELECT, INSERT ON public_health_clinic.Prescription    TO 'clinic_doctor'@'localhost';
GRANT SELECT         ON public_health_clinic.Medicine        TO 'clinic_doctor'@'localhost';

-- Nurse user (can view and update appointments and patient records)
CREATE USER IF NOT EXISTS 'clinic_nurse'@'localhost' IDENTIFIED BY 'Nurse@Clinic2024';
GRANT SELECT, INSERT, UPDATE ON public_health_clinic.Patient      TO 'clinic_nurse'@'localhost';
GRANT SELECT, UPDATE         ON public_health_clinic.Appointment  TO 'clinic_nurse'@'localhost';
GRANT SELECT                 ON public_health_clinic.MedicalRecord TO 'clinic_nurse'@'localhost';

-- Pharmacist user (can view prescriptions and update medicine stock)
CREATE USER IF NOT EXISTS 'clinic_pharmacist'@'localhost' IDENTIFIED BY 'Pharma@Clinic2024';
GRANT SELECT         ON public_health_clinic.Prescription    TO 'clinic_pharmacist'@'localhost';
GRANT SELECT, UPDATE ON public_health_clinic.Medicine        TO 'clinic_pharmacist'@'localhost';
GRANT SELECT         ON public_health_clinic.MedicalRecord   TO 'clinic_pharmacist'@'localhost';

-- Receptionist user (can manage appointments and patient registration)
CREATE USER IF NOT EXISTS 'clinic_receptionist'@'localhost' IDENTIFIED BY 'Recept@Clinic2024';
GRANT SELECT, INSERT, UPDATE ON public_health_clinic.Patient      TO 'clinic_receptionist'@'localhost';
GRANT SELECT, INSERT, UPDATE ON public_health_clinic.Appointment  TO 'clinic_receptionist'@'localhost';
GRANT SELECT, INSERT         ON public_health_clinic.Billing      TO 'clinic_receptionist'@'localhost';

-- Apply all privilege changes
FLUSH PRIVILEGES;

-- Change password example (demonstrating ALTER USER)
-- ALTER USER 'clinic_nurse'@'localhost' IDENTIFIED BY 'NewNurse@2024';

-- Show all users (for verification)
SELECT user, host FROM mysql.user WHERE user LIKE 'clinic_%';

-- ============================================================
-- END OF SCRIPT
-- ============================================================
