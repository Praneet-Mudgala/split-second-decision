extends StaticBody2D

const BURST_PARTICLES = preload("res://Scenes/burst_particles.tscn")

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var is_broken: bool = false

func smash() -> void:
	if is_broken:
		return
	is_broken = true
	
	var particles = BURST_PARTICLES.instantiate()
	particles.global_position = global_position
	get_parent().add_child(particles)
	particles.burst(Color("#955a1eff"))
	
	
	collision.set_deferred("disabled", true)
	sprite.frame = 4
	await get_tree().create_timer(0.1).timeout
	sprite.frame = 5
	await get_tree().create_timer(0.1).timeout
	
	queue_free()
