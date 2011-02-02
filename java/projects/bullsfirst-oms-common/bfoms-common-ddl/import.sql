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
insert into Instrument (id, version, symbol, name, exchange) values (1, 0, 'MMM', '3M Company', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (2, 0, 'AA', 'Alcoa Inc.', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (3, 0, 'AXP', 'American Express Company', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (4, 0, 'T', 'AT&T Inc.', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (5, 0, 'BAC', 'Bank of America Corporation', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (6, 0, 'BA', 'Boeing Company (The)', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (7, 0, 'CAT', 'Caterpillar, Inc.', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (8, 0, 'CVX', 'Chevron Corporation', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (9, 0, 'CSCO', 'Cisco Systems, Inc.', 'NASDAQ');
insert into Instrument (id, version, symbol, name, exchange) values (10, 0, 'KO', 'Coca-Cola Company (The)', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (11, 0, 'DD', 'E.I. du Pont de Nemours and Company', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (12, 0, 'XOM', 'Exxon Mobil Corporation', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (13, 0, 'GE', 'General Electric Company', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (14, 0, 'HPQ', 'Hewlett-Packard Company', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (15, 0, 'HD', 'Home Depot, Inc. (The)', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (16, 0, 'INTC', 'Intel Corporation', 'NASDAQ');
insert into Instrument (id, version, symbol, name, exchange) values (17, 0, 'IBM', 'International Business Machines Corporation', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (18, 0, 'JNJ', 'Johnson & Johnson', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (19, 0, 'JPM', 'J P Morgan Chase & Co', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (20, 0, 'KFT', 'Kraft Foods Inc.', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (21, 0, 'MCD', 'McDonald''s Corporation', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (22, 0, 'MRK', 'Merck & Company, Inc.', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (23, 0, 'MSFT', 'Microsoft Corporation', 'NASDAQ');
insert into Instrument (id, version, symbol, name, exchange) values (24, 0, 'PFE', 'Pfizer, Inc.', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (25, 0, 'PG', 'Procter & Gamble Company (The)', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (26, 0, 'TRV', 'The Travelers Companies, Inc.', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (27, 0, 'UTX', 'United Technologies Corporation', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (28, 0, 'VZ', 'Verizon Communications Inc.', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (29, 0, 'WMT', 'Wal-Mart Stores, Inc.', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (30, 0, 'DIS', 'Walt Disney Company (The)', 'NYSE');

-- Popular High-Tech Companies
insert into Instrument (id, version, symbol, name, exchange) values (31, 0, 'AAPL', 'Apple Inc.', 'NASDAQ');
insert into Instrument (id, version, symbol, name, exchange) values (32, 0, 'ADBE', 'Adobe Systems Incorporated', 'NASDAQ');
insert into Instrument (id, version, symbol, name, exchange) values (33, 0, 'AMD', 'Advanced Micro Devices, Inc.', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (34, 0, 'DELL', 'Dell Inc.', 'NASDAQ');
insert into Instrument (id, version, symbol, name, exchange) values (35, 0, 'EBAY', 'eBay Inc.', 'NASDAQ');
insert into Instrument (id, version, symbol, name, exchange) values (36, 0, 'GOOG', 'Google Inc.', 'NASDAQ');
insert into Instrument (id, version, symbol, name, exchange) values (37, 0, 'JAVA', 'Sun Microsystems, Inc.', 'NASDAQ');
insert into Instrument (id, version, symbol, name, exchange) values (38, 0, 'MOT', 'Motorola, Inc.', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (39, 0, 'NOK', 'Nokia Corporation', 'NYSE');
insert into Instrument (id, version, symbol, name, exchange) values (40, 0, 'SNE', 'Sony Corp Ord', 'NYSE');
