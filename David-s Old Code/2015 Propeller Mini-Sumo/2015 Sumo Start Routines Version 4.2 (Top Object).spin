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
 ' Main    : "Sumo motors and sensors 5.1"
  pst     : "Parallax Serial Terminal"
   serout : "motorcontrol 1.0"
   gyro   : "Gtest"
   Front : "Front Search"
   Back  : "Back Search"
   Ir : "SquareWave.spin"
    
VAR

  long state, routine, routine_name, pattern, front_input, back_input, gyro_input, counter
   long ir_input, motor1, motor2, state0, state1, state2, state3, state4, side, left, right, finput
     
PUB Start
   gyro_input := 0
   serout.init
   serout.speed(0, 0)
   lcd.init(11, 2400, 4)
   routine := 0
   BUTTONS.start(_CLKFREQ / 1000)
   lcd_clear
   Front.Front_init
'   Back.Back_init
   pst.Start(115200)
   gyro.startup
   waitcnt(clkfreq + cnt)
   gyro.startup
   Routine_manager
        
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
      1 : pattern := string("Spin Left ")
          spin_left
      2 : pattern := string("Spin Right")
          spin_right
      3 : pattern := string("180 Spin  ")
          spin_180
      4 : pattern := string("Front_45  ")
          front_45
      5 : pattern := string("Back_45   ")
          back_45
      6 : pattern := string("B Charge  ")
      7 : pattern := string("Run Seven ")
  lcd.str(string(3))
  lcd.str(pattern)
  waitcnt(clkfreq + cnt)
  main
  
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
    4 : routine_name := string("Front 45         ")
    5 : routine_name := string("Back 45          ")
    6 : routine_name := string("Backwards Charge ")
    7 : routine_name := string("Routine Seven    ")

PUB charge

   serout.speed(-200, -200)
   waitcnt(clkfreq/2 + cnt)
   serout.speed(0, 0)
   waitcnt(clkfreq + cnt)
   main

PRI spin_left
  
  repeat until gyro_input >= 90
     gyro.main
     gyro_input := gyro.getz
     gyro_input := gyro_input / 100
     lcd.str(string(1))
     lcd.str(string("spin left"))
     lcd.str(string(2))
     lcd.str(gyro_input)
      serout.speed(-200, 200)
  serout.speed(0, 0)
  waitcnt(clkfreq + cnt)
  Main

PRI spin_right
  repeat until gyro_input <= -90
     gyro.main
     gyro_input := gyro.getz
     gyro_input := gyro_input / 100
     lcd.str(string(1))
     lcd.str(string("spin left"))
     lcd.str(string(2))
     lcd.str(gyro_input)
      serout.speed(200, -200)
  serout.speed(0, 0)
  waitcnt(clkfreq + cnt)
      
     ' routine_sensor_check
  Main

PRI spin_180
     repeat until gyro_input <= -175 or gyro_input >= 175
        gyro.main
          gyro_input := gyro.getz
        gyro_input := gyro_input / 100
        lcd.str(string(1))
        lcd.str(string("spin left"))
        lcd.str(string(2))
        lcd.str(gyro_input)
          serout.speed(200, -200)
  serout.speed(0, 0)
  waitcnt(clkfreq + cnt)
  Main

PRI front_45
  Main

PRI back_45
  Main
  
PRI sensors

  front_input := Front.get_front
  gyro.main
  gyro_input := gyro.getz
  gyro_input := gyro_input/100

return

{{

Main Code Starts Here

}}


PUB main

  side := 0
  left := 0
  right := 1
  ir_input := %11111
 ' pst.Start(115_200)
'  serout.init
'  lcd.init(0, 2400, 4)
  lcd_clear
  lcd.str(string(1))
  lcd.str(string("Main Program Running"))
repeat 
    finput := Front.get_front
    lcd_clear
    lcd.bin(ir_input, 5)
    logic_handler(finput)         
    serout.speed(motor2, motor1)
  
PRI sensor_check(rpin, tpin) 
                               
    Ir.freq(0, tpin, 38000)
    dira[tpin]~
  
    dira[tpin]~~
    waitcnt(clkfreq/1000 + cnt)
    state := ina[rpin]
    dira[tpin]~
    return state

PRI logic_handler(data)
   
    case data
      %11111 : search
      %11110 : motor1 := -200
             motor2 := 0
             side := right
      %11101 : motor1 := -200
             motor2 := -100
             side := right
      %11100 : motor1 := -200
             motor2 := -130
             side := right
      %11011 : motor1 := -200
             motor2 := -200
      %11010 : motor1 := -200
             motor2 := -150
             side := right
      %11001 : motor1 := -200
             motor2 := -160
             side := right
      %11000 : motor1 := -200
             motor2 := -150
             side := right
      %10111 : motor1 := -100
             motor2 := -200
             side := left
      %10110 : motor1 := -200
             motor2 := -150
             side := right
      %10101 : motor1 := -200
             motor2 := -200
      %10100 : motor1 := -200
             motor2 := -170
             side := right
      %10011 : motor1 := -180
             motor2 := -200
             side := left                                              
      %10010 : motor1 := -200
             motor2 := -180
             side := right
      %10001 : motor1 := -200
             motor2 := -200
      %10000 : motor1 := -200
             motor2 := -190
      %01111 : motor1 := 0
             motor2 := -200
             side := left
      %01110 : motor1 := -200
             motor2 := -200
      %01101 : motor1 := -180
             motor2 := -200
             side := left
      %01100 : motor1 := -200
             motor2 := -200
      %01011 : motor1 := -170
             motor2 := -200
             side := left
      %01010 : motor1 := -200
             motor2 := -200
      %01001 : motor1 := -180
             motor2 := -200
             side := left
      %01000 : motor1 := -200
             motor2 := -200
      %00111 : motor1 := -180
             motor2 := -200
             side := left
      %00110 : motor1 := -200
             motor2 := -200
      %00101 : motor1 := -190
             motor2 := -200
             side := left
      %00100 : motor1 := -200
             motor2 := -200
      %00011 : motor1 := -170
             motor2 := -200
             side := left
      %00010 : motor1 := -200
             motor2 := -200
      %00001 : motor1 := -190
             motor2 := -200
             side := left
      %00000 : motor1 := -200
             motor2 := -200

return

PRI search

    if side == right
        motor1 := -200
        motor2 := 200
    elseif side == left
        motor1 := 200
        motor2 := -200

return