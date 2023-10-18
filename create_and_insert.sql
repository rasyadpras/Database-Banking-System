--DDL
CREATE TABLE users (
	user_id SERIAL PRIMARY KEY,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	citizenship VARCHAR NOT NULL,
	birth_date DATE NOT NULL
);

CREATE TABLE bank_account (
	account_id SERIAL PRIMARY KEY,
	user_id INTEGER NOT NULL,
	balance MONEY NOT NULL,
	currency VARCHAR(3) NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP,
	deleted_at TIMESTAMP
);

CREATE TABLE transactions (
	transaction_id SERIAL PRIMARY KEY,
	account_id INTEGER NOT NULL,
	transaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	deposit_amount MONEY,
	withdraw_amount MONEY
);

--DML

INSERT INTO users (user_id, first_name, last_name, citizenship, birth_date)
VALUES
	(1, 'Rasyad', 'Prasetyo', 'Indonesian', '1998-12-02'),
	(2, 'Raisa', 'Andriana', 'Indonesian', '1990-06-06'),
	(3, 'Charles', 'Puth', 'American', '1991-12-02'),
	(4, 'Adele', 'Adkins', 'British', '1988-05-05'),
	(5, 'Younghyun', 'Kang', 'Korean', '1993-12-19');
	
SELECT * FROM users ORDER BY user_id ASC;

INSERT INTO bank_account (account_id, user_id, balance, currency)
VALUES
	(1, 1, '1000', 'USD'),
	(2, 2, '5000', 'USD'),
	(3, 3, '50000', 'USD'),
	(4, 3, '10000', 'USD'),
	(5, 4, '200000', 'USD'),
	(6, 4, '13000', 'USD'),
	(7, 5, '500000', 'USD');
	
SELECT * FROM bank_account ORDER BY account_id ASC;

INSERT INTO transactions (transaction_id, account_id, deposit_amount, withdraw_amount)
VALUES
	(1, 1, '500', NULL),
	(2, 2, '300', NULL),
	(3, 2, NULL, '200'),
	(4, 5, NULL, '50000'),
	(5, 7, '100000', NULL);
	
SELECT * FROM transactions ORDER BY transaction_id ASC;

UPDATE bank_account SET balance = balance + '500' WHERE account_id = 1;
UPDATE bank_account SET updated_at = CURRENT_TIMESTAMP WHERE account_id = 1;

UPDATE bank_account
SET
	balance = balance + '300' - '200',
	updated_at = CURRENT_TIMESTAMP
WHERE account_id = 2;

UPDATE bank_account
SET
	balance = balance - '50000',
	updated_at = CURRENT_TIMESTAMP
WHERE account_id = 5;

UPDATE bank_account
SET
	balance = balance + '100000',
	updated_at = CURRENT_TIMESTAMP
WHERE account_id = 7;

INSERT INTO bank_account (account_id, user_id, balance, currency)
VALUES (8, 1, '0', 'USD');

DELETE FROM bank_account WHERE account_id = 8;

--Index

CREATE INDEX index_citizenship ON users (citizenship);

SELECT * FROM users WHERE citizenship = 'Indonesian';

--Stored Procedure
CREATE OR REPLACE PROCEDURE deposit (
	account INT,
	amount MONEY
)
LANGUAGE plpgsql    
AS $$
BEGIN
    UPDATE bank_account
    SET balance = balance + amount 
    WHERE account_id = account;
    commit;
end $$;

CALL deposit(1,'500');

--CTE
WITH user_balance AS (
	SELECT
		users.user_id,
		CONCAT(first_name, ' ', last_name) AS name ,
		citizenship,
		birth_date,
		balance,
		currency
	FROM users INNER JOIN bank_account ON users.user_id = bank_account.user_id
)
SELECT * FROM user_balance ORDER BY user_id ASC;