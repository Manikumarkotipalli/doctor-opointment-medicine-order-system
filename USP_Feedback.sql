/**************************************************************
	Table Name			: USP_Feedback
	Purpose		        : Patients can give their feedback to doctors
	Created By          : Mani kumar
	Created On          : 11/08/24
	Modified By         :
	Modified ON         :
	Modified            :

****************************************************************/
CREATE PROCEDURE USP_Feedback
@AppointmentID INT,
@Rating FLOAT,
@Description NVARCHAR(100)=NULL
AS
BEGIN
	BEGIN TRY
	DECLARE @TempAppointmentID INT;
	DECLARE @TempRating INT =5;
	DECLARE @CheckFeedback INT;
	--Checking AppointmentID is exists or not
	SELECT @TempAppointmentID = [AppointmentID]
	FROM Appointments
	WHERE AppointmentID =@AppointmentID ;
	--Checking whether patient is already given the feedback or not
	SELECT @CheckFeedback =[AppointmentID]
	FROM Feedback
	WHERE AppointmentID = @AppointmentID
		--If AppointmentID is not exists in Appointments Table , Raise an error
		IF (@TempAppointmentID IS NULL )
			BEGIN
				RAISERROR('ID IS INVALID',16,1)
				RETURN
			END
		--If patient was already given the feedback , Raise an error
		ELSE IF (@CheckFeedback IS NOT NULL)
			BEGIN
				RAISERROR ('You have already given Feedback',16,1)
				RETURN
			END
		--If Rating input is higher then standard rating , Raise an error
		ELSE IF(@Rating > @TempRating)
			BEGIN
				RAISERROR('please Send valid Rating',16,1);
				RETURN
			END 
		--Insert feedback data into Feedback table,If all the above conditions are failed
		ELSE	
			BEGIN
				INSERT INTO FeedBack (DoctorID,PatientID,Rating,Description,AppointmentID)
				SELECT 
					A.DoctorID,
					A.PatientID,
					@Rating,
					@Description,
					@AppointmentID
				FROM Appointments A
				WHERE A.AppointmentID=@AppointmentID

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


--Unit Testing

--Valid AppointmentID 
--Expected Output , Insert inputs into feedback table

EXEC USP_Feedback 
	@AppointmentID =39,
	@Rating =3,
	@Description ='Very patient friendly doctor , treatment is very well'

--FeedBack is already given by specified AppointmentID
--Expected output ,Throw an error
EXEC USP_Feedback 
	@AppointmentID =37,
	@Rating =4,
	@Description ='Very patient friendly doctor , treatment is very well'

--Sending AppointmentID as NUll
--Expected output ID is invalid
EXEC USP_Feedback 
	@AppointmentID =NULL,
	@Rating =2.5,
	@Description ='Very patient friendly doctor , treatment is very well'

--Sending Invalid Rating
--Expected output ,Throws an error
EXEC USP_Feedback 
	@AppointmentID =32,
	@Rating =9,
	@Description ='Very patient friendly doctor , treatment is very well'

SELECT * FROM Appointments
