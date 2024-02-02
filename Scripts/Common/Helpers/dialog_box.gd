extends Control

@onready var label = $dialog_box/MarginContainer/RichTextLabel
@onready var npc_name = $NinePatchRect2/name_npc
@onready var audio_player = $AudioStreamPlayer

var text = ''
var ltr_id = 0

var letter_time = 0.08
var pt_time = 0.12
var space_time = 0.07
var line_id = 0

signal done_writing()

func show_box(text_to_write, charname : String, sfx : AudioStream):
	text = text_to_write
	label.text = text
	npc_name.text = charname
	label.text = ''
	audio_player.stream = sfx
	write_text()

func clear():
	label.text = ''

func write_text():
	label.text += text[ltr_id]
	ltr_id += 1
	if ltr_id >= len(text):
		print('done writing')
		done_writing.emit()
		return
		
	match text[ltr_id]:
		"!",",","?":
			await get_tree().create_timer(pt_time).timeout
		".":
			await get_tree().create_timer(0.14).timeout
		" ":
			await get_tree().create_timer(space_time).timeout
		_ :
			await get_tree().create_timer(letter_time).timeout
	
	if text[ltr_id] != " ":
		play_sfx()
	write_text()
	
func play_sfx():
	var new_audio_player = audio_player.duplicate()
	new_audio_player.pitch_scale += randf_range(-0.1, 0.1)
	if text[ltr_id] in ['a', 'e', 'i', 'o', 'u']:
		new_audio_player.pitch_scale += 0.2
	get_tree().root.add_child(new_audio_player)
	new_audio_player.play()
	await new_audio_player.finished
	new_audio_player.queue_free()
