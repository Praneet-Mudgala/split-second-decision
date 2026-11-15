extends StaticBody2D

const BURST_PARTICLES = preload("res://scenes/burst_particles.tscn")

@export var time_before_break: float = 0.8
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var detector: Area2D = $StepDetector

var is_crumbling: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detector.body_entered.connect(_on_step_detected)

func _on_step_detected(body: Node2D) -> void:
	if is_crumbling:
		return
	if body.name == "Player":
		start_crumbling()

func start_crumbling() -> void:
	is_crumbling = true
	
	sprite.frame = 7
	
	await get_tree().create_timer(time_before_break * 0.4).timeout
	
	var particles = BURST_PARTICLES.instantiate()
	particles.global_position = global_position
	get_parent().add_child(particles)
	particles.burst(Color("d29a4fff"))
	
	collision.set_deferred("disabled", true)
	queue_free()
