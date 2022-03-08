import sqlite3
from flask import Flask, session, render_template, redirect, url_for, request

app = Flask('app')
app.secret_key = "password123"

@app.route('/', methods=['GET', 'POST'])
def login():
  connection = sqlite3.connect("myDatabase.db")
  connection.row_factory = sqlite3.Row
  cursor = connection.cursor()
 
  if request.method == 'POST':
    uname = request.form["uname"]
    password = request.form["pass"]
    print(uname, password)
    # get password correspond to the username
    data = cursor.execute("SELECT username, password, type_user,name FROM users WHERE username=? AND password=?",(uname,password));
    key = data.fetchone();
    #print(key)

    if key:

      # print out 
      print("Key[0]");
      print(key[2]);
      session['type'] = [key[2],key[3]];
      print("Login granted")

      return redirect('/home')
    else:
      return render_template("login.html", err="Invalid login!")
      # exit(0);
  elif request.method == 'GET':
    if 'type' in session:
      return redirect('/home')
    # if user is not logged in send to login.html
    return render_template("login.html")
    # if user is not logged in then redirect to /home
    
    
  # If the username/password is correct, log them in and redirect them to the home page. Remember to set your session variables! 

  # Else, give an error message and redirect them to the same login page 
  return 

# @app.route('/home/<uname>', methods=['GET', 'POST'])
@app.route('/home', methods=['GET', 'POST'])
def home():
  connection = sqlite3.connect("myDatabase.db")
  connection.row_factory = sqlite3.Row
  cursor = connection.cursor()
  # data2 = cursor.execute("SELECT type_user FROM users WHERE username=?",(str(uname),));
  # key2 = data2.fetchone();
  # print(key2)
  if 'type' in session:
    if session['type'][0] == 'TA':
      #We know the user is a TA
      cursor.execute("SELECT id, name, email, engagement FROM students")
      students = cursor.fetchall()
    elif session['type'][0] == 'Student':
      #We know the user is a student
      cursor.execute("SELECT id, name, email FROM students")
      students = cursor.fetchall()
    else:
      #We know the user is a professor
      cursor.execute("SELECT * FROM students")
      students = cursor.fetchall()

    return render_template("home.html", students=students, name = session['type'][1])
  else: return redirect("/")

@app.route('/logout', methods=['GET', 'POST'])
def logout():
  session.clear()
  return redirect("/")

app.run(host='0.0.0.0', port=8080)