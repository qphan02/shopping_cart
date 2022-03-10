from flask import Flask, render_template, request, session, redirect
from datetime import datetime
import sqlite3

app = Flask('app')

RESULTS_PER_PAGE = 3
app.secret_key = 'super secret key'

@app.route('/add_to_cart/<product_id>', methods=['GET', 'POST'])
def addToCart(product_id):
  if not isinstance(int(product_id), int):
    return redirect("/catalog")
  if request.method == 'POST':
    print("POST")
  if 'key' in session:
    print("key in sessh")
    if 'cart' in session:
      cart = session['cart']
      if product_id + ":" not in cart:
        cart = cart + product_id + ":"
      session['cart'] = cart
      session[str(product_id)] = request.form['quantity'];
      print("quantity", session[str(product_id)])
      print(cart)
    else: 
      print("no cart")
      cart = product_id + ":"
      session['cart'] = cart
      session[str(product_id)] = request.form['quantity'];
    return redirect("/catalog/" + str(session['page']))
  else: return redirect("/")
@app.route('/query', methods=['POST'])
def query():
  if 'key' in session:
    print(request.form['filter'])
    session['filter'] = request.form['filter']
    session['query'] = request.form['query'];
  return redirect("/catalog")
  
@app.route('/catalog')
def catalog():
  if 'key' in session:
    updatePages()
    connection = sqlite3.connect("myDatabase.db")
    cursor = connection.cursor()

    if 'query' in session and 'filter' in session:
      if session['filter'] == 'Category':
        cursor.execute("SELECT * FROM Product WHERE lower(category) LIKE ? LIMIT 3 OFFSET 0", ("%" + session['query'].lower() + "%",));
      else:
        cursor.execute("SELECT * FROM Product WHERE lower(name) LIKE ? LIMIT 3 OFFSET 0", ("%" + session['query'].lower() + "%",));
    # if query is not in session
      page = 1;
    # cursor.execute("SELECT * FROM Product LIMIT 3 OFFSET 0;" )
      products = cursor.fetchall()
      print("page ", page , " of ", page)
      print("found", len(products), " products")

      return render_template("home.html", products=products, session=session)
    else:
      cursor.execute("SELECT * FROM Product LIMIT 3;");
      products = cursor.fetchall()
      return render_template("home.html", products=products, session=session)
  else: return redirect("/")
    
  # @app.route('/catalog/<page>')
  # def catalogPage(page):
  #   if 'key' in session:
      
@app.route('/catalog/<page>')
def catalogPage(page):
  if not isinstance(int(page), int):
    return redirect("/catalog")
  session['page'] = page
  offset = (int(session['page']) - 1) * RESULTS_PER_PAGE

  if 'key' in session:
    connection = sqlite3.connect("myDatabase.db")
    cursor = connection.cursor()

    if 'query' in session and 'filter' in session:
      if session['filter'] == 'Category':
        cursor.execute("SELECT * FROM Product WHERE lower(category) LIKE ? LIMIT 3 OFFSET ?", ("%" + session['query'].lower() + "%", offset,));
      else:
        cursor.execute("SELECT * FROM Product WHERE lower(name) LIKE ? LIMIT 3 OFFSET ?", ("%" + session['query'].lower() + "%", offset,));
    # if query is not in session
      page = 1;
    # cursor.execute("SELECT * FROM Product LIMIT 3 OFFSET 0;" )
      products = cursor.fetchall()
      print("page ", page , " of ", page)
      print("found", len(products), " products")
      updatePages()
      return render_template("home.html", products=products, session=session, pages=session['pages'])
    else:
      cursor.execute("SELECT * FROM Product LIMIT 3 OFFSET ?;", (offset,));
      products = cursor.fetchall()
      print("found", len(products), " products")
      print("page ", 1 , " of ", 1)
      updatePages()
      return render_template("home.html", products=products, session=session, pages=session['pages'])
  else: return redirect("/")

