extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const MOTION_SPEED = 100
var   GRID_MANAGER = null
var   current_anim = null

var	_touching_players = []

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	current_anim = get_node("anim").play("standing")
	print(GRID_MANAGER)
	pass

func _process(delta):
	var motion = get_input_direction()
	
	var new_anim = "standing"
	if motion.y < 0:
		new_anim = "walk_up"
	elif motion.y > 0:
		new_anim = "walk_down"
	elif motion.x < 0:
		new_anim = "walk_left"
	elif motion.x > 0:
		new_anim = "walk_right"

	if new_anim != current_anim:
		current_anim = new_anim
		get_node("anim").play(current_anim)

		
	
	move_and_slide(motion * MOTION_SPEED)
	
	
	if Input.is_action_just_released("drop_bomb"):
		setup_bomb()
		
func get_input_direction():
	var y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	var x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	return Vector2(x, y)
	
func setup_bomb():
	print("dropping Bomb")
	var bomb = preload("res://bomb.tscn").instance()
	bomb.position = GRID_MANAGER.get_grid_location(self.position)
	bomb.init(_touching_players,GRID_MANAGER)
	get_node("../..").add_child(bomb)


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") && not body in _touching_players:
		_touching_players.append(body)
	print("ENTER",self,_touching_players,body)
		
	pass # replace with function body
	
func death():
	queue_free()


func _on_Area2D_body_exited(body):
	if body.is_in_group("Player") &&  body in _touching_players:
		_touching_players.erase(body)

	print("EXIT",self,_touching_players,body)
	pass # replace with function body
