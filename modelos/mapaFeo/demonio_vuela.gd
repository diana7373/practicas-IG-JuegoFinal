extends Node3D

@onready var anim = $"AnimationPlayer"

func _ready():
	anim.get_animation("Take 001").loop = true
	anim.play("Take 001")
