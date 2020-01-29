# dst - MSP Vorbereitung

---

Themenübersicht, wichtigste Infos sowie Quellen.

---

## Kolloquium

- zwei Themen
- 1. Schwerpunkt: Themen + Kontext
- 2. Verständnisfragen: allgemein, dann detailierter


---

## 0. VHDL Brush UP

- 7 Grundregeln zu VHDL (Handout)
    + Flip-Flops erkennen


---

## 1. Advanced FPGA

### Clock Domain Crossing / CDC

- Signal Synchronisation
- Methods & Circuits to Protect/Synchronize

**Kontrollfragen CDC**

> 1. Erklären Sie das Phänomen von Metastabilen Zuständen bei Flipflops und warum diese in der Digitalen Schaltungstechnik unerwünscht sind. 
> 2. Wann kommt es zu Metastabilen Zuständen bei Flipflops? 
> 3. Wie helfen einem ein RTL Simulator oder ein Statischer Timing Analyzer bei der Suche nach Metastabilen Zuständen? 
> 4. Welche Elemente der folgenden Formel kann man beeinflussen, und wie? Tck-Q + Tmet + Tdly < Tperiod – Tsu 
> 5. Welche Gefahren lauern bei SRL (Shieberegister) und Bock RAM (BRAM)? 
> 6. Welche Synthese Constraints sollte man bei 2-FF Synchronizer definieren? 
> 7. Welche Problematik kommt hinzu, wenn ganze Datenbusse synchronisiert werden müssen? 
> 8. Wie werden Datenbusse geeignet synchronisiert (mehrere Varianten)? 
> 9. Welche Synchronisationsmethoden gibt es bei den Reset-Signalen? 

#### Reset Synchronisation

- asynchron: reset Signal direkt, ohne FF
- synchron: reset Signal über dual-FF synchronisiert
- Asynchronous Assertion, Synchronous Deassertion
- reset weglassen (FIR)

#### Datensynchronisation

- Phase Control beider Clocks
- double flopping
- FIFO

#### Timing Constraints

- T input min/max
- T output min/max

### CORDIC algorithm

**Kontrollfragen Cordic**

> 1. Erklären Sie das Konzept des Cordic Algorithmus. 
> 2. Welche Zusammenhänge bestehen zwischen tan(φ) und 2-i?

- Die φ wird eingeschränkt, so dass die Rotation jeweils mit einer Multiplikation mit +/- 2^(-i) erreichbar ist
 
> 3. Was hat es auf sich mit den Skalier-Faktoren 0.6073 und 1.647? 

Die Resultate sind im Betrag um 0.6073 zu klein (?).
Der ganze Rotation Mode hat einen Gain von 1.647

> 4. Was ist der Unterschied zwischen dem Rotations-Mode und dem Vector-Mode? 
> 5. Was ist der Unterschied zwischen dem Zirkulären Mode und dem Linearen Mode? 
> 6. Wie wird ein Vektor um 90 Grad gedreht? 

- geht ohne Cordic, Vorzeichen und Argumente des Vektors tauschen

> 7. Wie wird ein Vektor um 180 Grad gedreht?

- geht ohne Cordic, Vorzeichen vom Vektor ändern

> 8. Aus welchen Elementen besteht die Hardware, um eine Cordic-Iteration zu berechnen? 

- Shift Register (2^-i), Multiplikatoren, Additionen

> 9. Skizzieren die Hardware für eine Cordic-Iteration. 

- Big Table with Inputs, Outputs & Modes (Fosa), MUX (?) (für di)

### Fixed & Floating Point

#### endliche Genauigkeit (Runden)

- Saturation (upper & lower limits)
- Wrapping / Wrap-around
- Truncation (floor)
- Round


---

## 2. Structured Analysis / Structured Design - SA/SD 

- Systemanalyse = SA + SD
- Prozessspezifikationen
- keine Vierecke, Kreisli und Härdöpfel
- richtige Begriffe verwenden (CD, DFD, DD, DS, (PS?))
- Context Diagram
    + **rundes** System
    + **eckige** externe Akteure
- Data Flow Diagram
    + Prozesse (rule of 7)
- Data Dictionary
    + Name | Type | Source | Description
- System DFD


---

## 3. System on programmable Chip - SopC

### Fragen zur SopC HW-Umgebung


> 1. Welche drei Tools sind zentral, wenn man ein Nios II System entwickelt? 
> 2. Welche Resultate (Files) werden von den drei Tools generiert?

- QSYS ---> SopC Infofile .sopcinfo
- Quartus ---> Konf file .sof
- eclipse ---> SW Image (.elf)

> 3. Nennen Sie je zwei Vor- und Nachteile des Nios II: 
> 4. Wie kommt meine Hardware-Konfiguration auf das FPGA? 
> 5. Wie startet das SopC-System auf? 

- Hardware-Konfiguration laden (siehe Punkt 4)
- SW Boot Vorgang
- alt_main()
- alt_sys_init()
- main()
- exit()

