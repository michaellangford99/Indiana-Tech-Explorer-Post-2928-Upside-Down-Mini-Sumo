''This code example is from Propeller Education Kit Labs: Fundamentals, v1.2.
''A .pdf copy of the book is available from www.parallax.com, and also through
''the Propeller Tool software's Help menu (v1.2.6 or newer).
''
'' IrObjectDetection.spin
'' Detect objects with IR LED and receiver and display with Parallax Serial Terminal.

CON
   
  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000

VAR

  long x

OBJ
    
  lcd     : "Debug_Lcd"
  Buttons : "Touch Buttons"
  Main    : "Sumo motors and sensors 5.0"
  
VAR

  long state, routine, routine_name, pattern

PUB Start

              
   lcd.init(0, 2400, 4)
   routine := 0
   BUTTONS.start(_CLKFREQ / 1000)
   lcd_clear
   waitcnt(clkfreq + cnt)
   state := Buttons.state
   
   if state <> %00000000
        Routine_manager
   else
        Main.main
        
PUB Routine_manager

      repeat 
          waitcnt(clkfreq/2 + cnt)
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
          if routine == 8
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

Pub engage

  lcd_clear
 
  lcd.str(string(1))
  lcd.str(string("routine engaged"))
  case routine
      0 : pattern := string("Run Zero ")
      1 : pattern := string("Run One  ")
      2 : pattern := string("Run Two  ")
      3 : pattern := string("Run Three")
      4 : pattern := string("Run Four ")
      5 : pattern := string("Run Five ")
      6 : pattern := string("Run Six  ")
      7 : pattern := string("Run Seven")
  lcd.str(string(3))
  lcd.str(pattern)
  waitcnt(clkfreq + cnt)
  Main.main
  
PRI deselect

  lcd_clear
  waitcnt(clkfreq/1000 + cnt)
  lcd.str(string(1))
  lcd.str(string("Routine deselected. Select new routine"))
  waitcnt(clkfreq + cnt)
  Routine_manager

PRI routine_check
                                 
  case routine
    0 : routine_name := string("Routine Zero ")
    1 : routine_name := string("Routine One  ")
    2 : routine_name := string("Routine Two  ")
    3 : routine_name := string("Routine Three")
    4 : routine_name := string("Routine Four ")
    5 : routine_name := string("Routine Five ")
    6 : routine_name := string("Routine Six  ")
    7 : routine_name := string("Routine Seven")
    