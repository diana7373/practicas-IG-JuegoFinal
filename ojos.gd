extends Camera3D

@export var ray_length: float = 5.0
@onready var ray: RayCast3D = $RayCast3D

@onready var player := get_parent()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:

		var mouse_pos = get_viewport().get_mouse_position()

		ray.global_position = project_ray_origin(mouse_pos)
		ray.target_position = project_local_ray_normal(mouse_pos) * ray_length
		ray.force_raycast_update()

		if ray.is_colliding():
			var collider = ray.get_collider()

			# OPCIÓN PRO: grupos, no nombres
			if collider.is_in_group("enemy"):
				if not player.can_attack():
					return
				collider.take_damage(25.0)
