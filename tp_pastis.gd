extends Area3D

@export var connect_portal: Area3D
@onready var tp := $"../../../trasportaciones/tp"
func _on_body_entered(body: Node3D) -> void:
	if body.name == "Jugador":
		body.drop_knife()
		tp.queue_free() 
		var destination = connect_portal.global_transform.origin
		body.global_transform.origin = destination
