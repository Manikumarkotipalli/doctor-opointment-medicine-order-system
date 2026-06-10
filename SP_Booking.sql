/**************************************************************
	Table Name			: USP_Booking
	Purpose		        : Patients can Book doctor depends on their availability
	Created By          : Mani kumar
	Created On          : 07/08/24
	Modified By         : Mani kumar
	Modified ON         : 12/08/24
	MOdified            : Modified the logic of Re-scheduling  and Added Cancellation feature 

****************************************************************/
CREATE PROCEDURE  USP_Booking
@PatientID INT=NULL,
@SlotID INT =NULL,
@Operation VARCHAR(20)=NULL,
@DoctorID INT =NULL,
@Date VARCHAR(20) = NULL,
@ReScheduleSlotID INT = NULL,
@AppointmentID INT = NULL
AS
BEGIN
	BEGIN TRY
		--Showing the available Appointment slots for VIEW AVAILABLE Operation
		IF (@Operation ='ViewAvailable')
			BEGIN
				SELECT A.AvailabilityID ,
					A.DayOfWeek,
					A.DoctorID,
					D.Name,
					S.SlotID,
					(S.SlotStartTime),
					(S.SlotEndTime),
					A.Date,
					S.IsBooked
				FROM DoctorAvailability A
				INNER JOIN Doctor D
				ON A.DoctorID = D.DoctorID
				INNER JOIN AppointmentSlots S
				ON S.AvailabilityID =A.AvailabilityID
				WHERE A.DoctorID = @DoctorID
				AND A.DATE = @Date
		END
		--Booking a slot If Slot is Available and Operation is BOOKAPPOINTMENT
		ELSE IF (@Operation ='BookAppointment')
			BEGIN
				DECLARE @TempSlotCheck INT;
				DECLARE @BookingStatus BIT;
				DECLARE @CheckAppointmentFrequency INT;
				DECLARE @ChekDate VARCHAR(15);
				--Checking for slot Availability , Booking status of that slot
				SELECT @TempSlotCheck =A.[SlotID] ,@BookingStatus = A.IsBooked
				FROM AppointmentSlots A
				WHERE SlotID = @SlotID
				--Checking if the same patient booked the same doctor on the same date
				SELECT @CheckAppointmentFrequency = COUNT(AppointmentID)
				FROM Appointments
				WHERE Date = @Date 
				AND PatientID = @PatientID 
				AND DoctorID = @DoctorID;

				SELECT @ChekDate = [Date]
				FROM DoctorAvailability
				WHERE  [Date] = @Date

				--Throwing an error if the same patient booked the same doctor on the same date
				IF (@CheckAppointmentFrequency !=0)
					BEGIN
						RAISERROR('You have already had an appointment on same day with same doctor ,Try another day',16,1);
					RETURN
				END
				--If slot available and not booked yet ,update booking status of that slot , And then make an appointment
				ELSE IF (@TempSlotCheck IS NOT NULL AND @BookingStatus =0 AND @ChekDate IS NOT NULL)
					BEGIN
						INSERT INTO Appointments(PatientID ,DoctorID ,Date ,SlotStartTime ,SlotEndTime,SlotID,Status)
						SELECT @PatientID AS PatientID ,
							   @DoctorID AS DoctorID,
							   @Date AS Date,
							   A.SlotStartTime,
							   A.SlotEndTime,
							   A.SlotID,
							  'Booked' 
						FROM AppointmentSlots A
						INNER JOIN DoctorAvailability D
						ON D.AvailabilityID =A.AvailabilityID
						WHERE SlotID = @SlotID
					
						UPDATE AppointmentSlots
						SET IsBooked = 1
						WHERE SlotID = @SlotID
						AND Date = @Date
					
						SELECT 'Booking successful' AS MESSAGE

			
				END
				ELSE
					BEGIN
						RAISERROR('slot has been already booked',16,1)
					END

		END
		--If operation is Rescheduling 
		ELSE IF (@Operation ='ReSchedule')
			BEGIN
				DECLARE @CheckAppointment INT ;
				DECLARE @CheckSlot INT;
				
				--Check Appointment is exists or not
				SELECT @CheckAppointment = AppointmentID
				FROM Appointments
				WHERE AppointmentID =@AppointmentID
				--Check If user specified slot is available or not
				SELECT @BookingStatus = IsBooked , @CheckSlot =SlotID
				FROM AppointmentSlots
				WHERE SlotID = @ReScheduleSlotID
				--If Booking status is available and appointment existed and also wanted slot is available
			IF (@BookingStatus =0 AND @CheckAppointment IS NOT NULL AND @CheckSlot IS NOT NULL)
				BEGIN
					--Update previous slot to available for others
					UPDATE AppointmentSlots
					SET IsBooked = 0
					WHERE SlotID = @SlotID
					--Book new slot
					UPDATE Appointments
					SET SlotID =@ReScheduleSlotID
					WHERE AppointmentID =@AppointmentID
					--Change the status of that booked slot
					UPDATE AppointmentSlots
					SET IsBooked = 1
					WHERE SlotID = @ReScheduleSlotID

					SELECT 'Re-Scheduling Successful' AS MESSAGE
				END
			ELSE
				BEGIN
					RAISERROR('Slot Id Not Available',16,1);
					RETURN
				END
		END
		--If operation is cancellation 
		ELSE IF (@Operation ='Cancel')
			BEGIN
			DECLARE @CheckAppointmentForCancellation INT ;
			--Check Appointment is exists for cancellation
			SELECT @CheckAppointmentForCancellation = AppointmentID
			FROM Appointments
			WHERE AppointmentID =@AppointmentID
			--If Available Delete the Appointment and change slot status to available
			IF(@CheckAppointmentForCancellation IS NOT NULL)
				BEGIN
					DELETE 
					FROM Appointments 
					WHERE AppointmentID = @AppointmentID

					UPDATE AppointmentSlots 
					SET IsBooked=0
					FROM AppointmentSlots S
					INNER JOIN Appointments A
					ON S.SlotID =A.SlotID
					WHERE S.SlotID =@SlotID

					SELECT 'Appointment Cancelled' AS MESSAGE;

					RETURN
				END
			ELSE
				BEGIN
					RAISERROR('Appointment Not Available ',16,1)
					RETURN
				END
			END
		ELSE
			BEGIN
				RAISERROR('Invalid operation',16,1)
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


