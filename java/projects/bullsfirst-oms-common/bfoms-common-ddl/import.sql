-- -----------------------------------------------------------------------------
-- Caution: Do not split statements on multiple lines - Seam cannot parse them.
-- Backslash as a line continuation character doesn't work either.
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Parties
-- -----------------------------------------------------------------------------
insert into Party (id, version) values (1, 0);
insert into Party (id, version) values (2, 0);
insert into Party (id, version) values (3, 0);

insert into Person (id, firstName, lastName) values (1, 'John', 'Horner');
insert into Person (id, firstName, lastName) values (2, 'Karen', 'Horner');
insert into Person (id, firstName, lastName) values (3, 'Jack', 'Horner');

-- -----------------------------------------------------------------------------
-- Users
-- -----------------------------------------------------------------------------
insert into Users (id, version, username, passwordHash, person_id) values (1, 0, 'jhorner', 'bDUBbzggM5St3G4xCJBX3w==', 1);
insert into Users (id, version, username, passwordHash, person_id) values (2, 0, 'khorner', 'h4zxG34UOEqumJf1l7ti3Q==', 2);

-- -----------------------------------------------------------------------------
-- Instruments
-- -----------------------------------------------------------------------------
-- Companies included in the Dow Jones Industrial Average
insert into Instrument (symbol, name, exchange) values ('MMM', '3M Company', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('AA', 'Alcoa Inc.', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('AXP', 'American Express Company', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('T', 'AT&T Inc.', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('BAC', 'Bank of America Corporation', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('BA', 'Boeing Company (The)', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('CAT', 'Caterpillar, Inc.', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('CVX', 'Chevron Corporation', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('CSCO', 'Cisco Systems, Inc.', 'NASDAQ');
insert into Instrument (symbol, name, exchange) values ('KO', 'Coca-Cola Company (The)', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('DD', 'E.I. du Pont de Nemours and Company', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('XOM', 'Exxon Mobil Corporation', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('GE', 'General Electric Company', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('HPQ', 'Hewlett-Packard Company', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('HD', 'Home Depot, Inc. (The)', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('INTC', 'Intel Corporation', 'NASDAQ');
insert into Instrument (symbol, name, exchange) values ('IBM', 'International Business Machines Corporation', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('JNJ', 'Johnson & Johnson', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('JPM', 'J P Morgan Chase & Co', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('KFT', 'Kraft Foods Inc.', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('MCD', 'McDonald''s Corporation', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('MRK', 'Merck & Company, Inc.', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('MSFT', 'Microsoft Corporation', 'NASDAQ');
insert into Instrument (symbol, name, exchange) values ('PFE', 'Pfizer, Inc.', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('PG', 'Procter & Gamble Company (The)', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('TRV', 'The Travelers Companies, Inc.', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('UTX', 'United Technologies Corporation', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('VZ', 'Verizon Communications Inc.', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('WMT', 'Wal-Mart Stores, Inc.', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('DIS', 'Walt Disney Company (The)', 'NYSE');

-- Popular High-Tech Companies
insert into Instrument (symbol, name, exchange) values ('AAPL', 'Apple Inc.', 'NASDAQ');
insert into Instrument (symbol, name, exchange) values ('ADBE', 'Adobe Systems Incorporated', 'NASDAQ');
insert into Instrument (symbol, name, exchange) values ('AMD', 'Advanced Micro Devices, Inc.', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('DELL', 'Dell Inc.', 'NASDAQ');
insert into Instrument (symbol, name, exchange) values ('EBAY', 'eBay Inc.', 'NASDAQ');
insert into Instrument (symbol, name, exchange) values ('GOOG', 'Google Inc.', 'NASDAQ');
insert into Instrument (symbol, name, exchange) values ('JAVA', 'Sun Microsystems, Inc.', 'NASDAQ');
insert into Instrument (symbol, name, exchange) values ('MOT', 'Motorola, Inc.', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('NOK', 'Nokia Corporation', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('SNE', 'Sony Corp Ord', 'NYSE');