@app.route('/', methods=['GET', 'POST'])
def login():
  print("Received login")
  connection = sqlite3.connect("myDatabase.db")
  connection.row_factory = sqlite3.Row
  cursor = connection.cursor()
 
  if request.method == 'POST':
    print("Received login request")
    email = request.form["email"]
    password = request.form["pass"]
    print(email, password)
    # get password correspond to the username
    data = cursor.execute("SELECT email, password,name FROM users WHERE email=? AND password=?",(email,password));
    key = data.fetchone();
    #print(key)

    if key:

      # print out 
      print("Key[0]");
      print(key[2]);
      session['key'] = [key[0],key[2]];
      session['page'] = 1;
      
      print("Login granted")

      return redirect('/catalog')
    else:
      return render_template("login.html", err="Invalid login!")
      # exit(0);
  elif request.method == 'GET':
    if 'key' in session:
      return redirect('/catalog')
    # if user is not logged in send to login.html
    return render_template("login.html")
    # if user is not logged in then redirect to /home
def updatePages():
  count = 0
  connection = sqlite3.connect("myDatabase.db")
  connection.row_factory = sqlite3.Row
  cursor = connection.cursor()
  if 'query' in session and 'filter' in session:
    if session['filter'] == 'Category':
      data = cursor.execute("SELECT COUNT(*) as count FROM Product WHERE lower(category) LIKE ?", ("%" + session['query'].lower() + "%",));
    else:
      data = cursor.execute("SELECT COUNT(*) as count FROM Product WHERE lower(name) LIKE ?", ("%" + session['query'].lower() + "%",));
  else:
    data = cursor.execute("SELECT COUNT(*) as count FROM Product")
  count = data.fetchone()
  print(count)
  # print("page count for current query is", int(count[0] / 3) + 1)
  if (count):
    print(count[0])
    session['pages'] = int(count[0] / 3) + 1
  else: session['pages'] = 1
      
  # load number of pages for query into session data
    
  # If the username/password is correct, log them in and redirect them to the home page. Remember to set your session variables! 

  # Else, give an error message and redirect them to the same login page 

# @app.route('/home/<uname>', methods=['GET', 'POST'])
# @app.route('/home', methods=['GET', 'POST'])
# def home():
#   connection = sqlite3.connect("myDatabase.db")
#   connection.row_factory = sqlite3.Row
#   cursor = connection.cursor()
#   if 'key' in session:
#     products = cursor.execute("SELECT ")
#     return render_template("home.html", name = session['key'][1])
#   else: return redirect("/")

@app.route('/place', methods=['GET','POST'])
def placeOrder():
  if 'key' in session and 'cart' in session:
    connection = sqlite3.connect("myDatabase.db")
    connection.row_factory = sqlite3.Row
    cursor = connection.cursor()
    arr = session['cart'].split(":")
    items = []
    prices = []
    quantities = []
    totalPrice = 0
    for obj in arr:
      print(obj)
      query = cursor.execute("SELECT * FROM Product WHERE id=?", (obj,))
      result = query.fetchone()
      if (result):
        items.append(result[1])
        quantities.append(session[str(result[0])])
        price = result[2]
        print("price:", price)
        prices.append(price)
        quantity = session[str(result[0])]
        print("quantity:", quantity)
        subtotal = int(price) * int(quantity)
        stock = result[3]
        newStock = stock - int(quantity)
        cursor.execute("UPDATE Product SET stock=? WHERE id=?", (newStock, obj,))
        connection.commit()
        print(subtotal)
        totalPrice += subtotal
    cart_size = len(items)
    if cart_size > 0:
      date = datetime.now()
      cursor.execute("INSERT INTO Orders VALUES(?,?,?);", (session['key'][0], date,totalPrice,))
      connection.commit()
      for i in range(len(items)):
        cursor.execute("INSERT INTO OrderItem VALUES(?,?,?,?);",(session['key'][0], date, arr[i], quantities[i],))
        connection.commit()
        key = session['key']
        session.clear()
        session['key'] = key
        session['page'] = 1
      return render_template("success.html")
    # check all the items in cart are in stock
    # remove quantities of each item in cart from shop
    # insert order info into orders table
  else:
    return redirect("/")
