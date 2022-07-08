import tkinter as tk
from tkinter import ttk, messagebox
import mysql.connector
from tkinter import *
import serial
import time
# Xbee_Serial = serial.Serial('COM11', 115200)
time.sleep(2)

def GetValue(event):
    e1.delete(0, END)
    e2.delete(0, END)
    e3.delete(0, END)
    e4.delete(0, END)
    e5.delete(0, END)
    e6.delete(0, END)
    e7.delete(0, END)
    row_id = listBox.selection()[0]
    select = listBox.set(row_id)
    e1.insert(0, select['order_id'])
    e2.insert(0, select['groceries'])
    e3.insert(0, select['electronics'])
    e4.insert(0, select['instruments'])
    e5.insert(0, select['tools'])
    e6.insert(0, select['appliances'])
    e7.insert(0, select['medicines'])



def Add():
    order_id = e1.get()
    groceries = e2.get()
    electronics = e3.get()
    instruments = e4.get()
    tools = e5.get()
    appliances = e6.get()
    medicines = e7.get()


    mysqldb = mysql.connector.connect(host="localhost", user="root", password="1729", database="warehousedb")
    mycursor = mysqldb.cursor()

    try:
        sql = "INSERT INTO  orders (order_id,groceries,electronics,instruments,tools,appliances,medicines) VALUES (%s, %s, %s, %s, %s, %s, %s)"
        val = (order_id,groceries,electronics,instruments,tools,appliances,medicines)
        mycursor.execute(sql, val)
        mysqldb.commit()
        lastid = mycursor.lastrowid
        messagebox.showinfo("information", "Order Placed.")
        e1.delete(0, END)
        e2.delete(0, END)
        e3.delete(0, END)
        e4.delete(0, END)
        e5.delete(0, END)
        e6.delete(0, END)
        e7.delete(0, END)
        e1.focus_set()
    except Exception as e:
        print(e)
        mysqldb.rollback()
        mysqldb.close()

def show():
    mysqldb = mysql.connector.connect(host="localhost", user="root", password="1729", database="warehousedb")
    mycursor = mysqldb.cursor()
    mycursor.execute("SELECT order_id,groceries,electronics,instruments,tools,appliances,medicines FROM orders")
    records = mycursor.fetchall()
    print(records)

    for i, (order_id,groceries,electronics,instruments,tools,appliances,medicines) in enumerate(records, start=1):
        listBox.insert("", "end", values=(order_id,groceries,electronics,instruments,tools,appliances,medicines))
        mysqldb.close()


root = Tk()
root.geometry("500x500")
global e1
global e2
global e3
global e4
global e5
global e6
global e7


tk.Label(root, text="WAREHOUSE ORDERS", fg="Black", font=('Arial', 20)).place(x=630, y=10)

tk.Label(root, text="Order ID").place(x=10, y=60)
Label(root, text="Groceries").place(x=10, y=90)
Label(root, text="Electronics").place(x=10, y=120)
Label(root, text="Instruments").place(x=10, y=150)
Label(root, text="Tools").place(x=10, y=180)
Label(root, text="Appliances").place(x=10, y=210)
Label(root, text="Medicines").place(x=10, y=240)


e1 = Entry(root)
e1.place(x=140, y=60)

e2 = Entry(root)
e2.place(x=140, y=90)

e3 = Entry(root)
e3.place(x=140, y=120)

e4 = Entry(root)
e4.place(x=140, y=150)

e5 = Entry(root)
e5.place(x=140, y=180)

e6 = Entry(root)
e6.place(x=140, y=210)

e7 = Entry(root)
e7.place(x=140, y=240)

Button(root, text="Add", command=Add, height=1, width=10).place(x=300, y=233)
cols = ('order_id', 'groceries', 'electronics', 'instruments', 'tools', 'appliances', 'medicines')
listBox = ttk.Treeview(root, columns=cols, show='headings')
for col in cols:
    listBox.heading(col, text=col)
    listBox.grid(row=1, column=0, columnspan=2)
    listBox.place(x=60, y=290)
show()
listBox.bind('<Double-Button-1>', GetValue)
root.mainloop()
def bnr(a):
    bn=bin(a).replace('0b','')
    x=bn[::-1]
    while len(x)<8:
        x+='0'
    bn=x[::-1]
    return bn
try:
    connection = mysql.connector.connect(host="localhost", user="root", password="1729", database="warehousedb")
    sql_select_Query = "select * from orders"
    cursor = connection.cursor()
    cursor.execute(sql_select_Query)
    # get all records
    records = cursor.fetchall()
    for row in records:
        packet = [bnr(row[1]<<4|row[2]),bnr(row[3]<<4|row[4]),bnr(row[5]<<4|row[6])]
    for i in range (3):
        value=packet[i]
        print(value.encode('ascii'))
        time.sleep(0.001)
        # Xbee_Serial.write(value.encode('ascii'))

except mysql.connector.Error as e:
    print("Error reading data from MySQL table", e)
finally:
    if connection.is_connected():
        connection.close()
        cursor.close()