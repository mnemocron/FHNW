# dsv - MSP Vorbereitung

---

Themenübersicht, wichtigste Infos sowie Quellen.

---

## Einseitige z-Transformation

- wegen Anfangsbedingungen
- Verschiebungseigenschaft
- Endwertsatz
    + limes k->Inf.  =  imes z->1
- Kausalität
- 

---

## Spektralanalyse

### DFT

- Integral mit exp( -j * 2pi/T0 * n*t)
- "Unschärferelation": Frequenzauflösung vs. Beobachtungszeit
- Matrixnotation
- Zusammenhang zu Fourierkoeffizienten
    + X[n] = N * c_n
    + wenn Abtasttheorem eingehalten ist
    + und beobachtungszeit exakt eine Periode ist (oder ganzzahliges Vielfaches)

### FFT

- Butterfly Operation
- nur mit 2^n Abtastwerten möglich (keine Beliebige Beobachtungszeit)
- Decimation in Time
    + Eingangsvektor x[k] wird nicht in Reihenfolge angelegt
    + Zeitvektor in gerade und ungerade Indizes unterteilen
- Decimation in Frequency
    + Eingangsvektor x[k] wird in korrekter Reihenfolge angelegt
    + Ausgangsvektor X[k] liegt in reversed Bit Order an

### Goertzel Algorithmus

- genauere Analyse des Frequenzspektrums, nicht nur in n*fs/N Schritten
- mit Hilfe eines linearen Filters
- n muss nicht natürliche Zahl sein

### Windowing

- Wenn fs nicht ein ganzzahliges Vielfaches von fs ist, gibt es Sidelobes
- **Windowing**
- Breite der Hauptkeule
- Dämpfung der Nebenkeulen
- Kaiserfenster
    + kann minimale Nebenkeulendämpfung angegeben werden
- Fenster verzerrt Leistungsdichte


### Leistungsdichte

- Bratlett
    + Mittelwert mehrerer Zeitabschnitte
    + ohne Fensterfunktion
- Welch 
    + mit Fensterfunktion 
    + Zeitabschnitte können sich überlappen

---

## Filterentwurf

### Linearphasige Filter

- konstante Gruppenlaufzeit (Delay) = Ableitungs des Phasengangs
- 4 Typen
    + welche Filtertypen (LP, HP ...) kann man mit den FIR-Typen (1-4) bauen?
    + wenn fixe Nullstelle bei 0 ist, kein DC Anteil -> kein Lowpass
    + alle Typen haben einen Amplitudengang aus einer Summe von Cosinusanteilen

- Optimale Approximation
