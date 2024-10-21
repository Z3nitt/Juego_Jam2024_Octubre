extends Control

@export var icono_salir_normal: Texture
@export var icono_salir_pressed: Texture

@export var icono_jugar_normal: Texture
@export var icono_jugar_pressed: Texture

@export var icono_creditos_normal: Texture
@export var icono_creditos_pressed: Texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_salir_pressed() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/creditos.tscn")
