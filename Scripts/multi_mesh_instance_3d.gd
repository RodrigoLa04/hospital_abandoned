extends MultiMeshInstance3D

func _ready():
	print("Script iniciado")

	var ancho = 10
	var largo = 10
	var separacion = 2.0
 # tamaño del bloque, ajústalo si hay huecos o superposición

	var multimesh = MultiMesh.new()
	multimesh.mesh = self.get("mesh")

	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.instance_count = ancho * largo

	var i = 0
	for x in range(ancho):
		for z in range(largo):
			var transform = Transform3D.IDENTITY
			transform.origin = Vector3(x * separacion, 0, z * separacion)
			multimesh.set_instance_transform(i, transform)
			i += 1

	self.multimesh = multimesh
