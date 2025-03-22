class_name Level extends Node2D

@export var next_level : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	%WinContainer.visible = false
	%ContinueButton.pressed.connect(_on_continue_pressed.bind())

func _process(delta: float) -> void:
	%HealthLbl.text = str(%MainCharacter.health)
	
	if %MainCharacter.health < 1:
		get_tree().reload_current_scene()


func _on_continue_pressed():
	get_tree().change_scene_to_packed(next_level)

func _on_win_condition_area_body_entered(body):
	if body.is_in_group("player"):
		%WinContainer.visible = true
