extends Node3D


@export var key_name: String
@export var open: bool = false


func _on_mobile_detector_body_entered(body: Node3D) -> void:
	if open == false:
		if key_name == "":
			$AnimationPlayer.play("open")
			open = true
		else:
			if body.has_node(key_name):
				$AnimationPlayer.play("unlock")
				open = true
			else:
				$AnimationPlayer.play("locked")


func _on_mobile_detector_body_exited(body: Node3D) -> void:
	if open == true:
		if key_name == "":
			$AnimationPlayer.play("close")
			open = false
		else:
			if body.has_node(key_name):
				$AnimationPlayer.play("close_and_lock")
				open = false
			else:
				$AnimationPlayer.play("close")
				open = false
