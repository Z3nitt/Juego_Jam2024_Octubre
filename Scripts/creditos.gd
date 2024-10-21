extends Control

@onready var video = $VideoStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	video.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu_principal.tscn") # Replace with function body.
