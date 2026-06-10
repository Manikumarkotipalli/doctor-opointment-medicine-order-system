/**************************************************************
	Table Name			: USP_ProfileManagement
	Purpose		        : Allow Users to Manage their profiles
	Created By          : Mani kumar
	Created On          : 07/08/24
	Modified By         :
	Modified ON         :
	MOdified            :

****************************************************************/
CREATE PROCEDURE  USP_ProfileManagement
@UserID INT ,
@UserType VARCHAR (10),
@UserPassword VARCHAR(20),
@Operation VARCHAR (10) = NULL,
@Mobile VARCHAR(20) =NULL,
@Email VARCHAR(30) = NULL,
@Password VARCHAR(20) =NULL
AS
BEGIN
	BEGIN TRY
		--Executing USP_UserLogin stored procedure for UserLogin
		EXEC USP_UserLogin 
				@UserId =@UserID , 
				@UserType=@UserType,
				@Password=@UserPassword
				
		--If UserType is Patient 
		IF (@UserType = 'Patient')
			BEGIN
				--If Operation is view , Display the patient details
				IF (@Operation ='View')
					BEGIN
					SELECT P.UserName ,P.Email , P.Mobile
					FROM Patient P
					WHERE P.PatientID = @UserID
					RETURN
					END
				--If Operation is update , then update the Patient details with Patient sent inputs
				ELSE IF(@Operation ='Update')
					BEGIN
					UPDATE Patient
					SET Mobile =ISNULL(@Mobile ,Mobile),
						Email = ISNULL(@Email,Email),
						[Password] =ISNULL(@Password,Password)
					WHERE PatientID =@UserID
					RETURN
					END
				ELSE
					BEGIN
						RAISERROR('Invalid P Operation',16,1);
						RETURN
					END
			END
		--If UserType is Doctor
		ELSE IF (@UserType ='Doctor')
			BEGIN
				--If Operation is view , Display the Doctor details
				IF (@Operation ='View')
					BEGIN
					SELECT D.UserName ,D.Email , D.Mobile
					FROM Doctor D
					WHERE D.DoctorID = @UserID
					RETURN
					END
				--If Operation is update , then update the doctor details with doctor sent inputs
				ELSE IF(@Operation ='Update')
					BEGIN
					UPDATE Doctor
					SET Mobile =ISNULL(@Mobile ,Mobile),
						Email = ISNULL(@Email,Email),
						[Password] =ISNULL(@Password,Password)
					WHERE DoctorID =@UserID
					RETURN
					END
				ELSE
					BEGIN
						RAISERROR('Invalid Operation',16,1);
						RETURN
					END
			END
		--If UserType is Admin
		ELSE IF (@UserType ='Admin')
			BEGIN
				--If Operation is view , Display the Admin details
				IF (@Operation ='View')
					BEGIN
					SELECT A.UserName ,A.Email , A.Mobile
					FROM Admin A
					WHERE A.AdminID = @UserID
					RETURN
					END
					
				--If Operation is update , then update the Admin details with Admin sent inputs
				ELSE IF(@Operation ='Update')
					BEGIN
					UPDATE Admin
					SET Mobile = ISNULL(@Mobile ,Mobile),
						Email = ISNULL(@Email,Email),
						[Password] =ISNULL( @Password,Password)
					WHERE AdminID = @UserID
					RETURN
					END
				ELSE
					BEGIN
						RAISERROR('Invalid Operation',16,1);
						RETURN
					END
				END

			ELSE
			--Raise an error , If user sends an invalid id
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

        PRINT 'Error: ' + @ErrorMessage;

      END CATCH
END

--Unit Testing

--Valid Parameters
--Expected output 'Updated the specified table with given inputs'
EXEC  USP_ProfileManagement @UserID =9,
							@UserType='Doctor',
							@UserPassword='san12',
							@Operation='Update',
							@Email ='santhoshnarayan@gmail.com',
							@Mobile ='1898302874'
							
--Invalid ID
--Expected output 'Invalid Patient ID'
EXEC  USP_ProfileManagement @UserID =150,
							@UserType='Patient',
							@UserPassword='san12',
							@Operation='Update',
							@Email ='Jinx@gmail.com',
							@Password ='SAYANORA'
							
--Valid parameters
--Expected output 'view profile of that particular ID'
EXEC  USP_ProfileManagement @UserID =9,
							@UserType='Doctor',
							@Operation='View',
							@UserPassword='san12'

--Sending Nulls to some parameters
--Expected Output 'Update the specified inputs and leave the null specified column
EXEC  USP_ProfileManagement @UserID =2,
							@UserType='Admin',
							@UserPassword='mouni',
							@Operation='Update',
							@Email =NULL,
							@Password ='mouni',
							@Mobile ='13691109898'
							

SELECT * FROM Admin
SELECT * FROM Patient
SELECT * FROM Doctor
SELECT * FROM ErrorLog
