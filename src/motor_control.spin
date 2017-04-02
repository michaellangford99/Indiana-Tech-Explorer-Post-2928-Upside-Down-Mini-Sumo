CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

        reset=6
        serout=7
        baud=9600

        
        
VAR
   long stack[500], s1, s2, d1, d2

   long add1, add2
   long array1[10], array2[10]
   
OBJ
    serial : "FUllDuplexSerial"
    
PUB Start
   serial.Start(31, serout, %0000, baud)

   dira[reset]~~
   outa[reset] := 0

   waitcnt(clkfreq/100+cnt)

   outa[reset] := 1

   waitcnt(clkfreq/100+cnt)
   
PUB Set(sp2, sp1)

 'sp2 /=4
 'sp1 /=4

 sp1 := -sp1
 sp2 := sp2

 array1[9] := array1[8]
 array1[8] := array1[7]
 array1[7] := array1[6]
 array1[6] := array1[5]
 array1[5] := array1[4]
 array1[4] := array1[3]
 array1[3] := array1[2]
 array1[2] := array1[1]
 array1[1] := array1[0]
 array1[0] := sp1   

 array2[9] := array2[8]
 array2[8] := array2[7]
 array2[7] := array2[6]
 array2[6] := array2[5]
 array2[5] := array2[4]
 array2[4] := array2[3]
 array2[3] := array2[2]
 array2[2] := array2[1]
 array2[1] := array2[0]
 array2[0] := sp2 

 add1 := (array1[0]+array1[1]+array1[2]+array1[3]+array1[4]+array1[5]+array1[6]+array1[7]+array1[8]+array1[9])/10
 add2 := (array2[0]+array2[1]+array2[2]+array2[3]+array2[4]+array2[5]+array2[6]+array2[7]+array2[8]+array2[9])/10
 
 if add1 > -1
   s1 := add1
   d1 := 0
 else
   s1 := -add1
   d1 := 1

 if add2 > -1
   s2 := add2
   d2 := 2
 else
   s2 := -add2
   d2 := 3

 serial.tx(d1)
 serial.tx(s1)       
 waitcnt(clkfreq/100+cnt)
 'motor 2
 serial.tx(d2)
 serial.tx(s2)
 