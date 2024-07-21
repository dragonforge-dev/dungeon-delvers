@tool # Needed so it runs in editor.
extends EditorScenePostImport

# Import Script for floors, gives them collision meshes
func _post_import(scene):
	iterate(scene)
	return scene

# Recursive function that is called on every node
func iterate(node):
	if node != null:
		if node is MeshInstance3D:
			node.create_trimesh_collision()
		for child in node.get_children():
			iterate(child)
