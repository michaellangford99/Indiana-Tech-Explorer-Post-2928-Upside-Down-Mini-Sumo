CON
   
  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000

  num_routines = 6
  
  upside_down = 1
  right_side_up = 0

  forward = 0
  backward = 1

  forward_escape = 2
  backward_escape = 3

  turn_go_left = 4
  turn_go_right = 5
  
  cw = 0
  ccw = 1

  forward_counter_max = 10
  backward_counter_max = 10

  'forward = left
  'backward = right
  

  {
  right side up:
    forward:  ir_f
    backward: ir_b
  upside_down:
    forward:  ir_l
    backward: ir_r



  }
  
VAR
  long up_state, up_last_state
  long down_state, down_last_state
  long kill_switch_cog_id, kill_switch_stack[200]
  long sensor_cog_id, sensor_stack[400]
  long routine_number

  long side ' upside down = 1  right side up = 0
  long direction, search, forward_counter, backward_counter
  long fbits[3], ir_f
  long bbits[3], ir_b
  long lbits[3], ir_l
  long rbits[3], ir_r
   
OBJ
  ir     : "IRSensors"
  pins   : "pin_numbers"
  motors : "motor_control"
  'pst    : "Parallax Serial Terminal"
  lcd    : "Serial_LcdMJL"
  
