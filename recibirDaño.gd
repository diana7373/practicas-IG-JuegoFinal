extends Sprite3D

signal no_hp_left

@export var max_hp : int = 100
@onready var barra: ProgressBar = $SubViewport/Panel/ProgressBar

func _ready() -> void:
	barra.max_value = max_hp
	barra.value = max_hp

func take_damage(damage: float):
	barra.value -= damage

	if barra.value <= 0.1:
		no_hp_left.emit()
