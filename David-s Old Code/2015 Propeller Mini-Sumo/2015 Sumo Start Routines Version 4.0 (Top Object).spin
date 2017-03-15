''2015 Start Routines Version 4.0 (Top Object)
''Written by David Langford

CON
   
  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000

VAR

  long x

OBJ
    
  lcd     : "Debug_Lcd"
  Buttons : "Touch Buttons"
  Main    : "Sumo motors and sensors 5.1"
 ' lcd     : "Parallax Serial Terminal"
   serout : "motorcontrol 1.0"
   gyro   : "Gyroscope Vs 1.0"
   Front : "Front Search"
   Back  : "Back Search"
          
VAR

  long state, routine, routine_name, pattern, front_input, back_input, gyro_input

PUB Start
   gyro_input := 0
   serout.init
   serout.speed(0, 0)
   lcd.init(11, 2400, 4)
   routine := 0
   BUTTONS.start(_CLKFREQ / 1000)
   lcd_clear
   Front.Front_init
   Back.Back_init
   gyro.startup
   waitcnt(clkfreq + cnt)
   state := Buttons.state >> 4
   
  ' if state <> %00000000
        Routine_manager
  ' else
  '      Main.main
        
PUB Routine_manager

      repeat
          sensors
          waitcnt(clkfreq/20 + cnt)
          state := Buttons.state >> 4            
          buttoncheck
          waitcnt(clkfreq/10 + cnt)
          'lcd_clear
          lcd.str(string(1))
          lcd.bin(state, 8)
          lcd.str(string(" routine :"))
          lcd.dec(routine)
          routine_check
          lcd.str(string(2))
          lcd.str(routine_name)
          lcd.str(string(3))
          lcd.str(string("F:"))
          lcd.bin(front_input, 5)
          lcd.str(string(" B:"))
          lcd.bin(back_input, 5)
          lcd.str(string(4))
          lcd.str(string("gyro: "))
          lcd.dec(gyro_input)
          
PUB buttoncheck

        if state == %00001000
          routine += 1
          if routine == 8
               routine := 0
        if state == %00000100
          selected
        if state == %00000010
          routine -= 1
           if routine == -1
               routine := 0
               
PRI selected

  lcd_clear
  
repeat
  lcd.str(string(1))
  lcd.str(string("Routine Selected: "))
  lcd.dec(routine)
  lcd.str(string(2))
  lcd.str(routine_name)
  lcd.str(string(3))              
  lcd.str(string("button 5 to start"))
  lcd.str(string(4))
  lcd.str(string("button 7 to deselect"))
  state := Buttons.State >> 4
  waitcnt(clkfreq/2 + cnt)
  if state == %00000010
    engage
  if state == %00001000
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
      0 : charge
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
    0 : routine_name := string("Charge           ")
    1 : routine_name := string("Spin Left        ")
    2 : routine_name := string("Spin Right       ")
    3 : routine_name := string("180 Spin         ")
    4 : routine_name := string("Backwards Charge ")
    5 : routine_name := string("Routine Five     ")
    6 : routine_name := string("Routine Six      ")
    7 : routine_name := string("Routine Seven    ")

PRI charge
  pattern := 0
  repeat until pattern == 1000
    pattern += 1
  Main.main

PRI sensors

  front_input := Front.get_front
  back_input  := back.get_back
  gyro_input := gyro.getz
  gyro_input := gyro_input/100

return
