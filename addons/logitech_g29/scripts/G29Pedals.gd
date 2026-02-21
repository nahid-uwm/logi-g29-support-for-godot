## A custom node for handling pedal input from a Logitech G29 Racing Wheel.
##
## [G29Pedals] processes raw joypad axis values from the throttle, brake, and clutch 
## pedals and converts them into normalized, easy-to-use values (0.0 to 1.0). 
## It also features a built-in mapping system allowing players to rebind their pedals at runtime.
## [br][br]
## [b]Example Usage:[/b]
## [codeblock]
## func _ready():
##     $G29Pedals.throttle_changed.connect(_on_throttle_pressed)
##
## func _on_throttle_pressed(value: float):
##     # value is 0.0 (resting) to 1.0 (floored)
##     car_acceleration = max_acceleration * value
## [/codeblock]
@icon("res://addons/logitech_g29/icons/G29 Pedal.svg")
class_name G29Pedals
extends Node

# --- NORMALIZED SIGNALS (0.0 to 1.0) ---

## Emitted when the throttle pedal is pressed or released. 
## The [param value] ranges from [code]0.0[/code] (unpressed) to [code]1.0[/code] (fully pressed).
signal throttle_changed(value: float)

## Emitted when the brake pedal is pressed or released. 
## The [param value] ranges from [code]0.0[/code] (unpressed) to [code]1.0[/code] (fully pressed).
signal brake_changed(value: float)

## Emitted when the clutch pedal is pressed or released. 
## The [param value] ranges from [code]0.0[/code] (unpressed) to [code]1.0[/code] (fully pressed).
signal clutch_changed(value: float)

# --- RAW SIGNALS (-1.0 to 1.0) ---

## Emitted when the raw throttle axis changes. The [param value] typically ranges from [code]-1.0[/code] to [code]1.0[/code].
signal throttle_raw_changed(value: float)

## Emitted when the raw brake axis changes. The [param value] typically ranges from [code]-1.0[/code] to [code]1.0[/code].
signal brake_raw_changed(value: float)

## Emitted when the raw clutch axis changes. The [param value] typically ranges from [code]-1.0[/code] to [code]1.0[/code].
signal clutch_raw_changed(value: float)

# --- MAPPING SIGNALS ---

## Emitted after [method start_mapping_pedal] successfully detects a physical pedal press and binds it.
## [param pedal_name] will be the string passed to the mapping function, and [param axis_index] is the newly assigned joypad axis.
signal mapping_complete(pedal_name: String, axis_index: int)


@export_group("Device Settings")

## If [code]true[/code], the node will prioritize connecting to a joypad with "G29" or "Logitech" in its name.
@export var prefer_logitech_g29: bool = true

## The internal joypad ID assigned by Godot. Read-only during gameplay.
@export var device_id: int = -1


@export_group("Hardware Axes Mapping")

## The joypad axis mapped to the throttle. Can be reassigned at runtime using [method start_mapping_pedal].
@export var throttle_axis: JoyAxis = JOY_AXIS_LEFT_Y 
## The joypad axis mapped to the brake. Can be reassigned at runtime using [method start_mapping_pedal].
@export var brake_axis: JoyAxis = JOY_AXIS_RIGHT_X
## The joypad axis mapped to the clutch. Can be reassigned at runtime using [method start_mapping_pedal].
@export var clutch_axis: JoyAxis = JOY_AXIS_RIGHT_Y


@export_group("Pedal Inversion")

## Reverses the normalized output for the throttle. Sim racing pedals often read [code]-1.0[/code] when fully pressed and [code]1.0[/code] when resting. Check this if your pedal is acting backward.
@export var invert_throttle: bool = true
## Reverses the normalized output for the brake.
@export var invert_brake: bool = true
## Reverses the normalized output for the clutch.
@export var invert_clutch: bool = true


@export_group("Debug")

## If [code]true[/code], prints normalized pedal outputs and mapping success alerts to the console.
@export var debug_print: bool = true

## The minimum change required (on a 0.0 to 1.0 scale) before a new debug message is printed. 
## Set to [code]0.01[/code] to see 1% micro-movements, or [code]0.1[/code] for 10% steps to reduce console spam.
@export var debug_pedal_threshold: float = 0.01

# Internal State Tracking
var _last_throttle: float = 0.0
var _last_brake: float = 0.0
var _last_clutch: float = 0.0

var _last_raw_throttle: float = 0.0
var _last_raw_brake: float = 0.0
var _last_raw_clutch: float = 0.0

# Used to prevent debug console spam based on the threshold
var _last_printed_throttle: float = 0.0
var _last_printed_brake: float = 0.0
var _last_printed_clutch: float = 0.0

# Mapping State
var _is_mapping: bool = false
var _pedal_being_mapped: String = ""

func _ready() -> void:
	if device_id == -1: device_id = _pick_device()
	if device_id == -1: 
		set_process(false)
		return

func _process(_delta: float) -> void:
	# If we are currently mapping a pedal, skip normal driving logic
	if _is_mapping:
		_process_mapping()
		return 

	_process_pedals()

