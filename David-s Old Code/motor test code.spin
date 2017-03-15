OBJ

SEROUT : "FullDuplexSerial" 'creat serout object

PUB Main

SEROUT.Start(0, 1, 1, 9600)
repeat
  SEROUT.dec(3)
  SEROUT.dec(50)
  waitcnt(clkfreq + cnt)