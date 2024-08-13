@tool
extends EditorScenePostImport

# Import Script for walls: Gives them collision meshes, and sets them to collision layer 2
func _post_import(scene):
	iterate(scene)
	return scene

func iterate(node):
	if node != null:
		if node is MeshInstance3D:
			node.create_trimesh_collision()
		if node is StaticBody3D:
			node.set_collision_layer_value(1, false)
			node.set_collision_layer_value(2, true) # Walls are on Collision Layer 2
			node.set_collision_mask_value(1, false) # Walls don't need to detect anything, so don't need a mask.
		for child in node.get_children():
			iterate(child)
