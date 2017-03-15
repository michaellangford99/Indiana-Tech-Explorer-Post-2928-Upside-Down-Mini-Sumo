{Front Search
Written By David Langford}


CON
   
  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000

VAR

  long  front_input, Fstate1, Fstate2, Fstate3, Fstate4, Fstate0, Fstate, stack, front_mid_input, finput
   
OBJ

  FFreqout      : "SquareWave"
  pst           : "Parallax Serial Terminal"

PUB Front_Init

cognew(Front_Search(16, 18, 20, 22, 24, 26), @stack[200])
pst.Start(115200)
repeat
    pst.clear
    finput := get_front
    pst.bin(get_front, 5)
    waitcnt(clkfreq/100 + cnt)
return    
PUB Front_Search(Freceive, Fr1, Fr2, Fr3, Fr4, Fr5)

repeat 
    waitcnt(clkfreq/100+cnt)
    Fstate0 := fsensor_check(Freceive, Fr1)
    Fstate1 := fsensor_check(Freceive, Fr2) 
    Fstate2 := fsensor_check(Freceive, Fr3)
    Fstate3 := fsensor_check(Freceive, Fr4)
    Fstate4 := fsensor_check(Freceive, Fr5)

    Fstate0 := Fstate0          
    Fstate1 := Fstate1 << 1                   
    Fstate2 := Fstate2 << 2
    Fstate3 := Fstate3 << 3
    Fstate4 := Fstate4 << 4

    front_input.byte[0] := Fstate4.byte[0] + Fstate3.byte[0] + Fstate2.byte[0] + Fstate1.byte[0] + Fstate0.byte[0]
'    front_mid_input.byte[0] := Fstate3.byte[0] + Fstate2[0] + Fstate1[0]
                                               
PRI fsensor_check(Front_rpin, Front_tpin) 
                               
    FFreqout.freq(0, Front_tpin, 38500)
    dira[Front_tpin]~
    dira[Front_tpin]~~
    waitcnt(clkfreq/1000 + cnt)
    dira[Front_rpin]~
    Fstate := ina[Front_rpin]
    dira[Front_tpin]~
    return Fstate

PUB get_front
  
  return front_input

'PUB get_mid_front
'
'  return front_mid_input  