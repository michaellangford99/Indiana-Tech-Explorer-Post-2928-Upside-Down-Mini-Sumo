CON
   
  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000

OBJ

pst    : "Parallax Serial Terminal"
search : "2017 Sumo Search Object"
motors : "2017 Motor Control Ver 1.0"
lcd    : "2017 LCD MJL Ver 1.0"
pins   : "2017 pins"
'kill   : "2017 Killswitch Ver 0.0"  'or include in the main code itself - probably best to have as separate object on own cog

VAR

long front, back, left, right                       'sensor bar inputs
long m1, m2                                         'motor command values
long search_pattern, clockwise, counter_clockwise   'search pattern algorithmn 
long top_button        'input from top pushbutton
long bottom_button     'input from bottom pushbutton
long routine_number    'the number of the routine. There will need to be identical numbers of routines for normal and inverted
long routine_set       'another variable to check if the routine has really been selected. Push to killswitch on the top to activate
long routine_clear1    'inputs from the top and bottom pushbutton in the confirmation phase. If either is pressed the UI will restart
long routine_clear2 
long routine_start     'variable for actually starting the start routine. First you push down, then it waits until you realease
long orientation, normal, inverted
long routine_name
long top_kill, bottom_kill

PUB Start

pst.Start(115200)
search.init         'this code needs to have its constants specified
motors.Start
lcd.start(pins#LCD_PIN, 2400, 2) 'need actual numbers
initialize_variables
start_routine       'this code will have a variable that specifies whether we are normal or inverted
      
PUB start_routine

  repeat
    waitcnt(clkfreq/100 + cnt)           
    lcd.str(string("TOP=normal"))
    lcd.gotoxy(0,1)
    lcd.str(string("BOTTOM=inv"))
    top_button := ina[pins#PUSHBUTTON_UP]
    bottom_button := ina[pins#PUSHBUTTON_DOWN]
    if top_button == 1
      orientation := normal
      normal_routines_select
    elseif bottom_button == 1
      orientation := inverted
      inverted_routines_select

pri normal_routines_select

    lcd.cls
    waitcnt(clkfreq/100 + cnt)
    lcd.str(string("Normal"))
    waitcnt(clkfreq + cnt)

    repeat
      button_check
      lcd.cls
      waitcnt(clkfreq/100 + cnt)
      routine_check_normal
      lcd.str(routine_name)
      
pri routine_check_normal

    case routine_number
       0 : routine_name := string("F_charge_n")
       1 : routine_name := string("B_charge_n ")

pri inverted_routines_select

    lcd.cls
    waitcnt(clkfreq/100 + cnt)
    lcd.str(string("inverted"))
    waitcnt(clkfreq + cnt)

    repeat
      button_check
      lcd.cls
      waitcnt(clkfreq/100 + cnt)
      routine_check_inverted
      lcd.str(routine_name)

pri routine_check_inverted

    case routine_number
       0 : routine_name := string("F_charge_inv")
       1 : routine_name := string("B_charge_inv")
       
pri button_check

    top_button := ina[pins#PUSHBUTTON_UP]
    bottom_button := ina[pins#PUSHBUTTON_DOWN]
    routine_set := ina[pins#TOP_KILL_SWITCH]
    if routine_set == 1
      routine_confirm
    if top_button == 1
      routine_number += 1
      if routine_number == 2
        routine_number := 0
    if bottom_button == 1
      routine_number := routine_number - 1                                                 
      if routine_number == -1
        routine_number := 1
    if top_button == 1
        routine_confirm
    
pri routine_confirm

    routine_set := 0
    waitcnt(clkfreq/2 + cnt)
    
    repeat
      lcd.cls
      waitcnt(clkfreq/1000 + cnt)
      lcd.str(string("Selected"))
      lcd.gotoxy(0,1)
      lcd.str(routine_name)
      routine_set := ina[pins#TOP_KILL_SWITCH]
      routine_clear1 := ina[pins#PUSHBUTTON_UP]
      routine_clear2 := ina[pins#PUSHBUTTON_DOWN]
      if routine_clear1 or routine_clear2 == 1
        start_routine
      if routine_set == 1
        execute
    
pri execute

  lcd.cls
  waitcnt(clkfreq/1000 + cnt)
  lcd.str(string("Release_2_Go"))
  lcd.gotoxy(0,1)
  lcd.str(routine_name)
  
  if orientation == normal
    repeat until routine_start == 1
      routine_start := ina[pins#TOP_KILL_SWITCH]
    repeat
      routine_start := ina[pins#TOP_KILL_SWITCH]
      if routine_start == 0
        case routine_number
          0 : front_charge_normal
          1 : back_charge_normal
  elseif orientation == inverted
    repeat until routine_start == 1
      routine_start := ina[pins#BOTTOM_KILL_SWITCH]
    repeat
      routine_start := ina[pins#BOTTOM_KILL_SWITCH]
      if routine_start == 0
        case routine_number
          0 : front_charge_inverted
          1 : back_charge_inverted

pri front_charge_normal

  main

pri back_charge_normal

  main

pri front_charge_inverted

  main

pri back_charge_inverted

  main
          
PUB main

repeat
  if orientation == normal
    normal_search
  elseif orientation == inverted
    inverted_search
  logic
  motors.set(m1, m2)
  killswitch    


PUB normal_search

  front := search.get_front
  back := search.get_back
  right := search.get_right
  left := search.get_left
  
PUB inverted_search

  front := search.get_left
  back := search.get_right
  right := search.get_front
  left := search.get_back

PUB logic

  if front /= %111
    case front
      %011 : m1 := 50
             m2 := 127
             search_pattern := counter_clockwise
      %101 : m1 := 127
             m2 := 127
      %001 : m1 := 100
             m2 := 127
             search_pattern := counter_clockwise
      %110 : m1 := 127
             m2 := 50
             search_pattern := clockwise
      %010 : m1 := 127
             m2 := 127
      %100 : m1 := 127
             m2 := 100
             search_pattern := clockwise
      %000 : m1 := 127
             m2 := 127
    if back /= %111
      case back
       %011 : m1 := -50
              m2 := -127
              search_pattern := clockwise
       %101 : m1 := -127
              m2 := -127
       %001 : m1 := -100
              m2 := -127
              search_pattern := clockwise
       %110 : m1 := -127
              m2 := -50
              search_pattern := counter_clockwise
       %010 : m1 := -127
              m2 := -127
       %100 : m1 := -127
              m2 := -100
              search_pattern := counter_clockwise
       %000 : m1 := -127
              m2 := -127
    elseif left /= %111
      case left
       %011 : m1 := 30
              m2 := -127
              search_pattern := clockwise
       %101 : m1 := 20
              m2 := -127
       %001 : m1 := -30
              m2 := -127
              search_pattern := clockwise
       %110 : m1 := -30
              m2 := 127
              search_pattern := counter_clockwise
       %010 : m1 := -127
              m2 := -127
       %100 : m1 := 127
              m2 := -20
              search_pattern := counter_clockwise
       %000 : m1 := -127
              m2 := -127
    elseif right /= %111
      case right
       %011 : m1 := -30
              m2 := 127
              search_pattern := counter_clockwise
       %101 : m1 := -20
              m2 := 127
       %001 : m1 := 30
              m2 := 127
              search_pattern := counter_clockwise
       %110 : m1 := 30
              m2 := -127
              search_pattern := clockwise
       %010 : m1 := 127
              m2 := 127
       %100 : m1 := -127
              m2 := 20
              search_pattern := clockwise
       %000 : m1 := 127
              m2 := 127
    else
      if search_pattern == clockwise
              m1 := 127
              m2 := -127
      else
              m1 := -127
              m2 := 127

PUB initialize_variables

  'side tracking in search routine
  counter_clockwise := 0   'variable for robot needing to turn counterclockwise to see robot
  clockwise := 1           'variable for robot needing to turn clockwise to see robot
  search_pattern := 0        'tracks which side robot was seen last. Assumes counterclockwise, until first actual data 

  'orientation tracking for input assignment from search bar
  normal := 0
  inverted := 1

  'button variables for start routine selection and UI
  top_button := 0      'the pushbuttons are high when pushed (as in a push = 1)
  bottom_button := 0

  'start routines
  top_button := 0       'input from top pushbutton
  bottom_button := 0    'input from bottom pushbutton
  routine_number := 0   'the number of the routine. There will need to be identical numbers of routines for normal and inverted
  routine_set := 0      'another variable to check if the routine has really been selected. Push to killswitch on the top to activate
  routine_clear1 := 0   'inputs from the top and bottom pushbutton in the confirmation phase. If either is pressed the UI will restart
  routine_clear2 := 0
  routine_start := 0    'variable for actually starting the start routine. First you push down, then it waits until you realease

  'kill switches
  top_kill := 0         'these also trigger on 1
  bottom_kill := 0
  
PUB killswitch

  repeat
    top_kill := ina[pins#TOP_KILL_SWITCH]
    bottom_kill := ina[pins#BOTTOM_KILL_SWITCH]
    if top_kill == 1
      repeat
        motors.set(0,0)
    if bottom_kill == 1
      repeat
        motors.set(0,0) 