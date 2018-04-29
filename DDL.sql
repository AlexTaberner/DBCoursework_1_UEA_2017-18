CREATE SCHEMA dbcoursework;
SET search_path to dbcoursework,public;

CREATE TABLE Staff
(
StaffID		    INTEGER CHECK(staffid > 0),
Name            VARCHAR(70) NOT NULL,
PRIMARY KEY     (StaffID)
);

CREATE TABLE Product
(
ProductID		INTEGER CHECK(productid > 0),
Name			VARCHAR(100) NOT NULL UNIQUE,
PRIMARY KEY     (ProductID)
);

CREATE TABLE Customer
(
CustomerID		INTEGER CHECK(customerid > 0),
Name			VARCHAR(70) NOT NULL,
Email			VARCHAR(200) NOT NULL UNIQUE CHECK(Email like '%_@__%.__%'),
PRIMARY KEY     (CustomerID)
);

CREATE TABLE Ticket
(
TicketID		INTEGER CHECK(ticketid > 0),
Problem		    VARCHAR(2000) NOT NULL,
Status		    VARCHAR(6) NOT NULL CHECK(Status IN ('open','closed')) DEFAULT 'open',
Priority		INTEGER NOT NULL CHECK(Priority IN (1,2,3)) DEFAULT 3,
LoggedTime		TIMESTAMP NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP AS timestamp(0)),
CustomerID		INTEGER NOT NULL,
ProductID		INTEGER NOT NULL,
PRIMARY KEY     (TicketID),
FOREIGN KEY     (CustomerID) REFERENCES Customer(CustomerID),
FOREIGN KEY     (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE TicketUpdate
(
TicketUpdateID	INTEGER CHECK(ticketupdateid > 0),
Message		    VARCHAR(2000) NOT NULL,
UpdateTime		TIMESTAMP NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP AS timestamp(0)),
TicketID		INTEGER NOT NULL,
StaffID         INTEGER,
PRIMARY KEY     (TicketUpdateID),
FOREIGN KEY     (TicketID) REFERENCES Ticket(TicketID),
FOREIGN KEY     (StaffID) REFERENCES Staff(StaffID)
);	

SET timezone = '+00:00';