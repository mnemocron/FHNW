#include <Wire.h>

#define BYTE_STATUS 0x11
#define BYTE_VOLT   0x22
#define BYTE_TEMP   0x33

// nur für Testzwecke
#define WIRE_SLAVE_ADDRESS 0x70

// globale Variablen um den Status eines aktuellen Slave BMS' abzuspeichern
// volatile weil diese von Wire Interrupts verändert werden
volatile float slave_voltage = 4.0f;
volatile uint8_t slave_status = 0;
volatile uint8_t slave_voltage_bytes[2] = {0,0};
volatile uint8_t slave_temperature_bytes[5] = {0,0,0,0,0};

void setup() {
  // put your setup code here, to run once:
  Wire.begin(); // join i2c bus (address optional for master)
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  
  Serial.println("requesting status");
  requestFromSlave(WIRE_SLAVE_ADDRESS, BYTE_STATUS, 1);
  Serial.println("requesting voltage");
  requestFromSlave(WIRE_SLAVE_ADDRESS, BYTE_VOLT, 2);
  Serial.println("requesting temperature");
  requestFromSlave(WIRE_SLAVE_ADDRESS, BYTE_TEMP, 5);

  slave_voltage = calculateSlaveVoltage(slave_voltage_bytes[0], slave_voltage_bytes[1]);
  Serial.print("Slave status: ");
  Serial.println((char)slave_status);
  Serial.print("Voltage: ");
  Serial.println(slave_voltage);
  Serial.print("Temperature: ");
  for(int i=0; i<5; i++){
    Serial.print((char)slave_temperature_bytes[i]);
  } Serial.println();
  
  delay(3000);
}

/**
 * @Todo korrekte Konvention für Spannungs werte -> Dennis
 */
float calculateSlaveVoltage(uint8_t hibyte, uint8_t lobyte){
  return (float)hibyte + ((float)lobyte)/10.0f;
}

/**
 * Funktion um mehrere Datenbytes von den Slave BMS Boards zu holen
 */
void requestFromSlave(uint8_t addr, uint8_t reg, uint8_t len){
  Wire.beginTransmission(addr);   // start
  Wire.write(reg);                // write the request command
  Wire.endTransmission(false);    // restart
  Wire.requestFrom(addr, len);    // request the bytes
  uint8_t i = 0;
  while (Wire.available()) {      // read all bytes
    char c = Wire.read();
    if(reg == BYTE_STATUS)
      slave_status = (uint8_t)c;
    if(reg == BYTE_VOLT)
      slave_voltage_bytes[i%2] = (uint8_t)c;
    if(reg == BYTE_TEMP)
      slave_temperature_bytes[i%5] = (uint8_t)c;
    i++;
  }
  Wire.endTransmission();         // stop
}





