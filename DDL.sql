CREATE SCHEMA dbcoursework;
SET search_path to dbcoursework,public;

/* Staff table */
CREATE TABLE Staff
(
StaffID		    INTEGER CHECK(staffid > 0),
Name            VARCHAR(40) NOT NULL,
PRIMARY KEY     (StaffID)
);

/* Product table */
CREATE TABLE Product
(
ProductID		INTEGER CHECK(productid > 0),
/*Unique names only */
Name			VARCHAR(40) NOT NULL UNIQUE,
PRIMARY KEY     (ProductID)
);

/* Customer table */
CREATE TABLE Customer
(
CustomerID		INTEGER CHECK(customerid > 0),
Name			VARCHAR(40) NOT NULL,
/*Unique emails only, in correct format */
Email			VARCHAR(40) NOT NULL UNIQUE CHECK(Email like '%_@__%.__%'),
PRIMARY KEY     (CustomerID)
);

/* Ticket table */
CREATE TABLE Ticket
(
TicketID		INTEGER CHECK(ticketid > 0),
Problem		    VARCHAR(1000) NOT NULL,
/*open and closed only accepted, no input defaults to open */
Status		    VARCHAR(20) NOT NULL CHECK(Status IN ('open','closed')) DEFAULT 'open',
/*1 2 3 only accepted, no input defaults to 3 */
Priority		INTEGER NOT NULL CHECK(Priority IN (1,2,3)) DEFAULT 3,
/*Timestamp format only 'YYYY-MM-DD HH:MM', no input defaults to current timestamp */
LoggedTime		TIMESTAMP NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP AS timestamp(0)),
CustomerID		INTEGER NOT NULL,
ProductID		INTEGER NOT NULL,
PRIMARY KEY     (TicketID),
FOREIGN KEY     (CustomerID) REFERENCES Customer(CustomerID),
FOREIGN KEY     (ProductID) REFERENCES Product(ProductID)
);

/* Ticket updates table */
CREATE TABLE TicketUpdate
(
TicketUpdateID	INTEGER CHECK(ticketupdateid > 0),
/*cant have an update without a message */
Message		    VARCHAR(1000) NOT NULL,
/*Timestamp format only 'YYYY-MM-DD HH:MM', no input defaults to current timestamp */
UpdateTime		TIMESTAMP NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP AS timestamp(0)),
TicketID		INTEGER NOT NULL,
StaffID         INTEGER,
PRIMARY KEY     (TicketUpdateID),
FOREIGN KEY     (TicketID) REFERENCES Ticket(TicketID),
FOREIGN KEY     (StaffID) REFERENCES Staff(StaffID)
);
/* Set timezone to UTC on server*/
SET timezone = '+00:00';

/* View that returns all open tickets*/
CREATE VIEW outstanding AS
	SELECT ticket.ticketid, ticket.problem, ticket.status, ticket.priority, ticket.loggedtime, customer.name AS CustomerName, product.name AS ProductName, (SELECT updatetime FROM ticketupdate WHERE ticket.ticketid = ticketupdate.ticketid LIMIT 1)
	FROM ticket
	INNER JOIN customer ON ticket.customerid = customer.customerid
	INNER JOIN product ON ticket.productid = product.productid
	WHERE ticket.status = 'open';

/* View that returns all closed tickets with their total amount of updates and time to first update + closing update */
CREATE VIEW closed_report AS
   SELECT ticket.ticketid, ticket.problem, ticket.status, ticket.priority,
   (SELECT count(*) AS count FROM dbcoursework.ticketupdate WHERE ticket.ticketid = ticketid) AS total_updates,
   (SELECT MIN(ticketupdate.updatetime) - ticket.loggedtime AS atime FROM dbcoursework.ticketupdate WHERE ticket.ticketid = ticketid LIMIT 1) AS first_response_time,
   (SELECT MAX(ticketupdate.updatetime) - ticket.loggedtime AS atime FROM dbcoursework.ticketupdate WHERE ticket.ticketid = ticketid) AS time_to_resolution
   FROM dbcoursework.ticket
   WHERE ticket.status = 'closed';

/* Function that closes a ticket specified */   
CREATE FUNCTION close_ticket(INTEGER)
RETURNS VARCHAR AS $$
UPDATE ticket
SET status = 'closed'
WHERE ticketid = $1;
SELECT status FROM ticket WHERE ticketid = $1; $$
LANGUAGE SQL;
