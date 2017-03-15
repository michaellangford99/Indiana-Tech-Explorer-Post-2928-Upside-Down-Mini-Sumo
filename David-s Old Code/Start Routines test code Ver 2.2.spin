' LEDbinarysequence.spin
' LED pattern increments by one in binary form up to 25

CON

  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000


OBJ

  Buttons          : "Touch Buttons"
  
VAR

  long pattern, input, buttonstate, stack, button2state, buttonstatehit

PUB Start

  Buttons.start(_CLKFREQ / 100)                         ' Launch the touch buttons driver sampling 100 times a second
  dira[16..23]~~
  cognew(buttoncheck, @stack[50])                       ' Set the LEDs as outputs

  repeat until buttonstate == %10000000
      buttonstate := Buttons.State                         ' Light the LEDs when touching the corresponding buttons 
     
  pattern := %00000000
  input := 0

  dira[16..23] := %00000000       'sets LED's to zero
  outa[16..23] := %00000000
  
  repeat
    dira[16..23]++                'increments LED's by one 
    outa[16..23]++
    waitcnt(clkfreq + cnt)        'wait one second
    pattern += 1                  'make tracking variable match the LED's display
    input := buttonstatehit       'update sensor status
    if input == 1
      end

Pub buttoncheck

 buttonstatehit := 0

 repeat
  button2state := Buttons.State
   if button2state ==%01000000
      buttonstatehit := 1
      
Pub end

  repeat
    dira[16..23] := %00000000       'sets LED's to zero
    outa[16..23] := %00000000
    waitcnt(clkfreq/2 + cnt)
    dira[16..23] := pattern
    outa[16..23] := pattern
               