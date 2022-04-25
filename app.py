import sqlite3
from flask import Flask, session, render_template, redirect, url_for, request
from datetime import date

app = Flask('app')
app.secret_key = "leo-phan"

db_fname = "store.db"
home_fname = "home.html"
login_fname = "login.html"
about_fname = "about.html"
product_fname = "product.html" 


@app.route('/', methods=['GET', 'POST'])
def home(search_list = None):

    user_data = None
    if 'user' in session:
        user_data = session['user']

    if(search_list != None):
        return render_template(home_fname,products = search_list, user = user_data)

    # connect to the database
    connection = sqlite3.connect(db_fname);
    connection.row_factory = sqlite3.Row;
    cursor = connection.cursor();
    
    # retrieve database
    data = cursor.execute("SELECT * FROM product ORDER BY ticker;")
    products = data.fetchall();

    # get signal from html forms
    if request.method == 'POST':
        print("POST!");
        # ticker = request.form[]

    return render_template(home_fname,products = products, user = user_data)
    
@app.route('/ticker/<ticker>', methods=['GET', 'POST'])
def product(ticker):
    user_data = None
    if 'user' in session:
        user_data = session['user']
    
    cart_data = None
    if 'cart' in session:
        cart_data = session['cart']

    print('cart 2', cart_data)
    connection = sqlite3.connect(db_fname);
    connection.row_factory = sqlite3.Row;
    cursor = connection.cursor();
    query = cursor.execute("SELECT * FROM product WHERE ticker = (?);",(ticker,))
    ticker_data = query.fetchall()
    connection.close()
    return render_template(product_fname,product = ticker_data[0], user = user_data, cart = cart_data);

@app.route('/tab/<tab>', methods=['GET', 'POST'])
def nav(tab):
    if tab == 'home':
        return redirect('/');
    elif tab == 'login':
        return redirect('/login');
    elif tab == 'about':
        return redirect('/about');
    elif tab == 'history':
        return redirect('/history')
    else:
        return redirect('/');

@app.route('/about', methods=['GET', 'POST'])
def about():

    user_data = None
    if 'user' in session:
        user_data = session['user']

    return render_template(about_fname, user = user_data)

@app.route('/home')
def goto_home():
    return redirect('/')

@app.route('/search', methods=['GET', 'POST'])
def search():
    if request.method == 'POST':
        connection = sqlite3.connect(db_fname);
        connection.row_factory = sqlite3.Row;
        cursor = connection.cursor();
        search_criterias= ('%' + request.form["search"].lower() + '%',)*3
        cursor.execute("SELECT * FROM product WHERE LOWER(ticker) LIKE ? OR LOWER(category) LIKE ? OR LOWER(name) LIKE ? ORDER BY ticker;",search_criterias)
        query = cursor.fetchall()
        connection.close()
        return home(query)
    return home()

@app.route('/login', methods=['GET', 'POST'])
def login():

    user_data = None
    if 'user' in session:
        user_data = session['user']

    connection = sqlite3.connect(db_fname)
    connection.row_factory = sqlite3.Row
    cursor = connection.cursor()

    if request.method == 'POST':

        uname = request.form["uname"]
        password = request.form["pass"]
        print(uname, password)
        # get password correspond to the username
        data = cursor.execute("SELECT * FROM users WHERE name=? AND password=?;",(uname,password));
        user_data = data.fetchone();
        #print(key)

        if user_data:
            user_value = {
                'email'     : user_data[0],
                'name'      : user_data[1],
                'balance'   : user_data[3]
            }
            session['user'] = user_value
            return redirect('/')
        else:
            return render_template("login.html", err="Incorrect username or password! Please try again!", user = user_data)
            
    elif request.method == 'GET':
        # if user already logged in, then they will get logged out
        if 'user' in session:
            session.clear()
            return redirect('/')
        # if user is not logged in send to login.html
        return render_template("login.html", user = user_data)


