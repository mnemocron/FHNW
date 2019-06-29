
## Stimuli

### Stimuli Beschreibung

```vhdl
[label :] signal name <= expression {, expression};

[label :] signal name <= TRANSPORT expression AFTER time expression
{, expression AFTER time expression};

s <= TRANSPORT '0',
        '1' AFTER 20 ns,
        '0' AFTER 30 ns,
        '1' AFTER 40 ns,
        '0' AFTER 60 ns,
        '1' AFTER 110 ns,
        '0' AFTER 120 ns,
        '1' AFTER 140 ns,
        '0' AFTER 150 ns,
        '1' AFTER 170 ns,
        '0' AFTER 210 ns;
```

Anstelle einer Sensitivity-List steuert das WAIT-Statement 
den PROCESS:

```vhdl
[label :] PROCESS...
BEGIN
    ...
    WAIT FOR ...;
    ...
END PROCESS [label];


p_einmalige_sequenz : PROCESS -- keine Sensitivity-List!
BEGIN
    s <= '0';
        WAIT FOR 20 ns;
        s <= '1';
        WAIT FOR 10 ns;
        s <= '0';
        WAIT FOR 10 ns;
        s <= '1';
        WAIT FOR 20 ns;
        s <= '0';
        WAIT FOR 50 ns;
        ...
        s <= '1';
        WAIT FOR 40 ns;
        s <= '0';
WAIT; -- wait forever!
END PROCESS p_einmalige_sequenz;
```

Wiederkehrender Signalverlauf

```vhdl
p_clock_50MHz : PROCESS
BEGIN
clock <= '0'; -- Start der
    WAIT FOR 5 ns;
    clock <= '1';
    WAIT FOR 10 ns;
    clock <= '0';
    WAIT FOR 5 ns; -- Ende der
END PROCESS p_clock_50MHz;
```

---

### Monitor

```vhdl
[label :] WAIT [ON signal name {, signal name}] |
                [UNTIL condition] |
                [FOR time expression];
```

ASSERT-Statement:
– Überwachung von Signalen und Ist/Soll-Vergleiche

```vhdl
[label :] ASSERT condition [REPORT string expression] 
    [SEVERITY note | warning | error | failure];
```

`to_string(1-dim-vec/char/integer/real/time) RETURN string`

`to_hstring`

```vhdl
write(output, "all tests done");

write(output, "verification of number 0..." & lf);

-- Standard text files: 
 
file INPUT: TEXT open READ_MODE is "STD_INPUT"; 
 
file OUTPUT: TEXT open WRITE_MODE is "STD_OUTPUT"; 
```
