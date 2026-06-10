/**************************************************************
	Table Name			: USP_UserRegistration
	Purpose		        : Register Users Based on their types
	Created By          : Mani kumar
	Created On          : 06/08/24
	Modified By         :
	Modified ON         :
	Modified            :

****************************************************************/
ALTER PROCEDURE USP_UserRegistration
@UserName VARCHAR(20),
@Name VARCHAR(20),
@Password VARCHAR(20),
@Email VARCHAR(30),
@Mobile VARCHAR(20),
@Aadhar VARCHAR(20),
@User VARCHAR(10),
@Specialization VARCHAR(20) =NULL
AS
BEGIN
	BEGIN TRY
		--Checking the input parameters , If any of the parameters are empty , Raise an error
		IF @UserName IS NULL OR @Name IS NULL OR @Password IS NULL OR @Email IS NULL OR @Mobile IS NULL OR @Aadhar IS NULL OR @User IS NULL
		BEGIN
			RAISERROR('Parameters Can''t be empty',16,1)
			RETURN
		END
		
		--If UserType is patient
		IF (@User ='Patient')
			BEGIN
				DECLARE @TempUserName VARCHAR(20);
				--Checking the existence of UserName
				SELECT @TempUserName =[UserName]
				FROM Patient
				WHERE UserName = @UserName;
				
				--Inserting input parameters into Patient table
				IF(@TempUserName IS NULL)
					BEGIN
					INSERT INTO Patient(UserName ,[Name],[Password],[Email],Mobile,Aadhar,IsActive)
						VALUES (@UserName ,@Name ,@Password ,@Email ,@Mobile ,@Aadhar ,1)
					END
				ELSE
					BEGIN
							RAISERROR('UserName Already Exists',16,1)
					END
			END
			--If Usertype is Doctor
			ELSE IF (@User ='Doctor')
				BEGIN
					DECLARE @TempDoctorUserName VARCHAR(20)
					--Checking the existence of DoctorId
					SELECT @TempDoctorUserName =[UserName]
					FROM Doctor
					WHERE UserName = @UserName

					--Inserting input parameters into Patient table
					IF(@TempDoctorUserName IS NULL)
						BEGIN
							INSERT INTO Doctor (UserName ,[Name],Email,[Password],IsActive,Aadhar,Specialization)
							VALUES (@UserName ,@Name ,@Email ,@Password ,1,@Aadhar,@Specialization)
						END
					ELSE
						BEGIN
							RAISERROR('UserName is already exists',16,1)
						END
				END
			--If UserType is Admin
			ELSE IF (@User ='Admin')
			BEGIN
				DECLARE @TempAdminUserName VARCHAR(20);
				--Checking the existence of DoctorId
				SELECT @TempAdminUserName =[UserName]
				FROM [Admin]
				WHERE UserName = @UserName
				--Inserting input parameters into Patient table
				IF(@TempAdminUserName IS NULL)
				BEGIN
					INSERT INTO [Admin](UserName ,[Name] ,[Password],Email,Mobile,IsActive,Aadhar)
					VALUES (@UserName ,@Name ,@Password ,@Email,@Mobile,1,@Aadhar)
				END
				ELSE
				BEGIN
					RAISERROR('UserName already Exists',16,1);
				END
				
				END
				ELSE
				BEGIN
					RAISERROR('Invalid UserType',16,1)
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
		IF ERROR_NUMBER() = 2627 -- Unique constraint violation error number
        BEGIN
            -- Throw a custom error
            RAISERROR('A user with this parameter already exists.', 16, 1);
        END
		ELSE IF ERROR_NUMBER() =547
		BEGIN
			RAISERROR('Cannot Enter Null values ',16,1);
		END
		ELSE
		BEGIN
			THROW;
		END
      
	END CATCH
END


--- Unit Testing

--Valid data
--Expected output 'Insert the data into Specified user's table
EXEC USP_UserRegistration
	@UserName = 'krishnaMadhav',
	@Name ='krishna',
	@Password='krishna1234',
	@Email='krishnaMadhav@gmail.com',
	@Mobile='9963456709',
	@Aadhar='990990912378',
	@User='Patient'

--Invalid data
--Expected output ,Raising error stating 'parameters can't be empty'
EXEC USP_UserRegistration
	@UserName = NULL,
	@Name ='John Michel',
	@Password='John@2006',
	@Email='John@gmail.com',
	@Mobile='1234567890',
	@Aadhar='123412341234',
	@User='Patient'
	

--Sending existed credentials for registration
--Expected Output ,Raise an error stating 'Username already exists'
EXEC USP_UserRegistration
	@UserName = 'JohnMichel123',
	@Name ='John Michel',
	@Password='John@2006',
	@Email='John@gmail.com',
	@Mobile='9834898308',
	@Aadhar='129083728098',
	@User='Patient'

	

--Sending invalid Usertype
--Expected output 'Invalid UserType'
EXEC USP_UserRegistration
	@UserName = 'JohnMic',
	@Name ='JohnAbraham',
	@Password='John@2006',
	@Email='John@gmail.com',
	@Mobile='9090129839',
	@Aadhar='123412341234',
	@User='User'

	



 
 