@app.route('/new_account', methods=['GET', 'POST'])
def new_account():

    user_data = None
    if 'user' in session:
        user_data = session['user']

    connection = sqlite3.connect(db_fname)
    connection.row_factory = sqlite3.Row
    cursor = connection.cursor()

    if request.method == 'POST':

        email = request.form["email"]
        uname = request.form["uname"]
        password = request.form["pass"]
        print(uname, password)
        # get password correspond to the username
        data = cursor.execute("SELECT * FROM users WHERE email=? OR name=?;",(email, uname,));
        user_data = data.fetchone();

        if user_data:
            return render_template("adduser.html", err="Account with this email and username already existed!", user = user_data)
        else:
            cursor.execute("INSERT INTO users VALUES(?,?,?,?);", (email, uname, password,100000))
            connection.commit()

            user_value = {
                'email'     : email,
                'name'      : uname,
                'balance'   : 100000
            }
            session['user'] = user_value
            return redirect("/")
            
    elif request.method == 'GET':
        return render_template("adduser.html", user = user_data)

@app.route('/trade/<ticker>', methods=['GET', 'POST'])
def trade(ticker):
    if request.method == 'POST':
        qty = request.form['quantity']
        type = request.form['trade']
        order_desc =  str(type +' ' + qty + ' shares of ' + ticker)
        
        connection = sqlite3.connect(db_fname)
        connection.row_factory = sqlite3.Row
        cursor = connection.cursor()
        cursor.execute('SELECT price FROM product WHERE ticker = ?', (ticker,))
        price = cursor.fetchone()[0]

        order = [ticker, str(qty), str(price), type];
        
        if 'cart' not in session:
            orders = []
            orders.append(order)
            session['cart'] = orders
        else:
            orders = session['cart']
            orders.append(order)
            session['cart'] = orders
    str_redirect = str("/ticker/" + ticker)
    return redirect(str_redirect)

@app.route('/cancel/<item>', methods=['GET', 'POST'])
def cancel(item):
    item_list = list(item.split("-"))
    last_ticker = item_list.pop(-1)
    session['cart'].remove(item_list)
    print(session['cart'])
    if(len(session['cart']) == 0):
        session.pop('cart')
    str_redirect = str("/ticker/" +last_ticker)
    # return product(last_ticker)
    return redirect(str_redirect);

@app.route('/delcart/<ticker>', methods=['GET', 'POST'])
def delcar(ticker):
    session.pop('cart')
    str_redirect = str("/ticker/" +ticker)
    return redirect(str_redirect);

@app.route('/checkout', methods=['GET', 'POST'])
def checkout(err = None):
    user_data = None
    if 'user' in session:
        user_data = session['user']
    
    cart_data = None
    if 'cart' in session:
        cart_data = session['cart']

    totalcost = 0
    for item in cart_data:
        if(item[3] == 'BUY'):
            totalcost += float(item[1]) * float(item[2])
        else:
            totalcost -= float(item[1]) * float(item[2])
    totalcost = round(totalcost,2)
    return render_template("checkout.html", user = user_data, cart = cart_data, totalcost = totalcost, error = err)

