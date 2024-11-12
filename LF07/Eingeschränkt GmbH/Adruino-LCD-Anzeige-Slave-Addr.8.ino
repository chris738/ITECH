// include the library code:
#include <LiquidCrystal.h>
#include <Wire.h>

// initialize the library by associating any needed LCD interface pin
// with the arduino pin number it is connected to
const int rs = 12, en = 13, d4 = 8, d5 = 9, d6 = 10, d7 = 11;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);

void setup() {
  
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.print("hello, world!");
  
  Serial.begin(9600);
  Wire.begin(8);                // join I2C bus with address #8
  Wire.onReceive(receiveEvent); // register event
}

void decodeMessage(String Message) {
  if (Message.charAt(0) == '%') {
    String newMessage = Message.substring(1);  // Entfernt das '%'
    LCDUpdate(1, newMessage);  // Übergebe die Nachricht an die zweite Zeile
  } else {
    LCDUpdate(0, Message);  // Übergebe die gesamte Nachricht an die erste Zeile
  }
}


void receiveEvent(int howMany) {
  String receivedString = "";  // Initialize an empty string to store the received data
  
  while (Wire.available() > 1) { // Loop through all but the last
    char c = Wire.read();        // Receive byte as a character
    receivedString += c;         // Append character to string
  }

  // Read the last byte
  char c = Wire.read();          // Receive the last byte as a character
  receivedString += c;           // Append the last character to the string
  
  // Now you can use `receivedString` for further processing
  Serial.print("\nFull String: ");
  Serial.println(receivedString);  // Print the full concatenated string
  decodeMessage(receivedString);
}

void LCDUpdate(int zeile, String message) {
  lcd.setCursor(0, zeile);
  lcd.print("                ");  // Passe die Anzahl der Leerzeichen je nach LCD-Breite an
  lcd.setCursor(0, zeile);
  lcd.print(message);
}

void loop() {
  // set the cursor to column 0, line 1
  // (note: line 1 is the second row, since counting begins with 0):
  //lcd.setCursor(0, 1);
  // print the number of seconds since reset:
  //lcd.print(millis() / 1000);
  delay(200);
}
