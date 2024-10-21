extends CharacterBody2D
class_name Enemigo1
@export var max_health: int = 100  # Salud máxima del enemigo
var current_health: int = max_health  # Salud actual del enemigo

@export var speed: float = 100.0  # Velocidad de movimiento del enemigo
@onready var _animated_sprite = $AnimationPlayer  # Referencia al AnimationPlayer
@onready var sprite = $Sprite2D  # Referencia al Sprite2D del enemigo

var is_flashing: bool = false  # Controla si el enemigo está parpadeando rojo
var objetivo: Node2D  # Variable para almacenar la referencia al Core

func _ready() -> void:
	# Reproducir la animación de "Idle" o "Caminar" al comenzar
	_animated_sprite.play("new_animation")  # Suponiendo que "Idle" es la animación de reposo del enemigo
	$Area2D.connect("area_entered", Callable(self, "_on_area_entered"))
	
	# Asignamos el objetivo dinámicamente si está presente en la escena
	# Ajusta la ruta del Core si es necesario según la estructura de tu escena
	objetivo = get_parent().get_node("Core")  # Asegúrate de que la ruta sea correcta

	if not objetivo:
		print("Core no encontrado!")  # Para depuración si no se encuentra el Core
		
	$Area2D.connect("area_entered", Callable(self, "_on_area_entered"))

func _process(delta: float) -> void:
	if objetivo:
		# Llamamos a la función de perseguir al Core
		persigue_a_jugador(objetivo)

# Función para hacer que el enemigo persiga al objetivo (Core)
func persigue_a_jugador(objetivo: Node2D) -> void:
	# Calcular la dirección hacia el Core
	var direction = (objetivo.position - position).normalized()

	# Asignar la velocidad del enemigo
	velocity = direction * speed  # Usamos el vector 'direction' multiplicado por la velocidad
	
	# Mover al enemigo usando move_and_slide() sin argumentos
	move_and_slide()  # No necesitamos pasar ningún argumento aquí

	# Si la dirección en x es negativa, voltear el sprite
	if direction.x < 0:
		sprite.scale.x = -abs(sprite.scale.x)  # Voltear a la izquierda
	else:
		sprite.scale.x = abs(sprite.scale.x)  # Voltear a la derecha

	# Reproducir animación de caminar mientras se mueve
	if velocity.length() > 0:
		_animated_sprite.play("new_animation")  # Reproducir animación de caminar
	else:
		_animated_sprite.play("new_animation")  # Si no se mueve, reproducir animación de reposo
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

# Función para detectar colisiones con proyectiles
func _on_area_entered(area: Area2D) -> void:
	# Verificar si el área que ingresó es un proyectil
	if area.name == "Node2D":
		apply_damage(25)  # Aplicar daño de 25 puntos
		area.queue_free()  # Destruir el proyectil al colisionar

# Función para parpadear en rojo cuando recibe daño
func flash_red() -> void:
	if not is_flashing:
		is_flashing = true
		sprite.modulate = Color(1, 0, 0)  # Cambiar color a rojo
		await get_tree().create_timer(0.2).timeout  # Esperar 0.2 segundos
		sprite.modulate = Color(1, 1, 1)  # Restaurar el color original
		is_flashing = false

# Función para manejar la muerte del enemigo
func die() -> void:
	# Aquí puedes agregar animaciones de muerte o efectos
	
	queue_free()  # Eliminar el enemigo de la escena


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	pass



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.queue_free()
		get_tree().change_scene_to_file("res://Scenes/gameover.tscn")
	#if body is Core:
	#	Global.VidaMundo -=1



func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "":
		print ("ha entrao")
