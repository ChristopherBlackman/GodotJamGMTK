extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var time = 3
var radius = 1
var destruct = false
var _GRID_MANAGER = null
const SIZE = 32

var random_entities = []

const ORIGIN = Vector2(0,0)
const UP     = Vector2(0,-1)
const DOWN	 = Vector2(0,1)
const LEFT   = Vector2(-1,0)
const RIGHT  = Vector2(1,0)


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	get_node("Timer").start()
	get_node("UP").cast_to = UP*radius
	get_node("DOWN").cast_to = DOWN*radius
	get_node("LEFT").cast_to = LEFT*radius
	get_node("RIGHT").cast_to = RIGHT*radius
	

func init(players,grid_manager,time=self.time,radius=self.radius):
	self.time = time
	self.radius = radius
	_GRID_MANAGER = grid_manager
	for player in players:
		self.add_collision_exception_with(player)
		#_touching_players.append(player)

func _process(delta):
	if destruct:
		explode()
		pass

#func _exit_tree():
#	for random in random_entities:
#		#check if a bomb
#		print("exiting tree")
##		print(random)
##		print(random.get_name())
#		if((not weakref(random)) and random.has_method("explode")):
#			print("Sending Message To : ",random," to Explode")
#			random.explode()

		

func explode(collision_exceptions=[]):
	print(self,"EXPLODING")
	
	var global_grid = _GRID_MANAGER.convert_cordinate_to_grid(self.position,Vector2(0,0))
	
	# explosion radius
	var left 	= global_grid + LEFT*radius
	var right 	= global_grid + RIGHT*radius
	var up 		= global_grid + UP*radius
	var down 	= global_grid + DOWN*radius
	
	var left_e = null
	var right_e = null
	var up_e = null
	var down_e = null
	
	#Get Ray Nodes
	var r_down = get_node("DOWN")
	var r_up = get_node("UP")
	var r_right = get_node("RIGHT")
	var r_left = get_node("LEFT")
	
	#Static Bodys
	var min_x = left.x
	var max_x = right.x
	var min_y = up.y
	var max_y = down.y
	
	var collisions = []
	var list = []
	var ray_exceptions = [self,$Area2D] + collision_exceptions
	
	print(ray_exceptions)
	
	var col_x_max = null
	var col_x_min = null
	var col_y_max = null
	var col_y_min = null
	
	for x in range(left.x,global_grid.x):
		if _GRID_MANAGER.get_tile_type(Vector2(x,global_grid.y)) >= 0:
			min_x = x + 1
			col_x_min = Vector2(x,global_grid.y)
	for x in range(global_grid.x,right.x+1):
		print(x)
		if _GRID_MANAGER.get_tile_type(Vector2(x,global_grid.y)) >= 0:
			max_x = x-1
			col_x_max = Vector2(x,global_grid.y)
	for y in range(up.y,global_grid.y):
		if _GRID_MANAGER.get_tile_type(Vector2(global_grid.x,y)) >= 0:
			min_y = y+1
			col_y_min = Vector2(global_grid.x,y)
	for y in range(global_grid.y,down.y+1):
		if _GRID_MANAGER.get_tile_type(Vector2(global_grid.x,y)) >= 0:
			max_y = y-1
			col_y_max = Vector2(global_grid.x,y)
			
	if col_x_max:
		collisions.append(col_x_max)
	if col_y_max:
		collisions.append(col_y_max)
	if col_x_min:
		collisions.append(col_x_min)
	if col_y_min:
		collisions.append(col_y_min)
		
	print(collisions)
	

	list = [r_up,r_down,r_left,r_right]
	

