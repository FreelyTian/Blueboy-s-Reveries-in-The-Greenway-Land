extends CharacterBody2D

var name_c = 'Garret'
var one = 'hello'
var sfx = preload("res://Assets/Sounds/sfx/beepD.wav")

func _on_dialog_caller_body_entered(body):
	if body.is_in_group('player'):
		print('in')
		DialogueManager.start_chat(name_c, one, global_position, sfx)
