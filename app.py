#!/usr/bin/python3

from flask import Flask
from flask import render_template, request
from os import environ

# PostgreSQL libraries
import psycopg2
import psycopg2.extras

app = Flask(__name__, static_url_path='/static')

# SGBD configs
DB_HOST = environ["DB_HOST"]
DB_USER = environ["DB_USER"]
DB_DATABASE = DB_USER
DB_PASSWORD = environ["DB_PASSWORD"]
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)
FILENAME = ""

# ==============================================================================

@app.route("/")
def index():
    return render_template("index.html", FILENAME = FILENAME)

# =============== Inserir e remover categorias e subcategorias =================

# Category Table
@app.route("/category_table")
def category_table():
    cursor = None
    dbConn = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        
        cursor.execute("SELECT name FROM super_category ORDER BY name;")
        super_c_rows = cursor.fetchall()
        cursor.execute("SELECT name FROM simple_category ORDER BY name;")
        simple_c_rows = cursor.fetchall()
        
        return render_template("CategoryTable.html", simple_c_rows = simple_c_rows, super_c_rows = super_c_rows, FILENAME = FILENAME)
    except Exception as e:
        return render_template("error.html", error = str(e), FILENAME = FILENAME)
    finally:
        cursor.close()
        dbConn.close()

# Category Independent
@app.route("/category_independent")
def category_independent():
    cursor = None
    dbConn = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        
        cursor.execute("SELECT name FROM category;")

        return render_template("CategoryIndependent.html", cursor = cursor, FILENAME = FILENAME)
    except Exception as e:
        return render_template("error.html", error = str(e), FILENAME = FILENAME)
    finally:
        cursor.close()
        dbConn.close()

# Category Add to Super
@app.route("/category_add_to_super", methods = ["POST"])
def category_add_to_super():
    cursor = None
    dbConn = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        simple_c_name = request.form["simple_c_name"]
        super_c_name = request.form["super_c_name"]
        
        # Check if the Simple Category is on the DB
        cursor.execute("SELECT DISTINCT name FROM category WHERE name=%s", (simple_c_name,))
        if cursor.rowcount == 0:
            cursor.execute("INSERT INTO category VALUES(%s)", (simple_c_name,))
            cursor.execute("INSERT INTO simple_category VALUES(%s)", (simple_c_name,))
        
        # If the Super Category is in fact a Simple one, we must transfer it
        cursor.execute("SELECT DISTINCT name FROM super_category WHERE name = %s", (super_c_name,)) 
        if cursor.rowcount == 0:
            cursor.execute("DELETE FROM simple_category WHERE name = %s", (super_c_name,))
            cursor.execute("INSERT INTO super_category VALUES(%s)", (super_c_name,))
        
        # Add the relation between the categories to the DB
        cursor.execute("INSERT INTO has_other VALUES(%s, %s)", (simple_c_name, super_c_name))
        
        return render_template("CategoryTableAddSuccess.html", simple_c_name = simple_c_name, super_c_name = super_c_name, FILENAME = FILENAME)
    except Exception as e:
        return render_template("error.html", error = str(e), FILENAME = FILENAME)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

# Category Add
@app.route("/category_add", methods = ["POST"])
def category_add():
    cursor = None
    dbConn = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        c_name = request.form["c_name"]

        cursor.execute("INSERT INTO category VALUES(%s)", (c_name,))
        # Restriction 1: must add to simple_category
        cursor.execute("INSERT INTO simple_category VALUES(%s)", (c_name,))
        
        return render_template("CategoryIndependentAddSuccess.html", c_name = c_name, FILENAME = FILENAME)
    except Exception as e:
        return render_template("error.html", error = str(e), FILENAME = FILENAME)
    finally:
        cursor.close()
        dbConn.commit()
        dbConn.close()

