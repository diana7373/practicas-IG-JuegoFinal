extends Node3D

@onready var anim = $"AnimationPlayer"

func _ready():
	anim.get_animation("Flying").loop = true
	anim.play("Flying")