PUB Start

  'start pst
  'pst.start(115_200)
  'pst.str(string("initializing...", 13))
    
  'start LCD
  lcd.start(pins#LCD_PIN, 2400, 2)
  lcd.cls
       

  'start motors
  motors.start
  
  'start IRs
  sensor_cog_id := cognew(sensor_loop, @sensor_stack[200])
  
  'set up pushbuttons and kill switch
  dira[pins#TOP_KILL_SWITCH]~
  dira[pins#BOTTOM_KILL_SWITCH]~
  dira[pins#PUSHBUTTON_UP]~
  dira[pins#PUSHBUTTON_DOWN]~  

  routine_number:=1      
                                   
  'enter start routine selection loop
  repeat
    up_state := ina[pins#PUSHBUTTON_UP]
    down_state := ina[pins#PUSHBUTTON_DOWN]

    'increment or decrement routine number
    if (up_state == 1) and (up_last_state == 0)
        routine_number++
    if (down_state == 1) and (down_last_state == 0)
        routine_number--

    'roll over routine number
    if routine_number > num_routines
        routine_number := 1
    if routine_number < 1
        routine_number := num_routines
        
    'display sensors info
    'debug_sensors
    
    'display routine name
    lcd.home
    case routine_number
      1: lcd.str(string("fwd/left"))
         lcd.putc(lcd#LCD_LINE1)
         lcd.str(string("        "))
         
      2: lcd.str(string("bck/rit "))
         lcd.putc(lcd#LCD_LINE1)
         lcd.str(string("        "))
         
      3: lcd.str(string("fwd/left"))
         lcd.putc(lcd#LCD_LINE1)
         lcd.str(string(" escape "))
         
      4: lcd.str(string("bck/rit "))
         lcd.putc(lcd#LCD_LINE1)
         lcd.str(string(" escape "))
         
      5: lcd.str(string("turngo L"))
         lcd.putc(lcd#LCD_LINE1)
         lcd.str(string("        "))
      
      6: lcd.str(string("turngo R"))
         lcd.putc(lcd#LCD_LINE1)
         lcd.str(string("        "))
    
        
    'check kill switch buttons
    if (ina[pins#TOP_KILL_SWITCH] == 1)
      repeat until (ina[pins#TOP_KILL_SWITCH] == 0)
      side := right_side_up
      quit  'jump out of repeat loop
                
    if (ina[pins#BOTTOM_KILL_SWITCH] == 1)
      repeat until (ina[pins#BOTTOM_KILL_SWITCH] == 0)
      side := upside_down
      quit  'jump out of repeat loop
      
    up_last_state := up_state
    down_last_state := down_state
    
  'start kill switch cog right before entering main sumo code
  kill_switch_cog_id := cognew(kill_switch_loop, @kill_switch_stack)

  'start routine has been selected, now run start routine, if any
  
  
  case side
     right_side_up:
        case (routine_number - 1)
          forward:
                direction := forward
                repeat 10
                    motors.set(127, 127)
                    waitcnt(clkfreq/100 + cnt)
          backward:
                direction := backward
                repeat 10
                    motors.set(-127, -127)
                    waitcnt(clkfreq/100 + cnt)
          forward_escape:
                direction := backward
                repeat 60
                    motors.set(-127, -10)
                    waitcnt(clkfreq/100 + cnt)
          backward_escape:
                direction := forward
                repeat 60
                    motors.set(127, 10)
                    waitcnt(clkfreq/100 + cnt)
          turn_go_left:
                direction := forward
                repeat 11
                    motors.set(127, -127)
                    waitcnt(clkfreq/100 + cnt)
                repeat 10
                    motors.set(127, 127)
                    waitcnt(clkfreq/100 + cnt)
          turn_go_right:
                direction := forward
                repeat 11
                    motors.set(-127, 127)
                    waitcnt(clkfreq/100 + cnt)
                repeat 10
                    motors.set(127, 127)
                    waitcnt(clkfreq/100 + cnt) 
        
     upside_down:
        case (routine_number - 1)
          forward: ' left
                repeat 10
                    direction := forward
                    motors.set(127, 127)
                    waitcnt(clkfreq/100 + cnt)
          backward: ' right
                repeat 10
                    direction := backward
                    motors.set(-127, -127)
                    waitcnt(clkfreq/100 + cnt)

          other: Main

  repeat
    motors.set(0,0)
      
  Main

pub kill_switch_loop | cogs

  waitcnt(clkfreq/4 + cnt)

  repeat
    dira[pins#TOP_KILL_SWITCH]~
    dira[pins#BOTTOM_KILL_SWITCH]~

    if (ina[pins#TOP_KILL_SWITCH] == 1) or (ina[pins#BOTTOM_KILL_SWITCH] == 1)
      waitcnt(clkfreq/10 + cnt)
      if (ina[pins#TOP_KILL_SWITCH] == 1) or (ina[pins#BOTTOM_KILL_SWITCH] == 1)

       'before killing off all the cogs, stop the motors
       motors.set(0,0)
       waitcnt(clkfreq/200 + cnt)
       
       repeat cogs from 0 to 7
        if cogs <> kill_switch_cog_id
            cogstop(cogs)
       repeat
        'do nothing eternally

pub sensor_loop
  ir.start(pins#IR_TRANSMITTER)
  repeat

    waitcnt(clkfreq/50 + cnt)
    
  
    ir.IrDetect(pins#F_0,pins#F_1,pins#F_2)
    fbits[0] := ir.GetIR(1)                                  
    fbits[1] := ir.GetIR(2)  << 1                            
    fbits[2] := ir.GetIR(3)  << 2                             
    ir_f.byte[0]:=fbits[0] + fbits[1] + fbits[2]

    ir.IrDetect(pins#B_0,pins#B_1,pins#B_2)
    bbits[0] := ir.GetIR(1)                                  
    bbits[1] := ir.GetIR(2)  << 1                            
    bbits[2] := ir.GetIR(3)  << 2                           
    ir_b.byte[0]:=bbits[0] + bbits[1] + bbits[2]

    ir.IrDetect(pins#L_0,pins#L_1,pins#L_2)
    lbits[0] := ir.GetIR(1)                                 
    lbits[1] := ir.GetIR(2)  << 1                           
    lbits[2] := ir.GetIR(3)  << 2                            
    ir_l.byte[0]:=lbits[0] + lbits[1] + lbits[2]

    ir.IrDetect(pins#R_0,pins#R_1,pins#R_2)
    rbits[0] := ir.GetIR(1)                                 
    rbits[1] := ir.GetIR(2)  << 1                            
    rbits[2] := ir.GetIR(3)  << 2                             
    ir_r.byte[0]:=rbits[0] + rbits[1] + rbits[2]
    
pub debug_sensors

    'lcd.putc(lcd#LCD_LINE0)
    'lcd.bin(ir_r, 3)
    'lcd.str(string("  "))
    'lcd.bin(ir_l, 3)

    lcd.putc(lcd#LCD_LINE1)
    lcd.bin(ir_f, 3)
    lcd.str(string("  "))
    lcd.bin(ir_b, 3)
    
    waitcnt(clkfreq/100 + cnt)
     {  
    pst.home
    pst.str(string("front: "))
    pst.bin(ir_f, 3)
    pst.newline

    pst.str(string("back : "))
    pst.bin(ir_b, 3)
    pst.newline

    pst.str(string("left : "))
    pst.bin(ir_l, 3)
    pst.newline

    pst.str(string("right: "))
    pst.bin(ir_r, 3)
    pst.newline
        }
    
pub Main
    
    if side == right_side_up
        Main_right_side_up
    if side == upside_down
        Main_upside_down
        
pub Main_right_side_up

 search := cw     'search cw
 'direction := forward  'forward

 repeat
   waitcnt(clkfreq/100 + cnt)
   {pst.home
   pst.str(string("back : "))
   pst.bin(ir_b, 3)
   pst.char(" ")
   pst.bin(ir_f, 3)
   pst.newline
   pst.dec(direction)
   pst.newline
   pst.dec(search)
   pst.newline
   pst.newline
   pst.dec(forward_counter)
   pst.char(" ")
   pst.char(" ")
   pst.newline
   pst.dec(backward_counter)
   pst.char(" ")
   pst.char(" ")
   }
   if (direction == backward)
     if ir_b == %111
       if ir_f < %111
         backward_counter++
         forward_counter := 0
       else
         backward_counter:= 0
     else
       backward_counter:= 0

   if (direction == forward)
     if ir_f == %111
       if ir_b < %111
         forward_counter++
         backward_counter:= 0
       else
         forward_counter:= 0
     else
       forward_counter:= 0

   if forward_counter > forward_counter_max
     'switch directions
     direction := backward
     if search == cw
        search := ccw
     else
        search := cw
     forward_counter := 0
     backward_counter := 0

   if backward_counter > backward_counter_max
     'switch directions
     direction := forward
     if search == cw
        search := ccw
     else
        search := cw
     forward_counter := 0
     backward_counter := 0




   if direction == forward 
    case ir_f
      %000:
        motors.set(127, 127)
        'pst.str(string("charge   "))
      %100:
        motors.set(127, 64)
        'pst.str(string("right    "))
        search := cw
      %010:
        motors.set(127, 127)
        'pst.str(string("charge   "))
      %110:
        motors.set(127, 0)
        'pst.str(string("hardright"))
        search := cw
      %001:
        motors.set(64, 127)
        'pst.str(string("left     "))
        search := ccw
      %101:
        motors.set(127, 127)
        'pst.str(string("charge   "))
      %011:
        motors.set(0, 127)
        'pst.str(string("hardleft "))
        search := ccw
      %111:
        motors.set(127 + (-255*search), -127 + (255*search))
        'pst.str(string("search   "))

   if direction == backward 
    case ir_b
      %000:
        motors.set(-127, -127)
        'pst.str(string("charge   "))
      %100:
        motors.set(-64, -127)
        'pst.str(string("right    "))
        search := cw
      %010:
        motors.set(-127, -127)
        'pst.str(string("charge   "))
      %110:
        motors.set(0, -127)
        'pst.str(string("hardright"))
        search := cw
      %001:
        motors.set(-127, -64)
        'pst.str(string("left     "))
        search := ccw
      %101:
        motors.set(-127, -127)
        'pst.str(string("charge   "))
      %011:
        motors.set(-127, 0)
        'pst.str(string("hardleft "))
        search := ccw
      %111:
        motors.set(127 + (-255*search), -127 + (255*search))
        'pst.str(string("search   "))
    
pub Main_upside_down  

 search := cw     'search cw
 'direction := forward  'forward
 'ir_l == forward
 'ir_r == backward
 repeat
   waitcnt(clkfreq/100 + cnt)
   {
   pst.home
   pst.str(string("back : "))
   pst.bin(ir_r, 3)
   pst.char(" ")
   pst.bin(ir_l, 3)
   pst.newline
   pst.dec(direction)
   pst.newline
   pst.dec(search)
   pst.newline
   pst.newline
   pst.dec(forward_counter)
   pst.char(" ")
   pst.char(" ")
   pst.newline
   pst.dec(backward_counter)
   pst.char(" ")
   pst.char(" ")
   }
   if (direction == backward)
     if ir_r == %111
       if ir_l < %111
         backward_counter++
         forward_counter := 0
       else
         backward_counter:= 0
     else
       backward_counter:= 0

   if (direction == forward)
     if ir_l == %111
       if ir_r < %111
         forward_counter++
         backward_counter:= 0
       else
         forward_counter:= 0
     else
       forward_counter:= 0

   if forward_counter > forward_counter_max
     'switch directions
     direction := backward
     if search == cw
        search := ccw
     else
        search := cw
     forward_counter := 0
     backward_counter := 0

   if backward_counter > backward_counter_max
     'switch directions
     direction := forward
     if search == cw
        search := ccw
     else
        search := cw
     forward_counter := 0
     backward_counter := 0




   if direction == forward 
    case ir_l
      %000:
        motors.set(-127, -127)
        'pst.str(string("charge   "))
      %100:
        motors.set(-64, -127)
        'pst.str(string("right    "))
        search := cw
      %010:
        motors.set(-127, -127)
        'pst.str(string("charge   "))
      %110:
        motors.set(0, -127)
        'pst.str(string("hardright"))
        search := cw
      %001:
        motors.set(-127, -64)
        'pst.str(string("left     "))
        search := ccw
      %101:
        motors.set(-127, -127)
        'pst.str(string("charge   "))
      %011:
        motors.set(-127, 0)
        'pst.str(string("hardleft "))
        search := ccw
      %111:
        motors.set(127 + (-255*search), -127 + (255*search))
        'pst.str(string("search   "))

   if direction == backward 
    case ir_r
      %000:
        motors.set(127, 127)
        'pst.str(string("charge   "))
      %100:
        motors.set(127, 64)
        'pst.str(string("right    "))
        search := cw
      %010:
        motors.set(127, 127)
        'pst.str(string("charge   "))
      %110:
        motors.set(127, 0)
        'pst.str(string("hardright"))
        search := cw
      %001:
        motors.set(64, 127)
        'pst.str(string("left     "))
        search := ccw
      %101:
        motors.set(127, 127)
        'pst.str(string("charge   "))
      %011:
        motors.set(0, 127)
        'pst.str(string("hardleft "))
        search := ccw
      %111:
        motors.set(127 + (-255*search), -127 + (255*search))
        'pst.str(string("search   "))

      