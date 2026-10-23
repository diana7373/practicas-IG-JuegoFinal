extends Node3D

@onready var anim = $"AnimationPlayer"

func _ready():
	anim.get_animation("rig|rigAction").loop = true
	anim.play("rig|rigAction")
