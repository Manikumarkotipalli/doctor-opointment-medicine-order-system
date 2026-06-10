/**************************************************************
	Table Name			: USP_UserLogin
	Purpose		        : Login Users based on their Registration details
	Created By          : Mani kumar
	Created On          : 06/08/24
	Modified By         :
	Modified ON         :
	MOdified            :

****************************************************************/
CREATE PROCEDURE USP_UserLogin
@UserID INT ,
@Password VARCHAR(20),
@UserType VARCHAR (10)
AS
BEGIN
	BEGIN TRY
		--Checking for the valid @UserID and @UserType
		IF @UserID IS NULL OR @UserType IS NULL OR @Password IS NULL
		BEGIN
			RAISERROR('Invalid Parameter',16,1)
			RETURN
			
		END
		--If UserType is patient
		 IF (@UserType ='Patient')
		BEGIN
			DECLARE @TempPatientID INT;
			DECLARE @TempPatientPassword VARCHAR(20);
			--Checking the PatientId is exists in patient table or not
			SELECT @TempPatientID =[PatientID] ,@TempPatientPassword=[Password]
			FROM Patient
			WHERE PatientID = @UserID
			--If patientId matches with Existing Id then Login succesful
			IF(@TempPatientID IS NULL)
			BEGIN
				
				RAISERROR('Invalid Patient ID',16,1)
				RETURN
			END
			ELSE IF (@TempPatientPassword !=@Password)
			BEGIN
				RAISERROR('Invalid Password',16,1)
				RETURN
			END
			ELSE
			BEGIN
				PRINT 'Login Successful';
				RETURN
			END
		END
		--If @UserType is Doctor
		 IF (@UserType ='Doctor')
		BEGIN
			DECLARE @TempDoctorID INT;
			DECLARE @TempDoctorPassword VARCHAR(20);
			--Checking the DoctorID is exists in Doctor table or not
			SELECT @TempDoctorID = [DoctorID] , @TempDoctorPassword=[Password]
			FROM  Doctor
			WHERE DoctorID = @UserID
			--If DoctorID matches with Existing Id then Login succesful
			IF (@TempDoctorID IS NULL)
			BEGIN
					RAISERROR('Invalid Doctor ID',16,1)
					RETURN
			END
			ELSE IF (@TempDoctorPassword != @Password)
			BEGIN
				RAISERROR('Invalid Password',16,1)
				RETURN
			END
			ELSE 
			BEGIN
				PRINT 'Login Successful';
				RETURN
			END
		END
		 IF (@UserType ='Admin')
		BEGIN
			DECLARE @TempAdminID INT;
			DECLARE @TempAdminPassword VARCHAR(20);
			--Checking the AdminID is exists in Admin table or not
			SELECT @TempAdminID = [AdminID] , @TempAdminPassword=[Password]
			FROM [Admin]
			WHERE AdminID = @UserID;
			--If AdminID matches with Existing Id then Login succesful
			IF(@TempAdminID IS NULL)
			BEGIN
				RAISERROR('Invalid AdminID',16,1);
				RETURN
			END
				ELSE IF (@TempAdminPassword !=@Password)
			BEGIN
				RAISERROR('Invalid Password',16,1)
				RETURN
			END
			ELSE
			BEGIN
				PRINT 'Login Successful';
				RETURN
			END
		END
		ELSE
		BEGIN
			RAISERROR('Invalid  Operation',16,1)
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

---------Unit Testing---------

--Valid PatientID
--Expected output ,Login Successful
EXEC USP_UserLogin
	@UserID = 8,
	@UserType = 'Doctor',
	@Password='maya1234'

--InValid PatientID
--Expected output 'Invalid Patient ID'
EXEC USP_UserLogin
	@UserID = 100,
	@UserType = 'Patient',
	@Password='rrrayan'

--Invalid password
--Expected output 'Invalid password'
EXEC USP_UserLogin
	@UserID = 1,
	@UserType = 'Admin',
	@Password='dsjnds'

--Invalid parameter
--Expected output 'Invalid parameter'
EXEC USP_UserLogin
	@UserID = 1,
	@UserType = null,
	@Password=null





	



	