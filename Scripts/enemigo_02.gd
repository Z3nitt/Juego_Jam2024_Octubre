extends CharacterBody2D

@export var speed: float = 100.0  # Velocidad de movimiento del enemigo
@export var max_health: int = 100  # Salud máxima del enemigo
var current_health: int = max_health  # Salud actual del enemigo

@onready var _animated_sprite = $AnimationPlayer  # Referencia al AnimationPlayer
@onready var sprite = $Sprite2D  # Referencia al Sprite2D del enemigo

var jugador: Node2D  # Variable para almacenar la referencia al jugador
var is_flashing: bool = false  # Controla si el enemigo está parpadeando rojo

func _ready() -> void:
	# Reproducir la animación de "Idle" o "Caminar" al comenzar
	_animated_sprite.play("Idle")  # Suponiendo que "Idle" es la animación de reposo del enemigo
	
	# Asignamos el jugador dinámicamente si está presente en la escena
	jugador = get_node("/root/World/Player")  # Ajusta la ruta del jugador en la escena si es necesario

	# Conectar la señal de colisión del área
	$CollisionShape2D.connect("area_entered", Callable(self, "_on_area_entered"))

func _process(delta: float) -> void:
	if jugador:
		# Llamamos a la función de perseguir al jugador
		persigue_a_jugador(jugador)

# Función para hacer que el enemigo persiga al jugador
func persigue_a_jugador(jugador: Node2D) -> void:
	# Usamos la posición global del jugador para evitar que la cámara afecte la lógica de persecución
	var direction = (jugador.global_position - global_position).normalized()

	# Asignar la velocidad del enemigo
	velocity = direction * speed
	
	# Mover al enemigo usando move_and_slide sin argumentos
	move_and_slide()  # No pasamos argumentos ya que el CharacterBody2D usa 'velocity' internamente

	# Si la dirección en x es negativa, voltear el sprite
	if direction.x < 0:
		sprite.scale.x = -abs(sprite.scale.x)  # Voltear a la izquierda
	else:
		sprite.scale.x = abs(sprite.scale.x)  # Voltear a la derecha

	# Reproducir animación de caminar mientras se mueve
	if velocity.length() > 0:
		_animated_sprite.play("Walk")  # Reproducir animación de caminar
	else:
		_animated_sprite.play("Idle")  # Si no se mueve, reproducir animación de reposo

# Función para detectar colisiones con proyectiles
func _on_area_entered(area: Area2D) -> void:
	# Verificar si el área que ingresó es un proyectil
	if area.name == "Node2D":
		apply_damage(25)  # Aplicar daño de 25 puntos
		area.queue_free()  # Destruir el proyectil al colisionar


# Función para aplicar daño al enemigo
func apply_damage(damage_amount: int) -> void:
	# Reducir la salud del enemigo
	current_health -= damage_amount
	
	# Indicar daño con color rojo
	flash_red()

	# Verificar si la salud del enemigo ha llegado a 0
	if current_health <= 0:
		Global.Score +=10
		die()  # Matar al enemigo si la salud es 0 o menos

# Función para parpadear en rojo cuando recibe daño
func flash_red() -> void:
	if not is_flashing:
		is_flashing = true
		sprite.modulate = Color(1, 0, 0)  # Cambiar color a rojo
		await get_tree().create_timer(0.2).timeout  # Esperar 1 segundo usando 'await'
		sprite.modulate = Color(1, 1, 1)  # Restaurar el color original
		is_flashing = false


# Función para manejar la muerte del enemigo
func die() -> void:
	# Aquí puedes agregar animaciones de muerte o efectos
	queue_free()  # Eliminar el enemigo de la escena


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.queue_free()
		get_tree().change_scene_to_file("res://Scenes/gameover.tscn")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	pass
