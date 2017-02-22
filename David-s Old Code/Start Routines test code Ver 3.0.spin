''ledincrement.spin
''a spin code designed to increment the start routine number by binary one
''each time the button is pressed
CON

  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000     

OBJ

  Buttons          : "Touch Buttons"
'  IrDetect         : "IrObjectDetection Ver 2.0"
  lcd              : "Serial_LCD"


VAR

  long pattern, buttonstate, stack, button2state, buttonstatehit, buttonstate3

PUB Start

  Buttons.start(_CLKFREQ / 100)         'Launch the touch buttons driver sampling
                                        '100 times a second
  pattern := 0                          'set everything to zero
  dira[16..23] := %00000000       
  outa[16..23] := %11111111
  lcd.init(15, 2400, 4)
  
  repeat until buttonstate == %01000000
      buttonstate := Buttons.State      'Light the LEDs when touching the corresponding buttons 
      if buttonstate == %10000000
          dira[16..23]++                'increments LED's by one 
          waitcnt(clkfreq + cnt)        'wait one second
          pattern += 1
          'lcd_display(pattern)
          lcd.str(string(
  end                                   'if button has been pressed, go to end 

Pub end

  repeat until buttonstate3 == %11000000
    dira[16..23] := %00000000           'sets LED's to zero
    waitcnt(clkfreq/2 + cnt)            'blink LED pattern every half second
    dira[16..23] := pattern
    outa[16..23] := pattern
    buttonstate3 := Buttons.State

  dira[16..23]~                         'sets LED's to zero
'  IrDetect.Start

PUB lcd_display(lcd_input)

  case lcd_input
    0 : routine_zero
    '1 : routine_one

pri routine_zero

  lcd.str(string("routine zero"))                                