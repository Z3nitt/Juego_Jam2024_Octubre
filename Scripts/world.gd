extends Node2D
signal VidaMundoChanged
# Nodo del jugador instanciado en la escena World
@onready var player = $Player  # Suponiendo que el nodo Player está directamente en la escena World
@onready var core = $Core
@export var enemy1_scene : PackedScene
@export var enemy2_scene : PackedScene
@export var enemy3_scene : PackedScene  # Escena del enemigo que se instancia
@onready var _timer = $EnemySpawnTimer  # El temporizador para spawnear enemigos

var enemigos = []  # Lista de enemigos instanciados en la escena

func _ready() -> void:
	# Iniciar el temporizador para spawnear enemigos
	_timer.start()
	$Core.get_node("Area2D").connect("body_entered", Callable(self, "_on_area_2d_body_entered"))

# Función para instanciar enemigos de forma aleatoria
func spawn_enemy() -> void:
	# Validar que las escenas no sean nulas antes de intentar instanciarlas
	if enemy1_scene == null or enemy2_scene == null or enemy3_scene == null:
		print("Error: Las escenas de los enemigos no están asignadas correctamente.")
		return  # Detener la función si alguna escena es nula
	
	# Generar un número aleatorio para decidir qué tipo de enemigo spawnear
	var random_enemy_type = randi() % 3  # Genera un número entre 0, 1 y 2
	
	# Instanciar un nuevo enemigo basado en el número aleatorio
	var enemigo
	
	if random_enemy_type == 0:
		enemigo = enemy1_scene.instantiate()  # Tipo de enemigo 1
	elif random_enemy_type == 1:
		enemigo = enemy2_scene.instantiate()  # Tipo de enemigo 2
	else:
		enemigo = enemy3_scene.instantiate()  # Tipo de enemigo 3
	
	# Posición aleatoria en la parte superior de la pantalla
	enemigo.position = Vector2(randf_range(0, get_viewport().size.x), -50)

	# Añadir el enemigo a la escena y a la lista
	add_child(enemigo)
	enemigos.append(enemigo)
	
	# Asignar su comportamiento para que persiga al objetivo correspondiente
	if random_enemy_type == 0 or random_enemy_type == 2:
		enemigo.persigue_a_jugador(core)  # Enemigos tipo 1 y 3 siguen al Core
	else:
		enemigo.persigue_a_jugador(player)  # Enemigos tipo 2 siguen al Player


# Llamado por el temporizador cada vez que expire
func _on_enemy_spawn_timer_timeout() -> void:
	# Llamar a la función para spawnear enemigos
	spawn_enemy()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Enemigo1 or body is Enemigo3:
		body.queue_free()
		Global.VidaMundo -= 1
		core._actualizar_textura()
		emit_signal("VidaMundoChanged")
		
	if Global.VidaMundo == 0:
		get_tree().change_scene_to_file("res://Scenes/gameover.tscn")
