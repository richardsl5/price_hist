
use crypto;
# Cut down SQL script to reload the data but not delete the price history

# Clean up the old tables
DROP TABLE IF EXISTS buy_history ;
DROP TABLE IF EXISTS currency ;

CREATE TABLE currency (
	ticker	VARCHAR(6)	PRIMARY KEY,
	name	VARCHAR(20)	NOT NULL,
	id		VARCHAR(20) NOT NULL
);

CREATE TABLE buy_history(
	id		INTEGER	PRIMARY KEY,
	ticker	VARCHAR(6)	NOT NULL,
	qty		REAL	NOT NULL,
	price	REAL	NOT NULL,
	buydate	DATE	NOT NULL,
	FOREIGN KEY (ticker) REFERENCES currency(ticker)
);

#Load data
LOAD DATA LOCAL INFILE 'currency.dat' INTO TABLE currency;
LOAD DATA LOCAL INFILE 'buy_history.dat' INTO TABLE buy_history;

