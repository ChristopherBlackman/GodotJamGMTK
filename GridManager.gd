extends Node

var	_GRID_POS 		= Vector2(0,0)
var	_GRID_WIDTH  	= 32
var	_GRID_HEIGHT 	= 32


# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_node("Floor").position = _GRID_POS
	get_node("Collisions").position = _GRID_POS
	_GRID_WIDTH = get_node("Collisions").cell_size.x
	_GRID_HEIGHT = get_node("Collisions").cell_size.y
	spawn_players()
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func get_grid_location(current_pos):
	var x = _GRID_POS.x + floor(current_pos.x/_GRID_WIDTH)*_GRID_WIDTH   + _GRID_WIDTH/2
	var y = _GRID_POS.y + floor(current_pos.y/_GRID_HEIGHT)*_GRID_HEIGHT + _GRID_HEIGHT/2
	print(Vector2(x,y))
	return Vector2(x,y)
	
func convert_coordinate(grid):
	var x = _GRID_POS.x + floor(grid.x)*_GRID_WIDTH -  _GRID_WIDTH/2
	var y = _GRID_POS.y + floor(grid.y)*_GRID_HEIGHT - _GRID_HEIGHT/2
	return Vector2(x,y)
	
func spawn_players():
	var player = preload("res://Bro.tscn").instance()
	player.position = convert_coordinate(Vector2(1,1))
	player.GRID_MANAGER = self
	self.add_child(player)
	pass