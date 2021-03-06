{{

┌─────────────────────────────────────┬────────────────────────┬────────┬──────┐
│ Gyroscope Handeler.spin             │ Michael J. Langford    │ Vs 1.0 │ Jan 2│
├─────────────────────────────────────┴────────────────────────┴────────┴──────┤
│ Demonstrates X,Y,Z output to mother object. Uses default (I²C) interface     │
│ on the Gyroscope module.                                                     │
│ This program is for extracting RAW data from the Gyroscope                   │
│ Module(measurements are in DPS(Degrees Per Second).                          │
└──────────────────────────────────────────────────────────────────────────────┘
     L3G200D Module                       
   ┌─────────────────┐       
   │   L        INT2 ┣───   Data ready/FIFO interrupt
   │   3        INT1 ┣───   Programmable interrupt
   │   G         SDO ┣───   SPI serial data output -- I²C LSB of the device address (SA0)
   │   4 SDA/SDI/SDO ┣───   I²C serial data (SDA) -- SPI serial data input (SDI) -- 3-wire SPI data output (SDO)
   │   2         SCL ┣───   I²C & SPI clock
   │   0         CS  ┣───   I²C/SPI mode selection (defaulted to I²C) pull low for SPI mode
   │   0         VIN ┣───   2.7 - 6.5VDC (module is regulated to 2.5VDC) (give it 3.3VDC)
   │   D         GND ┣──┐
   └─────────────────┘  
                        
}}
                        
CON
                        
  _clkmode      = xtal1 + pll16x
  _clkfreq      = 80_000_000
                        
  '****IMPORTANT -- THESE ARE THE PIN NUMBERS!!!!!!!****                     
  SCLpin         = 8   'edit these to reflect actual pin numbers 
  SDApin         = 9       
                        
    
  '****Registers****    

  WRITE         = $D2   
  READ          = $D3
                        
  CTRL_REG1     = $20    'SUB $A0 
  CTRL_REG3     = $22   
  CTRL_REG4     = $23
  STATUS_REG    = $27   
  OUT_X_INC     = $A8
                        

  x_idx = 0             
  y_idx = 1
  z_idx = 2             
    
VAR                     

long x, xx, yy, zz                  
long y
long z                  

long stack
long input

long cx                 
long cy
long cz                 

long ff_x               
long ff_y
long ff_z               

long multiBYTE[3]

OBJ

  pst : "Parallax Serial Terminal"

PUB StartUp | last_ticks 
  
  Wrt_1B(CTRL_REG3, $08)                                'set up data ready signal
  Wrt_1B(CTRL_REG4, $80)                                'set up "block data update" mode (to avoid bad reads when the values would get updated while we are reading) 
  
  Wrt_1B(CTRL_REG1, $1F)                                'write a byte to control register one (enable all axis, 100Hz update rate)

  Calibrate
  last_ticks := cnt
  cognew(gyroMain, @stack[1000])

  run
    
PUB run

pst.Start(115200)
repeat
    pst.clear
    input := RawZ
    pst.dec(input)
    waitcnt(clkfreq/1000)
    
PUB gyroMain

repeat
    zz += z
  ''Main routine                                           
    WaitForDataReady 
    Read_MultiB(OUT_X_INC)                              'Read out multiple bytes starting at "output X low byte"
    
{{<possibly delete>}}    
    x := x - cx                                         'subtract calibration out
    y := y - cy
    z := z - cz
    
    ' at 250 dps setting, 1 unit = 0.00875 degrees,
    ' that means about 114.28 units = 1 degree
    ' this gets us close
    x := x / 114
    y := y / 114
    z := z / 114
{{</possibly delete>}}

PUB RawX    
    return xx
    
PUB RawY    
    return yy

PUB RawZ    
    return zz

PUB Calibrate
  cx := 0
  cy := 0
  cz := 0

  repeat 25
    WaitForDataReady
    Read_MultiB(OUT_X_INC)                              ' read the 3 axis values and accumulate
    cx += x
    cy += y
    cz += z

  cx /= 25                                              ' calculate the average
  cy /= 25
  cz /= 25

    
PUB WaitForDataReady | status

  repeat
      status := Read_1B(STATUS_REG)                     ' read the ZYXZDA bit of the status register (looping until the bit is on)
      if (status & $08) == $08
        quit
                        
PUB Wrt_1B(SUB1, data)

  ''Write single byte to Gyroscope.
  
      start
      send(WRITE)                   'device address as write command
        'slave ACK
      send(SUB1)                    'SUB address = Register MSB 1 = reg address auto increment
        'slave ACK
      send(data)                    'data you want to send
        'slave ACK
      stop
 
PUB Wrt_MultiB(SUB2, data, data2)

 ''Write multiple bytes to Gyroscope.

      start
      send(WRITE)                   'device address as write command
        'slave ACK
      send(SUB2)                    'SUB address = Register MSB 1 = reg address auto increment
        'slave ACK
      send(data)                    'data you want to send
        'slave ACK
      send(data2)                   'data you want to send
        'slave ACK
      stop

PUB Read_1B(SUB3) | rxd

 ''Read single byte from Gyroscope

      start
      send(WRITE)                   'device address as write command
        'slave ACK
      send(SUB3)                    'SUB address = Register MSB 1 = reg address auto increment
        'slave ACK
      stop
      start                         'SR condition
      send(READ)                    'device address as read command
        'slave ACK
      rxd := receive(false)         'recieve the byte and put in variable rxd
      stop
  
     result := rxd

PUB Read_MultiB(SUB3) 

 ''Read multiple bytes from Gyroscope

     start
      send(WRITE)                     'device address as write command
        'slave ACK
      send(SUB3)                       'SUB address = Register MSB 1 = reg address auto increment
        'slave ACK
      stop
      start                           'SR condition
      send(READ)                      'device address as read command
        'slave ACK
      multiBYTE[x_idx] := (receive(true)) |  (receive(true)) << 8         'Receives high and low bytes of Raw data
      multiBYTE[y_idx] := (receive(true)) |  (receive(true)) << 8                                                                                 
      multiBYTE[z_idx] := (receive(true)) |  (receive(false)) << 8 
      stop
  
      x := ~~multiBYTE[x_idx]
      y := ~~multiBYTE[y_idx]
      z := ~~multiBYTE[z_idx]

PRI send(value)  ' I²C Send data - 4 Stack Longs 

  value := ((!value) >< 8)

  repeat 8
    dira[SDApin]       := value
    dira[SCLpin]       := false
    dira[SCLpin]       := true
    value >>= 1

  dira[SDApin]         := false
  dira[SCLpin]         := false
  result               := not(ina[SDApin])
  dira[SCLpin]         := true
  dira[SDApin]         := true

PRI receive(aknowledge) ' I²C receive data - 4 Stack Longs

  dira[SDApin]         := false

  repeat 8
    result <<= 1
    dira[SCLpin]       := false
    result             |= ina[SDApin]
    dira[SCLpin]       := true

  dira[SDApin]         := (aknowledge)
  dira[SCLpin]         := false
  dira[SCLpin]         := true
  dira[SDApin]         := true

PRI start ' 3 Stack Longs

  outa[SDApin]         := false
  outa[SCLpin]         := false
  dira[SDApin]         := true
  dira[SCLpin]         := true

PRI stop ' 3 Stack Longs

  dira[SCLpin]         := false
  dira[SDApin]         := false
                                    