//import the library in the sketch
#include <SharpIR.h>
#include <Wire.h>

//Create a new instance of the library
//Call the sensor "sensor"
//The model of the sensor is "GP2YA41SK0F"
//The sensor output pin is attached to the pin A0
SharpIR sensorA0( SharpIR::GP2Y0A41SK0F, A0 );
SharpIR sensorA1( SharpIR::GP2Y0A41SK0F, A1 );
SharpIR sensorA2( SharpIR::GP2Y0A41SK0F, A2 );
SharpIR sensorA3( SharpIR::GP2Y0A41SK0F, A3 );

enum AnalogPin { A, B, C, D }; // Enum für Analogpins
enum Staus { RESERVIERT, FREI, BESETZT };

class Parkplatz {
  private:
    enum Color { RED, GREEN };
    Staus ParkplatzStatus;
    Staus RealStaus;
    int pinLEDGreen;
    int pinLEDRed;
    bool RedLED;
    bool GreenLED;
    AnalogPin sensorPin;

    void updateLED(){
      if (RealStaus == FREI){
        if (ParkplatzStatus == RESERVIERT){
          setLED(GREEN, false);
          setLED(RED, true);
        } else {
          setLED(GREEN, true);
          setLED(RED, false);
        }

      } else {
        setLED(GREEN, false);
        setLED(RED, true);
      }
    }

    void isPresent(){
      int distance;
      switch (sensorPin){
        case A:
          distance = sensorA0.getDistance();
          break;
        case B:
          distance = sensorA1.getDistance();
          break;
        case C:
          distance = sensorA2.getDistance();
          break;
        case D:
          distance = sensorA3.getDistance();
          break;
      }
      
      if (distance <= 15) {
        RealStaus = FREI;
      } else {
        RealStaus = BESETZT;
      }

      updateLED();
      //Serial.print( "\tDistance: " + String(distance) + "\tParkplatz: " + String(sensorPin));
    }

    bool getLED(Color LED) {
      switch (LED){
        case RED:
          return RedLED;

        case GREEN:
          return GreenLED;
      }
    }

    void setLED(Color LED, bool Status) {
      switch (LED){
        case RED:
          RedLED = Status;
          digitalWrite(pinLEDRed, Status);

          break;

        case GREEN:
          GreenLED = Status;
          digitalWrite(pinLEDGreen, Status);
          break;

        default:
          break;
      }
    }

  public:
    // Konstruktor
    Parkplatz(int greenPin, int redPin, AnalogPin sensor) {
      pinLEDGreen = greenPin;
      pinLEDRed = redPin;
      sensorPin = sensor;
      pinMode(pinLEDGreen, OUTPUT);
      pinMode(pinLEDRed, OUTPUT);
      RealStaus = FREI;
      ParkplatzStatus = BESETZT;

    }

    void Update(){
      isPresent();
    }

    Staus getStatus(){
      Update();
      if (ParkplatzStatus == RESERVIERT ) { 
        return RESERVIERT; 
      } else { 
        return RealStaus;
      }
    }

    String getStatusAsString() {
      switch (getStatus()) {
        case FREI: return "F"; // 0 für FREI
        case RESERVIERT: return "R"; // 1 für RESERVIERT
        case BESETZT: return "B"; // 2 für BESETZT
        default: return "X"; // Fehlerwert
      }
    }

    void setStatus(Staus newStatus){
      Update();
      ParkplatzStatus = newStatus;
      if (newStatus == RESERVIERT) {
          setLED(GREEN, false);
          setLED(RED, true);
      } else if (newStatus == FREI){ 
          setLED(GREEN, true);
          setLED(RED, false);
      }
    }

};

Parkplatz parkplaetze[] = {
  Parkplatz(11, 12, A),
  Parkplatz(9, 10, B),
  Parkplatz(7, 8, C),
  Parkplatz(5, 6, D)
};

void SetParkplatz(Staus NewStatus, int index) {
  parkplaetze[index].setStatus(NewStatus);
}

void DecodeMessage(String message) {
  // Überprüfe, ob die Nachricht die Länge 2 hat (z. B. "F1" oder "R2")
  if (message.length() == 2) {
    char action = message.charAt(0); // F oder R
    int index = message.charAt(1) - '0'; // Umwandlung von char zu int
    if (index >= 0 && index <= 9) { // Überprüfen, ob n zwischen 0 und 4 liegt
      switch (action) {
        case 'F': // Aktion für frei
          SetParkplatz(FREI, index); // Parkplatz als frei markieren
          break;

        case 'R': // Aktion für reserviert
          SetParkplatz(RESERVIERT, index); // Parkplatz als reserviert markieren
          break;

        default:
          break;
      }
    }
  }
}

void receiveEvent(int howMany) {
  String receivedString = "";
  while (1 < Wire.available()) {
    char c = Wire.read();
    receivedString += c;
  }
  char lastChar = Wire.read();
  receivedString += lastChar;
  Serial.println("Empfangener String: " + receivedString);
  DecodeMessage(receivedString);
}

void requestEvent() {
    String statusString = ""; // String zum Speichern der Status

    for (int i = 0; i < 4; i++) {
        parkplaetze[i].Update(); // Aktualisiere den Parkplatzstatus
        statusString += parkplaetze[i].getStatusAsString(); // Füge den Status zum String hinzu
    }

    Wire.write(statusString.c_str()); // Sende den Status als C-String
}


void setup() {
  Wire.begin(4);
  Wire.onReceive(receiveEvent);
  Wire.onRequest(requestEvent);
  Serial.begin( 9600 ); //Enable the serial comunication
  
  for (int i=5; i<=12; i++){
    digitalWrite(i, HIGH);
  }
  delay(1600);
  for (int i=5; i<=12; i++){
    digitalWrite(i, LOW);
  }

  Serial.println("Setup Complete IR\n\n--------------\n");
}

void loop(){
  String statusString = "";
  delay(200);
  for (int i = 0; i < 4; i++) {
    //Serial.print("Parkplatz: " + String(i) + "\tStatus: " + String(parkplaetze[i].getStatus()) );
    parkplaetze[i].Update();
  }

  //delay(1000);
}