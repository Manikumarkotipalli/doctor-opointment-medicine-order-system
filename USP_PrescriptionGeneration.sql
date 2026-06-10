/**************************************************************
	Table Name			: USP_PrescriptionGeneration
	Purpose		        : Doctors generate prescription to patients based on Apointments
	Created By          : Mani kumar
	Created On          : 08/08/24
	Modified By         :
	Modified ON         :
	MOdified            :

****************************************************************/


CREATE PROCEDURE USP_PrescriptionGeneration
@AppointmentID INT ,
@Quantity INT,
@MedicineID INT,
@Dosage VARCHAR(20),
@Instructions VARCHAR(50)
AS
BEGIN
	BEGIN TRY
		DECLARE @TempAppointmentID INT;
		DECLARE @CheckPrescription INT;
		DECLARE @MaxQuantity INT =40;
	
		--Checking If the input Appointment is exists or not
		SELECT @TempAppointmentID =[AppointmentID]
		FROM Appointments
		WHERE AppointmentID=@AppointmentID

		SELECT @CheckPrescription =[AppointmentID]
		FROM Orders
		WHERE AppointmentID=@AppointmentID
	
		IF(@CheckPrescription IS NOT NULL)
			BEGIN
				RAISERROR('Prescription is already generated for this Appointment',16,1);
				RETURN
			END
		--Raise an error if Appointment is not existed
		IF (@TempAppointmentID IS  NULL)
			BEGIN
			
				RAISERROR('Appointment Not exists',16,1);
				RETURN
			
			END
		ELSE IF (@Quantity>@MaxQuantity)
			BEGIN
				RAISERROR('Maximum Prescribe Quantity Reached',16,1);
				RETURN
			END
		--If the AppointmentID is exists , then inserting prescription data in precriptions table
		ELSE
			BEGIN
				INSERT INTO Prescriptions(AppointmentID , MedicineID ,Dosage , Quantity ,Instructions)
				VALUES (@AppointmentID ,
				@MedicineID,
				@Dosage,
				@Quantity,
				@Instructions)
				RETURN
			END
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(200),
            @ErrorSeverity INT,
            @ErrorState INT,
            @ErrorProcedure NVARCHAR(30),
            @ErrorLine INT,
            @ErrorNumber INT;

		SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE(),
           @ErrorProcedure = ERROR_PROCEDURE(),
           @ErrorLine = ERROR_LINE(),
           @ErrorNumber = ERROR_NUMBER();

		EXEC USP_LogError @ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorNumber;
	    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH
END

-----------Unit testing----------

--Valid AppointmentID 
--Expected Output ,Generate prescription with specified appointmentID
EXEC USP_PrescriptionGeneration
	@AppointmentID =35,
	@Quantity=4,
	@MedicineID=1,
	@Dosage='600mg',
	@Instructions='Take 1 pill at night'

--InValid AppointmentID
--Expected output , 'Appointment Not exists'
EXEC USP_PrescriptionGeneration
	@AppointmentID =390,
	@Quantity=4,
	@MedicineID=1,
	@Dosage='600mg',
	@Instructions='Take 1 pill at night'


--InValid Qunatity
--Expected output , 'Maximum Prescribe Quantity Reached'
EXEC USP_PrescriptionGeneration
	@AppointmentID =39,
	@Quantity=45,
	@MedicineID=1,
	@Dosage='600mg',
	@Instructions='Take 1 pill at night'





SELECT * FROM Appointments
SELECT * FROM Prescriptions
SELECT * FROM MedicineInventory
SELECT * FROM ErrorLog

	
	
	
	
	
	
	
	
	

	
