CON

  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000


OBJ

  Buttons          : "Touch Buttons"


PUB Main

  Buttons.start(_CLKFREQ / 100)                         ' Launch the touch buttons driver sampling 100 times a second
  dira[23..16]~~                                        ' Set the LEDs as outputs
  repeat
    outa[23..16] := Buttons.State                       ' Light the LEDs when touching the corresponding buttons 
    waitcnt(Clkfreq/1000 + CNT)
  