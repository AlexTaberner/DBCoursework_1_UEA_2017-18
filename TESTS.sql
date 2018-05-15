1)
INSERT INTO Customer(customerid,name,email)
    VALUES([unique ID],[Name],[email]);

2)    
INSERT INTO ticket(ticketid,problem,status,priority,loggedtime,customerid,productid)
    VALUES([unique id],[description],[status (open, closed)],[priority (1,2,3)],[TIMESTAMP '2018-03-11 10:53:55'],[Customer's id],[Product's id]);
    
3)
INSERT INTO ticketupdate(ticketupdateid,message,ticketid,staffid)
    Values([unique id],[message],[ticket id],[staff id]);
    
4)
SELECT ticket.ticketid, ticket.problem, ticket.status, ticket.priority, ticket.loggedtime, customer.name, product.name, 
    (SELECT updatetime FROM ticketupdate WHERE ticket.ticketid = ticketupdate.ticketid LIMIT 1)
FROM ticket
INNER JOIN customer ON ticket.customerid = customer.customerid
INNER JOIN product ON ticket.productid = product.productid
WHERE ticket.status = 'open'

5)
UPDATE ticket
SET status = 'closed'
WHERE ticketid = [ticketid]

6)
SELECT ticketupdate.ticketupdateid, ticket.problem, ticketupdate.message, staff.name, ticketupdate.updatetime
FROM ticket
INNER JOIN ticketupdate ON ticket.ticketid = ticketupdate.ticketid
LEFT JOIN staff ON ticketupdate.staffid = staff.staffid
WHERE ticket.ticketid = 2
ORDER BY ticketupdate.updatetime

7)
SELECT ticket.ticketid, ticket.problem, ticket.status, ticket.priority,
(SELECT count(*) AS count FROM dbcoursework.ticketupdate WHERE ticket.ticketid = ticketid) AS total_updates,
(SELECT MIN(ticketupdate.updatetime) - ticket.loggedtime AS atime FROM dbcoursework.ticketupdate WHERE ticket.ticketid = ticketid LIMIT 1) AS first_response_time,
(SELECT MAX(ticketupdate.updatetime) - ticket.loggedtime AS atime FROM dbcoursework.ticketupdate WHERE ticket.ticketid = ticketid) AS time_to_resolution
FROM dbcoursework.ticket
WHERE ticket.status = 'closed';

8)
DELETE FROM customer
WHERE customer.CustomerID = [cust id]
AND NOT EXISTS(SELECT ticket.ticketid FROM Ticket WHERE Ticket.CustomerID = [cust id])
