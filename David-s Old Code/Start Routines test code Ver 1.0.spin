' LEDbinarysequence.spin
' LED pattern increments by one in binary form up to 25
VAR

  long pattern, input, buttonstate, stack

PUB Main

  cognew(LED, @stack[20])

  repeat
    buttonstate := ina[21]
  
  
Pub LED

  pattern := 0

  repeat while input == 0
    dira[16..20]++
    outa[16..20]++
    pattern += 1
    waitcnt(clkfreq + cnt)
    input := buttonstate

  LED
  