extends Node


@onready var dialog_box_scene = preload("res://Scenes/Commos/dialog_box.tscn")

var Lines = []
var cur_line_id = 0
var txt_box
var is_active = false
var txt_box_position = Vector2.ZERO
var can_advance_line = false
var char_name
var sfx : AudioStream

func load_lines(Charname, whichone):
	if Charname != null and whichone != null:
		var filepath = "res://Assets/Dialogs/" + Charname + "/" + whichone + ".json"
		var file = FileAccess.open(filepath, FileAccess.READ).get_as_text()
		var content = JSON.parse_string(file)
		return content
	else:
		return ['falhou']

func start_chat(Charname, whichone, position : Vector2, speech_sfx):
	if is_active:
		return
	Lines = load_lines(Charname, whichone)
	txt_box_position = position
	sfx = speech_sfx
	show_txt_box(Charname)
	is_active = true
	
func show_txt_box(Charname):
	txt_box = dialog_box_scene.instantiate()
	txt_box.done_writing.connect(_on_done_chat)
	get_tree().root.add_child(txt_box)
	txt_box.scale = Vector2(0.6, 0.6)
	txt_box.global_position.x = txt_box_position.x / 8
	txt_box.global_position.y = txt_box_position.y + 55
	txt_box.show_box(Lines[cur_line_id]['text'], Charname, sfx)
	char_name = Charname
	can_advance_line = false

func _on_done_chat():
	can_advance_line = true
	
func _unhandled_input(event):
	if event.is_action_pressed("interact") and can_advance_line and is_active:
		cur_line_id += 1
		txt_box.queue_free()
		if cur_line_id >= Lines.size():
			print(Lines)
			is_active = false
			cur_line_id = 0
			return	
		show_txt_box(char_name)
