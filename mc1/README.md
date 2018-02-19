# Microcontroller 1

---

## Assembler

### `avra` / `avrdude`

Auf Linux / Ubuntu for Windows. Für den ATmega2560 wird eine spezielle Version von `avra` benötigt. Zur installation werden weitere Packages benötigt:

```bash
$ sudo apt-get update
$ sudo apt-get install autoconf automake
```

[TimoFurrer/avra-atmega2560](https://github.com/timofurrer/avra-atmega2560)

[DarkSector/AVR/asm/include/m2560def.inc](https://github.com/DarkSector/AVR/blob/master/asm/include/m2560def.inc)

**Kompilieren:**

`avra helloworld.asm`

**Upload:**

`avrdude -p m2560 -c stk600 -U flash:w:helloworld.hex:i`


### Tutorials

[instructables](www.instructables.com/id/Command-Line-Assembly-Language-Programming-for-Ard/)


### Arduino IDE

Die Arduino IDE kann ebenfalls Assembler code kompilieren - ist jedoch etwas umständlich. Dies wendet zB. die Adafruit NeoPixel Library an um den zeitkritischen (Synchron-) Bitstream an die LEDs zu senden.

---
