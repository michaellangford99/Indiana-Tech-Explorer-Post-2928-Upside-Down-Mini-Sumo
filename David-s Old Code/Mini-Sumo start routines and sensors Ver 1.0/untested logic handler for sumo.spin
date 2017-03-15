'' IR_Logic_Handler.spin
'' a spin code designed to read sensor inputs from four sides and decide a
'' motor routine to run
''
''written by David Langford

OBJ

VAR

Long front_input, back_input, left_input, right_input, last_side_seen

PUB Start

repeat
    front_input := front_ir
    back_input  := back_ir
    left_input  := left_ir
    right_input := right_ir
        
    if front_input.byte[5] == 0
        motor1speed := front_speed1
        motor2speed := front_speed2
        last_side_seen := 0
    elseif back_input.byte[5] == 0
        motor1speed := back_speed1
        motor2speed := back_speed2
        last_side_seen := 1
    elseif left_input.byte[5] == 0
        motor1speed := left_speed1
        motor2speed := left_speed2
        last_side_seen := 2
    elseif right_input.byte[5] == 0
        motor1speed := back_speed1
        motor2speed := back_speed2
        last_side_seen := 3
    else
        last_side_seen := 4

    Motors.Set