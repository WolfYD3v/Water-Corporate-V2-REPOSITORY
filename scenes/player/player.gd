extends CharacterBody3D
class_name Player

# Code for the player rotation from https://forum.godotengine.org/t/cannot-control-the-camera-with-the-mouse-while-it-is-attached-to-a-rotating-3d-object/61806/3
# Thanks to gertkeno for his contribution in the forum
# Original code edited to match what I wanted to do

@export var free_roam_enable: bool = false
@export var debug_top_down_camera_view: bool = false

@onready var camera: Camera3D = $Camera
@onready var player_mouse: Area3D = $PlayerMouseArea
@onready var debug_top_down_camera: Camera3D = $DebugTopDownCamera
@onready var walking_sfx_audio_stream_player_3d: AudioStreamPlayer3D = $WalkingSFXAudioStreamPlayer3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var mouse_sensitivity: float = 0.001

var can_move: bool = true
var can_rotate: bool = true

var _tween

func _ready() -> void:
	animation_player.play("RESET")
	if free_roam_enable: player_mouse.queue_free()
	if not debug_top_down_camera_view: debug_top_down_camera.queue_free()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#if free_roam_enable and can_move:
#
		## Handle jump.
		#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			#velocity.y = JUMP_VELOCITY
#
		#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		#if direction:
			#velocity.x = direction.x * SPEED
			#velocity.z = direction.z * SPEED
		#else:
			#velocity.x = move_toward(velocity.x, 0, SPEED)
			#velocity.z = move_toward(velocity.z, 0, SPEED)
#
		#move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
		if event is InputEventMouseMotion:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and can_rotate:
				rotation.y += - event.relative.x * mouse_sensitivity

func change_position(new_position: Vector3, allow_player_walking_sequence: bool = true, forced: bool = false) -> void:
	if can_move or can_rotate or forced:
		can_move = false
		can_rotate = false
		
		if allow_player_walking_sequence:
			if _tween:
				_tween.kill()
			_tween = get_tree().create_tween()
			_tween.tween_property(self, "position", new_position, 1.0)
			
			while _tween.is_running():
				if not animation_player.is_playing():
					animation_player.speed_scale = randf_range(0.9, 1.1)
					animation_player.play("move_camera")
				walking_sfx_audio_stream_player_3d.pitch_scale = randf_range(2.3, 2.7)
				walking_sfx_audio_stream_player_3d.play()
				await walking_sfx_audio_stream_player_3d.finished
		
		can_move = true
		can_rotate = true