func _process_pedals() -> void:
	# THROTTLE
	var raw_throttle: float = Input.get_joy_axis(device_id, throttle_axis)
	if raw_throttle != _last_raw_throttle:
		throttle_raw_changed.emit(raw_throttle)
		_last_raw_throttle = raw_throttle
		
	var throttle_val: float = _normalize_pedal(raw_throttle, invert_throttle)
	if throttle_val != _last_throttle:
		throttle_changed.emit(throttle_val)
		_last_throttle = throttle_val
		
		# Debug print with customizable spam prevention
		if debug_print and abs(throttle_val - _last_printed_throttle) >= debug_pedal_threshold:
			print("G29Pedals Debug: throttle_changed (Axis ID: %d) | Norm: %.4f | Raw: %.4f" % [throttle_axis, throttle_val, raw_throttle])
			_last_printed_throttle = throttle_val

	# BRAKE
	var raw_brake: float = Input.get_joy_axis(device_id, brake_axis)
	if raw_brake != _last_raw_brake:
		brake_raw_changed.emit(raw_brake)
		_last_raw_brake = raw_brake

	var brake_val: float = _normalize_pedal(raw_brake, invert_brake)
	if brake_val != _last_brake:
		brake_changed.emit(brake_val)
		_last_brake = brake_val
		
		# Debug print with customizable spam prevention
		if debug_print and abs(brake_val - _last_printed_brake) >= debug_pedal_threshold:
			print("G29Pedals Debug: brake_changed (Axis ID: %d) | Norm: %.4f | Raw: %.4f" % [brake_axis, brake_val, raw_brake])
			_last_printed_brake = brake_val

	# CLUTCH
	var raw_clutch: float = Input.get_joy_axis(device_id, clutch_axis)
	if raw_clutch != _last_raw_clutch:
		clutch_raw_changed.emit(raw_clutch)
		_last_raw_clutch = raw_clutch

	var clutch_val: float = _normalize_pedal(raw_clutch, invert_clutch)
	if clutch_val != _last_clutch:
		clutch_changed.emit(clutch_val)
		_last_clutch = clutch_val
		
		# Debug print with customizable spam prevention
		if debug_print and abs(clutch_val - _last_printed_clutch) >= debug_pedal_threshold:
			print("G29Pedals Debug: clutch_changed (Axis ID: %d) | Norm: %.4f | Raw: %.4f" % [clutch_axis, clutch_val, raw_clutch])
			_last_printed_clutch = clutch_val

# --- MANUAL MAPPING FUNCTIONS ---

## Halts standard input processing and waits for the player to press a physical pedal.
## Once an axis change greater than 0.5 is detected, it assigns that axis to the requested pedal
## and resumes normal operation.
## [br][br]
## [b]Example Usage:[/b]
## [codeblock]
## # Called when a player clicks a "Remap Throttle" button in the UI
## func _on_remap_throttle_button_pressed():
##     $G29Pedals.start_mapping_pedal("throttle")
## [/codeblock]
## [br]
## Accepted strings: [code]"throttle"[/code], [code]"brake"[/code], [code]"clutch"[/code].
func start_mapping_pedal(pedal_name: String) -> void:
	if pedal_name not in ["throttle", "brake", "clutch"]:
		push_error("G29Pedals: Invalid pedal name. Use 'throttle', 'brake', or 'clutch'.")
		return
	
	_pedal_being_mapped = pedal_name
	_is_mapping = true
	
	if debug_print: 
		print("G29Pedals Debug: Press the ", pedal_name, " pedal now to map it...")

func _process_mapping() -> void:
	# Rapidly scan all possible joystick axes
	for axis: int in range(JOY_AXIS_MAX):
		var value: float = Input.get_joy_axis(device_id, axis)
		
		# If an axis is pressed hard enough (ignoring tiny stick drift)
		if abs(value) > 0.5:
			_assign_axis_to_pedal(_pedal_being_mapped, axis)
			_is_mapping = false
			mapping_complete.emit(_pedal_being_mapped, axis)
			
			if debug_print: 
				print("G29Pedals Debug: Success! ", _pedal_being_mapped, " mapped to axis ", axis)
			return

func _assign_axis_to_pedal(pedal_name: String, axis: int) -> void:
	if pedal_name == "throttle": throttle_axis = axis
	elif pedal_name == "brake": brake_axis = axis
	elif pedal_name == "clutch": clutch_axis = axis

# --- UTILITIES ---

func _normalize_pedal(raw_value: float, invert: bool) -> float:
	var normalized: float = (raw_value + 1.0) / 2.0
	if invert: return 1.0 - normalized
	return normalized

func _pick_device() -> int:
	var pads: Array[int] = Input.get_connected_joypads()
	if pads.is_empty(): return -1
	if prefer_logitech_g29:
		for id: int in pads:
			var joy_name: String = Input.get_joy_name(id)
			if "G29" in joy_name or "Logitech" in joy_name: return id
	return pads[0]
