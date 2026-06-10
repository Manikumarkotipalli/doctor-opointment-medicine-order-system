/**************************************************************
	Table Name			: USP_LogError
	Purpose		        : Logging errors
	Created By          : Mani kumar
	Created On          : 13/08/24
	Modified By         :
	Modified ON         :
	MOdified            :

****************************************************************/

CREATE PROCEDURE USP_LogError
    @ErrorMessage NVARCHAR(4000),
    @ErrorSeverity INT,
    @ErrorState INT,
    @ErrorProcedure NVARCHAR(128),
    @ErrorLine INT,
    @ErrorNumber INT
AS
BEGIN
    INSERT INTO ErrorLog (ErrorMessage, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorNumber)
    VALUES (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorNumber);
END
