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
