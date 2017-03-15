CON
   
  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000

OBJ
                                
  lcd         : "Serial_LcdMJL"  

Var
long x  
PUB Main
            
  lcd.init(12, 2400, 4)
  lcd.cls

  lcd.str(string("MiniSumo"))
  lcd.gotoxy(0, 1)
  lcd.str(string("  LCD!  "))
  repeat
    x++
    waitcnt(clkfreq/1 + cnt)
    lcd.gotoxy(0, 1)
    lcd.dec(x)