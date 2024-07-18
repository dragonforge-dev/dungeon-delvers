@tool # Needed so it runs in editor.
extends EditorScenePostImport

# Import Script for walls, gives them collision meshes and sets appropriate layers
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
		for child in node.get_children():
			iterate(child)
