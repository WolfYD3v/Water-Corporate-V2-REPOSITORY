extends CharacterBody3D
class_name Player

# Code for the player rotation from https://forum.godotengine.org/t/cannot-control-the-camera-with-the-mouse-while-it-is-attached-to-a-rotating-3d-object/61806/3
# Thanks to gertkeno for his contribution in the forum
# Original code edited to match what I wanted to do

@export var free_roam_enable: bool = false

@onready var camera: Camera3D = $Camera
@onready var player_mouse: Area3D = $PlayerMouseArea

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var mouse_sensitivity: float = 0.001

func _ready() -> void:
	if free_roam_enable: player_mouse.queue_free()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if not free_roam_enable:
		return

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
		if event is InputEventMouseMotion:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				rotation.y += - event.relative.x * mouse_sensitivity
