CON

  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000


OBJ

  Buttons          : "Touch Buttons"
  pst              : "Parallax Serial Terminal"

PUB Main
  pst.Start(115_200)
  Buttons.start(_CLKFREQ / 100)                         ' Launch the touch buttons driver sampling 100 times a second
  dira[23..16]~~                                        ' Set the LEDs as outputs
  pst.Str(string("Hi Andrew!! It's Propellery!!!!!"))
  pst.NewLine
  pst.Str(string(" press the button the left if you think 1 + 1 = 2, and"))
  pst.NewLine
  pst.Str(string("press the button on the right if you think 1 + 1 = 3!"))                                       
  repeat
    'if 
    outa[23..16] := Buttons.State                 ' Light the LEDs when touching the corresponding buttons 

    if Buttons.State == %10000000
        waitcnt(clkfreq / 100 + cnt) 
        pst.Clear
        waitcnt(clkfreq / 100 + cnt)
        pst.Str(string("You're Right!!"))
        pst.NewLine
        pst.Str(string("press the 2 middle buttons to see the question again"))

    if Buttons.State == %00000001
        waitcnt(clkfreq / 100 + cnt) 
        pst.Clear
        waitcnt(clkfreq / 100 + cnt) 
        pst.Str(string("Sorry, Nope!"))
        pst.NewLine
        pst.Str(string("press the 2 middle buttons to see the question again"))
        


    if Buttons.State == %00011000
        waitcnt(clkfreq / 100 + cnt) 
        pst.Clear
        waitcnt(clkfreq / 100 + cnt)
        pst.Str(string(" press the button the left if you think 1 + 1 = 2, and"))
        pst.NewLine
        pst.Str(string("press the button on the right if you think 1 + 1 = 3!"))

    
    waitcnt(clkfreq / 100 + cnt) 
         

