DB = store

run:
	@export FLASK_ENV=development
	@python3 -m flask run

web:
	@open http://127.0.0.1:5000/

build:
	@sqlite3 ${DB}.db ".read store_schema.sql"

clean:
	@rm ${DB}.db

user:
	@sqlite3 ${DB}.db "SELECT * FROM users"

product:
	@sqlite3 ${DB}.db "SELECT * FROM product"

orders:
	@sqlite3 ${DB}.db "SELECT * FROM orders"

cat:
	@sqlite3 ${DB}.db "SELECT * FROM category"

schema:
	@sqlite3 ${DB}.db ".schema"

tables:
	@sqlite3 ${DB}.db ".tables"

sql:
	@sqlite3 ${DB}.db