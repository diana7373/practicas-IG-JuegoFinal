extends Control

func _ready() -> void:
	visible = false

func mostrar():
	visible = true
	get_tree().paused = true

func ocultar():
	visible = false
	get_tree().paused = false

func _on_continuar_pressed() -> void:
	ocultar()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_salir_pressed() -> void:
	get_tree().quit()
