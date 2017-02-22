CON
    _clkmode = xtal1 + pll16x
    _xinfreq = 5_000_000
                     
OBJ
    BS2 : "BS2_Functions"    ' Create BS2 Object

PUB Start 
    BS2.start (31,30)        ' Initialize BS2 Object timing, Rx and Tx pins for DEBUGOBJ

'serout.start(22, 23, 0, 84)
repeat
   waitcnt(clkfreq / 100 + cnt)
  BS2.SEROUT_DEC(0, 3, 9600,1,8)
    waitcnt(clkfreq / 100 + cnt)
  BS2.SEROUT_DEC(0, 124,9600,1,8)
                            