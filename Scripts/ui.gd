extends CanvasLayer

var life_texture = preload("res://Assets/Lives.png")
var empty_life_texture = preload("res://Assets/Player.png")

@onready var lives_container: HBoxContainer = $MarginContainer/LivesContainer
@onready var asteroids_spawner: AsteroidsSpawner = $"../AsteroidsSpawner"
@onready var life_manager: LifeManager = $"../LifeManager"
@onready var game_over_label: Label = $MarginContainer/CenterContainer/GameOverLabel
@onready var points_label: Label = %PointsLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var lives = life_manager.lives
	
	for i in range(lives):
		var life_text_rect = TextureRect.new()
		life_text_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		life_text_rect.stretch_mode = TextureRect.STRETCH_SCALE
		life_text_rect.texture = life_texture
		life_text_rect.custom_minimum_size = Vector2(32,32)
		lives_container.add_child(life_text_rect)
		
	life_manager.player_life_lost.connect(life_lost)
	asteroids_spawner.points_updated.connect(set_points)
	asteroids_spawner.game_won.connect(game_won)

func life_lost(lives):
	var life_texture: TextureRect = lives_container.get_child(lives)
	life_texture.texture = empty_life_texture
	
	if lives == 0:
		game_over_label.visible = true

func set_points(points: int):
	points_label.text = "%d" %points


func game_won():
	game_over_label.visible = true
	game_over_label.text = "YOU WON!"
	game_over_label.add_theme_color_override("font_color", Color.DARK_GREEN)
