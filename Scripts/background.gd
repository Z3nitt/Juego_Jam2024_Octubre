extends Node
var posicion_fija: Vector2

#@export var enemigo : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	posicion_fija = $Sprite2D.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	pass
	#var enemy_instance = enemigo.instantiate()
	#enemy_instance.global_position = $PathSpawn/PathFollow2D.global_position
	#add_child(enemy_instance)




func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