> 6. Ein SW-Projekt in der NIOS-II IDE besteht aus zwei Teilprojekten. Wieso diese Unterteilung und was befindet sich in den beiden Teilprojekten? 
> 7. Was ist die HAL Libarary und wozu dient sie? 
> 8. Welche Kommandos kennt das Nios-II SBT um ein Projekt zu kompilieren und zu linken, bzw. auf dem Development Board ausführen zu lassen? 


### SDRAM Clock Lag/Lead

- Phase Shift notwendig oder nicht?
- PLL Phase

### Avalon BUS

– Avalon Memory Mapped Interface 
– Avalon Streaming Interface
– Avalon Memory Mapped Tristate Interface
– Avalon Clock
– Avalon Interrupt
– Avalon Conduit

> 1. Wozu dient das Avalon Interface 
> 2. Wie viele verschiedene Avalon Interfaces gibt es? Listen Sie diese auf: 
> 4. Nennen Sie ein Beispiel für eine Komponente, die über beides, sowohl Clock Sink als auch Clock Source verfügt. 
> 5. Nennen Sie ein Beispiel für eine Komponente, die über zwei Clock Sinks verfügt. 
> 6. Nehmen Sie an, Sie wollen mit einem Altera_Avalon_PIO 16 Kippschalter einlesen. 
Welche Avalon Interfaces und welche Signal Typen benötigen Sie? 
> 7. Welches sind die elementaren Signale für einen Avalon-MM Slave Transfer?
> 8. Wozu wird das zusätzliche Signal waitrequest benötigt? 
> 9. Wozu wir das zusätzliche Signal readdatavalid benötigt? 
> 10. Beschreiben Sie den Ablauf für folgendes Timing
> 11. Kreuzen Sie die richtigen Antworten an: 
> 12. Welche Datenbreiten kann eine Slave Port haben? 
> 13. Wie geht der Master vor, wenn die Datenbreite von Master und Slave nicht 
übereinstimmen?
> 14. Zeichnen Sie die Richtung (Input/Output) für die jeweiligen Signale ein. 
> 15. Ein Master Write Burst Zugriff mit der Burstlänge 8 dauert exakt 8 Taktzyklen.
> 16. Wozu dient das Interrupt Interface? 
> 17. Über welche Signale verfügt das Interrupt Interface, was haben sie für eine Funktion und 
von wem warden sie erzeugt? 
> 18. Welcher Interrupt ist zuerst aufgetreten (Bild oben)? 
> 19. Welcher Interrupt wurde zuerst abgearbeitet (Bild oben)? 
> 20. Welche Aufgabe hat die Tristate Conduit Bridge? 

- Punkt zu Punkt Verbindung von on-chip Komponenten zu off-chip Peripherie.

> 21. Welche Aufgabe hat der Tristate Conduit Pin Sharer? 

- findet Signale, die sich wie Tristate verhalten und fasst diese auf einem Bus zusammen

> 22. Wozu dient das Avalon Streaming Interface? 
> 23. Von wo nach wo fliessen die Daten in einer Avalon Streaming Connection? 
> 24. Wie heisst der Fachbegriff, wenn der Empfänger den Datenaustausch unterbricht, weil er die ankommenden Daten nicht mehr entgegennehmen kann (weil. z.B. sein FIFO voll ist) und mit welchem Signal wird dies angezeigt? 
> 25. Zeichnen Sie das in vorheriger Frage gesuchte Signal in folgendem Timing Diagramm ein. 
> 26. Was wird mit dem Signal empty während einem Packet Transfer übermittelt und was hätte es für einen Wert, wenn 37 Bytes über 8 Channel bei einer Symbolgrösse von 8 Bit übertragen werden. 
> 27. Wozu dient das Conduit Interface? 


### CPU Optimization

- Tightly Coupled Memory (TCM)
- Custom Instruction (direkt Teil der CPU)
    + Combinatorial
    + Multi-Cycle
    + Extended (Comp + Mux)
    + Internal Register File
- Custom-Peripheral (über Avalon)
- Floating Point
- Multi-Core
    + MUTEX

**Fragen zur Optimierung von Nios II Systemen**

> 1. Nennen Sie drei Varianten, wie man eine Multiply-Accumulate Struktur mit dem Nios-II realisieren kann. Erläutern Sie die Vor- und Nachteile der einzelnen Varianten. 


---

## 4. Advanced Verification

### Code Coverage

- Line Coverage
- Statement Coverage
- Branch Coverage (every possible branch entered?)
- Condition Coverage (every condition tested?)
- Expression Coverage
    + UDP (test only necessary combinations)
    + FEC (change one property while others are fixed)

### Functional Coverage

- are all Requirements/Specifications covered by the code
- Was sind die 4 Zustände eines Properties?
    + inactive, active, pass, fail

### Functional Safety

- Worum geht es?

