##---------------------------------------------------------------
## Name: Burkhardt
## Vorname: Simon
##---------------------------------------------------------------

restart

radix dec

force reset 1 0ns, 0 40ns
force clock 0 0ns, 1 10ns -r 20ns
force data_valid 0 0ns, 1 60ns
force data 0 0ns, 10 60ns, 5 80ns, 15 100ns, 10 120ns, 5 140ns, 15 160ns, 10 180ns, 5 200ns, 15 220ns,10 240ns


run 340ns


