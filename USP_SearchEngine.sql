/**************************************************************
	Table Name			: USP_SearchEngine
	Purpose		        : Searching doctors , medicines , Appointments based on conditions
	Created By          : Mani kumar
	Created On          : 12/08/24
	Modified By         :
	Modified ON         :
	MOdified            :

****************************************************************/
CREATE PROCEDURE USP_SearchEngine
@SearchType VARCHAR(15),
@MinRating FLOAT =NULL,
@MaxRating FLOAT =NULL,
@MinPrice INT= NULL,
@MaxPrice INT = NULL,
@Date VARCHAR(15)=NULL
AS
BEGIN
	--If SearchType is Doctors ,Display All the doctors whose having rating between specified range
	IF (@SearchType ='Doctors')
	BEGIN
		SELECT D.Name,D.Specialization,D.Mobile,D.Email ,AVG(F.Rating) As Rating
		From Doctor D
		INNER JOIN FeedBack F
		ON F.DoctorID=D.DoctorID
		WHERE F.Rating BETWEEN @MinRating AND @MaxRating
		GROUP BY D.Name,D.Specialization,D.Mobile,D.Email 
		

	END
	--If SearchType is Medicines , Display All the medicines in the range of specified prices
	ELSE IF (@SearchType ='Medicines')
	BEGIN
		SELECT M.MedicineName ,M.Price
		FROM MedicineInventory M
		WHERE M.Price BETWEEN @MinPrice AND @MaxPrice

		

	END
	--If SearchType is Appointments ,Display All the Apointments in specified date
	ELSE IF (@SearchType ='Appointments')
	BEGIN
		SELECT A.AppointmentID ,D.Name  ,P.Name --A.Date
		FROM Appointments A
		INNER JOIN Doctor D
		ON A.DoctorID = D.DoctorID
		INNER JOIN Patient P
		ON A.PatientID = P.PatientID
		WHERE A.[Date] =@Date

		

	END
	ELSE
	BEGIN
		PRINT @Date
		RAISERROR('Invalid parameters',16,1)
	END

END
--Unit Testing
EXEC USP_SearchEngine @SearchType ='Medicines',
						@MinPrice=50,
						@MaxPrice=200

EXEC USP_SearchEngine @SearchType ='Doctors',
						@MinRating=1,
						@MaxRating=5

EXEC USP_SearchEngine @SearchType ='Appointments',
						@Date='2024-08-14'



SELECT * FROM FeedBack
SELECT * FROM Appointments
SELECT * FROM AppointmentSlots
