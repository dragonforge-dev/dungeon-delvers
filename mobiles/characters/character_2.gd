extends CharacterBody3D

@export var is_player = false

@export_group("Physics")
@export var speed = 5.0
@export var acceleration = 4.0
@export var mouse_sensitivity = 0.0075
@export var rotation_speed = 12.0

@onready var spring_arm = $SpringArm3D
@onready var model = $Rig
@onready var anim_tree = $AnimationTree

var direction := Vector3.ZERO

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Determine movement
	if is_player: get_input()
	
	#Move the Character
	velocity = lerp(velocity, direction * speed, acceleration * delta)
	do_animation()
	move_and_slide()
	if velocity.length() > 1.0 and is_player: rotate_character(delta) # If the player is moving, line the player up with the camera


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		spring_arm.rotation.x -= event.relative.y * mouse_sensitivity
		spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x, -90.0, 30.0)
		spring_arm.rotation.y -= event.relative.x * mouse_sensitivity


# Gets input from the player and updates velocity.
func get_input() -> void:
	update_velocity(Input.get_vector("move_left", "move_right", "move_forward", "move_backward"))


# Directly updates the velocity. Is used by player input, and can be used
# to manually move the character for cutscene scripting or unit testing.
func update_velocity(input_dir: Vector2) -> void:
	if is_player:
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).rotated(Vector3.UP, spring_arm.rotation.y)
	else:
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)


# Gets a blend for the Idle/Walk/Run State to play.
func do_animation() -> void:
	var vl = velocity * model.transform.basis
	anim_tree.set("parameters/IWR/blend_position", Vector2(vl.x, -vl.z) / speed)


# Rotates the character towards the rotation of the Node or Vector passed to it.
func rotate_character(target, delta: float = 0.0167) -> void:
	if target is SpringArm3D:
		model.rotation.y = lerp_angle(model.rotation.y, target.rotation.y, rotation_speed * delta)
		return
	elif target is Vector2:
		target = Vector3(target.x, global_position.y, target.y)
	elif target is Node:
		target = target.global_position
	
	model.look_at(Vector3(target.x, global_position.y, target.z), Vector3.UP)
