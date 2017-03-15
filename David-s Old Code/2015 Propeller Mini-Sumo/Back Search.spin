{Front Search
Written By David Langford}


CON
   
  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000

VAR

  long  back_input, Bstate1, Bstate2, Bstate3, Bstate4, Bstate0, Bstate, stack, back_mid_input, binput
   
OBJ

  BFreqout      : "SquareWave"
  pst           : "Parallax Serial Terminal"
  
PUB Back_Init

cognew(Back_Search(27, 25, 23, 21, 19, 17), @stack[800])
'pst.Start(115200)
'repeat
'   pst.clear
'   binput := get_back
'   pst.bin(binput, 5)
'   waitcnt(clkfreq/100 + cnt)

return

PUB Back_Search(Breceive, Bar1, Bar2, Bar3, Bar4, Bar5)

repeat 
    waitcnt(clkfreq/100+cnt)
    Bstate0 := sensor_check(Breceive, Bar1)
    Bstate1 := sensor_check(Breceive, Bar2) 
    Bstate2 := sensor_check(Breceive, Bar3)
    Bstate3 := sensor_check(Breceive, Bar4)
    Bstate4 := sensor_check(Breceive, Bar5)

    Bstate0 := Bstate0          
    Bstate1 := Bstate1 << 1                   
    Bstate2 := Bstate2 << 2
    Bstate3 := Bstate3 << 3
    Bstate4 := Bstate4 << 4

    back_input.byte[0] := Bstate4.byte[0] + Bstate3.byte[0] + Bstate2.byte[0] + Bstate1.byte[0] + Bstate0.byte[0]
    back_mid_input.byte[0] := Bstate3.byte[0] + Bstate2.byte[0] + Bstate1.byte[0]
                                               
PRI sensor_check(Back_rpin, Back_tpin) 
                               
    BFreqout.freq(0, Back_tpin, 38500)
    dira[Back_tpin]~
    dira[Back_tpin]~~
    waitcnt(clkfreq/1000 + cnt)
    dira[Back_rpin]~
    Bstate := ina[Back_rpin]
    dira[Back_tpin]~
    return Bstate

PUB get_back
  
  return back_input

'PUB get_back_mid_input
'
'  return back_mid_input  