extends Node3D

@export var distancia := 20.0
@export var velocidad := 0.5

var origen: Vector3
var t := 0.0

func _ready():
	origen = $AnimatableBody3D.global_position

func _physics_process(delta):
	t += delta * velocidad
	var offset = -sin(t) * distancia
	$AnimatableBody3D.global_position = origen + Vector3(0, 0, offset)
