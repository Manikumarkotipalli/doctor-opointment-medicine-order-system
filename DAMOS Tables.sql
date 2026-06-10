/**************************************************************
	Table Name			: Patient ,Doctor,Admin ,DoctorAvailability ,AppointmentSlots,Appointments,Prescription,MedicineInventory,Feedback,Orders
	Purpose		        : Tables creation
	Created By          : Mani kumar
	Created On          : 06/08/24
	Modified By         :
	Modified ON         :
	MOdified            :

****************************************************************/
CREATE DATABASE DAMOS

CREATE TABLE Patient
(
	[PatientID] INT IDENTITY PRIMARY KEY,
	[UserName] VARCHAR(20) UNIQUE NOT NULL,
	[Name] VARCHAR(20) NOT NULL,
	[Password] VARCHAR(20) NOT NULL,
	[Email] VARCHAR(30) UNIQUE NOT NULL,
	[Mobile] VARCHAR(20) UNIQUE ,
	[IsActive] BIT,
	[Aadhar] VARCHAR(20) UNIQUE 

)
SELECT * FROM Patient
SELECT * FROM Doctor
SELECT * FROM Admin

CREATE TABLE Doctor
(
	[DoctorID] INT PRIMARY KEY IDENTITY,
	[UserName] VARCHAR(20) UNIQUE NOT NULL,
	[Name] VARCHAR(20) NOT NULL,
	[Email] VARCHAR(30) UNIQUE NOT NULL,
	[Password] VARCHAR(20) NOT NULL,
	[IsActive] BIT,
	[Aadhar] VARCHAR(20) UNIQUE ,
	[Specialization] VARCHAR(20),
	[Mobile] VARCHAR(20)

)
CREATE TABLE [Admin]
(
	[AdminID] INT IDENTITY PRIMARY KEY,
	[UserName] VARCHAR(20) UNIQUE NOT NULL,
	[Name] VARCHAR(20) NOT NULL,
	[Password] VARCHAR(20) NOT NULL,
	[Email] VARCHAR(30) UNIQUE NOT NULL,
	[Mobile] VARCHAR(20) UNIQUE ,
	[IsActive] BIT,
	[Aadhar] VARCHAR(20) UNIQUE 
)



CREATE TABLE DoctorAvailability (
    AvailabilityID INT PRIMARY KEY IDENTITY,
    DoctorID INT,
    DayOfWeek NVARCHAR(10),  
    StartTime TIME,
    EndTime TIME,
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);
CREATE TABLE AppointmentSlots (
    SlotID INT PRIMARY KEY IDENTITY(1,1),
    AvailabilityID INT, 
    SlotStartTime TIME,
    SlotEndTime TIME,
    IsBooked  BIT DEFAULT 0,
     
    FOREIGN KEY (AvailabilityID) REFERENCES DoctorAvailability(AvailabilityID)
);

CREATE TABLE Appointments
(
	AppointmentID INT PRIMARY KEY IDENTITY,
	PatientID INT ,
	DoctorID INT,
	[Date] VARCHAR(20),
	[SlotStartTime] TIME,
	[SlotEndTime] TIME,
	FOREIGN KEY (PatientID) REFERENCES Patient (PatientID),
	FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
)
CREATE TABLE MedicineInventory
(
	MedicinID INT IDENTITY PRIMARY KEY,
	MedicineName VARCHAR(20) ,
	IsActive BIT,
	Quantity INT,
	Price INT
)


CREATE TABLE Prescriptions (
    AppointmentID INT,
    MedicineID INT,
    Dosage VARCHAR(50),
    Quantity INT,
    Instructions VARCHAR(255),
    PRIMARY KEY (AppointmentID, MedicineID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID),
    FOREIGN KEY (MedicineID) REFERENCES MedicineInventory(MedicinID)
);

CREATE TABLE [Order]
(
	OrderID INT IDENTITY PRIMARY KEY,
	OrderDate VARCHAR(10),
	TotalBill DECIMAL(12,2),
	OrderStaus BIT DEFAULT 0,
	PatientID INT FOREIGN KEY REFERENCES Patient(PatientID),
	AppointmentID INT FOREIGN KEY REFERENCES Appointments(AppointmentID)

)
CREATE TABLE FeedBack
(
	DoctorID INT FOREIGN KEY REFERENCES Doctor(DoctorID),
	PatientID INT FOREIGN KEY REFERENCES Patient(PatientID),
	AppointmentID INT FOREIGN KEY REFERENCES Appointments(AppointmentID),
	Rating INT,
	[Description] NVARCHAR(100),
)
CREATE TABLE ErrorLog (
    ErrorLogID INT IDENTITY(1,1) PRIMARY KEY,
    ErrorMessage NVARCHAR(4000),
    ErrorSeverity INT,
    ErrorState INT,
    ErrorProcedure NVARCHAR(128),
    ErrorLine INT,
    ErrorNumber INT,
    ErrorTime DATETIME DEFAULT GETDATE()
);



 











 
INSERT INTO MedicineInventory(MedicineName,IsActive,Quantity,price)
VALUES ('DOlo',1,100,150)


INSERT INTO DoctorAvailability(DoctorID ,  DayOfWeek ,StartTime,    EndTime , Date)
VALUES (9,'Tuesday' ,'10:00','20:00','2024-08-14')


DECLARE @AvailabilityID INT;
SELECT @AvailabilityID = AvailabilityID FROM DoctorAvailability WHERE DoctorID = 9 AND DayOfWeek = 'Tuesday';


INSERT INTO AppointmentSlots (AvailabilityID, SlotStartTime, SlotEndTime,Date)
VALUES 
(@AvailabilityID, '09:00', '09:30','2024-08-16'),
(@AvailabilityID, '09:30', '10:00','2024-08-16'),
(@AvailabilityID, '10:00', '10:30','2024-08-16'),
(@AvailabilityID, '10:30', '11:00','2024-08-16'),
(@AvailabilityID, '11:00', '11:30','2024-08-16'),
(@AvailabilityID, '11:30', '12:00','2024-08-16');





