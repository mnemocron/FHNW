/**
 * Arduino-InlineAssembly.ino
 * 
 * author: Simon Burkhardt
 * date:   2018-02-19
 * 
 * for Arduino Mega 2560
 */


void setup() {
  // put your setup code here, to run once:
  asm volatile (
    "ldi  r16, 0x05"  "\n\t"
    "ldi r17, 0x07"   "\n\t"
    "ldi r18, 0x00"   "\n\t"
    "add r18, r16"    "\n\t"
    "add r18, r17"    "\n\t"
  );
}

void loop() {
  // put your main code here, to run repeatedly:

}
