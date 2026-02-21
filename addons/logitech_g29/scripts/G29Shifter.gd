## A custom node for handling input from a Logitech Driving Force Shifter.
##
## [G29Shifter] monitors the joypad buttons associated with the H-pattern shifter 
## and emits corresponding signals when gears are engaged or disengaged.
## [br][br]
## [b]Important Note on Reverse Gear:[/b] To engage reverse on a physical Logitech shifter, 
## you must press the shifter knob [i]down[/i] into the base and move it into the 6th gear position. 
## If reverse still does not trigger, your operating system or wheel drivers may be mapping 
## it incorrectly, or the hardware sensor may be failing. Use the [member print_debug_ids] 
## property to see exactly what button ID is firing when you shift.
## [br][br]
## [b]Example Usage:[/b]
## [codeblock]
## func _ready():
##     $G29Shifter.gear_1_pressed.connect(_on_gear_1_engaged)
##     $G29Shifter.gear_reverse_pressed.connect(_on_reverse_engaged)
##
## func _on_gear_1_engaged():
##     current_gear = 1
##     print("Shifted into 1st gear!")
## [/codeblock]
@icon("res://addons/logitech_g29/icons/G29 Shifter.svg")
class_name G29Shifter
extends Node

# --- GEAR SIGNALS ---

## Emitted when the shifter is moved into the 1st gear slot.
signal gear_1_pressed
## Emitted when the shifter is moved out of the 1st gear slot.
signal gear_1_released

## Emitted when the shifter is moved into the 2nd gear slot.
signal gear_2_pressed
## Emitted when the shifter is moved out of the 2nd gear slot.
signal gear_2_released

## Emitted when the shifter is moved into the 3rd gear slot.
signal gear_3_pressed
## Emitted when the shifter is moved out of the 3rd gear slot.
signal gear_3_released

## Emitted when the shifter is moved into the 4th gear slot.
signal gear_4_pressed
## Emitted when the shifter is moved out of the 4th gear slot.
signal gear_4_released

## Emitted when the shifter is moved into the 5th gear slot.
signal gear_5_pressed
## Emitted when the shifter is moved out of the 5th gear slot.
signal gear_5_released

## Emitted when the shifter is moved into the 6th gear slot.
signal gear_6_pressed
## Emitted when the shifter is moved out of the 6th gear slot.
signal gear_6_released

## Emitted when the shifter is pushed down and moved into the reverse position.
signal gear_reverse_pressed
## Emitted when the shifter is moved out of the reverse position.
signal gear_reverse_released


@export_group("Device Settings")

## If [code]true[/code], the node will prioritize connecting to a joypad with "G29" or "Logitech" in its name.
@export var prefer_logitech_g29: bool = true

## The internal joypad ID assigned by Godot. Read-only during gameplay.
@export var device_id: int = -1


@export_group("Troubleshooting")

## If [code]true[/code], continuously scans all 64 possible joypad buttons and prints to the console whenever a button state changes. Very useful for diagnosing hardware issues, like a faulty reverse sensor.
@export var print_debug_ids: bool = true

# Internal State Tracking
var _previous_button_states: Dictionary = {}
var _debug_pressed_buttons: Array[int] = []

var _shifter_map: Dictionary = {
	12: "gear_1",
	13: "gear_2",
	14: "gear_3",
	15: "gear_4",
	16: "gear_5",
	17: "gear_6",
	18: "gear_reverse"
}

func _ready() -> void:
	if device_id == -1: device_id = _pick_device()
	if device_id == -1: 
		set_process(false)
		return
	for btn_name: String in _shifter_map.values():
		_previous_button_states[btn_name] = false

func _process(_delta: float) -> void:
	if print_debug_ids:
		_run_debug_scanner()
		
	for joy_btn: int in _shifter_map.keys():
		var btn_name: String = _shifter_map[joy_btn]
		var is_pressed: bool = Input.is_joy_button_pressed(device_id, joy_btn)
		var was_pressed: bool = _previous_button_states[btn_name]
		
		if is_pressed and not was_pressed: emit_signal(btn_name + "_pressed")
		elif not is_pressed and was_pressed: emit_signal(btn_name + "_released")
		_previous_button_states[btn_name] = is_pressed

func _run_debug_scanner() -> void:
	for i: int in range(64):
		var is_pressed: bool = Input.is_joy_button_pressed(device_id, i)
		var was_pressed: bool = i in _debug_pressed_buttons
		
		if is_pressed and not was_pressed:
			print("DEBUG - Gear Shifter Slot ID: ", i)
			_debug_pressed_buttons.append(i)
		elif not is_pressed and was_pressed:
			_debug_pressed_buttons.erase(i)

func _pick_device() -> int:
	var pads: Array[int] = Input.get_connected_joypads()
	if pads.is_empty(): return -1
	if prefer_logitech_g29:
		for id: int in pads:
			var joy_name: String = Input.get_joy_name(id)
			if "G29" in joy_name or "Logitech" in joy_name: return id
	return pads[0]
