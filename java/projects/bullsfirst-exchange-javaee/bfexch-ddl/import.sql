-- -----------------------------------------------------------------------------
-- Caution: Do not split statements on multiple lines - Seam cannot parse them.
-- Backslash as a line continuation character doesn't work either.
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Instruments
-- -----------------------------------------------------------------------------
-- Companies included in the Dow Jones Industrial Average
insert into Instrument (symbol, name, exchange) values ('MMM',  '3M Company',                                  'NYSE');
insert into Instrument (symbol, name, exchange) values ('AA',   'Alcoa Inc.',                                  'NYSE');
insert into Instrument (symbol, name, exchange) values ('AXP',  'American Express Company',                    'NYSE');
insert into Instrument (symbol, name, exchange) values ('T',    'AT&T Inc.',                                   'NYSE');
insert into Instrument (symbol, name, exchange) values ('BAC',  'Bank of America Corporation',                 'NYSE');
insert into Instrument (symbol, name, exchange) values ('BA',   'Boeing Company (The)',                        'NYSE');
insert into Instrument (symbol, name, exchange) values ('CAT',  'Caterpillar, Inc.',                           'NYSE');
insert into Instrument (symbol, name, exchange) values ('CVX',  'Chevron Corporation',                         'NYSE');
insert into Instrument (symbol, name, exchange) values ('CSCO', 'Cisco Systems, Inc.',                         'NASDAQ');
insert into Instrument (symbol, name, exchange) values ('KO',   'Coca-Cola Company (The)',                     'NYSE');
insert into Instrument (symbol, name, exchange) values ('DD',   'E.I. du Pont de Nemours and Company',         'NYSE');
insert into Instrument (symbol, name, exchange) values ('XOM',  'Exxon Mobil Corporation',                     'NYSE');
insert into Instrument (symbol, name, exchange) values ('GE',   'General Electric Company',                    'NYSE');
insert into Instrument (symbol, name, exchange) values ('HPQ',  'Hewlett-Packard Company',                     'NYSE');
insert into Instrument (symbol, name, exchange) values ('HD',   'Home Depot, Inc. (The)',                      'NYSE');
insert into Instrument (symbol, name, exchange) values ('INTC', 'Intel Corporation',                           'NASDAQ');
insert into Instrument (symbol, name, exchange) values ('IBM',  'International Business Machines Corporation', 'NYSE');
insert into Instrument (symbol, name, exchange) values ('JNJ',  'Johnson & Johnson',                           'NYSE');
insert into Instrument (symbol, name, exchange) values ('JPM',  'J P Morgan Chase & Co',                       'NYSE');
insert into Instrument (symbol, name, exchange) values ('KFT',  'Kraft Foods Inc.',                            'NYSE');
insert into Instrument (symbol, name, exchange) values ('MCD',  'McDonald''s Corporation',                     'NYSE');
insert into Instrument (symbol, name, exchange) values ('MRK',  'Merck & Company, Inc.',                       'NYSE');
insert into Instrument (symbol, name, exchange) values ('MSFT', 'Microsoft Corporation',                       'NASDAQ');
insert into Instrument (symbol, name, exchange) values ('PFE',  'Pfizer, Inc.',                                'NYSE');
insert into Instrument (symbol, name, exchange) values ('PG',   'Procter & Gamble Company (The)',              'NYSE');
insert into Instrument (symbol, name, exchange) values ('TRV',  'The Travelers Companies, Inc.',               'NYSE');
insert into Instrument (symbol, name, exchange) values ('UTX',  'United Technologies Corporation',             'NYSE');
insert into Instrument (symbol, name, exchange) values ('VZ',   'Verizon Communications Inc.',                 'NYSE');
insert into Instrument (symbol, name, exchange) values ('WMT',  'Wal-Mart Stores, Inc.',                       'NYSE');
insert into Instrument (symbol, name, exchange) values ('DIS',  'Walt Disney Company (The)',                   'NYSE');

