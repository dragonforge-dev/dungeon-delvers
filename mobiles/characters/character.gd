extends CharacterBody3D


@export_group("Physics")
@export var speed = 5.0
@export var acceleration = 4.0
@export var mouse_sensitivity = 0.0075
@export var rotation_speed = 12.0

@onready var spring_arm = $SpringArm3D
@onready var model = $Rig
@onready var anim_tree = $AnimationTree


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#Move the Character
	var direction = get_input()
	update_velocity(direction)
	walk_animation(delta, direction)
	move_and_slide()
	adjust_camera(delta)


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		spring_arm.rotation.x -= event.relative.y * mouse_sensitivity
		spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x, -90.0, 30.0)
		spring_arm.rotation.y -= event.relative.x * mouse_sensitivity


func get_input() -> Vector3:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).rotated(Vector3.UP, spring_arm.rotation.y)
	
	return direction


func update_velocity(direction: Vector3) -> void:
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)


func walk_animation(delta: float, direction: Vector3) -> void:
	velocity = lerp(velocity, direction * speed, acceleration * delta)
	var vl = velocity * model.transform.basis
	anim_tree.set("parameters/IWR/blend_position", Vector2(vl.x, -vl.z) / speed)


# If the player is moving, line the player up with the camera
func adjust_camera(delta: float) -> void:
	if velocity.length() > 1.0:
		model.rotation.y = lerp_angle(model.rotation.y, spring_arm.rotation.y, rotation_speed * delta)
