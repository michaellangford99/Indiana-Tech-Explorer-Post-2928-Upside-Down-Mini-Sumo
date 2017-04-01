{Front Search
Written By David Langford}


CON
   
  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000

VAR

  long  back_input, front_input, left_input, right_input, stack[600], binput, Receive1, Receive2, Receive3, Universal_Transmit
  long  Fstate, Fstate0, Fstate1, Fstate2
  long  Bstate, Bstate0, Bstate1, Bstate2
  long  Lstate, Lstate0, Lstate1, Lstate2
  long  Rstate, Rstate0, Rstate1, Rstate2  
   
OBJ

  BFreqout      : "SquareWave"
  pst           : "Parallax Serial Terminal"

PUB init

cognew(Search, @stack)

repeat
  
PUB Search      
pst.Start(115_200)
repeat
  pst.clear
   binput := get_back
   pst.bin(binput, 3)

   Front_Search(13, 14, 15, 8)      'replace these with the sensor constants
   Back_Search(9, 10, 11, 8)
   Left_Search(17, 18, 19, 8)
   Right_Search(21, 22, 23, 8)
'     
   waitcnt(clkfreq/100 + cnt)



PUB Front_Search(FReceive0, FReceive1, FReceive2, FTransmit)

 
    waitcnt(clkfreq/100+cnt)
    Fstate0 := sensor_check(FReceive0, FTransmit)
    Fstate1 := sensor_check(FReceive1, FTransmit) 
    Fstate2 := sensor_check(Freceive2, FTransmit)

    Fstate0 := Fstate0          
    Fstate1 := Fstate1 << 1                   
    Fstate2 := Fstate2 << 2

    front_input.byte[0] := Fstate2.byte[0] + Fstate1.byte[0] + Fstate0.byte[0]



PUB Back_Search(BReceive0, BReceive1, BReceive2, BTransmit)

 
    waitcnt(clkfreq/100+cnt)
    Bstate0 := sensor_check(Breceive0, BTransmit)
    Bstate1 := sensor_check(Breceive1, BTransmit) 
    Bstate2 := sensor_check(Breceive2, BTransmit)

    Bstate0 := Bstate0          
    Bstate1 := Bstate1 << 1                   
    Bstate2 := Bstate2 << 2

    back_input.byte[0] := Bstate2.byte[0] + Bstate1.byte[0] + Bstate0.byte[0]



PUB Left_Search(LReceive0, LReceive1, LReceive2, LTransmit)

 
    waitcnt(clkfreq/100+cnt)
    Lstate0 := sensor_check(Lreceive0, LTransmit)
    Lstate1 := sensor_check(Lreceive1, LTransmit) 
    Lstate2 := sensor_check(Lreceive2, LTransmit)

    Lstate0 := Lstate0          
    Lstate1 := Lstate1 << 1                   
    Lstate2 := Lstate2 << 2

    left_input.byte[0] := Lstate2.byte[0] + Lstate1.byte[0] + Lstate0.byte[0]


    
PUB Right_Search(RReceive0, RReceive1, RReceive2, RTransmit)

 
    waitcnt(clkfreq/100+cnt)
    Rstate0 := sensor_check(Rreceive0, RTransmit)
    Bstate1 := sensor_check(Rreceive1, RTransmit) 
    Bstate2 := sensor_check(Rreceive2, RTransmit)

    Rstate0 := Rstate0          
    Rstate1 := Rstate1 << 1                   
    Rstate2 := Rstate2 << 2

    right_input.byte[0] := Rstate2.byte[0] + Rstate1.byte[0] + Rstate0.byte[0]
                                               
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

PUB get_front

  return front_input

PUB get_left

  return left_input

PUB get_right

  return right_input

'PUB get_back_mid_input
'
'  return back_mid_input  