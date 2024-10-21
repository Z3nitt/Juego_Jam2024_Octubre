extends Node

var VidaMundo : int = 3
var Score : int = 0 
var VidaPlayer : int = 1

signal VidaMundoChanged

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func disminuir_vida():
	emit_signal("VidaMundoChanged")
# Called every frame. 'delta' is the elapsed time since the previous frame.
