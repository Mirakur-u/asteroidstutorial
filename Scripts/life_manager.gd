extends Node

class_name LifeManager

signal player_life_lost(lifes_left: int)

const player_start_position = Vector2(0,0)
@export var lives = 3



var player_scene = preload("res://Scenes/player.tscn")
@onready var player: Player = $"../Player"


func _ready() -> void:
	player.on_player_died.connect(decrease_life)
	

func decrease_life():
	lives -= 1
	player_life_lost.emit(lives)
	if lives != 0:
		var player = player_scene.instantiate() as Player
		player.on_player_died.connect(decrease_life)
		get_tree().root.get_node("main").add_child(player)
		player.global_position = player_start_position
		player.start_invincibility()
