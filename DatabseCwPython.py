from flask import Flask, render_template, request
import psycopg2
import psycopg2.extras

app = Flask(__name__)
def getConn():
    connFile = open("connection.txt", "r")
    connStr = connFile.read();
    connFile.close()
    #connStr = "host='localhost' dbname= 'postgres' user='postgres' password = 'password'"
    conn = psycopg2.connect(connStr)          
    return conn

@app.route('/')
@app.route('/index')
def index():
    return render_template('index.html')
    
@app.route('/newcustomer', methods=['post'])
def newcustomer():
    conn = None
    try:
        #build query string
        query = "INSERT INTO Customer(customerid,name,email) VALUES(%s,'%s','%s');" % (request.form['id'], request.form['name'], request.form['email'])
        
        #setup connection
        conn = getConn()
        cur = conn.cursor()
        cur.execute('SET search_path to dbcoursework,public;')
        
        #fire command
        cur.execute(query)
        conn.commit()
        
        #return result string
        status = cur.statusmessage
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
    
@app.route('/updatestaff', methods=['post'])
def updatestaff():
    conn = None
    try:
        #build query string
        query = "INSERT INTO ticketupdate(ticketupdateid,message,ticketid,staffid) Values(%s,'%s',%s,%s);" % (request.form['updateid'], request.form['message'], request.form['ticketid'], request.form['staffid'])
        
        #setup connection
        conn = getConn()
        cur = conn.cursor()
        cur.execute('SET search_path to dbcoursework,public;')
        
        #fire command
        cur.execute(query)
        conn.commit()
        
        #return result string
        status = cur.statusmessage
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

@app.route('/outstanding', methods=['post'])
def outstanding():
    conn = None
    try:
        #build query string
        query = "SELECT ticket.ticketid, ticket.problem, ticket.status, ticket.priority, ticket.loggedtime, customer.name, product.name, (SELECT updatetime FROM ticketupdate WHERE ticket.ticketid = ticketupdate.ticketid LIMIT 1) FROM ticket INNER JOIN customer ON ticket.customerid = customer.customerid INNER JOIN product ON ticket.productid = product.productid"
        
        #setup connection
        conn = getConn()
        cur = conn.cursor()
        cur.execute('SET search_path to dbcoursework,public;')
        
        #fire command
        cur.execute(query)
        conn.commit()
        
        #return result string
        rows = cur.fetchall()
        
        #process into error or success page
        return render_template('outstanding.html', rows=rows)
    except Exception as e:
        return render_template('index.html', error=e)
    finally:
        if conn:
            conn.close()
    return render_template('index.html')
    
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
        #setup connection
        conn = getConn()
        cur = conn.cursor()
        cur.execute('SET search_path to dbcoursework,public;')
        
        #fire command
        cur.execute(query)
        conn.commit()
        
        #return result string
        status = cur.statusmessage
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
    
@app.route('/closeticket', methods=['post'])
def closeticket():
    conn = None
    try:
        #build query string
        query = "UPDATE ticket SET status = 'closed' WHERE ticketid = %s" % (request.form['ticketid'])
        
        #setup connection
        conn = getConn()
        cur = conn.cursor()
        cur.execute('SET search_path to dbcoursework,public;')
        
        #fire command
        cur.execute(query)
        conn.commit()
        
        #return result string
        status = cur.statusmessage
        result = ""
        if status :
            result = "Ticket: %s has been closed" % (request.form['ticketid'])

        #process into error or success page
        return render_template('index.html', result=result)
    except Exception as e:
        print(e)
        return render_template('index.html', error=e)
    finally:
        if conn:
            conn.close()
    return render_template('index.html')
    
@app.route('/listupdate', methods=['post'])
def listupdate():
    conn = None
    try:
        #build query string
        query = "SELECT ticketupdate.ticketupdateid, ticket.problem, ticketupdate.message, staff.name, ticketupdate.updatetime FROM ticket INNER JOIN ticketupdate ON ticket.ticketid = ticketupdate.ticketid LEFT JOIN staff ON ticketupdate.staffid = staff.staffid WHERE ticket.ticketid = %s ORDER BY ticketupdate.updatetime" % (request.form["ticketid"])
        
        #setup connection
        conn = getConn()
        cur = conn.cursor()
        cur.execute('SET search_path to dbcoursework,public;')
        
        #fire command
        cur.execute(query)
        conn.commit()
        
        #return results
        rows = cur.fetchall()

        #process into error or success page
        return render_template('updates.html', rows=rows)
    except Exception as e:
        print(e)
        return render_template('index.html', error=e)
    finally:
        if conn:
            conn.close()
    return render_template('index.html')
    
@app.route('/deletecustomer', methods=['post'])
def deletecustomer():
    conn = None
    try:
        #build query string
        query = """DELETE FROM customer WHERE customer.CustomerID = %s AND NOT EXISTS(SELECT ticket.ticketid FROM Ticket WHERE Ticket.CustomerID = %s)""" % (request.form['customerid'], request.form['customerid'])
        
        #setup connection
        conn = getConn()
        cur = conn.cursor()
        cur.execute('SET search_path to dbcoursework,public;')
        
        #fire command
        cur.execute(query)
        conn.commit()
        
        #return result string
        status = cur.statusmessage
        result = ""
        if status == "DELETE 0" :
            result = "customer: %s has not been deleted from the DB - Customer has tickets still open" % (request.form['customerid'])
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