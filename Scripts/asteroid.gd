extends Area2D

class_name Asteroid

signal on_asteroid_destroyed(size: AsteroidSize, position: Vector2)

var image_array = ["res://Assets/Asteroid_01.png", "res://Assets/Asteroid_02.png","res://Assets/Asteroid_03.png","res://Assets/Asteroid_04.png"]

const Utils = preload("res://Scripts/utils.gd")



@export var speed = randi_range(50,135)
@export var speed_increment_factor = .3
var size = Utils.AsteroidSize.BIG
var direction: Vector2
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var explosion_particles: CPUParticles2D = $ExplosionParticles



func _ready() -> void:
	var scaleValue = 1 / (size + 1.0)
	
	scale = Vector2(scaleValue, scaleValue)
	
	var random_index = randi() % image_array.size()
	var random_image = load(image_array[random_index])
	
	sprite_2d.texture = random_image
	speed = speed + speed*size*speed_increment_factor
	
	var x = randf_range(-1,1)
	var y = randf_range(-1,1)
	direction = Vector2(x,y)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area is Asteroid:
		direction = direction.bounce(direction.normalized())
	if area is Bullet:
		on_destroyed()
		area.queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.queue_free()
		on_destroyed()


func emit_explosion():
	explosion_particles.emitting = true
	explosion_particles.reparent(get_tree().root )
	
func on_destroyed():
	emit_explosion()
	queue_free()
	var new_asteroid_size = size +1
	on_asteroid_destroyed.emit(new_asteroid_size, global_position)
