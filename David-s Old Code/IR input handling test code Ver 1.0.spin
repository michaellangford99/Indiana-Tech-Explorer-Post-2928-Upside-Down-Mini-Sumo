'IR Test Code.spin
'A code designed to register inputs from sensors and show them in the LED's

CON

  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000
  
OBJ

 Buttons         : "Touch Buttons"

VAR

long sensorinput, ledstate, stack

PUB Main

  cognew(led, @stack[10])
  Buttons.start(_CLKFREQ / 100)
  ledstate := %00000
  
  repeat
    sensorinput := Buttons.state
    case sensorinput
      %00000000 :  ledstate := %00000000      'search
      %10000000 :  ledstate := %10000000      'farleft
      %01000000 :  ledstate := %01000000      'midleft
      %11000000 :  ledstate := %11000000      'left
      '%00100 :  center
      '%10100 :  midleft
      '%01100 :  midleft
      '%11100 :  midleft
      '%00010 :  midright
      '%10010 :  center
      '%01010 :  center
      '%11010 :  center
      '%00110 :  midright
      '%10110 :  center
      '%01110 :  center
      '%11110 :  center
      '%00001 :  farright
      '%10001 :  center
      '%01001 :  center
      '%11001 :  center
      '%00101 :  midright
      '%10101 :  center
      '%01101 :  center
      '%11101 :  center
      '%00011 :  right
      '%10011 :  center
      '%01011 :  center
      '%11011 :  center
      '%00111 :  midright
      '%10111 :  center
      '%01111 :  center
      '%11111 :  center

PUB led

repeat
  dira[16..23] := ledstate
  outa[16..23] := ledstate
