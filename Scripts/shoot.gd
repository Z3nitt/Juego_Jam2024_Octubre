extends Node2D

@export var speed: float = 500.0  # Speed of the projectile
var velocity: Vector2 = Vector2.ZERO  # Custom velocity

func _physics_process(delta: float) -> void:
	# Move the projectile based on its velocity
	position += velocity * delta
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	pass
