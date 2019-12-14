
# dst Fragekatalog

---

**Antworten sind nicht Musterlösungen - kein Gewähr auf Richtigkeit**


### Prüfung 2 2015

a) Wozu dient die System-ID in ihrem SopC?

> Für die Versionskontrolle von Hard- (.sof) und Softwareimages (.elf).
Softwareimages müssen auf die Hardware passen.


b) Sie wollen eine Funktion für eine FFT-Berechnung beschleunigen, ohne VHDL-Code schreiben zu müssen. Wie gehen Sie vor?

> Speicherzugriff verbessern --> TCM

> Custom Instruction: Gibt es einen VHDL Block im QSYS, der eine FFT implementiert? (ohne selber VHDL zu schreiben)

c) Was ist und wozu dient die HAL-API? 

> Hardware Abstraction Layer in Form einer C-Bibliothek.
Stellt C-Funktionen für Hardwarefunktionalitäten bereit.
Dadurch muss sich der Entwickler nicht um Low-Level kümmern.

d) Wozu wird der Nios II Core gerne eingesetzt, wenn auf dem gleichen FPGA auch ein ARM Prozessoren verfügbar ist? 

> der ARM Prozessor kann User Interfaces oder sogar ein Embedded Linux laufen lassen.
> Daher kann der Nios 2 für real-time Aufgaben eingesetzt werden.

e) Der Nios II Core selber hat kein Tristate Conduit Interface. Begründen Sie, wieso nicht? 

---

### Prüfung 2 2017

a) Wozu dient die JTAG-UART in ihrem SopC?

> JTAG wird benutzt um den FPGA zu Programmieren.
Im vergleich zum USB-Blaster kann mit UART ein definitives Beschreiben des FPGAs erreicht werden - nicht mehr umprogrammierbar.
 UART ?

(Musterlösung 2014)

> - SW-Download
> - Debug Schnittstelle
> - Console für sdtio

b) Wie kann man beeinflussen, dass die Abarbeitung von Interrupts möglichst schnell geschieht?

(Musterlösung 2014)

> - Tightly Coupled Instruction Memory für ISR
> - Tightly Coupled Data Memory für Exception Stack

c) Welche Abklärungen machen Sie, bevor Sie eine Floating-Point ALU in Ihr SopC einbauen? 

> - Kann die Berechnung auch mit Integer Arithmetik durchgeführt werden? z.B. 317uA benutzen anstatt 0.317mA
> - Falls float nötig, wird float-Division benötigt?
> - genügend Area vorhanden?

d) Nennen Sie drei Hilfsmittel, die Ihnen helfen aufzuzeigen, wo die Nios 2 CPU viel Rechenzeit benötigt.

> - GNU Profiler
> - Performance Counter
> - High performance Timer


e) Wozu dient ein Tristate Conduit Pin Sharer?

> Um phisikalische Pins am FPGA mit mehreren internen sowie externen Peripherien zu teilen / multiplexen.

---

### Prüfung 2 2016

(gemäss Mutsterlösung)

a) Beim Herunterladen des SW-Images auf das FPGA kommt folgende Fehlermeldung: 
`system timestamp mismatch` Nennen Sie zwei Ursachen hierfür? 

> - HW-Imaged (.sof) und SW-Image (.elf) Datein haben unterschiedliche Versionen (neuer / älter)
> - nach generieren mit QSYS sind nicht beide Dateien neu erstellt worden

b) Die Analyse von ihrem Software Code ergibt, dass die meiste CPU-Zeit in der Funktion `alt_u32 calculate_checksum (alt_u32 *memory_block_base_ptr)` verbraucht wird. Wie können Sie ihr System optimieren? 

> - TCM verwenden
> - Custom Instruction für die Checksummenbildung verwenden

c) Nennen Sie zwei Beispiele von *Character Mode Devices*?

> - stdout
> - UART
> - LCD Display
> - Filesystem (SD Card / Flash)

d) Verfügt der Nios II Core über eine Floating Point ALU? Begründen Sie.

> Nein! Die FPU alleine benötigt mehr teure FPGA ressourcen als der ganze restliche Nios 2 Core.

> vgl. SOPC_Folien_4 Seite 18/33 (2000 LE without divide / 5400 LE with divide)

e) Sie entwickeln ein Multiprozessorsystem mit zwei Nios2, welche sich ein BlockRAM für den Datenaustausch teilen. Was ist zu beachten beim Speicherzugriff? 

> Der Speicher stellt eine kritische Resource dar und muss mit einer durch mutual exclusion geschützt werden. --> Mutex Block

---

### Prüfung 2 2014

d) Was sind die Hauptgründe, weshalb der Nios II Core langsamer ist als die ARM Prozessoren auf den neuen SOC FPGAs? 

> Der Nios 2 wird als Softcore auf normale FPGA Hardware implementiert.
> Der ARM ist ein Hardcore und vollständig auf die Funktionalität als CPU Optimiert. Dadurch ist auch das Timing besser und der ARM kann höher getacktet werden. (200MHz vs. 800MHz)

--- 

### Prüfung 2 2013

b) Welche Vorteile bringen Tightly Coupled Memories?

> - Schneller Punkt-zu-Punkt Verbindung
> - keine Wartezeiten, weil kein Bus mit anderen Slaves

e) Ist das Avalon-MM Interface Multi-Master fähig? Falls nein, bitte begründen. Falls ja, nennen Sie ein Beispiel, wo dies zum Tragen kommt.

> - Ja,
> - Der DMA Controller übernimmt die Funktion des Masters, um unabhängig vom Nios 2 Daten von der Peripherie ins Memory zu schreiben.




