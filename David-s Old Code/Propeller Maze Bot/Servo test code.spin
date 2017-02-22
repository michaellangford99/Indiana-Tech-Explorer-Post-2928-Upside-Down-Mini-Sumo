'Propeller Maze Bot servo test code
'David Langford March 31st 2014

OBJ

PULSOUT : "Servo32v7 " 'Create pulsout object

PUB Main

PULSOUT.Start
repeat
  PULSOUT.Set(0, 1000)
  PULSOUT.Set(1, 2000)
  waitcnt(clkfreq/10 + cnt)