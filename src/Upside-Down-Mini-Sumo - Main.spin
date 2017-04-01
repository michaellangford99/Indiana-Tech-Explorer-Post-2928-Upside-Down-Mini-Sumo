CON
   
  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000

  num_routines = 4

VAR
  long up_state, up_last_state
  long down_state, down_last_state
  long kill_switch_cog_id, kill_switch_stack[200]
  long sensor_cog_id, sensor_stack[400]
  long routine_number

  long side ' upside down = 1  right side up = 0

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

    'display routine name
    lcd.home
    case routine_number
      1: lcd.str(string(" charge "))
      2: lcd.str(string("hardback"))
      3: lcd.str(string("  left  "))
      4: lcd.str(string("  right "))
     
    'display sensors info
    debug_sensors
        
    'check kill switch buttons
    if (ina[pins#TOP_KILL_SWITCH] == 1)
      repeat until (ina[pins#TOP_KILL_SWITCH] == 0)
      side := 0
      quit  'jump out of repeat loop
                
    if (ina[pins#BOTTOM_KILL_SWITCH] == 1)
      repeat until (ina[pins#BOTTOM_KILL_SWITCH] == 0)
      side := 1
      quit  'jump out of repeat loop
      
    up_last_state := up_state
    down_last_state := down_state
    
  'start kill switch cog right before entering main sumo code
  kill_switch_cog_id := cognew(kill_switch_loop, @kill_switch_stack)

  'start routine has been selected, now run start routine

  
  
  Main

pub kill_switch_loop | cogs

  waitcnt(clkfreq/4 + cnt)

  repeat
    dira[pins#TOP_KILL_SWITCH]~
    dira[pins#BOTTOM_KILL_SWITCH]~

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

    repeat

        motors.set(20, 20)
        lcd.home
        lcd.str(string("        "))
        lcd.home
        lcd.dec(side)
        lcd.putc(lcd#LCD_LINE1)
        lcd.dec(routine_number)      