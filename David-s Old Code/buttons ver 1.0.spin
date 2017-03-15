'button test code

var

long button, button2

Pub Main
  dira[4]~
  dira[5]~
repeat
  button := ina[4]
  if button == 1
    dira[22] := outa[22] := 1
  if button == 0
    dira[22] := outa[22] := 0

  button2 := ina[5]
  if button2 == 1
    dira[23] := outa[23] := 1
  if button2 == 0
    dira[23] := outa[23] := 0