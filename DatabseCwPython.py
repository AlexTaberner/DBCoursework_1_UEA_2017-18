from flask import Flask, render_template, request
import psycopg2
import psycopg2.extras

app = Flask(__name__)

#sets up connection
def getConn():
    connFile = open("connection.txt", "r")
    connStr = connFile.read();
    connFile.close()
    #connStr = "host='localhost' dbname= 'postgres' user='postgres' password = 'password'"
    conn = psycopg2.connect(connStr)          
    return conn

#runs query and returns query status
def runQueryStatus(query):
    conn = getConn()
    cur = conn.cursor()
    cur.execute('SET search_path to dbcoursework,public;')
    cur.execute(query)
    conn.commit()
    return cur.statusmessage
    
#runs query and returns query data (rows)
def runQueryRows(query):
    conn = getConn()
    cur = conn.cursor()
    cur.execute('SET search_path to dbcoursework,public;')
    cur.execute(query)
    conn.commit()
    return cur.fetchall()

#Homepage
@app.route('/')
@app.route('/index')
def index():
    return render_template('index.html')
    
#Newcustomer query
@app.route('/newcustomer', methods=['post'])
def newcustomer():
    conn = None
    try:
        #build query string
        query = "INSERT INTO Customer(customerid,name,email) VALUES(%s,'%s','%s');" % (request.form['id'], request.form['name'], request.form['email'])
        
        #return result string
        status = runQueryStatus(query)
        result = ""
        if status :
            result = "customer: %s has been added to the DB" % (request.form['name'])

        #process into error or success page
        return render_template('index.html', result=result)
    except Exception as e:
        print(e)
        return render_template('index.html', error=e)
    finally:
        if conn:
            conn.close()
    return render_template('index.html')
    
#update staff query
@app.route('/updatestaff', methods=['post'])
def updatestaff():
    conn = None
    try:
        #build query string
        query = "INSERT INTO ticketupdate(ticketupdateid,message,ticketid,staffid) Values(%s,'%s',%s,%s);" % (request.form['updateid'], request.form['message'], request.form['ticketid'], request.form['staffid'])
        
        #return result string
        status = runQueryStatus(query)
        result = ""
        if status :
            result = "Ticket: %s has been updated" % (request.form['ticketid'])

        #process into error or success page
        return render_template('index.html', result=result)
    except Exception as e:
        print(e)
        return render_template('index.html', error=e)
    finally:
        if conn:
            conn.close()
    return render_template('index.html')

#outstanding report query
@app.route('/outstanding', methods=['post'])
def outstanding():
    conn = None
    try:
        #build query string
        query = "SELECT * FROM dbcoursework.outstanding"
        
        #return result string
        rows = runQueryRows(query)
        
        #process into error or success page
        return render_template('outstanding.html', rows=rows)
    except Exception as e:
        return render_template('index.html', error=e)
    finally:
        if conn:
            conn.close()
    return render_template('index.html')
    
#new ticket query
@app.route('/newticket', methods=['post'])
def newticket():
    conn = None
    try:
        query = ''
        #build query string
        if request.form['datetime'] == '':
            query = "INSERT INTO ticket(ticketid,problem,status,priority,customerid,productid) VALUES(%s,'%s','%s',%s,%s,%s);" % (request.form['ticketid'], request.form['problem'], request.form['status'], request.form['priority'], request.form['customerid'], request.form['productid'])
        else:
            query = "INSERT INTO ticket(ticketid,problem,status,priority,loggedtime,customerid,productid) VALUES(%s,'%s','%s',%s,'%s',%s,%s);" % (request.form['ticketid'], request.form['problem'], request.form['status'], request.form['priority'], request.form['datetime'], request.form['customerid'], request.form['productid'])
        
        #return result string
        status = runQueryStatus(query)
        result = ""
        if status :
            result = "ticket: %s has been added to the DB" % (request.form['ticketid'])
        
        #process into error or success page
        return render_template('index.html', result=result)
    except Exception as e:
        print(e)
        return render_template('index.html', error=e)
    finally:
        if conn:
            conn.close()
    return render_template('index.html')
    
#close ticket query
@app.route('/closeticket', methods=['post'])
def closeticket():
    conn = None
    try:
        #build query string
        query = "SELECT * FROM close_ticket(%s)" % (request.form['ticketid'])
        
        #return result string
        result = ""
        rows = runQueryRows(query)
        if rows[0][0] == 'closed' :
            result = "Ticket: %s has been closed" % (request.form['ticketid'])
        else:
            result = "Ticket: %s has not been closed - Either does not exsist or unable to close yet" % (request.form['ticketid'])

        #process into error or success page
        return render_template('index.html', result=result)
    except Exception as e:
        print(e)
        return render_template('index.html', error=e)
    finally:
        if conn:
            conn.close()
    return render_template('index.html')
    
#list all updates for a ticket query
@app.route('/listupdate', methods=['post'])
def listupdate():
    conn = None
    try:
        #build query string
        query = "SELECT ticketupdate.ticketupdateid, ticket.problem, ticketupdate.message, staff.name, ticketupdate.updatetime FROM ticket INNER JOIN ticketupdate ON ticket.ticketid = ticketupdate.ticketid LEFT JOIN staff ON ticketupdate.staffid = staff.staffid WHERE ticket.ticketid = %s ORDER BY ticketupdate.updatetime" % (request.form["ticketid"])
        
        #return results
        rows = runQueryRows(query)

        #process into error or success page
        return render_template('updates.html', rows=rows)
    except Exception as e:
        print(e)
        return render_template('index.html', error=e)
    finally:
        if conn:
            conn.close()
    return render_template('index.html')
    
#all closed tickets report
@app.route('/closedreport', methods=['post'])
def closedreport():
    conn = None
    try:
        #build query string
        query = "SELECT * FROM dbcoursework.closed_report"
        
        #return result string
        rows = runQueryRows(query)
        
        #process into error or success page
        return render_template('closedreport.html', rows=rows)
    except Exception as e:
        return render_template('index.html', error=e)
    finally:
        if conn:
            conn.close()
    return render_template('index.html')
    
#delete a customer query
@app.route('/deletecustomer', methods=['post'])
def deletecustomer():
    conn = None
    try:
        #build query string
        query = "DELETE FROM customer WHERE customer.CustomerID = %s AND NOT EXISTS(SELECT ticket.ticketid FROM Ticket WHERE Ticket.CustomerID = %s)" % (request.form['customerid'], request.form['customerid'])
        
        #return result string
        status = runQueryStatus(query)
        result = ""
        if status == "DELETE 0" :
            result = "customer: %s has not been deleted from the DB - Customer still has tickets associated with them." % (request.form['customerid'])
        else:
            result = "customer: %s has been deleted from the DB" % (request.form['customerid'])
        #process into error or success page
        return render_template('index.html', result=result)
    except Exception as e:
        print(e)
        return render_template('index.html', error=e)
    finally:
        if conn:
            conn.close()
    return render_template('index.html')
    
if __name__=='__main__' :
    app.run(debug=True)