@app.route('/delete_from_cart/<id>', methods=['GET', 'POST'])
def deleteItemFromCart(id):
  if not isinstance(int(id), int):
    return redirect("/catalog")
  print(id)
  cart = session['cart']
  print(cart)
  session['cart'] = cart.replace(id + ":", "")
  print(cart)
  session.pop(id, 'None')
  return redirect("/catalog/" + str(session['page']))

@app.route('/checkout', methods=['GET', 'POST'])
def checkout():
  if 'cart' in session and 'key' in session:
    print(session['cart'])
    connection = sqlite3.connect("myDatabase.db")
    connection.row_factory = sqlite3.Row
    cursor = connection.cursor()
    arr = session['cart'].split(":")
    items = []
    prices = []
    quantities = []
    totalPrice = 0
    for obj in arr:
      print(obj)
      query = cursor.execute("SELECT * FROM Product WHERE id=?", (obj,))
      result = query.fetchone()
      if (result):
        items.append(result[1])
        quantities.append(session[str(result[0])])
        price = result[2]
        print("price:", price)
        prices.append(price)
        quantity = session[str(result[0])]
        print("quantity:", quantity)
        subtotal = int(price) * int(quantity)
        print(subtotal)
        totalPrice += subtotal
    cart_size = len(items)
    if cart_size > 0:
      return render_template("checkout.html", items=items, quantities=quantities, cart_size = cart_size, total=totalPrice, cart_ids=arr, prices=prices)
      # return "Cart size: " + str(cart_size) + "\n" + str(items) + " " + str(quantities)
  return "<a href='/catalog'>Empty cart</a>"

@app.route('/orders', methods=['GET','POST'])
def orderHistory():
  if 'key' in session:
    connection = sqlite3.connect("myDatabase.db")
    connection.row_factory = sqlite3.Row
    cursor = connection.cursor()
    query = cursor.execute("SELECT * FROM Orders WHERE customer_email=?", (session['key'][0],))
    orders = query.fetchall()
    itemlines = []
    for order in orders:
      line = ""
      queryItems = cursor.execute("SELECT name, price, quantity FROM OrderItem INNER JOIN Product ON product.id = orderitem.product_id WHERE customer_email=? AND date=?;", (session['key'][0], order[1],))
      orderitems = queryItems.fetchall()
      for orderitem in orderitems:
        line = line + str(orderitem[0]) + " $" + str(orderitem[1]) + " x" + str(orderitem[2]) + " "
      itemlines.append(line)
      
    return render_template("orders.html", orders=orders, lines = itemlines, i = len(orders))
  else:
    return redirect("/")

@app.route('/clearsearch', methods=['POST'])
def clearsearch():
  session.pop('query', None)
  return redirect("/catalog")
@app.route('/clearcart', methods=['POST'])
def clearcart():
  key = session['key']
  session.clear()
  session['key'] = key
  session['page'] = 1
  return redirect("/catalog")
  
@app.route('/signup', methods=['GET','POST'])
def signup():
  connection = sqlite3.connect("myDatabase.db")
  connection.row_factory = sqlite3.Row
  cursor = connection.cursor()
  if request.method == 'POST':
    print("GOT SIGNUP POSTREQ")
    email = request.form['email']
    name = request.form['name']
    passwd = request.form['pass']
    exists = cursor.execute("SELECT * FROM Users WHERE email=?", (email,))
    data = exists.fetchone()
    if not data:
      cursor.execute("INSERT INTO Users VALUES(?,?,?)", (email, name, passwd,))
      connection.commit()
      return render_template("signup.html", success="Account created")
    else:
      return render_template("signup.html", err="Email already in use")
  return render_template("signup.html")

@app.route('/logout', methods=['GET', 'POST'])
def logout():
  session.clear()
  return redirect("/")



app.run(host='0.0.0.0', port=8080)
