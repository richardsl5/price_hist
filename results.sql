# create the empty table to store the results
# No foreign keys as does not reference other tables
use crypto;

DROP TABLE IF EXISTS results;

CREATE TABLE results (
	row_id		INT			PRIMARY KEY,
	id			VARCHAR(20)	NOT NULL,
	name		VARCHAR(20)	NOT NULL,
	ticker		VARCHAR(6)	NOT NULL,
	rank		INT			NOT NULL,
	price_usd	REAL		NOT NULL,
	qty			REAL		NOT NULL,
	value_usd	REAL		NOT NULL,
	buy_price	REAL		NOT NULL,
	change_pct	REAL		NOT NULL,
	change_usd	REAL		NOT NULL,
	change_1h	REAL		NOT NULL,
	change_24h	REAL		NOT NULL,
	change_7d	REAL		NOT NULL,
	buy_date	DATE		NOT NULL
);


