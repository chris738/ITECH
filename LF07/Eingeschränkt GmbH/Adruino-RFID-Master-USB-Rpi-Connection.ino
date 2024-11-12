#include <SharpIR.h>
#include <Wire.h>

//IR Sensor
#define IR          A0
SharpIR sensor( SharpIR::GP2Y0A41SK0F, IR);

//Ampel
#define RED         8
#define GREEN       7
#define BLUE        2

//RFID
//Diese Pins müssen angepasst werden (GPIO Pin von der Liste oben)
#define RST_PIN     9
#define SS_PIN      10
#include <SPI.h>
#include <MFRC522.h>
MFRC522 mfrc522(SS_PIN, RST_PIN);
#define LCD         8
#define IR          4


//Setper Motor
#define STEPPER_PIN_1 6
#define STEPPER_PIN_2 5
#define STEPPER_PIN_3 4
#define STEPPER_PIN_4 3
int step_number = 0;

//Wire (I²C)
byte x = 0;

void setup() {

  //Wire I2C
  Wire.begin();
  Serial.begin(9600);

  SPI.begin();
  mfrc522.PCD_Init();

  //Ampel
  pinMode(RED, OUTPUT);
  pinMode(GREEN, OUTPUT);
  pinMode(BLUE, OUTPUT);

  //Schranke
  pinMode(STEPPER_PIN_1, OUTPUT);
  pinMode(STEPPER_PIN_2, OUTPUT);
  pinMode(STEPPER_PIN_3, OUTPUT);
  pinMode(STEPPER_PIN_4, OUTPUT);

  //Setup Complete
  i2csend("Setup Complete", LCD);
  i2csend("% ", LCD);

  digitalWrite(RED, HIGH);
  digitalWrite(GREEN, HIGH);
  delay(1000);
  digitalWrite(RED, LOW);
  digitalWrite(GREEN, LOW);
  Serial.println(" Setup Complete RFID");
}

bool IRSensor(){
  int dist = sensor.getDistance();
  if (dist <= 20) {
    return false;
  } else {
    return true;
  }
}

void accessGranted() {
  i2csend("Willkommen, ", LCD);
  openGate();
  delay(2000);

  while (IRSensor()){
     i2csend("Auto vor Schranke", LCD);
     delay(100);
  }
  delay(2000);
  closeGate();
  delay(1000);
}

void accessRefused() {
   //Serial.println(" Access Refused ");
   digitalWrite(RED, HIGH);
   digitalWrite(GREEN, LOW);
   i2csend("Access Refused!", LCD);
   //i2csend("% ", LCD);
   delay(1000);
}

void RFID() {
  if ( ! mfrc522.PICC_IsNewCardPresent()) {
    return;
  }
  if ( ! mfrc522.PICC_ReadCardSerial()) {
    return;
  }
  String content= "";

  for (byte i = 0; i < mfrc522.uid.size; i++) {
     content.concat(String(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " "));
     content.concat(String(mfrc522.uid.uidByte[i], HEX));
  }
  content.toUpperCase();
  MFRC522::PICC_Type piccType = mfrc522.PICC_GetType(mfrc522.uid.sak);
  String UID=content.substring(1);
  checkAccess(UID);
  delay(100);
  digitalWrite(RED, LOW);
  digitalWrite(GREEN, LOW);
}

bool waitForSerial(int maxWait, String Message) {
  int wait = 0;
  while (Serial.available() == 0) {
    i2csend(Message, LCD);
    delay (100);
    wait = wait + 1;
    if (wait > maxWait) {
      i2csend("timeout", LCD);
      return false;
    }
  }
  i2csend(" ", LCD);
  return true;
}

void getSerialName(){
  //waiting for response
  if( waitForSerial(10, "Warte auf Name") ){
    String Name = Serial.readStringUntil('\n');
    Name = "%" + Name;
    i2csend(Name, LCD);
  }
}

bool checkAccess(String uidTag) {

  //Sende UID Tag
  Serial.println(uidTag);

  //Warte auf Antwort
  if ( waitForSerial(10,"Warte auf Zugriff") ) {
    String response = Serial.readStringUntil('\n');

    //Antwort OK:
    if ( response.equals("OK") ) {
      getSerialName();
      //Serial.print("get Name\n");
      if ( FreiePark() ) {
	//Serial.print("Freie Parkplätze\n");
        accessGranted();
        //i2csend("AccessGranted..", LCD);
        delay(1000);
        return true;
      } else {
	accessRefused();
        return false;
      }
    } else {
      i2csend("%ungültige ID!", LCD);
    }
  }
  accessRefused();
  i2csend("%ungültige ID", LCD);
  return false;
}

