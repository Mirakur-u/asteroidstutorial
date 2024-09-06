extends Area2D

class_name Bullet
var direction: Vector2

@export var bullet_speed = 700
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _process(delta: float) -> void:
	position += direction * bullet_speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
