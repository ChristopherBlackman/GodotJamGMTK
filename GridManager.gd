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
	#print($"Collisions".get_used_cells())
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
	return Vector2(x,y)
	
func convert_cordinate_to_grid(current_pos,offset):
	var x = floor((current_pos.x+offset.x)/_GRID_WIDTH)
	var y = floor((current_pos.y+offset.y)/_GRID_HEIGHT)
	return Vector2(x,y)
	
func convert_coordinate(grid):
	var x = _GRID_POS.x + grid.x*_GRID_WIDTH +  _GRID_WIDTH/2
	var y = _GRID_POS.y + grid.y*_GRID_HEIGHT + _GRID_HEIGHT/2
	return Vector2(x,y)
	
func get_tile_type(grid):
	return $"Collisions".get_cellv(grid)

func is_destructable(grid):
	#might add more
	var itemId = $"Collisions".get_cellv(grid)
	if not itemId == 0:
		spawn_item(itemId,grid)
		print(itemId)
		return true
	return false

func destroy(grid):
	if is_destructable(grid):
		$"Collisions".set_cellv(grid,-1)
		return true
	return false
	
func spawn_players():
	var player = preload("res://Bro.tscn").instance()
	player.position = convert_coordinate(Vector2(1,1))
	player.GRID_MANAGER = self
	self.add_child(player)
	pass
	
func spawn_item(id,grid):
	#turn this into an Enum Later, of Find A Better Method
	var destructable_wall = 18
	if id == destructable_wall:
		var r = randf()
		if r < 0.3:
			var power_up = preload("res://PowerUp.tscn").instance()
			power_up.position = convert_coordinate(grid)
			power_up._GRID_MANAGER = self
			self.add_child(power_up)
		elif r < 0.6:
			var speed_up = preload("res://SpeedUp.tscn").instance()
			speed_up.position = convert_coordinate(grid)
			speed_up._GRID_MANAGER = self
			self.add_child(speed_up)
	pass
	