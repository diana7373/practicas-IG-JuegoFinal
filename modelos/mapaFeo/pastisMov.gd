extends Node3D

@onready var anim = $"AnimationPlayer"

func _ready():
	anim.get_animation("animation").loop = true
	anim.play("animation")
