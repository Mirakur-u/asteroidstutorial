extends Node

@export var ufo_scene: PackedScene
@onready var timer: UfoTimer = $Timer
@onready var ufo_explosion_audio = $"../ufoExplosionAudio"
@onready var path_top: PathFollow2D = $PathTopLeftRight/PathToFollow
@onready var path_bottom: PathFollow2D = $PathBottomRightLeft/PathToFollow


func _ready():
	timer.timeout.connect(spawn_ufo)


func spawn_ufo():
	var ufo = ufo_scene.instantiate() as Ufo
	var path_to_follow = path_top if randf() > 0.5 else path_bottom as PathFollow2D
	ufo.ufo_destroyed.connect(on_ufo_destroyed)
	if path_to_follow.get_child_count() !=0:
		return
	
	path_to_follow.progress = 0
	ufo.path = path_to_follow
	path_to_follow.add_child(ufo)
	timer.setup_timer()
	timer.start()
	timer.timeout.connect(spawn_ufo)

func on_ufo_destroyed():
	ufo_explosion_audio.play()
