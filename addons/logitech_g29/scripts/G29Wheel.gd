## A custom node for handling input from a Logitech G29 Racing Wheel.
##
## [G29Wheel] detects a connected racing wheel and translates raw joypad inputs 
## into human-readable signals. It calculates steering degrees based on the 
## [member wheel_range_degrees] and maps all face buttons, D-pad inputs, 
## paddles, and center dials to individual pressed/released signals.
## [br][br]
## By default, it will automatically search for the wheel if [member prefer_logitech_g29] is enabled.
@icon("uid://ch73ynu3lh3p")
class_name G29Wheel
extends Node

## Emitted when the steering wheel angle changes. The [param degrees] value is calculated using the raw axis and [member wheel_range_degrees].
signal steering_changed(degrees: float)

## Emitted when the raw steering axis changes. The [param value] is typically between -1.0 (left) and 1.0 (right).
signal steering_raw_changed(value: float)

# Face Buttons
## Emitted when the Cross (X) button is pressed down.
signal cross_pressed
## Emitted when the Cross (X) button is released.
signal cross_released
## Emitted when the Circle button is pressed down.
signal circle_pressed
## Emitted when the Circle button is released.
signal circle_released
## Emitted when the Square button is pressed down.
signal square_pressed
## Emitted when the Square button is released.
signal square_released
## Emitted when the Triangle button is pressed down.
signal triangle_pressed
## Emitted when the Triangle button is released.
signal triangle_released

# D-Pad
## Emitted when the D-pad Up direction is pressed.
signal dpad_up_pressed
## Emitted when the D-pad Up direction is released.
signal dpad_up_released
## Emitted when the D-pad Down direction is pressed.
signal dpad_down_pressed
## Emitted when the D-pad Down direction is released.
signal dpad_down_released
## Emitted when the D-pad Left direction is pressed.
signal dpad_left_pressed
## Emitted when the D-pad Left direction is released.
signal dpad_left_released
## Emitted when the D-pad Right direction is pressed.
signal dpad_right_pressed
## Emitted when the D-pad Right direction is released.
signal dpad_right_released

# Shoulders & Paddles
## Emitted when the L1 button (left paddle) is pressed.
signal l1_pressed
## Emitted when the L1 button (left paddle) is released.
signal l1_released
## Emitted when the R1 button (right paddle) is pressed.
signal r1_pressed
## Emitted when the R1 button (right paddle) is released.
signal r1_released
## Emitted when the L2 button is pressed.
signal l2_pressed
## Emitted when the L2 button is released.
signal l2_released
## Emitted when the R2 button is pressed.
signal r2_pressed
## Emitted when the R2 button is released.
signal r2_released
## Emitted when the L3 button is pressed.
signal l3_pressed
## Emitted when the L3 button is released.
signal l3_released
## Emitted when the R3 button is pressed.
signal r3_pressed
## Emitted when the R3 button is released.
signal r3_released

# System & Dials
## Emitted when the Share button is pressed.
signal share_pressed
## Emitted when the Share button is released.
signal share_released
## Emitted when the Options button is pressed.
signal options_pressed
## Emitted when the Options button is released.
signal options_released
## Emitted when the PlayStation (PS) button is pressed.
signal ps_pressed
## Emitted when the PlayStation (PS) button is released.
signal ps_released
## Emitted when the Plus (+) button is pressed.
signal plus_pressed
## Emitted when the Plus (+) button is released.
signal plus_released
## Emitted when the Minus (-) button is pressed.
signal minus_pressed
## Emitted when the Minus (-) button is released.
signal minus_released
## Emitted when the red selection dial is turned right.
signal dial_right_pressed
## Emitted when the red selection dial right-turn is released.
signal dial_right_released
## Emitted when the red selection dial is turned left.
signal dial_left_pressed
## Emitted when the red selection dial left-turn is released.
signal dial_left_released
## Emitted when the button inside the red selection dial is pressed.
signal dial_enter_pressed
## Emitted when the button inside the red selection dial is released.
signal dial_enter_released


@export_group("Device Settings")

## If [code]true[/code], the node will prioritize connecting to a joypad with "G29" or "Logitech" in its name.
@export var prefer_logitech_g29: bool = true

## The internal joypad ID assigned by Godot. Read-only during gameplay; automatically assigned by [method _pick_device].
@export var device_id: int = -1

## The maximum physical rotation of the wheel in degrees. The G29 defaults to 900 degrees (450 left, 450 right).
@export var wheel_range_degrees: float = 900.0

