CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

VAR
  
   
OBJ
   pst: "Parallax Serial Terminal"
  
PUB Main
   pst.start(115_200)


   repeat

    dira[26..27]~
    pst.dec(ina[26])
    pst.dec(ina[27])
    pst.home
   