extends PlatformerController2D

var particles_effect_scene = preload("res://scenes/prepared/particle_effects/fart.tscn")

func _physics_process(delta):
	var old_acc = acc
	super._physics_process(delta)
	
	if acc.x != 0:
		($AnimatedSprite2D as AnimatedSprite2D).play("walk")
	else:
		$AnimatedSprite2D.play("idle")
		
	$AnimatedSprite2D.scale.x = -1.0 if acc.x < 0 else 1.0	


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
