extends CharacterBody2D

var was_on_floor: bool = true

var time_passed: float = 0.0
@onready var start_y: float = position.y

const DUST_PARTICLES = preload("res://Scenes/dust_particles.tscn")
const BURST_PARTICLES = preload("res://Scenes/burst_particles.tscn")

@export var ice_speed: float = 150.0

@export var cherry_speed: float = 300.0
@export var cherry_jump: float = -400.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var ice_collision: CollisionShape2D = $IceCollision
@onready var cherry_collision: CollisionShape2D = $CherryCollision

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_cherry: bool = false
var is_attacking: bool = false
var is_dead_or_won: bool = false
var has_jumped: bool = false

func _ready() -> void:
	update_collision_shapes()


func _physics_process(delta: float) -> void:
	if is_dead_or_won:
		return
	
	if global_position.y > 700:
		take_damage()
	
	if is_on_floor() and velocity.y >= 0:
		has_jumped = false
	
	if Input.is_action_just_pressed("Swap") and not is_attacking:
		stretch(Vector2(1.4, 0.6))
		is_cherry = not is_cherry
		update_collision_shapes()
		
		var particles = BURST_PARTICLES.instantiate()
		particles.global_position = global_position
		get_parent().add_child(particles)
		particles.burst(Color("fc555bff") if is_cherry else Color("fff8deff"))
	
	if Input.is_action_just_pressed("Attack") and not is_cherry and not is_attacking:
		stretch(Vector2(1.3, 0.75))
		perform_ice_attack()
	
	if Input.is_action_just_pressed("Jump") and is_on_floor and is_cherry and not has_jumped:
		stretch(Vector2(0.5, 1.35))
		velocity.y = cherry_jump
		has_jumped = true
	
	if not is_on_floor():
		var grav_mult = 0.85 if is_cherry else 1.3
		velocity.y += (gravity * grav_mult) * delta
	
	var direction := Input.get_axis("Left", "Right")
	var current_speed = cherry_speed if is_cherry else ice_speed
	
	if direction != 0:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
	
	move_and_slide()
	update_animations(direction)
	anim.scale = anim.scale.lerp(Vector2.ONE, 15.0 * delta)
	
	if is_on_floor() and not was_on_floor and is_cherry:
		stretch(Vector2(1.25, 0.75))
		var dust = DUST_PARTICLES.instantiate()
		dust.global_position.x = global_position.x
		dust.global_position.y = global_position.y + 20.0
		get_parent().add_child(dust)
		dust.burst(Color("#ffffffff"))
	was_on_floor = is_on_floor()



func update_collision_shapes() -> void:
	ice_collision.set_deferred("disabled", is_cherry)
	cherry_collision.set_deferred("disabled", not is_cherry)


func perform_ice_attack() -> void:
	is_attacking = true
	anim.play("IceAttack")
	
	for body in attack_area.get_overlapping_bodies():
		if body.has_method("smash"):
			body.smash()
	
	await get_tree().create_timer(0.15).timeout
	is_attacking = false


func update_animations(direction: float) -> void:
	if is_attacking:
		return
	
	var prefix = "Cherry" if is_cherry else "Ice"
	
	if not is_on_floor() and is_cherry:
		anim.play("CherryJump")
	elif direction < 0:
		anim.play(prefix + "WalkLeft")
	elif direction > 0:
		anim.play(prefix + "WalkRight")
	else:
		anim.play(prefix + "Idle")


func take_damage() -> void:
	if is_dead_or_won:
		return
	is_dead_or_won = true
	Global.deaths += 1
	velocity = Vector2.ZERO
	
	var particles = BURST_PARTICLES.instantiate()
	particles.global_position = global_position
	get_parent().add_child(particles)
	particles.burst(Color("fc555bff") if is_cherry else Color("fff8deff"))
	
	anim.play("CherryDamage" if is_cherry else "IceDamage")
	await get_tree().create_timer(0.7).timeout
	
	get_tree().reload_current_scene()

func win_level() -> void:
	if is_dead_or_won:
		return
	is_dead_or_won = true
	velocity = Vector2.ZERO
	anim.play("CherryWin" if is_cherry else "IceWin")
	



func stretch(new_scale: Vector2) -> void:
	anim.scale = new_scale
