
# MC1 FS 2018 Test 2 - C

---

## 1. Angenommen Sie definieren im Modulrumpf (ausserhalb einer Funktion) folgendes:

`char s[]="hello"`

dann benötigt dies...

1. nur im SRAM Speicherplatz
2. nur im (Program-)Flash Speicherplatz
3. sowohl im SRAM wie auch im (Program-)Flash Speicherplatz

---

## 2. Wie kann man das BitNr 2 in PORTA auf 0 zurückgesetzt werden?

1. PORTA &= ~(1 << 2);
2. PORTA &= 0 << 2;
3. PORTA |= 0 << 2;

---

## 3. Die Adresse einer Variable x lässt sich wie folgt ermitteln

1. &x
2. *x
3. ^x

---

## 4. Der Datentyp int ist beim avr-gcc

1. 32bit breit
2. 16bit breit
3. 8bit breit

---

## 5. Welcher der folgenden Vorgänge benötigt auf dem Controller keinen Speicherplatz (weder Daten noch Programmcode)

1. Deklarationen
2. Referenzen
3. Definitionen

---

## 6. Was bewirkt 'static' bei der Definition einer lokalen Variable?

1. die "Lebensdauer" der Variable wird über den Funktionsaufruf hinaus verlängert
2. die Variable ist im gesamten aktuellen Modul sichtbar (aber nicht in anderen C-Modulen)
3. die Variable wird auf dem Stack angelegt

---

## 7. Arrays als Funktionsparameter können

1. nur via Pointer übergeben werden
2. nur wertemässig übergeben werden
3. sowohl wertemässig (als Array-Elemente) wie auch via Pointer (auf das Array) übegeben werden

---

## 8. Bei welchem Teilschritt werden Libraries (*.a) und Headerdateien ( *.h)eingelesen?

1. Libraries beim Compilieren, Headerdateien beim Linken
2. Headerdateien beim Compilieren, Libraries beim Linken
3. beides beim Compilieren

---

## 9. Wenn x ein Pointer auf einen Struct ist, dann ist folgender Zugriff sicher falsch:

1. z = (*z).y
2. z = *x.y
3. z = x->y

---

## 10. Beginnt eine Zeile in C mit einem Hash-Zeichen (#), so handelt es sich um ...

1. eine Kommentarzeile
2. eine Compiler-Option
3. eine Präprozessor-Anweisung

---

## 11. Ein Macro um das Quadrat zu berechnen sei wie folgt definiert:

`#define sqr(x) ((x)*(x))`

Welche der folgenden Anwendungen ist bezüglich Seiteneffekte problematisch:

1. y=sqr(a--);
2. y=sqr(a+b);
3. y=sqr(a*b);

---

## 12. Welche der folgenden Operationen ist in C eine logische AND-Verknüpfung?

1. A + B
2. A && B
3. A & B

---

## 13. Eine C Funktion kann der C-Compiler punkto Ausführungszeit am effizientesten umsetze, wenn sie wie folg deklariert wird:

1. static void foo(void){}
2. extern void foo(void){}
3. void foo(void){}

---

## 14. Angenommen es wird eine "Implicite Declaration" gemeldet, so geschieht dies ...

1. beim Linken der Objektdateien z.B. aufgrund einer fehlenden zugelinkten Bibliothek
2. beim Kompiliervorgang eines C-Modules z.B. aufgrund eines fehlenden #include
3. beim C-Präprozessing meist aufgrund fehlenden #define Anweisung

---

## 15. Floating Point Berechnungen mit avr-gcc ...

1. sind gar nich möglich (da float nicht unterstützt)
2. werden in der Library (avr-libc) behandelt
3. werden in der Floating Point Unit des Controllers behandelt

--- 

## 16. Angenommen Sie möchten den Wert a mit folgendem Ausdruck skalieren, wobei alle Variablen vom Typ int seien:

y = a / b * m;

so tritt dabei mit hoher Wahrscheinlichkeit folgendes Problem auf:

1. Zahlenüberlauf (coverflow)
2. es tritt kein Problem auf
3. Rundungsfehler > 1

---

## 17. In welchem Fall sollte eine Variable als 'volatile' definiert werden?

1. um die "Lebensdauer" der Variable zu vergrössern (über die Lebensdauer derFunktionsaufrufe hinaus)
2. wenn eine Variable in einem anderen Modul definiert ist
3. wenn auf die Variable sowohl aus Interrupt-Routinen wie aus dem Hauptprogramm zugegriffen wird

---

## 18. Structs als Funktionsparameter können ... 

1. immer nur wertemässig übergeben werden
2. immer nur via Pointer übergeben werden
3. sowohl weremässig wie auch via Pointer übergeben

---

## 19. Beim Aufruf von foo("bla") wird ...

1. die Adresse sowie die Länge des char-Array "bla" übergeben
2. das char-Array "bla" mit "Terminating Zero" wertemässig übergeben
3. nur die Speicheradresse des ersten Zeichen ('b') übergeben

---

## 20. Bei einer Berechnung mit Operatoren gleicher Priorität wie:

y = a * b / c

erfolgt die Berechnungsreihenfolge ...

1. von links nach rechts (also zuerst a * b)
2. von rechts nach links (also zuerst b / c)
3. compilerabhängig (da dies in C nicht definiert ist)

---

## 21. Angenommen Sie codieren

`char s[] = "bla";`

so ist...

1. sizeof(s) > strlen(s)
2. sizeof(s) < strlen(s)
3. sizeof(s) == strlen(s)

---

## 22. Welche Variablenart wird ohne Angabe eines Initialisierungswertes nicht initialisiert?

1. globale Variablen
2. normale lokale Variablen
3. lokale 'static' Variablen














