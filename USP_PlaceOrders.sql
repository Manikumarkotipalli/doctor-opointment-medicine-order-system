/**************************************************************
	Table Name			: USP_PlaceOrders
	Purpose		        : Patients can place orders based on their prescription
	Created By          : Mani kumar
	Created On          : 09/08/24
	Modified By         :
	Modified ON         :
	MOdified            :

****************************************************************/

CREATE PROCEDURE  USP_PlaceOrders
@AppointmentID INT
AS
BEGIN
	BEGIN TRY
		DECLARE @TempAppointmentID INT;
		DECLARE @CheckBookingStatus INT;
		DECLARE @CheckQuantity INT;
		DECLARE @MedicineQuantity INT
		--Checking the existence of AppointmentID in Appointments table
		SELECT @TempAppointmentID = [AppointmentID]
		FROM Appointments
		WHERE AppointmentID =@AppointmentID ;
		--Checking the booking status in orders table
		SELECT @CheckBookingStatus = [AppointmentID]
		FROM [Order]
		WHERE AppointmentID = @AppointmentID
		--Checking the Quantity of medicine prescribed by doctor
		SELECT @CheckQuantity=[Quantity]
		FROM Prescriptions
		WHERE AppointmentID=@AppointmentID
		--Checking the quantity available in Medicine Inventory
		SELECT @MedicineQuantity=M.Quantity
		FROM MedicineInventory M
		JOIN Prescriptions P
		ON M.MedicinID=P.MedicineID
		WHERE P.AppointmentID=@AppointmentID


		--Raise an error if @AppointmentID input or @TempAppointmentID is NULL
		IF (@AppointmentID IS NULL OR @TempAppointmentID IS NULL)
			BEGIN
				RAISERROR('ID IS INVALID',16,1)
				RETURN
			END
		ELSE IF (@CheckQuantity>@MedicineQuantity)
			BEGIN
				RAISERROR('Not enough medicine stock available',16,1);
				RETURN
			END


		--Checking the bookingstatus of that particular AppointmentID from orders , If yes raise an error
		ELSE IF (@CheckBookingStatus IS NOT NULL)
			BEGIN
				RAISERROR('Order is already placed',16,1)
				SELECT O.OrderID ,O.OrderDate ,O.TotalBill ,O.OrderStaus ,O.PatientID ,O.AppointmentID
				FROM [Order] O
				WHERE O.AppointmentID =@AppointmentID

				RETURN
			END
		--If all the above conditions are fail , place an order by inserting into orders table
		ELSE 
			BEGIN
				--Updating Medicine Inventory while placing an order respective to its Prescribed Quantity
				UPDATE MedicineInventory
				SET Quantity =M.Quantity-p.Quantity
				FROM MedicineInventory M
				INNER JOIN Prescriptions P
				ON P.MedicineID =M.MedicinID
				WHERE P.AppointmentID=@AppointmentID
				
				INSERT INTO [Order](OrderDate ,TotalBill ,OrderStaus ,PatientID ,AppointmentID)
				SELECT 
					 FORMAT(GETDATE(), 'yyyy-MM-dd') AS FormattedDate,
					 SUM(p.Quantity * M.Price) AS Price,
					 1 ,
					 A.PatientID,
					 A.AppointmentID
				FROM Prescriptions P
				INNER JOIN Appointments A
				ON P.AppointmentID =A.AppointmentID
				INNER JOIN MedicineInventory M
				ON M.MedicinID=P.MedicineID
				WHERE A.AppointmentID =@AppointmentID
				GROUP BY A.PatientID,
				A.AppointmentID


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

--Valid AppointmentId
--Expected output , Order placing successful in orders table
EXEC USP_PlaceOrders 40


--InValid AppointmentId
--Expected output , 'ID is Invalid'
EXEC USP_PlaceOrders 350




SELECT * FROM [Order]
SELECT * FROM ErrorLog
SELECT * FROM Prescriptions


	

	




	


