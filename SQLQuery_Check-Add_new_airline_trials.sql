IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Table_Airports')
	--1 DECYZJA START
	BEGIN
		PRINT 'Table Table_Airports Exists!'

		IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Table_Trials')
			--2 DECYZJA START
			BEGIN
				PRINT 'Table Table_Trials Exists!'
				------------------TABELE ISTNIEJ¥------------------


				------------------USTAW PÊTLE------------------

				DECLARE @no_airport_1 INT
				SET @no_airport_1 = 1
				PRINT 'airport_number_1: '
				PRINT @no_airport_1

				DECLARE @no_airport_2 INT
				SET @no_airport_2 = 1
				PRINT 'airport_number 2: '
				PRINT @no_airport_2

				SELECT MAX(id_airports) AS LastID FROM Table_Airports
				DECLARE @last_id_airport INT
				SET @last_id_airport = (SELECT MAX(id_airports) AS LastID FROM Table_Airports)
				PRINT '@last_id_airport: '
				PRINT @last_id_airport

				DECLARE @no_repeates INT
				SET @no_repeates = 1

				DECLARE @no_airport_1_bool BIT
				DECLARE @no_airport_2_bool BIT

				PRINT 'START WHILE'
				WHILE @no_airport_1 <= @last_id_airport
					--1 PÊTLA START
					BEGIN
						------------------CZY LOTNISKO Z DANYM ID ISTANIEJE?------------------
						IF EXISTS (SELECT id_airports FROM Table_Airports WHERE id_airports = @no_airport_1)
							--3 DECYZJA START
							BEGIN
								PRINT 'ID takiego Lotniska istnieje! Nr lotniska: '
								PRINT @no_airport_1

								WHILE @no_airport_2 <= @last_id_airport
									--2 PÊTLA START
									BEGIN
										
										------------------CZY ISTNIEJE ID LOTNISKA O NUMERZE no_airport_2 ORAZ no_airport_2 NIE JEST TAKI SAM JAK no_airport_1-----------------
										IF EXISTS (SELECT id_airports FROM Table_Airports WHERE id_airports = @no_airport_2) AND (@no_airport_2 != @no_airport_1)
										--4 DECYZJA START
										BEGIN 

											PRINT 'Lotnisko @no_airport_2 istnieje i jest ró¿ne od @no_airport_1'

											PRINT '@no_airport_2'
											PRINT @no_airport_2

											------------------CZY ISTNIEJE JU¯ DANA TRASA?------------------
											------------------JEŒLI ISTNIEJE NUMER ID LOTNISKA STARTOWEGO TAKIE JAK 1 NUMER LOTNISKA oraz JEŒLI ISTNIEJE NUMER ID LOTNISKA KOÑCZ¥CEGO TAKIE JAK 2 NUMER LOTNISKA = PRAWDA------------------
											IF EXISTS (SELECT start_id_airport, end_id_airport FROM Table_Trials WHERE start_id_airport = @no_airport_1 AND end_id_airport = @no_airport_2)
										 
											--5 DECYZJA START
											BEGIN
												
													PRINT 'Istnieje taka trasa w trabeli tras.'
													PRINT 'TAKA TRASA INSTNIEJE! NIE MO¯NA DODAÆ!'
													PRINT 'Istnieje taka trasa:'
													PRINT @no_airport_1
													PRINT @no_airport_2
													--SELECT * FROM Table_Trials WHERE start_id_airport = @no_airport_1 AND end_id_airport = @no_airport_2
													PRINT 'Numer powtórzenia: '
													PRINT @no_repeates
													SET @no_repeates = @no_repeates + 1
												
											END
												--5 DECYZJA KONIEC
											ELSE
											--5 DECYZJA JESZCZE START
											BEGIN
													
													PRINT '      '
													PRINT 'Nie istnieje taka trasa. Mo¿na dodaæ tak¹ trasê'
													PRINT 'Trasa z lotniska o ID: '
													PRINT @no_airport_1
													PRINT @no_airport_2

													--SELECT * FROM Table_Airports WHERE id_airports = @no_airport_1 AND id_airports = @no_airport_2
													------------------DEKLAROWANIE ZMIENNEJ KODU LOTNISKA STARTOWEGO------------------
													DECLARE @airplane_code_1 CHAR(3)
													SET @airplane_code_1 = (SELECT code FROM Table_Airports WHERE id_airports = @no_airport_1)
													PRINT '@airplane_code_1: '
													PRINT @airplane_code_1
													------------------DEKLAROWANIE ZMIENNEJ KODU LOTNISKA KOÑCOWEGO------------------
													DECLARE @airplane_code_2 CHAR(3)
													SET @airplane_code_2 = (SELECT code FROM Table_Airports WHERE id_airports = @no_airport_2)
													PRINT '@airplane_code_2: '
													PRINT @airplane_code_2
													------------------DEKLAROWANIE ZMIENNEJ KODU TRASY------------------
													DECLARE @trail_airline_code CHAR (11)
													SET @trail_airline_code = @airplane_code_1 + '-' + @airplane_code_2 + '-' + '001'
													--SET @trail_airline_code = ((SELECT code FROM Table_Airports WHERE id_airports = @no_airport_1) + '-' + (SELECT code FROM Table_Airports WHERE id_airports = @no_airport_2)) + '-' + '001'
													PRINT '@trail_airline_code:'
													PRINT @trail_airline_code
													------------------DEKLAROWANIE ZMIENNEJ KODU TRASY------------------
													PRINT 'Wstawianie dany do nowego wiersza w tabeli "Trials"'

													INSERT INTO Table_Trials (trial_code, start_id_airport, end_id_airport) VALUES (@trail_airline_code, @no_airport_1, @no_airport_2)

													PRINT 'Numer powtórzenia: '
													PRINT @no_repeates
													SET @no_repeates = @no_repeates + 1

											END --5 DECYZJA JESZCZE KONIEC
											
											PRINT '   ---   '
											SET @no_airport_2 = @no_airport_2 + 1
										END --4 DECYZJA KONIEC
										ELSE
										--4 DECYZJA JESZCZE START (JEŒLI ISTEJE LOTNISKO LUB NIE JEST RÓ¯NE)
										BEGIN
											SET @no_airport_2 = @no_airport_2 + 1
										END --4 DECYZJA JESZCZE KONIEC
									END --2 PÊTLA KONIEC

								PRINT '   '
								SET @no_airport_2 = 1
								SET @no_airport_1 = @no_airport_1 + 1
							END --3 DECYZJA KONIEC
						ELSE
							--3 DECYZJA JESZCZE START (JEŒLI TAKIE LOTNISKO NIE ISTNIEJE)
							BEGIN
								PRINT 'Lotnisko nie istnieje!'
								PRINT '   '
								SET @no_airport_1 = @no_airport_1 + 1
							END --3 DECYZJA JESZCZE KONIEC
						
					END --1 PÊTLA KONIEC
				PRINT 'END WHILE'


				------------------JEŒLI TABELE NIE ISTNIEJ¥------------------
			END --2 DECYZJA KONIEC
		ELSE
			--2 DECYZJA JESZCZE START (JEŒLI NIE ISTNIEJE TABELA TRIALS)
			BEGIN
				PRINT 'Table does not exists!'
				PRINT 'Creating lost table...'
				CREATE TABLE Table_Trials (
				id_trials INT NOT NULL PRIMARY KEY,
				trial_code CHAR(11) NOT NULL,
				start_id_airport INT NOT NULL,
				end_id_airport INT NOT NULL,
				)
				PRINT 'Table created!'
			END --2 DECYZJA JESZCZE KONIEC
	END --1 DECYZJA  KONIEC
ELSE
	--1 DECYZJA JESZCZE START (JEŒLI NIE ISTNIEJE TABELA AIRPORT)
	BEGIN
		PRINT 'Table does not exists!'
		PRINT 'Creating lost table...'
		CREATE TABLE Table_Airports (
		id_airports INT	PRIMARY KEY NOT NULL,
		state CHAR(20) NOT NULL,
		city CHAR(20) NOT NULL,
		name CHAR(50) NOT NULL,
		code CHAR(10) NOT NULL
		)
		PRINT 'Table created!'
	END --1 DECYZJA JESZCZE KONIEC

PRINT 'TABLE UPDATED!'
SELECT * FROM Table_Trials