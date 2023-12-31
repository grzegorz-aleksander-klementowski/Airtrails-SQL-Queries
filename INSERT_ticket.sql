IF @@ERROR = 403
BEGIN
    PRINT N'GEOBLOCK! You have no access from this location!';
	PRINT N'GEOBLOCK! Nie masz dostępu z tej lokacji!';
END
ELSE
BEGIN
	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='Table_Tickets')
	BEGIN
		PRINT 'Tabela Table_Tickets instnieje...'
		PRINT 'Tworzenie zmiennych...'

		DECLARE @id_flight INT
		DECLARE @first_name CHAR(20)
		DECLARE @surname CHAR(20)
		DECLARE @birthday DATE
		DECLARE @nationality CHAR(50)
		DECLARE @id_ticket INT
		DECLARE @id_trials INT
		DECLARE @mulitiplier_bonus_1 INT
		DECLARE @mulitiplier_bonus_2 INT
		DECLARE @mulitiplier_bonus_3 INT
		DECLARE @mulitiplier_bonus_4 INT
		DECLARE @mulitiplier_bonus_5 INT
		DECLARE @promotion_code INT
		DECLARE @id_bonus_1 INT
		DECLARE @id_bonus_2 INT
		DECLARE @id_bonus_3 INT
		DECLARE @id_bonus_4 INT
		DECLARE @id_bonus_5 INT
		DECLARE @cost FLOAT



		--TU WPISYWANE SĄ DANE KLIENTA
		SET @id_flight = 9
		SET @first_name = 'Grzegorz'
		SET @surname = 'Klementowski'
		SET @birthday = '1996-09-27'
		SET @nationality = 'Polish'
		SET @mulitiplier_bonus_1 = 0
		SET @mulitiplier_bonus_2 = 0
		SET @mulitiplier_bonus_3 = 0
		SET @mulitiplier_bonus_4 = 0
		SET @mulitiplier_bonus_5 = 0
		SET @promotion_code = 4600



		PRINT 'Wpisywanie danych do zmiennych...'
		SET @id_ticket = (SELECT MAX(Table_Tickets.id_ticket) AS lastID FROM Table_Tickets) + 1
		SET @id_trials = (SELECT Table_Flights.id_trials FROM Table_Flights WHERE id_flights = @id_flight)
		SET @id_bonus_1 = (SELECT Table_Bonusses.id_bonusses FROM Table_Bonusses WHERE id_operator = (SELECT Table_Flights.id_operator FROM Table_Flights WHERE id_flights = @id_flight) AND bonus_type = 1)
		SET @id_bonus_2 = (SELECT Table_Bonusses.id_bonusses FROM Table_Bonusses WHERE id_operator = (SELECT Table_Flights.id_operator FROM Table_Flights WHERE id_flights = @id_flight) AND bonus_type = 2)
		SET @id_bonus_3 = (SELECT Table_Bonusses.id_bonusses FROM Table_Bonusses WHERE id_operator = (SELECT Table_Flights.id_operator FROM Table_Flights WHERE id_flights = @id_flight) AND bonus_type = 3)
		SET @id_bonus_4 = (SELECT Table_Bonusses.id_bonusses FROM Table_Bonusses WHERE id_operator = (SELECT Table_Flights.id_operator FROM Table_Flights WHERE id_flights = @id_flight) AND bonus_type = 4)
		SET @id_bonus_5 = (SELECT Table_Bonusses.id_bonusses FROM Table_Bonusses WHERE id_operator = (SELECT Table_Flights.id_operator FROM Table_Flights WHERE id_flights = @id_flight) AND bonus_type = 5)
		SET @cost = (SELECT Table_Flights.basic_flight_cost FROM Table_Flights WHERE id_flights = @id_flight)
				+ (SELECT ((SELECT Table_Bonusses.cost FROM Table_Bonusses WHERE id_bonusses = @id_bonus_1) * @mulitiplier_bonus_1))
				+ (SELECT ((SELECT Table_Bonusses.cost FROM Table_Bonusses WHERE id_bonusses = @id_bonus_2) * @mulitiplier_bonus_2))
				+ (SELECT ((SELECT Table_Bonusses.cost FROM Table_Bonusses WHERE id_bonusses = @id_bonus_3) * @mulitiplier_bonus_3))
				+ (SELECT ((SELECT Table_Bonusses.cost FROM Table_Bonusses WHERE id_bonusses = @id_bonus_4) * @mulitiplier_bonus_4))
				+ (SELECT ((SELECT Table_Bonusses.cost FROM Table_Bonusses WHERE id_bonusses = @id_bonus_5) * @mulitiplier_bonus_5))
		PRINT 'Obliczanie kosztów'
					IF (SELECT DATEDIFF(YEAR, @birthday, GETDATE())) = 20
					BEGIN
						PRINT 'Klient nadaje się na zniszkę "20-tka!"'
						PRINT 'Obniżam koszty zakupu biltu o 20%...'
						SET @cost = (SELECT (@cost - ((SELECT Table_Promotions.cut_off FROM Table_Promotions WHERE id_promotion = 2) * @cost)))
					END
					IF @promotion_code = (SELECT Table_Promotion_Codes.promotion_code FROM Table_Promotion_Codes WHERE promotion_code = @promotion_code AND id_promotion = 3)
					BEGIN
						PRINT 'Kod promocyjny "Lekka torba" aktywny'
						PRINT 'Obniżam koszt za transport drugiej torby o 50%...'
						SET @cost = @cost - (@mulitiplier_bonus_1 * (SELECT ((SELECT Table_Bonusses.cost FROM Table_Bonusses WHERE id_bonusses = @id_bonus_1) - ((SELECT Table_Bonusses.cost FROM Table_Bonusses WHERE id_bonusses = @id_bonus_1) * (SELECT Table_Promotions.cut_off FROM Table_Promotions WHERE id_promotion = 3)))))
					END
					ELSE IF(@promotion_code = (SELECT Table_Promotion_Codes.promotion_code FROM Table_Promotion_Codes WHERE promotion_code = @promotion_code AND id_promotion = 4))
					BEGIN
						PRINT 'Kod promocyjny "Stepy Ukrainy" aktywny'
						
						--SELECT Table_Trials.id_trials FROM Table_Trials WHERE end_id_airport >= (SELECT MIN(Table_Airports.id_airports) AS first_id_ukraina_port FROM Table_Airports WHERE state = 'UKRAINA') AND end_id_airport <= (SELECT MAX(Table_Airports.id_airports) AS last_id_ukraina_port FROM Table_Airports WHERE state = 'UKRAINA')
						--SELECT MIN(Table_Trials.id_trials) AS min_id_trial_ukraine FROM Table_Trials WHERE end_id_airport >= (SELECT MIN(Table_Airports.id_airports) AS first_id_ukraina_port FROM Table_Airports WHERE state = 'UKRAINA') AND end_id_airport <= (SELECT MAX(Table_Airports.id_airports) AS last_id_ukraina_port FROM Table_Airports WHERE state = 'UKRAINA')
						
						IF EXISTS ((SELECT Table_Trials.id_trials FROM Table_Trials INNER JOIN Table_Airports ON Table_Trials.end_id_airport = Table_Airports.id_airports WHERE state = 'Ukraina' AND id_trials = @id_trials))
						BEGIN
							PRINT 'Promocja "Ukraińskie stepy" aktywna"'
							PRINT 'Obniżam koszt za loty do Ukrainy o 10%...'
							SET @cost = ((SELECT Table_Flights.basic_flight_cost FROM Table_Flights WHERE id_flights = @id_flight) - ((SELECT Table_Flights.basic_flight_cost FROM Table_Flights WHERE id_flights = @id_flight) * (SELECT Table_Promotions.cut_off FROM Table_Promotions WHERE id_promotion = 4)))
						END
						ELSE
						BEGIN
							PRINT 'Lot nie jest do Ukrainy, stąd cena nie może zostać obniżona.'
						END
					END
					IF EXISTS (SELECT Table_Promotion_Codes.promotion_code FROM Table_Promotion_Codes WHERE promotion_code = @promotion_code AND id_promotion = 5)
					BEGIN
						PRINT 'Promocja "Leć taniej!" aktywna"'
						SET @cost = ((SELECT Table_Flights.basic_flight_cost FROM Table_Flights WHERE id_flights = @id_flight) - ((SELECT Table_Flights.basic_flight_cost FROM Table_Flights WHERE id_flights = @id_flight) * (SELECT Table_Promotions.cut_off FROM Table_Promotions WHERE id_promotion = 5)))
						SELECT @cost
					END
					ELSE
					BEGIN
						PRINT 'Klient nie posiada kuponu promocyjnego'
					END

		PRINT 'Sprawdzanie przeciążenia:'

		IF EXISTS (SELECT * FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Table_Tem_Sys_data')
		BEGIN
			PRINT 'Tabela danych do synchronizacji instanieje.'
			SELECT COUNT(Table_Tem_Sys_data.time_data_query) FROM Table_Tem_Sys_data WHERE time_data_query > (SELECT (DATEADD(SECOND, -3, GETDATE())))

			DECLARE @server_overtime BIT
			SET @server_overtime = 'false'
			WHILE @server_overtime = 'false'
			BEGIN
				IF (SELECT COUNT(Table_Tem_Sys_data.time_data_query) FROM Table_Tem_Sys_data WHERE time_data_query > (SELECT (DATEADD(SECOND, -3, GETDATE())))) < 5
				BEGIN
					SET @server_overtime = 'true'
					PRINT 'Serwer nie jest przeciążony'
					INSERT INTO Table_Tem_Sys_data(new_ticket_query_id,time_data_query, positive_action) VALUES ( @id_ticket, GETDATE(), 'true')

					PRINT 'Dodaje nowy bilet...'
					INSERT INTO Table_Tickets (id_trials, client_first_name, client_surname, client_birthday, client_nationality, id_bonusses_1, id_bonusses_2, id_bonusses_3, id_bonusses_4, id_promotion, total_cost, time_bought)
					VALUES
					(
						@id_trials,
						@first_name,
						@surname,
						@birthday,
						@nationality,
						@mulitiplier_bonus_1,
						@mulitiplier_bonus_2,
						@mulitiplier_bonus_3,
						@mulitiplier_bonus_4,
						@promotion_code,
						@cost,
						GETDATE()
					)
					PRINT 'Dodano bilet zakupiny!'
					SELECT * FROM Table_Tickets WHERE id_ticket = (SELECT MAX(id_ticket) FROM Table_Tickets)
				END
				ELSE
				BEGIN
					SET @server_overtime = 'false'
					PRINT 'Serwer jest przeciążony'
					INSERT INTO Table_Tem_Sys_data(new_ticket_query_id,time_data_query, positive_action) VALUES ( @id_ticket, GETDATE(), 'false')
					PRINT 'Czekam...'
					WAITFOR DELAY '00:00:02'
					PRINT 'Powtarzam działanie...'
				END
			END
		END
		ELSE
		BEGIN
			PRINT 'Tabela do wpisania danych tymczasowych do synchronizacji NIE istnieje...'
			PRINT 'Wpisuje nową tabele...'
				CREATE TABLE Table_Tem_Sys_data
				(
					id_sys_data INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
					new_ticket_query_id INT NOT NULL,
					time_data_query DATETIME NOT NULL
				)
		END

	END
	ELSE
	BEGIN
		PRINT 'Tabela Table_Tickets NIE instnieje'
		CREATE TABLE Table_Tickets(
			id_ticket INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
			id_trials INT NOT NULL,
			client_first_name CHAR(20) NOT NULL,
			client_surname CHAR(20) NOT NULL,
			client_birthday DATE NOT NULL,
			client_nationality CHAR(50) NOT NULL,
			id_bonusses_1 INT NOT NULL,
			id_bonusses_2 INT NOT NULL,
			id_bonusses_3 INT NOT NULL,
			id_bonusses_4 INT NOT NULL,
			id_promotion INT NOT NULL,
			total_cost FLOAT NOT NULL,
			time_bought DATETIME NOT NULL
		)
		PRINT 'Utworzono nową tabele Ticket!'
	END
END