OBJ

  SqrWave    : "SquareWave"  

VAR
  long state1, state2, state3, fpin

PUB Start(freqpin)
     fpin := freqpin     'save desired freqout pin
      
PUB IrDetect(pin1, pin2, pin3)

  SqrWave.Freq(0, fpin, 38500) 'freq pin
                    
  dira[fpin]~               'prepare                   
  dira[fpin]~~              'freq it out                 
  waitcnt(clkfreq/1000 + cnt)' wait 1 uS              
  state1 := ina[pin1]       'recieve data 1
  state2 := ina[pin2]       'recieve data 2
  state3 := ina[pin3]       'recieve data 3                 
  dira[fpin]~               'turn freq off                
    
  waitcnt(clkfreq/100 + cnt)'huh????? see if we can get rid of this      

PUB GetIR(statenum)         'return specified state

    case statenum
        1 : return state1
        2 : return state2
        3 : return state3
    