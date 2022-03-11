import sqlite3
from flask import Flask, session, render_template, redirect, url_for, request

app = Flask('app')
app.secret_key = "leo-phan"

db_fname = "store.db"
home_fname = "home.html"
login_fname = "login.html"
about_fname = "about.html"
product_fname = "product.html"

@app.route('/', methods=['GET', 'POST'])
def home(search_list = None):

    if(search_list != None):
        return render_template(home_fname,products = search_list)

    # connect to the database
    connection = sqlite3.connect(db_fname);
    connection.row_factory = sqlite3.Row;
    cursor = connection.cursor();
    
    # retrieve database
    data = cursor.execute("SELECT * FROM product")
    products = data.fetchall();

    # get signal from html forms
    if request.method == 'POST':
        print("POST!");
        # ticket = request.form[]

    return render_template(home_fname,products = products)
    
@app.route('/ticket/<ticket>', methods=['GET', 'POST'])
def product(ticket):
    connection = sqlite3.connect(db_fname);
    connection.row_factory = sqlite3.Row;
    cursor = connection.cursor();
    query = cursor.execute("SELECT * FROM product WHERE ticket = (?);",(ticket,))
    ticket_data = query.fetchall()
    connection.close()
    return render_template(product_fname,product = ticket_data[0]);

@app.route('/tab/<tab>', methods=['GET', 'POST'])
def nav(tab):
    if tab == 'home':
        return redirect('/');
    elif tab == 'login':
        return redirect('/login');
    elif tab == 'about':
        return redirect('/about');
    else:
        return redirect('/');

@app.route('/about', methods=['GET', 'POST'])
def about():
    return render_template(about_fname)

@app.route('/home')
def goto_home():
    return redirect('/')

@app.route('/search', methods=['GET', 'POST'])
def search():
    if request.method == 'POST':
        connection = sqlite3.connect(db_fname);
        connection.row_factory = sqlite3.Row;
        cursor = connection.cursor();
        search_criterias= ('%' + request.form["search"] + '%',)*3
        cursor.execute("SELECT * FROM product WHERE LOWER(ticket) LIKE ? OR LOWER(category) LIKE ? OR LOWER(name) LIKE ?;",search_criterias)
        query = cursor.fetchall()
        connection.close()
        return home(query)
    return home()

@app.route('/login', methods=['GET', 'POST'])
def login():
  connection = sqlite3.connect(db_fname)
  connection.row_factory = sqlite3.Row
  cursor = connection.cursor()
 
  if request.method == 'POST':
    uname = request.form["uname"]
    password = request.form["pass"]
    print(uname, password)
    # get password correspond to the username
    data = cursor.execute("SELECT * FROM users WHERE name=? AND password=?;",(uname,password));
    key = data.fetchone();
    #print(key)

    if key:

      # print out 
      print("Key[0]");
      print(key[2]);
      session['type'] = [key[2],key[3]];
      print("Login granted")

      return redirect('/')
    else:
      return render_template("login.html", err="Incorrect username or password! Please try again!")
      # exit(0);
  elif request.method == 'GET':
    if 'type' in session:
      return redirect('/home')
    # if user is not logged in send to login.html
    return render_template("login.html")
    # if user is not logged in then redirect to /home
    
    
  # If the username/password is correct, log them in and redirect them to the home page. Remember to set your session variables! 

  # Else, give an error message and redirect them to the same login page 

# # @app.route('/home/<uname>', methods=['GET', 'POST'])
# @app.route('/home', methods=['GET', 'POST'])
# def home():
#   connection = sqlite3.connect("myDatabase.db")
#   connection.row_factory = sqlite3.Row
#   cursor = connection.cursor()
#   # data2 = cursor.execute("SELECT type_user FROM users WHERE username=?",(str(uname),));
#   # key2 = data2.fetchone();
#   # print(key2)
#   if 'type' in session:
#     if session['type'][0] == 'TA':
#       #We know the user is a TA
#       cursor.execute("SELECT id, name, email, engagement FROM students")
#       students = cursor.fetchall()
#     elif session['type'][0] == 'Student':
#       #We know the user is a student
#       cursor.execute("SELECT id, name, email FROM students")
#       students = cursor.fetchall()
#     else:
#       #We know the user is a professor
#       cursor.execute("SELECT * FROM students")
#       students = cursor.fetchall()

#     return render_template("home.html", students=students, name = session['type'][1])
#   else: return redirect("/")

# @app.route('/logout', methods=['GET', 'POST'])
# def logout():
#   session.clear()
#   return redirect("/")

app.run(host='0.0.0.0', port=8080)