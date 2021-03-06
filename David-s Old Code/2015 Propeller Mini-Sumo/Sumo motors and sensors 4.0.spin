'Propeller Sumo Five IR

CON

  _clkmode = xtal1 + pll16x                  ' System clock → 80 MHz
  _xinfreq = 5_000_000

OBJ

  Ir : "SquareWave.spin"
  pst : "Parallax Serial Terminal"
  serout : "motorcontrol 1.0"
  
VAR

  long Front_input, Back_input, input
  long motor1, motor2
  long Fstate0, Fstate1, Fstate2, Fstate3, Fstate4
  long Bstate0, Bstate1, Bstate2, Bstate3, Bstate4
  long state
  long side
  long left, right
  long stack

PUB main

  side := 0
  left := 0
  right := 1
  front_input := %11111
  back_input := %11111
  pst.Start(115200)
  serout.init

  cognew(Front, @stack[100])
  'cognew(Back, @stack[300])

repeat

  'input := Back_input
  ' if input /= %11111
  '      Back_logic_handler(input)
  ' else
      input := Front_input
      Front_logic_handler(input)

  serout.speed(motor1, motor2)
  pst.clear
  'pst.bin(Front_input, 5)
  pst.bin(Back_input, 5)
  
Pub Front

  front_input := %11111
    
repeat 

    Fstate0 := sensor_check(16, 18)
    if Fstate0 == 0
      Fstate0 := %01111
    else
      Fstate0 := %11111 
    Fstate1 := sensor_check(16, 20)
    if Fstate1 == 0
      Fstate1 := %10111
    else
      Fstate1 := %11111
    Fstate2 := sensor_check(16, 22)
    if Fstate2 == 0
      Fstate2 := %11011
    else
      Fstate2 := %11111
    Fstate3 := sensor_check(16, 24)
    if Fstate3 == 0
      Fstate3 := %11101
    else
      Fstate3 := %11111  
    Fstate4 := sensor_check(16, 26)
    if Fstate4 == 0
      Fstate4 := %11110
    else
      Fstate4 := %11111

    front_input := Fstate4 & Fstate4 & Fstate2 & Fstate1 & Fstate0
    
PUB Back

    
repeat 

    Bstate0 := sensor_check(17, 19)
    if Bstate0 == 0
      Bstate0 := %01111
    else
      Bstate0 := %11111 
    Bstate1 := sensor_check(17, 21)
    if Bstate1 == 0
      Bstate1 := %10111
    else
      Bstate1 := %11111
    Bstate2 := sensor_check(17, 23)
    if Bstate2 == 0
      Bstate2 := %11011
    else
      Bstate2 := %11111
    Bstate3 := sensor_check(17, 25)
    if Bstate3 == 0
      Bstate3 := %11101
    else
      Bstate3 := %11111  
    Bstate4 := sensor_check(17, 27)
    if Bstate4 == 0
      Bstate4 := %11110
    else
      Bstate4 := %11111

    back_input := Bstate4 & Bstate4 & Bstate2 & Bstate1 & Bstate0
    
PRI sensor_check(rpin, tpin) 
                               
    Ir.freq(0, tpin, 38500)
    dira[tpin]~
  
    dira[tpin]~~
    waitcnt(clkfreq/1000 + cnt)
    dira[rpin]~
    state := ina[rpin]
    dira[tpin]~
    return state

PRI front_logic_handler(data)
   
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
     %10111 : motor1 := 100
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
    %11110 : back_far_right
    %11101 : back_mid_right
    %11100 : back_mid_right
    %11011 : back_charge
    %11010 : back_right
    %11001 : back_right
    %11000 : back_right
    %10111 : back_mid_left
    %10110 : back_right
    %10101 : back_charge
    %10100 : back_right
    %10011 : back_left
    %10010 : back_right    
    %10001 : back_charge
    %10000 : back_charge
    %01111 : back_far_left
    %01110 : back_charge
    %01101 : back_left
    %01100 : back_charge
    %01011 : back_left
    %01010 : back_charge
    %01001 : back_left
    %01000 : back_charge
    %00111 : back_mid_left
    %00110 : back_charge
    %00101 : back_left
    %00100 : back_charge
    %00011 : back_left
    %00010 : back_charge
    %00001 : back_charge
    %00000 : back_charge

PRI search

    if side == right
        motor1 := -200   'motor1 is the left motor  (facing forwards)
        motor2 := 200
    elseif side == left
        motor1 := 200
        motor2 := -200

return

PRI back_charge

  motor1 := 200
  motor2 := 200

return

PRI back_far_right

  motor1 := -150    'right motor facing backwards, goes 3/4 speed backwards
  motor2 := 200     'left motor facing backwards, goes full speed forwards
  side := left      'back right = front left

return

PRI back_mid_right

  motor1 := 50    'right motor facing backwards, goes 1/4 speed forwards
  motor2 := 200   'left motor facing backwards, goes full speed forwards
  side := left    'back right = front left

return

PRI back_right

  motor1 := 150   'right motor facing backwards, goes 3/4 speed forwards
  motor2 := 200   'left motor facing backwards, goes full speed forwards
  side := left

return

PRI back_far_left

  motor1 := 200    'right motor facing backwards, goes full speed forwards
  motor2 := -150   'left motor facing backwards, goes 3/4 speed backwards
  side := right    'back left = front right

return

PRI back_mid_left

   motor1 := 200   'right motor facing backwards, goes full speed forwards
   motor2 := 50    'left motor facing backwards, goes 1/4 speed forwards
   side := right   'back left = front right

return

PRI back_left

  motor1 := 200    'right motor facing backwards, goes full speed backwards
  motor2 := 150    'left motor facing backwards, goes 3/4 speed backwards
  side := right    'back left = front right

return                                 