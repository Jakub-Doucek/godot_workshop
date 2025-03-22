extends CharacterBody2D


@export var speed = 300.0
@export var health = 1

var direction := -1.0


func _physics_process(delta: float) -> void:
	if health <= 0:
		return
		
	if not $RayCast2D.is_colliding():
		swap_direction()

	velocity.x = direction * speed
	var collision = move_and_collide(velocity * delta)

	if collision:
		var collider = collision.get_collider()
		if collider is CharacterBody2D and collider.is_in_group("player"):
			print("Enemy hit player from side")
			if collider.has_method("apply_knockback"):
				collider.apply_knockback(global_position)


func swap_direction():
	direction = direction * -1.0
	scale.x = scale.x * -1.0


func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and health > 0:
		body.jump()
		damage()

func damage():
	health -= 1
	if health == 0:
		$CollisionShape2D.disabled = true
		$AnimatedSprite2D.play("death")
