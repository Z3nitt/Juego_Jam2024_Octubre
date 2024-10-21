extends Node2D
class_name Core
@onready var sprite_core = $Sprite2D
@export var vida3: Texture
@export var vida2: Texture
@export var vida1: Texture

var posicion_fija: Vector2
#Variables declaradas
var max_health: int = 100
var current_health: int = 100


func _ready() -> void:
	sprite_core.texture = vida3
	_actualizar_textura()
#Recibir daño
func _actualizar_textura() -> void:
	match Global.VidaMundo:
		3:
			sprite_core.texture = vida3
		2:
			sprite_core.texture = vida2
		1:
			sprite_core.texture = vida1

# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.VidaMundo == 0:
		get_tree().change_scene_to_file("res://Scenes/gameover.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass
	#if body is Enemigo1:
	#	body.queue_free()
	#	Global.VidaMundo -= 1
	#elif body is Enemigo3:
	#	body.queue_free()
	#	Global.VidaMundo -= 1
	#if Global.VidaMundo == 0:
	#	get_tree().change_scene_to_file("res://Scenes/gameover.tscn")
