extends CharacterBody2D


class_name Player

signal on_player_died
@onready var blinking_timer: Timer = $BlinkingTimer
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var engine_sprite: Sprite2D = $EngineSprite
@onready var engine_audio: AudioStreamPlayer2D = $EngineAudio


@export var max_speed = 10
@export var rotation_speed = 3.5
@export var velocity_damping_factor = .5
@export var linear_velocity = 200



var is_invincible:bool = false
var input_vector: Vector2

var rotation_direction:int

func _ready():
	blinking_timer.timeout.connect(toggle_visibility)
	invincibility_timer.timeout.connect(stop_invincibility)



func _process(delta):
	input_vector.x = Input.get_action_strength("rotate_left") - Input.get_action_strength("rotate_right")
	input_vector.y = Input.get_action_strength("thrust")
	
	if Input.is_action_pressed("rotate_left"):
		rotation_direction = -1
	elif Input.is_action_pressed("rotate_right"):
		rotation_direction = 1
	else:
		rotation_direction = 0
		
	if input_vector.y !=0:
		animation_player.play("engine_animation")
		#engine_audio.play()
		if !engine_audio.is_playing():
			engine_audio.play()
	else:
		engine_audio.stop()
		animation_player.stop()
		engine_sprite.visible = false

func _physics_process(delta):
	rotation += rotation_direction * rotation_speed * delta
	if(input_vector.y > 0):
		accelerate_forward(delta)
	elif input_vector.y == 0 && velocity != Vector2.ZERO:
		slow_down_and_stop(delta)
		
	move_and_collide(velocity * delta)
		

func accelerate_forward(delta: float):
	velocity += (input_vector * linear_velocity * delta).rotated(rotation)
	velocity.limit_length(max_speed)

func slow_down_and_stop(delta: float):
	velocity = lerp(velocity, Vector2.ZERO, velocity_damping_factor * delta)

	if velocity.y >= -0.1 && velocity.y <= 0.1:
		velocity.y = 0



func start_invincibility():
	is_invincible = true
	blinking_timer.start()
	invincibility_timer.start()

func toggle_visibility():
	if sprite_2d.visible:
		sprite_2d.visible = false
	else:
		sprite_2d.visible = true
		


func stop_invincibility():
	is_invincible = false
	sprite_2d.visible = true
	blinking_timer.stop()
	invincibility_timer.stop()