# Category Remove
@app.route("/category_remove")
def category_remove():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        c_name = request.args["c_name"]
        
        # Delete the category from everywhere it is, no dependencies must be broken
        cursor.execute("DELETE FROM has_other WHERE category = %s", (c_name,))
        cursor.execute("DELETE FROM has_other WHERE super_category = %s", (c_name,))
        cursor.execute("DELETE FROM has_category WHERE name = %s", (c_name,))
        
        # Get every product that belongs to the category
        cursor.execute("SELECT ean FROM product WHERE cat = %s", (c_name,))
        eans = cursor.fetchall()
        for ean in eans:
            cursor.execute("DELETE FROM has_category WHERE ean = %s", (ean[0],))
            cursor.execute("DELETE FROM replenishment_event WHERE ean = %s", (ean[0],))
            cursor.execute("DELETE FROM planogram WHERE ean = %s", (ean[0],))
        cursor.execute("DELETE FROM product WHERE cat = %s", (c_name,))

        # Get every shelf that has a product of the category
        cursor.execute("SELECT nro, serial_number, manufacturer FROM shelf WHERE name = %s", (c_name,))
        shelves = cursor.fetchall()
        for s in shelves:
            cursor.execute("DELETE FROM replenishment_event WHERE nro = %s AND serial_number = %s AND manufacturer = %s", (s[0], s[1], s[2]))  
            cursor.execute("DELETE FROM planogram WHERE nro = %s AND serial_number = %s AND manufacturer = %s", (s[0], s[1], s[2]))     
        cursor.execute("DELETE FROM shelf WHERE name = %s", (c_name,))
        
        cursor.execute("DELETE FROM responsible_for WHERE name_cat = %s", (c_name,))
        cursor.execute("DELETE FROM simple_category WHERE name = %s", (c_name,))
        cursor.execute("DELETE FROM super_category WHERE name = %s", (c_name,))
        cursor.execute("DELETE FROM category WHERE name = %s", (c_name,))

        return render_template("CategoryTableRemoveSuccess.html", c_name = c_name, cursor = cursor, FILENAME = FILENAME)
    except Exception as e:
        return render_template("error.html", error = str(e), FILENAME = FILENAME)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

# ====================== Inserir e remover um retalhista =======================

# Retailer Table
@app.route("/retailer_table")
def retailer_table():
    cursor = None
    dbConn = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        
        cursor.execute("SELECT tin, name FROM retailer ORDER BY name;")

        return render_template("RetailerTable.html", cursor = cursor, FILENAME = FILENAME)
    except Exception as e:
        return render_template("error.html", error = str(e), FILENAME = FILENAME)
    finally:
        cursor.close()
        dbConn.close()
    
# Retailer Independent
@app.route("/retailer_independent")
def retailer_independent():
    cursor = None
    dbConn = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        
        cursor.execute("SELECT tin, name FROM retailer;")

        return render_template("RetailerIndependent.html", cursor = cursor, FILENAME = FILENAME)
    except Exception as e:
        return render_template("error.html", error = str(e), FILENAME = FILENAME)
    finally:
        cursor.close()
        dbConn.close()

# Retailer Add
@app.route("/retailer_add", methods = ["POST"])
def retailer_add():
    cursor = None
    dbConn = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        r_tin = request.form["r_tin"]
        r_name = request.form["r_name"]

        cursor.execute("INSERT INTO retailer VALUES(%s, %s)", (r_tin, r_name))
        
        return render_template("RetailerIndependentAddSuccess.html", r_tin = r_tin, r_name = r_name, FILENAME = FILENAME)
    except Exception as e:
        return render_template("error.html", error = str(e), FILENAME = FILENAME)
    finally:
        cursor.close()
        dbConn.commit()
        dbConn.close()

# Retailer Remove
@app.route("/retailer_remove")
def retailer_remove():
    cursor = None
    dbConn = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        r_tin = request.args["r_tin"]
        r_name = request.args["r_name"]

        # Get the products the retailer is responsible for
        query = "SELECT ean FROM has_category h \
                 JOIN responsible_for r ON h.name = r.name_cat \
                 WHERE r.tin = %s;"
        cursor.execute(query, (r_tin,))
        eans = cursor.fetchall()
        
        # Delete the retailer from everywhere he/she is, no dependencies must be broken
        cursor.execute("DELETE FROM replenishment_event WHERE tin = %s", (r_tin,))
        cursor.execute("DELETE FROM responsible_for WHERE tin = %s", (r_tin,))
        cursor.execute("DELETE FROM retailer WHERE tin = %s", (r_tin,))
        
        # Delete all products the retailer is responsible for from everywhere they are
        for ean in eans:
            cursor.execute("DELETE FROM has_category WHERE ean = %s", (ean[0],))
            cursor.execute("DELETE FROM planogram WHERE ean = %s", (ean[0],))
            cursor.execute("DELETE FROM replenishment_event WHERE ean = %s", (ean[0],))
            cursor.execute("DELETE FROM product WHERE ean = %s", (ean[0],))
            
        return render_template("RetailerTableRemoveSuccess.html", r_tin = r_tin, r_name = r_name, FILENAME = FILENAME)
    except Exception as e:
        return render_template("error.html", error = str(e), FILENAME = FILENAME)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