--Unit testing

--Valid DoctorId and Date
--Expected output ,Display all the appointment slots of specified doctor on specified date
EXEC USP_Booking 
		@Operation='ViewAvailable',
		@DoctorID =8,
		@Date='2024-08-14'

--Patient trying to book another appointment on same day
--Expected output ,'You have already have an appointment , try another day'
EXEC USP_Booking 
		@SlotID =82,
		@Operation='BookAppointment',
		@DoctorID =8,
		@Date='2024-08-14',
		@PatientID=15


--Patient trying to book another appointment on same day
--Expected output ,'You have already have an appointment , try another day'
EXEC USP_Booking 
		@SlotID =89,
		@Operation='BookAppointment',
		@DoctorID =8,
		@Date='2024-08-14',
		@PatientID=13

--Available Appointment slot ,Valid inputs
--Expected output , Book a slot in appointmentslots and insert into Appointments
EXEC USP_Booking 
		@SlotID =78,
		@Operation='BookAppointment',
		@DoctorID=8,
		@PatientID=14,
		@Date='2024-08-14'

--Available Appointment slot ,Valid AppointmentID
--Expected output ,Reschedule Appointment in specified slot
EXEC USP_Booking 
		@SlotID =78,
		@Operation='ReSchedule',
		@DoctorID=8,
		@ReScheduleSlotID=86,
		@PatientID=14,
		@Date='2024-08-14',
		@AppointmentID=39

--Booked slot ,Valid AppointmentID
--Expected output ,Cancel the Appointments , Update the bookingstatus to Available in Appointmentslot
EXEC USP_Booking 
		@SlotID =82,
		@Operation='Cancel',
		@AppointmentID =36


SELECT * FROM ErrorLog		












