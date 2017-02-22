CON

  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000


OBJ
  pst              : "Parallax Serial Terminal"

VAR

    long x
    long stack
PUB Main | n
  pst.Start(115_200)
  
  repeat
      n := CNT
      waitcnt(clkfreq + cnt)
      pst.Dec(n - cnt)
      n := 
      
