extends PlatformerController2D

var particles_effect_scene = preload("res://scenes/prepared/particle_effects/fart.tscn")

@onready var tile_map_layer := $"../Layer0"
@export var health = 5

var start_position : Vector2

func _ready() -> void:
	start_position = global_position

func is_touching_ladder() -> bool:
	var cell = tile_map_layer.local_to_map(tile_map_layer.to_local(get_global_transform().origin))
	var data = tile_map_layer.get_cell_tile_data(cell)
	if data:
		return data.get_custom_data("ladder")
	else:
		return false


func _physics_process(delta):
	
	if is_knockback:
		velocity = knockback_velocity
		knockback_elapsed += delta
		if knockback_elapsed >= knockback_timer:
			is_knockback = false
			knockback_velocity = Vector2.ZERO
		move_and_slide()
		return
	
	super._physics_process(delta)
	
	if acc.x != 0:
		($AnimatedSprite2D as AnimatedSprite2D).play("walk")
	else:
		$AnimatedSprite2D.play("idle")
		
	$AnimatedSprite2D.scale.x = -1.0 if acc.x < 0 else 1.0	
	
	if global_position.y > 500:
		death()


func death():
	global_position = start_position

func _on_ladder_area_body_entered(body: Node2D) -> void:
	apply_gravity = false
	acc.y = 0
	velocity.y = 0


func _on_ladder_area_body_exited(body: Node2D) -> void:
	apply_gravity = true
	
func _input(event):
	super._input(event)
	
	if Input.is_action_pressed("fart"):
		var effect : GPUParticles2D = particles_effect_scene.instantiate()
		effect.transform.origin = Vector2(-1, 40)
		add_child(effect)
		effect.emitting = true
		effect.finished.connect(_on_effect_finished.bind(effect))
		($AudioStreamPlayer as AudioStreamPlayer).play()

func _on_effect_finished(effect: GPUParticles2D):
	if is_instance_valid(effect):
		effect.queue_free()
		
var knockback_velocity := Vector2.ZERO
var is_knockback := false
var knockback_timer := 0.2
var knockback_elapsed := 0.0

func apply_knockback(from_position: Vector2):
	if is_knockback:
		return
	health -= 1
	$AnimationPlayer.play("damage")
	var direction = (global_position - from_position).normalized()
	knockback_velocity = direction * 600  # Adjust strength
	is_knockback = true
	knockback_elapsed = 0.0
