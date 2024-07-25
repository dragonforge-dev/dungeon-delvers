extends Node3D


@export var key: String
@export var open: bool = false


func _on_mobile_detector_body_entered(body: Node3D) -> void:
	if open == false:
		if key == null:
			$AnimationPlayer.play("open")
			open = true
		else:
			if body.has_node("Key"):
				$AnimationPlayer.play("unlock")
				open = true
			else:
				$AnimationPlayer.play("locked")


func _on_mobile_detector_body_exited(body: Node3D) -> void:
	if open == true:
		if key == null:
			$AnimationPlayer.play("close")
			open = false
		else:
			if body.has_node("Key"):
				$AnimationPlayer.play("close_and_lock")
				open = false
			else:
				$AnimationPlayer.play("close")
				open = false
