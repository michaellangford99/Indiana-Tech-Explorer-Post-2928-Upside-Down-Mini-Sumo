'Propeller Sumo Five IR

CON

  _clkmode = xtal1 + pll16x                  ' System clock → 80 MHz
  _xinfreq = 5_000_000

OBJ

  pst : "Parallax Serial Terminal"
  serout : "motorcontrol 1.0"
  lcd : "Debug_Lcd"
  Front : "Front Search"
  Back : "Back Search"
  gyro : "Gyroscope Handeler Vs 1.0"
  
VAR

  long ir_input, motor1, motor2, state0, state1, state2, state3, state4, state, side, left, right, input
  long finput, binput, gyro_input
  
PUB Initialize
  pst.Start(115200)
  side := 0
  left := 0
  right := 1
  input := %11111
  serout.init
  lcd.init(7, 2400, 4)
  lcd_clear
  Front.Front_Init
  Back.Back_Init
  gyro.StartUp
  gyro_input := 0
  repeat
    pst.dec(1)
    gyro_input := gyro.RawZ
    pst.dec(gyro_input)
  Main

'repeat
'     serout.speed(-200, 200)
'     waitcnt(clkfreq/200 + cnt)
PUB Main
  
repeat
    waitcnt(clkfreq/200 + cnt) 
    finput := Front.get_front
'    binput := Back.get_back
    lcd_clear
'    pst.str(string(1)) 
    pst.bin(finput, 5)
    pst.str(string(" "))
    pst.bin(binput, 5)
    'if finput <> 32
      logic_handler(finput)
    'elseif binput <> 32
    '  back_logic_handler(binput)
    'else
    '  search         
    serout.speed(motor2, motor1)
 
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

PRI back_logic_handler(data)
   
    case data
      %11111 : search
      %11110 : motor1 := 0
             motor2 := 0
             side := right
      %11101 : motor1 := 0
             motor2 := 0
             side := right
      %11100 : motor1 := 0
             motor2 := 0
             side := right
      %11011 : motor1 := 0
             motor2 := 0
      %11010 : motor1 := 0
             motor2 := 0
             side := right
      %11001 : motor1 := 0
             motor2 := 0
             side := right
      %11000 : motor1 := 0
             motor2 := 0
             side := right
      %10111 : motor1 := 0
             motor2 := 0
             side := left
      %10110 : motor1 := 0
             motor2 := 0
             side := right
      %10101 : motor1 := 0
             motor2 := 0
      %10100 : motor1 := 0
             motor2 := 0
             side := right
      %10011 : motor1 := 0
             motor2 := 0
             side := left                                              
      %10010 : motor1 := 0
             motor2 := 0
             side := right
      %10001 : motor1 := 0
             motor2 := 0
      %10000 : motor1 := 0
             motor2 := 0
      %01111 : motor1 := 0
             motor2 := 0
             side := left
      %01110 : motor1 := 0
             motor2 := 0
      %01101 : motor1 := 0
             motor2 := 0
             side := left
      %01100 : motor1 := 0
             motor2 := 0
      %01011 : motor1 := 0
             motor2 := 0
             side := left
      %01010 : motor1 := 0
             motor2 := 0
      %01001 : motor1 := 0
             motor2 := 0
             side := left
      %01000 : motor1 := 0
             motor2 := 0
      %00111 : motor1 := 0
             motor2 := 0
             side := left
      %00110 : motor1 := 0
             motor2 := 0
      %00101 : motor1 := 0
             motor2 := 0
             side := left
      %00100 : motor1 := 0
             motor2 := 0
      %00011 : motor1 := 0
             motor2 := 0
             side := left
      %00010 : motor1 := 0
             motor2 := 0
      %00001 : motor1 := 0
             motor2 := 0
             side := left
      %00000 : motor1 := 0
             motor2 := 0

    if side == right
      side := left
    else
      side := right

return

PRI search

    if side == right
        motor1 := -200
        motor2 := 200
    elseif side == left
        motor1 := 200
        motor2 := -200

return

PRI lcd_clear

       lcd.str(string($1b))
       lcd.str(string($43))
       waitcnt(clkfreq/10 + cnt)

return