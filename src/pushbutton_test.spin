CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

VAR
  
   
OBJ
   pst: "Parallax Serial Terminal" 
   pins : "pin_numbers"
  
PUB Main
   pst.start(115_200)


   repeat

    dira[pins#PUSHBUTTON_UP]~
    dira[pins#PUSHBUTTON_DOWN]~
    pst.dec(ina[pins#PUSHBUTTON_UP])
    pst.dec(ina[pins#PUSHBUTTON_DOWN])
    pst.home
   