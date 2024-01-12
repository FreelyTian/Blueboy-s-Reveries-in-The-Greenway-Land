extends CharacterBody2D

@onready var animplayer = $mesh/AnimationPlayer
@onready var animtree = $mesh/AnimationPlayer/AnimationTree
@export var movedata : PlayerMovementData
var _direction = Vector2.ZERO
var _last_direction = Vector2.ZERO

func _ready():
	animtree.active = true

func _physics_process(delta):
	move()
	move_and_slide()
	
func move():
	var _last_direction_bkp = _last_direction
	_direction = Input.get_vector("a", "d", "w", "s").normalized()
	_last_direction = _direction if _direction != Vector2.ZERO else _last_direction_bkp
	if _direction != Vector2.ZERO:
		set_walking(true)
		update_blend_pos()
		#animtree.active = true
		do_vel(movedata.accel)
	else:
		set_walking(false)
		do_vel(movedata.fric)
	
		
func do_vel(factor):
	velocity.x = lerp(velocity.x, _direction.x * movedata.SPEED, factor)
	velocity.y = lerp(velocity.y, _direction.y * movedata.SPEED, factor)	

func set_walking(value):
	animtree.set("parameters/conditions/is_walking", value)
	animtree.set("parameters/conditions/idle", not value)
	
func update_blend_pos():
	animtree["parameters/idle/blend_position"] = _direction
	animtree["parameters/walk/blend_position"] = _direction
	

