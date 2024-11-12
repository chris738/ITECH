#!/bin/env python

import serial
import time
import mysql.connector

ser = serial.Serial('/dev/ttyACM0', 9600)

database = mysql.connector.connect(
    host="localhost",
    user="Parkplatz",
    password="Passwort",
    database="Parkplatzverwaltung"
)

#cursor = database.cursor()

def FreiePark():
    cursor = database.cursor()
    query = "SELECT COUNT(*) FROM Parkplatz WHERE Status = 'frei'"
    cursor.execute(query)
    result = cursor.fetchone()
    #print("Datenbankabfrage Ergbenis: ", result[0])
    response = str(result[0])
    time.sleep(1)
    #print("Sende String:", response)
    #ser.write(b'%s\n' % response.encode())
    #print("Sende String:", response)
    ser.write(b'%s\n' % response.encode())
    return result[0]

def UpdateDatabase(status_string):
    if status_string == " Keine Daten ":
        print("Keine Parkplatz Daten!")
        return False
    else:
        status_map = {
            'F':'frei',
            'R':'reserviert',
            'B':'Besetzt',
        }

        ids = ['P1', 'P2', 'P3', 'P4']
        try:
            cursor = database.cursor()
            for i, status_char in enumerate(status_string):
                status_value = status_map[status_char]
                parking_id = ids[i]
                query = "UPDATE Parkplatz SET Status = %s WHERE Parkplatz = %s"
                #print("Query: ", query, status_value, parking_id)
                cursor.execute(query, (status_value, parking_id))

            database.commit()

       # except database.Error as err:
       #        print(f"Fehler!!!: {err}")
       #        return False

        finally:
            cursor.close()
            return True


def checkKarte(karte):
    try:
        cursor = database.cursor()
        query = "SELECT COUNT(*) FROM User WHERE Karte = %s"
        cursor.execute(query, (karte,))
        count = cursor.fetchone()[0]
        return count > 0

    except database.Error as err:
        print(f"Fehler: {err}")
        return False

    finally:
        cursor.close()

def getName(karte):
    try:
        cursor = database.cursor()
        query = "SELECT u.Name FROM User u WHERE u.Karte = %s"
        cursor.execute(query, (karte,))
        result = cursor.fetchone()

        if result:
            return result[0]
        else:
            return "no User Found!"

    except database.Error as err:
        return "fFehler: {err}"

    finally:
        cursor.close()

def decodeMessage(line, ser):
    if checkKarte(line):
        time.sleep(1)
        karte=line
        ser.write(b'OK\n')
        print("sende OK", karte)

        time.sleep(1)
        name = getName(karte)
        print("Sende Name: ", name)
        ser.write(b'%s\n' % name.encode())
        time.sleep(1)

    elif line == " Setup Complete RFID":
        print("Setup Complete")

    elif line.startswith("X"):
        data = line[1:]
        UpdateDatabase(data)

    elif line == "Parkplatz":
         FreiePark()
         #print("Freie Parkplätze: ", count)
         #time.sleep(1)
         #ser.write(b'%c\n' % count.encode())

    else:
        #ser.write(b'FAIL\n')
        print("unerwartete Nachricht: ", line)

try:
    while True:
        if ser.in_waiting > 0:
            line = ser.readline().decode('utf-8', errors='ignore').rstrip()
            #print("raw Data:", line)
            decodeMessage(line, ser)

except KeyboardInterrupt:
    print("Programm beendet")

finally:
    ser.close()
    database.close()


#Version 2








