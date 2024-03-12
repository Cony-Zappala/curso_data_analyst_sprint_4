##NIVEL 1:
#ejercicio 1:

SELECT user.id, user.name, user.surname, COUNT(transactions.id)
FROM sprint4.user
JOIN sprint4.transactions
ON user.id = transactions.user_id
GROUP BY user.id, user.name, user.surname
HAVING COUNT(transactions.id) > 30;

#ejercicio 2:
SELECT 
    AVG(sum_amount) AS average_transaction_sum, company_name 
FROM (
    SELECT SUM(transactions.amount) AS sum_amount, companies.company_name, credit_card.iban
    FROM sprint4.transactions  
	JOIN sprint4.companies 
    ON transactions.business_id = companies.company_id
	JOIN sprint4.credit_card 
    ON credit_card.id = transactions.card_id
    WHERE companies.company_name = 'Donec Ltd'
    GROUP BY companies.company_name, credit_card.iban
) AS subquery
GROUP BY company_name;

##NIVEL 2:
#creación de tabla:

CREATE TABLE IF NOT EXISTS estado_tarj AS (
WITH trans_card AS
#ES COMO LLAMAR A LA TABLA QUE ESTOY CREANDO (buscar video de COMMON TABLE EXPRESSION)
(SELECT transactions.card_id, transactions.timestamp, transactions.declined,
ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS row_num    
FROM transactions)
SELECT trans_card.card_id, 
	CASE 
		WHEN SUM(trans_card.declined)<=2 THEN 'ACTIVA'         
		ELSE 'INACTIVA'     
	END AS estado_tarjeta 
                    FROM trans_card 
                    WHERE row_num <= 3 
                    GROUP BY card_id
	)
    ;

WITH trans_card AS
(SELECT transactions.card_id, transactions.timestamp, transactions.declined,
ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS row_num    
FROM transactions)
SELECT trans_card.card_id, 
	CASE 
		WHEN SUM(trans_card.declined)<=2 THEN 'ACTIVA'         
		ELSE 'INACTIVA'     
	END AS estado_tarjeta 
                    FROM trans_card 
                    WHERE row_num <= 3 
                    GROUP BY card_id
                    HAVING COUNT(trans_card.card_id) = 3
    ;


