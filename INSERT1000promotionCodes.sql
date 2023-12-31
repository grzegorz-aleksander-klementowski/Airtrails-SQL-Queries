USE [system_sprzedazy_biletow_lotniczych]
GO
/****** Object:  StoredProcedure [dbo].[INSERT1000promotionCodes]    Script Date: 02/02/2021 16:56:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[INSERT1000promotionCodes]
AS

DECLARE @id_promotion INT
SET @id_promotion = 3
DECLARE @number INT
SET @number = 5
DECLARE @rand_num INT


IF EXISTS (SELECT Table_Promotions.id_promotion FROM Table_Promotions WHERE id_promotion = @id_promotion)
BEGIN

	PRINT 'Dodaje 1000 kuponów dla promocji nr'
	PRINT @id_promotion
	WHILE @number <= 1000
	BEGIN
	
	
		SET @rand_num = FLOOR(RAND()*(9999-1000+1)+1000)
		PRINT @rand_num
		INSERT INTO Table_Promotion_Codes
		(
			id_promotion,
			promotion_code
		)
		VALUES
		(
			@id_promotion,
			@rand_num
		)

		SET @number = @number + 1
	END

END
ELSE
BEGIN
	INSERT INTO Table_Promotions (promotion_name, cut_off) VALUES ('Nowa promocja', 0.0)

	SET @id_promotion = (SELECT MAX(Table_Promotions.id_promotion) FROM Table_Promotions)

	WHILE @number <= 1000
	BEGIN
	
	
		SET @rand_num = FLOOR(RAND()*(9999-1000+1)+1000)
		PRINT @rand_num
		INSERT INTO Table_Promotion_Codes
		(
			id_promotion,
			promotion_code
		)
		VALUES
		(
			@id_promotion,
			@rand_num
		)

		SET @number = @number + 1
	END
END