@tool
extends EditorScenePostImport

enum LoopMode { LOOP_NONE, LOOP_LINEAR, LOOP_PINGPONG }
const LOOPMODE = ["LOOP_NONE", "[b][color=green]LOOP_LINEAR[/color][/b]", "[b][color=orange]LOOP_PINGPONG[/color][/b]"]
var scene_name: StringName

# Import Script for characters to set looping animations automatically.
func _post_import(scene):
	scene_name = scene.name
	print_rich("\n[b][color=red]Begin Post-import[/color] -> [color=purple]%s[/color] as [color=green]%s[/color][/b]" % [scene_name, scene.get_class()])
	print_rich("[b]Time/Date Stamp: %s[/b]\n" % [Time.get_datetime_string_from_system(false, true)])
	iterate(scene)
	return scene

func iterate(node):
	if node != null:
		# Add looping animations 
		if node is AnimationPlayer:
			for animation_name in node.get_animation_list():
				if animation_name.contains("Idle") or animation_name.contains("ing"):
					node.get_animation(animation_name).set_loop_mode(LoopMode.LOOP_LINEAR)
				print_rich("Post-import: [b]%s[/b] -> [b]%s[/b]" % [animation_name, LOOPMODE[node.get_animation(animation_name).get_loop_mode()]])
		# Append "_Bone" to BoneAttachment3D nodes just to prevent duplicate names in our scene tree.
		if node is BoneAttachment3D:
			print_rich("Post-import: [b]Renamed [color=green]%s[/color] [color=yellow]%s[/color][/b] -> [color=yellow][b]%s[/b][/color]" % [node.get_class(), node.name, node.name + "_Bone"])
			node.name = node.name + "_Bone"
		# We want to hide everything in the character's hands, and everything they are wearing that is removeable.
		if node is MeshInstance3D and node.get_parent() is  BoneAttachment3D:
			node.set_visible(false)
			print_rich("Post-import: [b]Visibile [color=green]%s[/color] [color=yellow]%s[/color][/b] -> [color=yellow][b]%s[/b][/color]" % [node.get_class(), node.name, get_color_string(node.visible)])
		if node is Skeleton3D:
			node.rotate_y(-180.0)
		# Recursively call this function on any child nodes that exist.
		for child in node.get_children():
			iterate(child)


func get_color_string(value: bool):
	if value:
		return "[color=green]true[/color]"
	else:
		return "[color=red]false[/color]"