# ============== Listar todos os eventos de reposição de uma IVM ===============

# IVM Table
@app.route("/ivm_table")
def ivm_table():
    cursor = None
    dbConn = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        
        cursor.execute("SELECT manufacturer, serial_number FROM ivm ORDER BY manufacturer;")
        
        return render_template("IvmTable.html", cursor = cursor, FILENAME = FILENAME)
    except Exception as e:
        return render_template("error.html", error = str(e), FILENAME = FILENAME)
    finally:
        cursor.close()
        dbConn.close()

# IVM Events
@app.route("/ivm_events")
def ivm_events():
    cursor1 = None
    cursor2 = None
    dbConn = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor1 = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        cursor2 = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        i_manufacturer = request.args["i_manufacturer"]
        i_serial_number = request.args["i_serial_number"]
        
        query1 = "SELECT cat, SUM(units) \
                 FROM replenishment_event r JOIN product p ON r.ean = p.ean \
                 GROUP BY p.cat, r.manufacturer, r.serial_number \
                 HAVING manufacturer=%s AND serial_number=%s;"
        cursor1.execute(query1, (i_manufacturer, i_serial_number))
        query2 = "SELECT cat, descr, instant, units, name  \
                FROM replenishment_event e \
                JOIN product p ON e.ean = p.ean \
                JOIN retailer r ON e.tin = r.tin \
                WHERE manufacturer=%s AND serial_number=%s \
                ORDER BY instant DESC;"
        cursor2.execute(query2, (i_manufacturer, i_serial_number))
        
        return render_template("IvmEvents.html", cursor1 = cursor1, cursor2 = cursor2, i_manufacturer = i_manufacturer, i_serial_number = i_serial_number, FILENAME = FILENAME)
    except Exception as e:
        return render_template("error.html", error = str(e), FILENAME = FILENAME)
    finally:
        dbConn.commit()
        cursor1.close()
        cursor2 = None
        dbConn.close()

# =========== Listar todas as subcategorias de uma super categoria =============

# Category List
@app.route("/category_list")
def category_list():
    cursor1 = None
    cursor2 = None
    dbConn = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor1 = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        cursor2 = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        
        query1 = "SELECT DISTINCT name FROM super_category s \
        JOIN has_other h ON s.name = h.super_category;"
        cursor1.execute(query1)

        query2 = "SELECT name FROM super_category s \
        LEFT JOIN has_other h ON s.name = h.super_category \
        WHERE h.super_category IS NULL;"
        cursor2.execute(query2)

        return render_template("CategoryList.html", cursor1 = cursor1, cursor2 = cursor2, FILENAME = FILENAME)
    except Exception as e:
        return render_template("error.html", error = str(e), FILENAME = FILENAME)
    finally:
        cursor1.close()
        cursor2.close()
        dbConn.close()

# Category Sub
@app.route("/category_sub")
def category_sub():
    cursor = None
    dbConn = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        super_c_name = request.args["super_c_name"]
        
        subcategories = []
        queue = [super_c_name]
        while len(queue) != 0:
            current = queue.pop(0)
            cursor.execute("SELECT category FROM has_other WHERE super_category = %s" , (current,)) 
            for c in cursor:
                subcategories.append(c[0])
                queue.append(c[0])
        
        return render_template("CategoryListSub.html", super_c_name = super_c_name, subcategories = subcategories, FILENAME = FILENAME)
    except Exception as e:
        return render_template("error.html", error = str(e), FILENAME = FILENAME)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

# ==============================================================================

if __name__ == "__main__":
    app.run(debug = True, use_reloader = True)