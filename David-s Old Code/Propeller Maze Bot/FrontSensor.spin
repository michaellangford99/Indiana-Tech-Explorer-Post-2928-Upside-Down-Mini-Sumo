'FrontSensor.Spin

CON
   
  _clkmode = xtal1 + pll16x                  ' System clock → 80 MHz
  _xinfreq = 5_000_000

OBJ

  SqrWave    : "SquareWave"
  Pulsout    : "Servo32v7 "
  IrRadar    : "IrDetector"
  Debug      : "Parallax Serial Terminal"
  
VAR
    Long stack, ir_results, state, state2, stateofpin, speed, servo0, servo1

Pub init

IrRadar.init(2, 26, 5)
main

Pub get : ir_results

ir_results := IrRadar.distance
