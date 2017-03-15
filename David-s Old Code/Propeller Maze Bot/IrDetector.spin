''This code example is from Propeller Education Kit Labs: Fundamentals, v1.2.
''A .pdf copy of the book is available from www.parallax.com, and also through
''the Propeller Tool software's Help menu (v1.2.6 or newer).
''
''IrDetector.spin

CON

  scale = 16_777_216                         ' 2³²÷ 256

OBJ

  SquareWave  : "SquareWave"                 ' Import square wave cog object

VAR

  long anode, cathode, recPin, dMax, duty
  
PUB init(irLedAnode, irLedCathode, irReceiverPin)

  anode := irLedAnode
  cathode := irLedCathode
  recPin := irReceiverPin

PUB distance : dist
{{
Performs a duty sweep response test on the IR LED/receiver and returns dist, a zone value 
from 0 (closest) to 256 (no object detected).
}}
  'Start 38 kHz signal.
  SquareWave.Freq(1, anode, 38000)           ' ctrb 38 kHz
  dira[anode]~~

  'Configure Duty signal.
  ctra[30..26] := %00110                     ' Set ctra to DUTY mode
  ctra[5..0] := cathode                      ' Set ctra's APIN
  frqa := phsa := 0                          ' Set frqa register
  dira[cathode]~~                            ' Set P5 to output

  dist := 0

  repeat duty from 0 to 255                  ' Sweep duty from 0 to 255
    frqa := duty * scale                     ' Update frqa register
    waitcnt(clkfreq/128000 + cnt)            ' Delay for 1/128th s
    dist += ina[recPin]                      ' Object not detected?  Add 1 to dist.