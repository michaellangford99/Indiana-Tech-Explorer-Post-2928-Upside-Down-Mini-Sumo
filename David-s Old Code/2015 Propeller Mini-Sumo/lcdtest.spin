''This code example is from Propeller Education Kit Labs: Fundamentals, v1.2.
''A .pdf copy of the book is available from www.parallax.com, and also through
''the Propeller Tool software's Help menu (v1.2.6 or newer).
''
'' IrObjectDetection.spin
'' Detect objects with IR LED and receiver and display with Parallax Serial Terminal.

CON
   
  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000

var
  long x

OBJ
    
  lcd : "Debug_Lcd"
  'Buttons          : "Touch_Buttons"

PUB Main


   lcd.init(0, 2400, 4)
   
   'BUTTONS.start(_CLKFREQ / 1000)

   repeat
        
        waitcnt(clkfreq+cnt)
        lcd.str(string($1b))
        lcd.str(string($43))
        lcd.str(string(1))'home'
        lcd.str(string("but i am nice"))
          
        waitcnt(clkfreq+cnt)
        lcd.str(string($1b))
        lcd.str(string($43))
        lcd.str(string(1))'home'
        lcd.str(string(" Buy DavidProtect!!       "))    