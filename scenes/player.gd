extends CharacterBody3D

@export var speed: float = 10.0
@export var acceleration: float = 5.0
@export var gravity: float = 9.8
@export var jump_power: float = 5.0
@export var mouse_sensitivity: float = 0.3
var camera_x_rotation: float = 0.0
@onready var camera: Camera3D = $Head/Camera3D
@onready var head: Node3D = $Head
@export var sprint_multiplier: float = 1.8
@export var normal_fov: float = 75.0
@export var sprint_fov: float = 90.0
@export var fov_lerp_speed: float = 8.0
@export var crouch_speed_multiplier: float = 0.5

@export var standing_height: float = 1.8
@export var crouching_height: float = 1.0
@export var crouch_lerp_speed: float = 10.0

@export var standing_camera_y: float = 1.6
@export var crouching_camera_y: float = 1.0

var is_crouching: bool = false
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))

		var x_delta = event.relative.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation + x_delta, -90.0, 90.0)
		camera.rotation_degrees.x = -camera_x_rotation


func _physics_process(delta):
	var wants_to_crouch = Input.is_action_pressed("crouch")

	# Ceiling check (prevents standing up into objects)
	var can_stand = true
	if is_crouching and not wants_to_crouch:
		var space_check = PhysicsRayQueryParameters3D.create(
			global_position,
			global_position + Vector3.UP * (standing_height - crouching_height)
		)
		var result = get_world_3d().direct_space_state.intersect_ray(space_check)
		if result:
			can_stand = false

	# Final crouch state
	if wants_to_crouch:
		is_crouching = true
	elif can_stand:
		is_crouching = false
	var movement_vector = Vector3.ZERO

	if Input.is_action_pressed("movement_forward"):
		movement_vector -= head.basis.z
	if Input.is_action_pressed("movement_backward"):
		movement_vector += head.basis.z
	if Input.is_action_pressed("movement_left"):
		movement_vector -= head.basis.x
	if Input.is_action_pressed("movement_right"):
		movement_vector += head.basis.x

	movement_vector = movement_vector.normalized()

	# 🆕 Sprint logic
	var current_speed = speed
	if is_crouching:
		current_speed *= crouch_speed_multiplier
	elif Input.is_action_pressed("sprint"):
		current_speed *= sprint_multiplier

	velocity.x = lerp(velocity.x, movement_vector.x * current_speed, acceleration * delta)
	velocity.z = lerp(velocity.z, movement_vector.z * current_speed, acceleration * delta)

	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_power
	
	move_and_slide()
	var target_fov = normal_fov

	if Input.is_action_pressed("sprint"):
		target_fov = sprint_fov
	
	camera.fov = lerp(camera.fov, target_fov, fov_lerp_speed * delta)
	var target_height = standing_height
	var target_camera_y = standing_camera_y

	if is_crouching:
		target_height = crouching_height
		target_camera_y = crouching_camera_y

	# Scale player (simple method)
	scale.y = lerp(scale.y, target_height / standing_height, crouch_lerp_speed * delta)

	# Move camera smoothly
	var cam_pos = camera.position
	cam_pos.y = lerp(cam_pos.y, target_camera_y, crouch_lerp_speed * delta)
	camera.position = cam_pos
	
	
