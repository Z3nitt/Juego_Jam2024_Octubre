extends CanvasLayer
@onready var corazon1 = $Scoreboard/MarginContainer/Corazon1
@onready var corazon2 = $Scoreboard/MarginContainer/Corazon2
@onready var corazon3 = $Scoreboard/MarginContainer/Corazon3

func _process(_delta) -> void:
	%Score.text = "SCORE: "+ str(Global.Score)
	match Global.VidaMundo:
		3:
			corazon1.texture = load("res://assets/corazon_completo.png")
			corazon2.texture = load("res://assets/corazon_completo.png")
			corazon3.texture = load("res://assets/corazon_completo.png")
		2:
			corazon1.texture = load("res://assets/corazon_completo.png")
			corazon2.texture = load("res://assets/corazon_completo.png")
			corazon3.texture = load("res://assets/corazon_vacio.png")
		1:
			corazon1.texture = load("res://assets/corazon_completo.png")
			corazon2.texture = load("res://assets/corazon_vacio.png")
			corazon3.texture = load("res://assets/corazon_vacio.png")
