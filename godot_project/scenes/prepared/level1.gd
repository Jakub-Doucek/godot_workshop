extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#$moving_platform_wrong/AnimationPlayer.play("platform_move")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_finish_level_area_body_entered(body):
	$CanvasLayer/CenterContainer/Label.visible = true
