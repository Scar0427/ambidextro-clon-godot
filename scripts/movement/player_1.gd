extends CharacterBody2D

#VARIABLES
@export var speed = 2000 #Velocidad del personaje
@export var jumpForce = 2500 #Fuerza del salto
@export var isSecondPlayer = false #¿Es el segundo personaje?

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 5 #Gravedad del motor de físicas
var movement = Vector2.ZERO

#Esto es solo para que se ejecuten las animaciones de movimiento de los personajes.
func _ready() -> void:
	$AnimatedSprite2D.play()

#Método para leer las entradas del teclado y hacer lo que corresponda
func _get_input():
	movement = Vector2.ZERO
	if !isSecondPlayer:
		if Input.is_action_pressed("player1_left"):
			movement.x -= 1
		if Input.is_action_pressed("player1_right"):
			movement.x += 1
		if Input.is_action_pressed("player1_jump"):
			_jump()
	else:
		if Input.is_action_pressed("player2_left"):
			movement.x -= 1
		if Input.is_action_pressed("player2_right"):
			movement.x += 1
		if Input.is_action_pressed("player2_jump"):
			_jump()
	#Normalizar el vector movimiento, para que su valor máximo sea 1
	if movement.length() > 0:
		movement = movement.normalized() * speed
	

#Todo lo que es físicas va aquí. Funciona similar al Update de Unity
func _physics_process(delta: float) -> void:
	_get_input() # Lee la entrada
	velocity.y += gravity * delta #Establece la velocidad en el eje vertical usando como base la gravedad
	move_and_collide(movement * delta) #Mueve al personaje usando el verctor dado, e impide avanzar en caso de colisión
	move_and_slide() #Ejecuta las modificaciones en las físicas (como la velocidad del eje vertical, o sea, gravedad y salto.)

#Jump function
func _jump():
	if is_on_floor(): # SI esta obviamente en el piso (esto lo trae godot por defecto)
		velocity.y = jumpForce * -1 #Modifica la velocidad del moviemiento en y para que salte.
