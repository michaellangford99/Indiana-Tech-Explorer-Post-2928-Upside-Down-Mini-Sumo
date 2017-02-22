'IR Distance Detection

OBJ

SqrWave    : "SquareWave"
pst        : "Parallax Serial Terminal"
VAR

long state, wait

PUB Distance

wait := 1000

repeat until wait == 10000
  SqrWave.freq(0, 24, 38500)
  waitcnt(clkfreq/wait + cnt)
  ina[22] := state
  waitcnt(clkfreq/1000 + cnt)
  pst.Start(115200)
  pst.dec(state)
  waitcnt(clkfreq/1000 + cnt)
  wait := wait + 1000

Distance