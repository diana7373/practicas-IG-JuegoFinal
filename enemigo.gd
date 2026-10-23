extends CharacterBody3D

@export var max_hp := 100.0
@export var hp := max_hp
var can_take_damage := true
var timeout := 1.0

@onready var barra: Sprite3D = $enemy/barraVida
@onready var pastillas: Node3D = $"../../pastillas"

func _ready() -> void:
	hp = max_hp

func take_damage(amount: float) -> void:
	if not can_take_damage:
		return

	hp -= amount
	barra.take_damage(amount)

	if hp <= 0:
		pastillas.show()

func _on_barra_vida_no_hp_left() -> void:
	await get_tree().create_timer(timeout).timeout
	queue_free()