@app.route('/submit', methods=['GET', 'POST'])
def submit():
    user_data = None
    if 'user' in session:
        user_data = session['user']

    cart_data = None
    if 'cart' in session:
        cart_data = session['cart']

    today = date.today()
    today_date = today.strftime("%m/%d/%y")


    totalcost = 0
    for item in cart_data:
        if(item[3] == 'BUY'):
            totalcost += float(item[1]) * float(item[2])
        else:
            totalcost -= float(item[1]) * float(item[2])
    totalcost = round(totalcost,2)

    new_account_balance = round(user_data['balance'] - totalcost,2)

    if(new_account_balance < 0):
        return checkout("Error: Insufficient buying power to complete this transaction!")



    connection = sqlite3.connect(db_fname)
    connection.row_factory = sqlite3.Row
    cursor = connection.cursor()
    
    #update product table
    for item in session['cart']:
        ticker = item[0]
        qty    = int(item[1])
        if(item[3] == 'SELL'):
            qty = -qty
        cursor.execute("SELECT stock FROM product WHERE ticker = ?",(ticker,))
        qty_o = cursor.fetchone()[0]
        qty_n = int(qty_o) - int(qty)
        cursor.execute("UPDATE product SET stock = ? WHERE ticker = ? ",(qty_n,ticker))
        connection.commit()
        cursor.execute("INSERT INTO orderitem VALUES(?,?,?,?);",(user_data['email'],today_date,ticker,qty))
        connection.commit()
        cursor.execute("SELECT quantity FROM holdings WHERE ticker = ? AND customer_email = ?" ,(ticker,user_data['email']))
        query = cursor.fetchone()
        qty_holding = qty
        if query != None:
            qty_holding += query[0]
            cursor.execute("UPDATE holdings SET quantity = ? WHERE ticker = ? AND customer_email = ?;",(qty_holding,ticker,user_data['email']))
            connection.commit()
        else:
            cursor.execute("INSERT INTO holdings VALUES(?,?,?);",(user_data['email'],ticker,qty_holding))
            connection.commit()

    cursor.execute("UPDATE users SET balance = ? WHERE email = ? ",(new_account_balance,user_data['email']))
    connection.commit()

    cursor.execute("INSERT INTO orders VALUES(?,?,?);", (user_data['email'],today_date,totalcost))
    connection.commit()

    cursor.execute("SELECT ticker,quantity FROM holdings WHERE customer_email = ? ORDER BY ticker",(user_data['email'],))
    query = cursor.fetchall()
    user_holdings = []
    if(len(query) > 0):
        user_holdings = query

    connection.close()
    session.pop('cart')
    session['user']['balance'] = new_account_balance
    return render_template("confirmation.html",user = user_data, holdings = user_holdings)

@app.route('/history', methods=['GET', 'POST'])
def history(transaction_sort = 'ASC', search = None):
    user_data = None
    if 'user' in session:
        user_data = session['user']

    cart_data = None
    if 'cart' in session:
        cart_data = session['cart']

    connection = sqlite3.connect(db_fname)
    connection.row_factory = sqlite3.Row
    cursor = connection.cursor()

    cursor.execute("SELECT ticker,quantity FROM holdings WHERE customer_email = ? ORDER BY ticker",(user_data['email'],))
    query = cursor.fetchall()
    user_holdings = []
    if(len(query) > 0):
        user_holdings = query

    if search != None:
        return render_template("history.html",user = user_data, holdings = user_holdings, transactions = search)

    print(transaction_sort)
    if(transaction_sort == 'ASC'):
        cursor.execute("SELECT date, ticker_id, quantity FROM orderitem WHERE customer_email = ? ORDER BY date ASC",(user_data['email'],))
    else:
        cursor.execute("SELECT date, ticker_id, quantity FROM orderitem WHERE customer_email = ? ORDER BY date DESC",(user_data['email'],))

    query = cursor.fetchall()
    transactions = []
    if(len(query) > 0):
        transactions = query
    
    return render_template("history.html",user = user_data, holdings = user_holdings, transactions = transactions)

@app.route('/sortASC', methods=['GET', 'POST'])
def sortASC():
    transaction_sort = 'ASC'
    print(transaction_sort)
    return history(transaction_sort = 'ASC')

@app.route('/sortDESC', methods=['GET', 'POST'])
def sortDESC():
    transaction_sort = 'DESC'
    print(transaction_sort)
    return history(transaction_sort = 'DESC')


@app.route('/ordersearch', methods=['GET', 'POST'])
def orderhistory():
    user_data = None
    if 'user' in session:
        user_data = session['user']

    if request.method == 'POST':
        connection = sqlite3.connect(db_fname);
        connection.row_factory = sqlite3.Row;
        cursor = connection.cursor();
        search_criterias= (user_data['email'],str('%' + request.form["search"].upper() + '%'))
        cursor.execute("SELECT date, ticker_id, quantity FROM orderitem WHERE customer_email = ? AND ticker_id LIKE ? ORDER BY date ASC",search_criterias)
        query = cursor.fetchall()
        connection.close()
        return history(search=query)
    return history()

if __name__ == "__main__":
    # app.run(host='0.0.0.1', port=8081)
    app.run()