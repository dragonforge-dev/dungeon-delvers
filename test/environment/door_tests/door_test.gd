class_name DoorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite connects to
const __source = 'res://environment/doors/door.gd'

var timeout = 5000
var runner: Variant
var character: CharacterBody3D
var door: Node3D
var animation_player: AnimationPlayer
var key: Node


func before():
	runner = scene_runner("res://test/test_room.tscn")
	character = runner.invoke("find_child", "Knight")
	door = runner.invoke("find_child", "door")
	animation_player = door.get_node("AnimationPlayer") # There are two animation players in the scene, and we want the one attached to the door.


func after_test():
	character.global_transform.origin = Vector3.ZERO
	character.global_rotation = Vector3.ZERO
	door.key_name = ""
	if is_instance_valid(key):
		key.queue_free()


func test_open_door() -> void:
	# Given we have a door
	
	# When a character approaches the door
	character.move_to(door)

	# Then the door open animation should play
	await assert_func(animation_player, "get_current_animation").wait_until(timeout).is_equal("open")


func test_unlock_door() -> void:
	# Given we have a door with a key
	door.key_name = "Key"
	#   And a character holding the key
	key = Node.new()
	key.name = "Key"
	character.add_child(key)
	
	# When the character approaches the door
	character.move_to(door)
	
	# Then the door open animation should play
	await assert_func(animation_player, "get_current_animation").wait_until(timeout).is_equal("unlock")


func test_locked_door() -> void:
	# Given we have a door with a key
	door.key_name = "Key"
	#   But a character without the key
	
	# When the character approaches the door
	character.move_to(door)
	
	# Then the door locked animation should play
	await assert_func(animation_player, "get_current_animation").wait_until(timeout).is_equal("locked")


func test_close_door() -> void:
	# Given we have a door
	#   And a character has opened the door
	character.move_to(door)
	await assert_func(animation_player, "get_current_animation").wait_until(timeout).is_equal("open")
	# When the character leaves the door
	character.move_to(Vector3(0,0,0))
	# Then the door close animation should play
	await assert_func(animation_player, "get_current_animation").wait_until(timeout).is_equal("close")


func test_lock_door() -> void:
	# Given we have a door with a key
	door.key_name = "RubyGem"
	#   And a character holding the key
	key = Node.new()
	key.name = "RubyGem"
	character.add_child(key)
	#   And that character has opened the door
	character.move_to(door)
	await assert_func(animation_player, "get_current_animation").wait_until(timeout).is_equal("unlock")
	# When the character leaves the door
	character.move_to(Vector3(0,0,0))
	# Then the door lock and close animation should play
	await assert_func(animation_player, "get_current_animation").wait_until(timeout).is_equal("close_and_lock")
