extends Node2D

@onready var wheel: Node2D = %wheel
## ----------------- Buttons -------------------- ##
@onready var with_button: Sprite2D = %WithButton
@onready var circle: Sprite2D = %Circle
@onready var d_down: Sprite2D = %DDown
@onready var d_left: Sprite2D = %DLeft
@onready var d_right: Sprite2D = %DRight
@onready var d_up: Sprite2D = %DUp
@onready var triangle: Sprite2D = %Triangle
@onready var red_dial: Sprite2D = %RedDial
@onready var enter: Sprite2D = %Enter
@onready var l_1: Sprite2D = %L1
@onready var l_2: Sprite2D = %L2
@onready var l_3: Sprite2D = %L3
@onready var minus: Sprite2D = %Minus
@onready var option: Sprite2D = %Option
@onready var plus: Sprite2D = %Plus
@onready var ps: Sprite2D = %Ps
@onready var r_1: Sprite2D = %R1
@onready var r_2: Sprite2D = %R2
@onready var r_3: Sprite2D = %R3
@onready var share: Sprite2D = %Share
@onready var square: Sprite2D = %Square
@onready var x: Sprite2D = %X

## ----------------- Label -------------------- ##
@onready var wheel_degree: Label = %WheelDegree
@onready var clutch_label: Label = %ClutchLabel
@onready var brake_label: Label = %BrakeLabel
@onready var throttle_label: Label = %ThrottleLabel


func _on_g_29_wheel_steering_changed(degrees: float) -> void:
	wheel.rotation_degrees = degrees
	wheel_degree.text = str(snappedf(degrees, 0.01))


func _on_g_29_wheel_circle_pressed() -> void:
	circle.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_circle_released() -> void:
	circle.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_cross_pressed() -> void:
	x.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_cross_released() -> void:
	x.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_dial_enter_pressed() -> void:
	enter.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_dial_enter_released() -> void:
	enter.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_dial_left_pressed() -> void:
	red_dial.rotate(deg_to_rad(-15.0))
	red_dial.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_dial_left_released() -> void:
	red_dial.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_dial_right_pressed() -> void:
	red_dial.rotate(deg_to_rad(15.0))
	red_dial.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_dial_right_released() -> void:
	red_dial.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_dpad_down_pressed() -> void:
	d_down.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_dpad_down_released() -> void:
	d_down.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_dpad_left_pressed() -> void:
	d_left.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_dpad_left_released() -> void:
	d_left.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_dpad_right_pressed() -> void:
	d_right.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_dpad_right_released() -> void:
	d_right.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_dpad_up_pressed() -> void:
	d_up.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_dpad_up_released() -> void:
	d_up.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_l_1_pressed() -> void:
	l_1.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_l_1_released() -> void:
	l_1.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_l_2_pressed() -> void:
	l_2.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_l_2_released() -> void:
	l_2.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_l_3_pressed() -> void:
	l_3.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_l_3_released() -> void:
	l_3.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_minus_pressed() -> void:
	minus.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_minus_released() -> void:
	minus.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_options_pressed() -> void:
	option.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_options_released() -> void:
	option.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_plus_pressed() -> void:
	plus.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_plus_released() -> void:
	plus.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_ps_pressed() -> void:
	ps.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_ps_released() -> void:
	ps.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_r_1_pressed() -> void:
	r_1.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_r_1_released() -> void:
	r_1.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_r_2_pressed() -> void:
	r_2.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_r_2_released() -> void:
	r_2.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_r_3_pressed() -> void:
	r_3.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_r_3_released() -> void:
	r_3.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_share_pressed() -> void:
	share.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_share_released() -> void:
	share.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_square_pressed() -> void:
	square.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_square_released() -> void:
	square.modulate = Color(1.0,1.0,1.0)


func _on_g_29_wheel_triangle_pressed() -> void:
	triangle.modulate = Color(2.0,2.0,2.0)


func _on_g_29_wheel_triangle_released() -> void:
	triangle.modulate = Color(1.0,1.0,1.0)

## ------------------------------------- ##
## ------------------------------------- ##
## ------------------------------------- ##
@onready var brake: Sprite2D = %Brake
@onready var clutch: Sprite2D = %Clutch
@onready var throttle: Sprite2D = %Throttle



func _on_g_29_pedals_brake_changed(value: float) -> void:
	brake.modulate = Color(1.0 * (1-value),1.0 * (1-value),1.0 * (1-value))
	brake_label.text = str(snappedf(value, 0.001))


func _on_g_29_pedals_clutch_changed(value: float) -> void:
	clutch.modulate = Color(1.0 * (1-value),1.0 * (1-value),1.0 * (1-value))
	clutch_label.text = str(snappedf(value, 0.001))


func _on_g_29_pedals_throttle_changed(value: float) -> void:
	throttle.modulate = Color(1.0 * (1-value),1.0 * (1-value),1.0 * (1-value))
	throttle_label.text = str(snappedf(value, 0.001))