#	# enable to ray list and find collisions
	for ray in list:
		ray.enabled  = true
		for except in ray_exceptions:
			ray.add_exception(except)
		#ray.add_exception($Area2D)
		ray.add_exception(self)
		ray.force_raycast_update()

	# !!check if the ray is colliding or not!!(ray can be infinite)
	if r_left.is_colliding():
		left_e = _GRID_MANAGER.convert_cordinate_to_grid(r_left.get_collision_point(),Vector2(-1,0)) + Vector2(1,0)
		random_entities.append(r_left.get_collider())
		min_x = max(left_e.x+1,min_x)

	if r_right.is_colliding():
		right_e = _GRID_MANAGER.convert_cordinate_to_grid(r_right.get_collision_point(),Vector2(1,0)) + Vector2(-1,0)
		random_entities.append(r_right.get_collider())
		max_x = min(right_e.x-1,max_x)

	if r_up.is_colliding():
		up_e = _GRID_MANAGER.convert_cordinate_to_grid(r_up.get_collision_point(),Vector2(0,-1)) + Vector2(0,1)
		random_entities.append(r_up.get_collider())
		min_y = max(up_e.y+1,min_y)

	if r_down.is_colliding():
		down_e = _GRID_MANAGER.convert_cordinate_to_grid(r_down.get_collision_point(),Vector2(0,1)) + Vector2(0,-1)
		random_entities.append(r_down.get_collider())
		print("DOWN : ",left_e,min_x)
		max_y = min(down_e.y,max_y)
		
	
	
	for item in collisions:
		if _GRID_MANAGER.destroy(item):
			var explosion = preload("res://Explosion.tscn").instance()
			explosion.position = _GRID_MANAGER.convert_coordinate(item)
			_GRID_MANAGER.add_child(explosion)
			print("there was a thing")


	#Explosion horizonal, vertical, and self
	for i in range(min_x,max_x+1):
		if not i == global_grid.x:
			var explosion = preload("res://Explosion.tscn").instance()
			explosion.position = _GRID_MANAGER.convert_coordinate(Vector2(i,global_grid.y))
			_GRID_MANAGER.add_child(explosion)
	for i in range(min_y,max_y+1):
		if not i == global_grid.y:
			var explosion = preload("res://Explosion.tscn").instance()
			explosion.position = _GRID_MANAGER.convert_coordinate(Vector2(global_grid.x,i))
			_GRID_MANAGER.add_child(explosion)

	var explosion = preload("res://Explosion.tscn").instance()
	explosion.position = self.position
	_GRID_MANAGER.add_child(explosion)
	
	#	for random in random_entities:
#		#check if a bomb
#		print("exiting tree")
##		print(random)
##		print(random.get_name())
	#if((not weakref(random)) and random.has_method("explode")):
		#print("Sending Message To : ",random," to Explode")
	for random in random_entities:
		random.destruct()
	self.queue_free()
	

#
#	#Explosion horizonal, vertical, and self
#	for i in range(left.x,right.x+1):
#		if not i == self_grid.x:
#			var explosion = preload("res://Explosion.tscn").instance()
#			explosion.position = _GRID_MANAGER.convert_coordinate(Vector2(i,self_grid.y))
#			_GRID_MANAGER.add_child(explosion)
#	for i in range(up.y,down.y+1):
#		if not i == self_grid.y:
#			var explosion = preload("res://Explosion.tscn").instance()
#			explosion.position = _GRID_MANAGER.convert_coordinate(Vector2(self_grid.x,i))
#			_GRID_MANAGER.add_child(explosion)
#
#	var explosion = preload("res://Explosion.tscn").instance()
#	explosion.position = self.position
#	_GRID_MANAGER.add_child(explosion)
#
#	#handel destruction of non-player objects
#	for collision in collisions:
#		print(collision)
#		if collision.is_in_group("Temp_Wall"):
#			collision.destroy()
#			print("Temp_Wall")
#		if collision.is_in_group("Wall"):
#			print("Wall")
#		if collision.is_in_group("Bomb"):
#			print("Bomb")
	


	
	
	
func _on_Area2D_body_exited(body):
	remove_collision_exception_with(body)
	pass # replace with function body


func destruct():
	self.destruct = true


#func _on_Area2D2_body_entered(body):
#	remove_collision_exception_with(body)
#	pass # replace with function body


func _on_Timer_timeout():
	time = time -1
	print(time)
	if time <= 0:
		get_node("Timer").stop()
		destruct()
	pass # replace with function body