## The joypad axis used to track steering. Defaults to [constant JOY_AXIS_LEFT_X].
@export var steering_axis: JoyAxis = JOY_AXIS_LEFT_X


@export_group("Debug")

## If [code]true[/code], the node will print connection status, button presses, and steering changes to the console.
@export var debug_print: bool = true

## The minimum change in degrees required before a new debug message is printed for steering. Prevents console spam.
@export var debug_steering_threshold: float = 0.5


# Internal variables (Double hashes are omitted here as they do not need public documentation)
var _previous_button_states: Dictionary = {}
var _last_steering: float = 0.0
var _last_raw_steering: float = 0.0
var _last_printed_steering: float = 0.0

var _button_map: Dictionary = {}
var _dpad_map: Dictionary = {}

func _ready() -> void:
	_button_map = {
		0: "cross",        
		1: "square",       
		2: "circle",       
		3: "triangle",     
		4: "r1",           
		5: "l1",           
		6: "r2",           
		7: "l2",           
		8: "share",        
		9: "options",      
		10: "r3",          
		11: "l3",          
		19: "plus",        
		20: "minus",       
		21: "dial_right",  
		22: "dial_left",   
		23: "dial_enter",  
		24: "ps"           
	}
	
	_dpad_map = {
		JOY_BUTTON_DPAD_UP: "dpad_up",
		JOY_BUTTON_DPAD_DOWN: "dpad_down",
		JOY_BUTTON_DPAD_LEFT: "dpad_left",
		JOY_BUTTON_DPAD_RIGHT: "dpad_right"
	}

	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	_attempt_connection()

func _process(_delta: float) -> void:
	if _button_map.is_empty() or _dpad_map.is_empty():
		return
		
	_process_steering()
	_process_buttons(_button_map)
	_process_buttons(_dpad_map)

func _process_steering() -> void:
	var raw_steer: float = Input.get_joy_axis(device_id, steering_axis)
	if raw_steer != _last_raw_steering:
		steering_raw_changed.emit(raw_steer)
		_last_raw_steering = raw_steer
		
	var current_steer_deg: float = raw_steer * (wheel_range_degrees * 0.5)
	if current_steer_deg != _last_steering:
		steering_changed.emit(current_steer_deg)
		_last_steering = current_steer_deg
		
		if debug_print and abs(current_steer_deg - _last_printed_steering) >= debug_steering_threshold:
			print("G29Wheel Debug: steering_changed | Degrees: %.2f | Raw: %.4f" % [current_steer_deg, raw_steer])
			_last_printed_steering = current_steer_deg

func _process_buttons(map_to_check: Dictionary) -> void:
	for joy_btn: int in map_to_check.keys():
		var btn_name: String = map_to_check[joy_btn]
		var is_pressed: bool = Input.is_joy_button_pressed(device_id, joy_btn)
		var was_pressed: bool = _previous_button_states.get(btn_name, false)
		
		if is_pressed and not was_pressed: 
			emit_signal(btn_name + "_pressed")
			if debug_print: print("G29Wheel Debug: ", btn_name, "_pressed emitted (Button ID: ", joy_btn, ")")
		elif not is_pressed and was_pressed: 
			emit_signal(btn_name + "_released")
			if debug_print: print("G29Wheel Debug: ", btn_name, "_released emitted (Button ID: ", joy_btn, ")")
			
		_previous_button_states[btn_name] = is_pressed

## Attempts to find and connect to a valid joypad device based on [member prefer_logitech_g29].
func _attempt_connection() -> void:
	device_id = _pick_device()
	if device_id == -1:
		if debug_print: print("G29Wheel Warning: No wheel found.")
		set_process(false)
		return
	
	for btn_name: String in _button_map.values(): _previous_button_states[btn_name] = false
	for btn_name: String in _dpad_map.values(): _previous_button_states[btn_name] = false
	set_process(true)

func _on_joy_connection_changed(device: int, connected: bool) -> void:
	if connected and device_id == -1: _attempt_connection()
	elif not connected and device == device_id:
		device_id = -1
		set_process(false)

## Scans connected joypads and returns the device ID of the wheel. Returns -1 if no wheel is found.
func _pick_device() -> int:
	var pads: Array[int] = Input.get_connected_joypads()
	if pads.is_empty(): return -1
	if prefer_logitech_g29:
		for id: int in pads:
			var joy_name: String = Input.get_joy_name(id)
			if "G29" in joy_name or "Logitech" in joy_name: return id
	return pads[0]
