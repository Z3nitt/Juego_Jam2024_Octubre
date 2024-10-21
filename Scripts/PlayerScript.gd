extends CharacterBody2D
class_name Player
@export var speed: float = 200.0  # Ajusta la velocidad según sea necesario
@export var shoot_cooldown: float = 0.5  # Tiempo de recarga en segundos
@export var max_health: float = 100.0  # Salud máxima
@export var projectile_scene: PackedScene  # Referencia a la escena del proyectil

@onready var _animated_sprite = $AnimationPlayer
@onready var shoot_timer = $ShootTimer

var playerHealth: float = max_health  # Comenzamos con la salud completa
var velocityModifier: int = 70
var playerOrientation = "RIGHT"

# Variables para el tiempo de recarga de disparo
var last_shot_time: float = 0.0  # Hora del último disparo
var is_shooting: bool = false


func _ready() -> void:
	# Asegurarse de que la escena del proyectil esté cargada
	projectile_scene = preload("res://Scenes/shoot.tscn")
	shoot_timer.connect("timeout", Callable(self, "_on_shoot_timeout"))

func _physics_process(delta: float) -> void:
	var input_velocity: Vector2 = Vector2.ZERO  # Reiniciar la velocidad de entrada

	# Obtener dirección de movimiento
	if Input.is_action_pressed("D"):  # Mover derecha (D)
		input_velocity.x += 1
	if Input.is_action_pressed("A"):  # Mover izquierda (A)
		input_velocity.x -= 1
	if Input.is_action_pressed("S"):  # Mover abajo (S)
		input_velocity.y += 1
	if Input.is_action_pressed("W"):  # Mover arriba (W)
		input_velocity.y -= 1

	# Normalizar la velocidad de entrada para evitar movimiento diagonal más rápido
	if input_velocity.length() > 0:
		input_velocity = input_velocity.normalized() * speed

	# Mover al personaje
	velocity = input_velocity * delta * velocityModifier  # Calcular la velocidad con el modificador
	move_and_slide()  # Usar move_and_slide con la velocidad incorporada

	# Detección de movimiento
	var is_moving = input_velocity.length() > 0

	# Manejar la animación de caminar solo si no estamos disparando
	if not is_shooting:
		if is_moving:
			_animated_sprite.play("Walk")
			
			if input_velocity.x < 0:  # Movimiento hacia la izquierda
				$"PlayerSprite".scale.x = abs($"PlayerSprite".scale.x) * -1  # Voltear
				playerOrientation = "LEFT"
			elif input_velocity.x > 0:  # Movimiento hacia la derecha
				$"PlayerSprite".scale.x = abs($"PlayerSprite".scale.x)  # Orientación normal
				_animated_sprite.play("Walk")
				playerOrientation = "RIGHT"
		else:
			_animated_sprite.play("Idle")
	else:
		# Si estamos disparando, manejamos la animación de disparo
		if is_moving:
			_animated_sprite.play("ShootWalk")
		else:
			_animated_sprite.play("ShootIdle")

	# Verificar si ha pasado suficiente tiempo desde el último disparo
	var current_time = Time.get_ticks_msec() / 1000.0  # Obtener el tiempo en segundos
	if current_time - last_shot_time >= shoot_cooldown:
		if Input.is_action_just_pressed("ui_up"):  # Flecha arriba
			handle_shooting("UP", is_moving)
		elif Input.is_action_just_pressed("ui_down"):  # Flecha abajo
			handle_shooting("DOWN", is_moving)
		elif Input.is_action_just_pressed("ui_left"):  # Flecha izquierda
			handle_shooting("LEFT", is_moving)
		elif Input.is_action_just_pressed("ui_right"):  # Flecha derecha
			handle_shooting("RIGHT", is_moving)

func handle_shooting(direction: String, is_moving: bool) -> void:
	is_shooting = true
	
	if direction == "LEFT":  # Movimiento hacia la izquierda
		$"PlayerSprite".scale.x = abs($"PlayerSprite".scale.x) * -1  # Voltear
		playerOrientation = "LEFT"
	elif direction == "RIGHT":  # Movimiento hacia la derecha
		$"PlayerSprite".scale.x = abs($"PlayerSprite".scale.x)  # Orientación normal
		_animated_sprite.play("Walk")
		playerOrientation = "RIGHT"
	
	# Reproducir animación de disparo si nos estamos moviendo o no
	if direction == playerOrientation:
		if is_moving:
			_animated_sprite.play("ShootWalk")
		else:
			_animated_sprite.play("ShootIdle")
	
	shoot_timer.start()  # Inicia el temporizador de recarga
	shoot_projectile(direction, is_moving)  # Dispara el proyectil

# Función para disparar el proyectil
func shoot_projectile(direction: String, is_moving: bool) -> void:
	if projectile_scene:
		
		if direction != "DOWN" and direction != "UP":
			if direction != playerOrientation:
				return
				
		var projectile = projectile_scene.instantiate()
		var current_time = Time.get_ticks_msec() / 1000.0
		last_shot_time = current_time

		# Configuración de la posición del proyectil
		if playerOrientation == "RIGHT":
			projectile.position = position + Vector2(40, 0)
		elif playerOrientation == "LEFT":
			projectile.position = position - Vector2(40, 0)

		# Configuración de la velocidad y rotación del proyectil
		match direction:
			"UP":
				projectile.velocity = Vector2(0, -500)
				projectile.rotation_degrees = -90
			"DOWN":
				projectile.velocity = Vector2(0, 500)
				projectile.rotation_degrees = 90
			"RIGHT":
				projectile.velocity = Vector2(500, 0)
				projectile.rotation_degrees = 0
			"LEFT":
				projectile.velocity = Vector2(-500, 0)
				projectile.rotation_degrees = 180
		
		var animation_player = projectile.get_node("AnimationPlayer")  # Adjust the path if necessary
		if animation_player:
			animation_player.play("Shoot")  # Make sure the animation name matches what you've set in the AnimationPlayer
		
		get_parent().add_child(projectile)
	else:
		print("¡La escena del proyectil no está cargada!")

# Función para recibir daño
func take_damage(damage_amount: float) -> void:
	playerHealth -= damage_amount
	if playerHealth <= 0:
		playerHealth = 0
		die()  # Matar al jugador si la salud llega a 0

# Función para manejar la muerte del jugador
func die() -> void:
	print("¡El jugador ha muerto!")
	# Aquí puedes agregar animaciones de muerte o lógica de reinicio

func _on_shoot_timer_timeout() -> void:
	is_shooting = false
