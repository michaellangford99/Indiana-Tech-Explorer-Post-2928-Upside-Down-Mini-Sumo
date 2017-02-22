' LEDbinarysequence.spin
' LED pattern increments by one in binary form up to 256

CON

  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000


OBJ

  Buttons          : "Touch Buttons"
  
VAR

  long pattern, buttonstate, stack, button2state, buttonstatehit

PUB Start

  Buttons.start(_CLKFREQ / 100)' Launch the touch buttons driver sampling 100 times a second
  dira[16..23]~~
  
  repeat until buttonstate == %10000000
      buttonstate := Buttons.State' Light the LEDs when touching the corresponding buttons 
     
  pattern := %00000000
  dira[16..23] := %00000000       'sets LED's to zero
  outa[16..23] := %00000000
  
  repeat
    dira[16..23]++                'increments LED's by one 
    outa[16..23]++
    waitcnt(clkfreq + cnt)        'wait one second
    pattern += 1                  'make tracking variable match the LED's display
    button2state := Buttons.State  'update sensor status
   if button2state ==%01000000     'check if button has been pressed
      buttonstatehit := 1         'make variable more accessible
    if buttonstatehit == 1
          end                      'if button is pressed, go to the end

Pub end

  repeat   
    dira[16..23] := %00000000       'sets LED's to zero
    outa[16..23] := %00000000
    waitcnt(clkfreq/2 + cnt)        'blink LED pattern every half second
    dira[16..23] := pattern
    outa[16..23] := pattern
                               