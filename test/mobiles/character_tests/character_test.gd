# GdUnit generated TestSuite
class_name CharacterTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://mobiles/characters/character.gd'


var timeout = 5000
var runner: Variant
var character: CharacterBody3D


func before():
	runner = scene_runner("res://test/test_room.tscn")
	character = runner.invoke("find_child", "Knight")


func after_test():
	character.global_transform.origin = Vector3.ZERO
	character.global_rotation = Vector3.ZERO


func test_update_velocity() -> void:
	var zone = runner.invoke("find_child", "MobileDetector")
	
	character.update_velocity(Vector2(0,1,))
	
	await assert_signal(zone).wait_until(timeout).is_emitted("body_entered", [character])


func test_do_animation() -> void:
	var state_machine = character.get_node("AnimationTree").get("parameters/playback")
	
	character.update_velocity(Vector2(0,1,))

	await assert_func(state_machine, "get_current_node").wait_until(timeout).is_equal("IWR")


func test_rotate_character_spring_arm() -> void:
	var spring_arm = runner.invoke("find_child", "SpringArm3D")
	var model = character.get_node("Rig")
	
	spring_arm.global_rotation = Vector3(0, 1, 0)
	character.rotate_character(spring_arm)
	spring_arm.global_rotation = Vector3.ZERO # Set it back
	
	assert_vector(model.get_rotation()).is_equal_approx(Vector3(0, 0.2, 0), Vector3(0, 0.1, 0))


func test_rotate_character_vector_2() -> void:
	var door = runner.invoke("find_child", "door")
	var model = character.get_node("Rig")
	
	character.rotate_character(Vector2(door.global_position.x, door.global_position.z))
	
	assert_vector(model.get_rotation()).is_equal_approx(Vector3(0, 2.910502, 0), Vector3(0, 0.1, 0))


func test_rotate_character_vector_3() -> void:
	var door = runner.invoke("find_child", "door")
	var model = character.get_node("Rig")
	
	character.rotate_character(door.global_position)
	
	assert_vector(model.get_rotation()).is_equal_approx(Vector3(0, 2.910502, 0), Vector3(0, 0.1, 0))


func test_rotate_character_object() -> void:
	var door = runner.invoke("find_child", "door")
	var model = character.get_node("Rig")
	
	character.rotate_character(door)
	
	assert_vector(model.get_rotation()).is_equal_approx(Vector3(0, 2.910502, 0), Vector3(0, 0.1, 0))


func test_walk_to_target() -> void:
	var door = runner.invoke("find_child", "door")
	var zone = runner.invoke("find_child", "MobileDetector")
	var navigation_agent_3d = character.get_node("NavigationAgent3D")
	
	character.walk_to_target(door)

	await assert_func(navigation_agent_3d, "is_navigation_finished").wait_until(timeout).is_true()
