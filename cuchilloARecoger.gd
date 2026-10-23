extends Area3D

func _ready() -> void:
	add_to_group("pickup")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.pickup_knife()
		queue_free()
