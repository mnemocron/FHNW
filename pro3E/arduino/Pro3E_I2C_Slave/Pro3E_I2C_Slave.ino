#include <Wire.h>

#define BYTE_STATUS 0x11
#define BYTE_VOLT   0x22
#define BYTE_TEMP   0x33

// nur für Testzwecke
#define WIRE_OWN_ADDRESS 0x70

// um den Si8600 einzuschalten
#define PIN_ENABLE_WIRE A3

volatile uint8_t wire_action = 0;

void setup() {
  Wire.begin(WIRE_OWN_ADDRESS); // join i2c bus with own address
  Wire.onReceive(receiveEvent); // register event
  Wire.onRequest(requestEvent);
  Serial.begin(9600);           // start serial for output
  pinMode(PIN_ENABLE_WIRE, OUTPUT);
  digitalWrite(PIN_ENABLE_WIRE, HIGH);
}

void loop() {
  // put your main code here, to run repeatedly:
  delay(100);
}

void receiveEvent(int howMany) {
  uint8_t val = Wire.read();    // receive byte as an integer
  Serial.print(val);
  switch(val){
    case BYTE_STATUS:
      Serial.println(": request status");
      wire_action = BYTE_STATUS;
      break;
    case BYTE_VOLT:
      Serial.println(": request voltage");
      wire_action = BYTE_VOLT;
      break;
    case BYTE_TEMP:
      Serial.println(": request temperature");
      wire_action = BYTE_TEMP;
      break;
    default:
      // @Todo: hier weitere commands (nicht read request)
      // Turn balancing on/off
      break;
  }
}

// function that executes whenever data is requested by master
// this function is registered as an event, see setup()
void requestEvent() {
  switch(wire_action){
    case BYTE_STATUS:
      Serial.println("send status y");
      Wire.write("y");  // = ok
      break;
    case BYTE_VOLT:
      Serial.println("send voltage 42");
      Wire.write(random(2,4)); // generate radnom data for testing the master
      Wire.write(random(0,9)); // @Todo: Konvention für Spannungsbytes -> Dennis
      break;
    case BYTE_TEMP:
      Serial.println("send temperature");
      Wire.write("T="); // generate radnom data for testing the master
      Wire.write(random(255));
      Wire.write(random(255));
      Wire.write(random(255));
      break;
    default:
      break;
  }
  wire_action = 0;
  Serial.print(wire_action);
  Serial.println(" = reset");
}