void i2csend(String ToSend, int slaveID){
  Wire.beginTransmission(slaveID);
  Wire.write(ToSend.c_str(), ToSend.length());
  Wire.endTransmission();
  //delay(500);
}

bool FreiePark() {
  bool frei=false;
  Serial.print("Parkplatz\n");
  //delay(1000);
  if( waitForSerial(25, "Prüfe ob Frei") ){
    String parkpl = Serial.readStringUntil('\n');

    //Serial.print("Debug Response Str: ");
    //Serial.println(parkpl);

    int count = parkpl.toInt();
    //Serial.print("Debug response Int: ");
    //Serial.println(count);

    if (count > 0) {
      i2csend("Frei !", LCD);
      frei=true;
    } else {
      i2csend("Besetzt !", LCD);
      frei=false;
    }
  }
  return frei;
}

String i2cRequest(int slaveID) {
  String result = "";
  Wire.requestFrom(slaveID, 32);
  if (Wire.available()) {
    while (Wire.available()) {
      char c = Wire.read();
      result += c;
    }
  } else {
      result = "Keine Daten";
  }
  return result;
}

void OneStep(bool dir){
  if(dir){
    switch(step_number){
      case 0:
        digitalWrite(STEPPER_PIN_1, HIGH);
        digitalWrite(STEPPER_PIN_2, LOW);
        digitalWrite(STEPPER_PIN_3, LOW);
        digitalWrite(STEPPER_PIN_4, LOW);
      break;

      case 1:
        digitalWrite(STEPPER_PIN_1, LOW);
        digitalWrite(STEPPER_PIN_2, HIGH);
        digitalWrite(STEPPER_PIN_3, LOW);
        digitalWrite(STEPPER_PIN_4, LOW);
      break;
      case 2:
        digitalWrite(STEPPER_PIN_1, LOW);
        digitalWrite(STEPPER_PIN_2, LOW);
        digitalWrite(STEPPER_PIN_3, HIGH);
        digitalWrite(STEPPER_PIN_4, LOW);
      break;
      case 3:
        digitalWrite(STEPPER_PIN_1, LOW);
        digitalWrite(STEPPER_PIN_2, LOW);
        digitalWrite(STEPPER_PIN_3, LOW);
        digitalWrite(STEPPER_PIN_4, HIGH);
      break;
   }
  } else {
      switch(step_number){
        case 0:
          digitalWrite(STEPPER_PIN_1, LOW);
          digitalWrite(STEPPER_PIN_2, LOW);
          digitalWrite(STEPPER_PIN_3, LOW);
          digitalWrite(STEPPER_PIN_4, HIGH);
        break;
        case 1:
          digitalWrite(STEPPER_PIN_1, LOW);
          digitalWrite(STEPPER_PIN_2, LOW);
          digitalWrite(STEPPER_PIN_3, HIGH);
          digitalWrite(STEPPER_PIN_4, LOW);
        break;
        case 2:
          digitalWrite(STEPPER_PIN_1, LOW);
          digitalWrite(STEPPER_PIN_2, HIGH);
          digitalWrite(STEPPER_PIN_3, LOW);
          digitalWrite(STEPPER_PIN_4, LOW);
        break;
        case 3:
          digitalWrite(STEPPER_PIN_1, HIGH);
          digitalWrite(STEPPER_PIN_2, LOW);
          digitalWrite(STEPPER_PIN_3, LOW);
          digitalWrite(STEPPER_PIN_4, LOW);
    }
  }
  step_number++;

  if(step_number > 3){
    step_number = 0;
  }
}

void openGate() {
  digitalWrite(GREEN, HIGH);
  digitalWrite(RED, HIGH);
  for (int i = 0; i < 700; i++){
    OneStep(false);
    delay(2);
  }
  digitalWrite(RED, LOW);
}

void closeGate() {
  digitalWrite(RED, HIGH);
  for (int i = 0; i < 700; i++){
    OneStep(true);
    delay(2);
  }
  digitalWrite(GREEN, LOW);
}

void UpdateDatabase() {
  String result = i2cRequest(IR);
  Serial.print("X");
  Serial.print(result);
  Serial.print("\n");
}

void loop() {
  RFID();

  digitalWrite(BLUE, HIGH);
  delay(500);

  UpdateDatabase();

  digitalWrite(BLUE, LOW);
  delay(500);
}

//Version 2
