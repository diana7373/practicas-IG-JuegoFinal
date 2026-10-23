extends CharacterBody3D

@export var velocidad: float = 5.0
@export var velocidad_correr: float = 9.0
@export var salto: float = 7.0
@export var sensibilidadRaton: float = 0.001

@onready var ojos: Camera3D = $Ojos
@onready var capturado := true

@export var saltos_maximos := 2
var saltos_actuales := 0

var pitch: float = 0.0 #tope de camara hacia arriba

var has_knife := false
@onready var knife: Node3D = $Ojos/Knife

@onready var menu: Control = $"../Menu"

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	knife.visible = false

func _input(event) -> void:
	if event is InputEventMouseMotion and capturado:
		#aqui movemos la camara horizontalmete
		rotate_y(-event.relative.x * sensibilidadRaton)
		#aqui la movemos  verticalmente
		pitch = clamp(pitch - event.relative.y * sensibilidadRaton, deg_to_rad(-89), deg_to_rad(89))
		ojos.rotation.x = pitch
		
	#si apretamos ESC pasamos al modo captura
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if capturado:
			capturado = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			menu.mostrar()
			capturado = true

func  _physics_process(delta: float) -> void:
	var direccion = Vector3.ZERO
	
	if Input.is_action_pressed("mover_adelante"):
		direccion -= transform.basis.z
	
	if Input.is_action_pressed("mover_atras"):
		direccion += transform.basis.z
	
	if Input.is_action_pressed("mover_derecha"):
		direccion += transform.basis.x
	
	if Input.is_action_pressed("mover_izquierda"):
		direccion -= transform.basis.x
		
	direccion = direccion.normalized() #para que no aumente la velocidad por pulsar wd a la vez
	
	var velocidad_actual := velocidad

	if Input.is_action_pressed("correr") and is_on_floor():
		velocidad_actual = velocidad_correr

	velocity.x = direccion.x * velocidad_actual
	velocity.z = direccion.z * velocidad_actual
	
	if is_on_floor():
		saltos_actuales = saltos_maximos
	else:
		velocity.y -= 11 * delta

	if Input.is_action_just_pressed("saltar") and saltos_actuales > 0:
		velocity.y = salto
		saltos_actuales -= 1
	
	move_and_slide()


func can_attack() -> bool:
	return has_knife

func pickup_knife() -> void:
	has_knife = true
	knife.visible = true
	
func drop_knife() -> void:
	has_knife = false
	knife.visible = false
