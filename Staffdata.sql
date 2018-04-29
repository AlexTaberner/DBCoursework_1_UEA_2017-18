SET search_path = dbcoursework, public;

INSERT INTO Staff(staffid,name)
    VALUES(15,'Alex Taberner');
INSERT INTO Staff(staffid,name)
    VALUES(1,'Jack Winter');
INSERT INTO Staff(staffid,name)
    VALUES(2,'Eugene Stoffer');
INSERT INTO Staff(staffid,name)
    VALUES(3,'Milo Barron');
INSERT INTO Staff(staffid,name)
    VALUES(4,'Jade Payne');
INSERT INTO Staff(staffid,name)
    VALUES(5,'Ryan Sweet');
INSERT INTO Staff(staffid,name)
    VALUES(6,'Jade Doughty');
INSERT INTO Staff(staffid,name)
    VALUES(7,'Rebecca Looks');
INSERT INTO Staff(staffid,name)
    VALUES(8,'Elsa Storm');
INSERT INTO Staff(staffid,name)
    VALUES(9,'Judy Hopps');
INSERT INTO Staff(staffid,name)
    VALUES(10,'Nick Wild');
INSERT INTO Staff(staffid,name)
    VALUES(11,'John Wick');
INSERT INTO Staff(staffid,name)
    VALUES(12,'Bruce Wayne');
INSERT INTO Staff(staffid,name)
    VALUES(13,'Johnathan Young');
INSERT INTO Staff(staffid,name)
    VALUES(14,'Shawn Delahunt');
    
    
INSERT INTO Product(productid,name)
    VALUES(7,'Operating systems');
INSERT INTO Product(productid,name)
    VALUES(1,'Office productivity suites');
INSERT INTO Product(productid,name)
    VALUES(2,'Games');
INSERT INTO Product(productid,name)
    VALUES(3,'Communications');
INSERT INTO Product(productid,name)
    VALUES(4,'Experimental products');
INSERT INTO Product(productid,name)
    VALUES(5,'Internet services');
INSERT INTO Product(productid,name)
    VALUES(6,'Cloud services');


INSERT INTO Customer(customerid,name,email)
    VALUES(1,'Joe Jones','joe@gmail.com');
INSERT INTO Customer(customerid,name,email)
    VALUES(2,'Jeff Bridges','crushinator2411@outlook.com');
INSERT INTO Customer(customerid,name,email)
    VALUES(3,'Rita Cosgrove','RitaFCosgrove@dayrep.com');
INSERT INTO Customer(customerid,name,email)
    VALUES(4,'Gavin A. Palmer','GavinAPalmer@teleworm.us');
INSERT INTO Customer(customerid,name,email)
    VALUES(5,'Theron J. Frisk','TheronJFrisk@jourrapide.com');
INSERT INTO Customer(customerid,name,email)
    VALUES(6,'Michele P. Espinoza','MichelePEspinoza@teleworm.us');
INSERT INTO Customer(customerid,name,email)
    VALUES(7,'Santiago K. Sims','SantiagoKSims@rhyta.com');
INSERT INTO Customer(customerid,name,email)
    VALUES(8,'Dorothy H. Archer','DorothyHArcher@rhyta.com');
INSERT INTO Customer(customerid,name,email)
    VALUES(9,'James E. Williams','JamesEWilliams@teleworm.us');
INSERT INTO Customer(customerid,name,email)
    VALUES(10,'Jacqueline T. Leak','JacquelineTLeak@rhyta.com');
INSERT INTO Customer(customerid,name,email)
    VALUES(11,'Gladys M. Farrell','GladysMFarrell@jourrapide.com');
INSERT INTO Customer(customerid,name,email)
    VALUES(12,'Nancy R. Dupre','NancyRDupre@armyspy.com');
INSERT INTO Customer(customerid,name,email)
    VALUES(13,'Anita C. Honeycutt','AnitaCHoneycutt@rhyta.com');
INSERT INTO Customer(customerid,name,email)
    VALUES(14,'Ronald R. Gonzalez','RonaldRGonzalez@teleworm.us');
INSERT INTO Customer(customerid,name,email)
    VALUES(15,'Mark D. Davis','MarkDDavis@dayrep.com');
INSERT INTO Customer(customerid,name,email)
    VALUES(16,'David J. Michalec','DavidJMichalec@rhyta.com');
    
    
INSERT INTO ticket(ticketid,problem,status,priority,customerid,productid)
    VALUES(1,'Computer running pear os is not booting, repair is not working','open',2,13,7);
INSERT INTO ticket(ticketid,problem,status,priority,loggedtime,customerid,productid)
    VALUES(2,'Can''t boot pc','open',2,'2018-01-25 15:42:22',6,6);
INSERT INTO ticket(ticketid,problem,status,priority,loggedtime,customerid,productid)
    VALUES(3,'won''t open document','open',2,'2018-02-14 13:14:17',12,6);
INSERT INTO ticket(ticketid,problem,status,priority,loggedtime,customerid,productid)
    VALUES(4,'no network connection','open',1,'2018-01-21 09:35:37',4,6);
INSERT INTO ticket(ticketid,problem,status,priority,loggedtime,customerid,productid)
    VALUES(5,'reset account password','closed',3,'2018-03-11 10:53:55',7,4);
    
    
INSERT INTO ticketupdate(ticketupdateid,message,updatetime,ticketid,staffid)
    Values(1,'The computer has been checked by the engineer in person, this ticket has been opened and we will investigate the issue.',
        '2018-01-25 15:42:23',2,15);
INSERT INTO ticketupdate(ticketupdateid,message,updatetime,ticketid)
    Values(2,'Can someone please update me on the progress???',
        '2018-01-27 12:36:21',2);
INSERT INTO ticketupdate(ticketupdateid,message,updatetime,ticketid,staffid)
    Values(3,'Ticket logged.',
        '2018-02-14 15:33:56',3,7);
INSERT INTO ticketupdate(ticketupdateid,message,updatetime,ticketid,staffid)
    Values(4,'major issue with cloud services connectivity, needs looking into ASAP!',
        '2018-01-21 09:35:38',4,3);
INSERT INTO ticketupdate(ticketupdateid,message,updatetime,ticketid,staffid)
    Values(5,'Recieved and reset, email sent to customer, resolving ticket.',
        '2018-03-11 15:42:23',5,1);