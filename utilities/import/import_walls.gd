@tool # Needed so it runs in editor.
extends EditorScenePostImport

# Import Script for floors, gives them collision meshes, and sets them to collision layer 2
func _post_import(scene):
	iterate(scene)
	return scene

# Recursive function that is called on every node
func iterate(node):
	if node != null:
		if node is MeshInstance3D:
			node.set_layer_mask_value(1, false)
			node.set_layer_mask_value(2, true)
			node.create_trimesh_collision()
		if node is StaticBody3D:
			node.set_collision_layer_value(1, false)
			node.set_collision_layer_value(2, true)
			node.set_collision_mask_value(1, false)
			node.set_collision_mask_value(2, true)
		for child in node.get_children():
			iterate(child)
