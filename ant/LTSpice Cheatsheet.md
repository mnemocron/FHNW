# LTSpice Cheatsheet

---

### OpAmp library

```
.lib opamp.sub
```

---

## 3db Cutoff Frequency

First, find the maximum attenuation, then calculate the frequency at the point where the amplification is 3db less than that.

```
.MEAS AC VUmax max mag(V(out))
.MEAS AC meas_3db when mag(V(out))=(VUmax/sqrt(2))
```

---

### Transformer

Couple inductances L1 and L2 with a transfer ratio K = 1

```
K L1 L2 1
```

#### Würth Electronics Midcom Library

- [we-online.com](https://www.we-online.com/web/en/passive_components_custom_magnetics/toolbox_pbcm/midcom_lt_spice.php)

---

### Voltage controlled switch to simulate FET

```
.model MYFET SW(Ron=1m Roff=1Meg Vt=.5 Vh=-.4)
```

---

## Monte Carlo Simulation

- Resistor Value = `{mc(10k,tolR)}`
- Spice directive: `.param tol = 0.1` (= 10%)
- AC Analysis: `.ac dec 10 1m 1Meg`
- Montecarlo Step: `.step param run 1 50 1` (`for i=1, i<=50, i+=1`)

