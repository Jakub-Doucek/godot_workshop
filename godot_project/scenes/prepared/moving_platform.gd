@tool
extends AnimatableBody2D

var tween : Tween

var start_position : Vector2

@export var move_to_point : Node2D :
	set(value):
		move_to_point = value
		create_animation()
		
@export var stop_animation_ed := false:
	set(value):
		stop_animation()
		
@export var start_animation_ed := false:
	set(value):
		create_animation()

# Called when the node enters the scene tree for the first time.
func _ready():
	create_animation()
	
func stop_animation():
	if is_node_ready():
		if tween:
			tween.kill()
			tween = null
		global_position = start_position

func create_animation():
	if is_node_ready():
		start_position = global_position
		stop_animation()
	
		if move_to_point:
			tween = get_tree().create_tween()
			var end_position :=  move_to_point.global_position
			tween.tween_property(self, "global_position", end_position, 2)
			tween.tween_property(self, "global_position", start_position, 2)
			tween.set_loops()	
			tween.play()
