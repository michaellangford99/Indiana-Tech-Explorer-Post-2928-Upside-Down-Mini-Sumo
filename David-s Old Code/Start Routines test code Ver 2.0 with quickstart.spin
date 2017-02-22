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

  repeat
      buttonstate := Buttons.State                         ' Light the LEDs when touching the corresponding buttons 
      if buttonstate == %10000000
          LED

Pub LED

  pattern := 0
  input := 0
  
  repeat
    dira[16..23]++
    outa[16..23]++
    waitcnt(clkfreq + cnt)
    pattern += 1
    input := buttonstatehit
    if input == 1
      end

Pub buttoncheck

 repeat
  button2state := Buttons.State

  if button2state ==%01000000
      buttonstatehit := 1

Pub end


            