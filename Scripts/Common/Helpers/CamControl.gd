extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_zoom(Vector2(3, 3))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	do_zoom()
	

func do_zoom():
	if Input.is_action_just_pressed("zoom out"):
		self.set_zoom(self.zoom / 1.33)
	elif Input.is_action_just_pressed("zoom in"):
		self.set_zoom(self.zoom * 1.33)
	
