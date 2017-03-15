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
    
  lcd     : "Debug_Lcd"
  Buttons : "Touch Buttons"

VAR

  long state, routine, routine_name

PUB Main

              
   lcd.init(15, 2400, 4)
   routine := 0
   BUTTONS.start(_CLKFREQ / 1000)
   lcd_clear
   
   repeat
        state := Buttons.state
        buttoncheck
        waitcnt(clkfreq/10 + cnt)  
        lcd.str(string(1))
        lcd.bin(state, 8)
        lcd.str(string(" routine :"))
        lcd.dec(routine)
        routine_check
        lcd.str(string(3))
        lcd.str(routine_name)
        
PUB buttoncheck

        if state == %10000000
          routine += 1
          if routine == 4
               routine := 0
        if state == %01000000
          selected
        if state == %00100000
          routine -= 1
           if routine == -1
               routine := 0
               
PRI selected

  lcd_clear
repeat
  lcd.str(string(1))
  lcd.str(string("Routine Selected: "))
  lcd.dec(routine)
  lcd.str(string(3))              
  lcd.str(string("button 3 to start"))
  state := Buttons.State
  waitcnt(clkfreq/10 + cnt)
  if state == %00100000
    engage
  if state == %10000000
    deselect

PRI lcd_clear

       lcd.str(string($1b))
       lcd.str(string($43))
       waitcnt(clkfreq/10 + cnt)

return

PRI engage

  lcd_clear
  repeat
    lcd.str(string(1))
    lcd.str(string("routine engaged"))

PRI deselect

  lcd_clear
  waitcnt(clkfreq/1000 + cnt)
  lcd.str(string(1))
  lcd.str(string("Routine deselected. Select new routine"))
  waitcnt(clkfreq + cnt)
  main

PRI routine_check

  case routine
    0 : routine_name := string("Routine Zero ")
    1 : routine_name := string("Routine One  ")
    2 : routine_name := string("Routine Two  ")
    3 : routine_name := string("Routine Three")

  return