-- Popular High-Tech Companies
insert into Instrument (symbol, name, exchange) values ('AAPL', 'Apple Inc.',                                  'NASDAQ');
insert into Instrument (symbol, name, exchange) values ('ADBE', 'Adobe Systems Incorporated',                  'NASDAQ');
insert into Instrument (symbol, name, exchange) values ('AMD', 'Advanced Micro Devices, Inc.',                 'NYSE');
insert into Instrument (symbol, name, exchange) values ('DELL', 'Dell Inc.',                                   'NASDAQ');
insert into Instrument (symbol, name, exchange) values ('EBAY', 'eBay Inc.',                                   'NASDAQ');
insert into Instrument (symbol, name, exchange) values ('GOOG', 'Google Inc.',                                 'NASDAQ');
insert into Instrument (symbol, name, exchange) values ('JAVA', 'Sun Microsystems, Inc.',                      'NASDAQ');
insert into Instrument (symbol, name, exchange) values ('MOT', 'Motorola, Inc.',                               'NYSE');
insert into Instrument (symbol, name, exchange) values ('NOK', 'Nokia Corporation',                            'NYSE');
insert into Instrument (symbol, name, exchange) values ('SNE', 'Sony Corp Ord',                                'NYSE');

-- -----------------------------------------------------------------------------
-- MarketPrice
-- -----------------------------------------------------------------------------
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('MMM',  '2009-09-01 09:00:00',  71.81, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('AA',   '2009-09-01 09:00:00',  12.05, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('AXP',  '2009-09-01 09:00:00',  33.58, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('T',    '2009-09-01 09:00:00',  25.95, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('BAC',  '2009-09-01 09:00:00',  17.70, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('BA',   '2009-09-01 09:00:00',  49.21, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('CAT',  '2009-09-01 09:00:00',  44.90, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('CVX',  '2009-09-01 09:00:00',  69.69, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('CSCO', '2009-09-01 09:00:00',  21.46, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('KO',   '2009-09-01 09:00:00',  48.72, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('DD',   '2009-09-01 09:00:00',  31.80, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('XOM',  '2009-09-01 09:00:00',  68.93, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('GE',   '2009-09-01 09:00:00',  13.74, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('HPQ',  '2009-09-01 09:00:00',  44.64, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('HD',   '2009-09-01 09:00:00',  27.01, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('INTC', '2009-09-01 09:00:00',  20.22, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('IBM',  '2009-09-01 09:00:00', 117.67, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('JNJ',  '2009-09-01 09:00:00',  60.35, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('JPM',  '2009-09-01 09:00:00',  43.08, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('KFT',  '2009-09-01 09:00:00',  28.44, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('MCD',  '2009-09-01 09:00:00',  56.05, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('MRK',  '2009-09-01 09:00:00',  32.29, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('MSFT', '2009-09-01 09:00:00',  24.35, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('PFE',  '2009-09-01 09:00:00',  16.54, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('PG',   '2009-09-01 09:00:00',  53.85, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('TRV',  '2009-09-01 09:00:00',  50.13, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('UTX',  '2009-09-01 09:00:00',  59.35, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('VZ',   '2009-09-01 09:00:00',  30.87, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('WMT',  '2009-09-01 09:00:00',  50.81, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('DIS',  '2009-09-01 09:00:00',  25.89, 'USD');

insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('AAPL','2009-09-01 09:00:00', 167.99, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('ADBE','2009-09-01 09:00:00',  31.27, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('AMD', '2009-09-01 09:00:00',   4.36, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('DELL','2009-09-01 09:00:00',  15.72, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('EBAY','2009-09-01 09:00:00',  22.14, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('GOOG','2009-09-01 09:00:00', 459.68, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('JAVA','2009-09-01 09:00:00',   9.29, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('MOT', '2009-09-01 09:00:00',   7.36, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('NOK', '2009-09-01 09:00:00',  13.61, 'USD');
insert into MarketPrice (symbol, effective, price_amount, price_currency) values ('SNE', '2009-09-01 09:00:00',  26.60, 'USD');
