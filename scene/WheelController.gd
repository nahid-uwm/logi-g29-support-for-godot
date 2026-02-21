@tool # Allows the wheel to rotate in the editor
class_name WheelController2D
extends Node2D

## Signal emitted whenever the wheel's rotation is changed
signal wheel_rotated(new_degrees: float)

## The current rotation. Changing this automatically updates the wheel visually.
@export var current_degrees: float = 0.0:
	set(value):
		current_degrees = value
		_apply_rotation()

# Applies the rotation directly to the 2D node
func _apply_rotation() -> void:
	rotation_degrees = current_degrees
	wheel_rotated.emit(current_degrees)

# --- Plug and Play Functions ---

## Call this to set a specific degree value directly
func set_wheel_rotation(degrees: float) -> void:
	current_degrees = degrees

## Call this to spin the wheel continuously (e.g., in _process)
func add_wheel_rotation(delta_degrees: float) -> void:
	current_degrees += delta_degrees
