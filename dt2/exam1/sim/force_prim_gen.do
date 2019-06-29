##---------------------------------------------------------------
## Name: Burkhardt
## Vorname: Simon
##---------------------------------------------------------------

restart

radix bin

force rst 1 0ns, 0 40ns
force en 0 0ns, 1 60ns, 0 260ns
force clk 0 0ns, 1 10ns -r 20ns

run 340ns


