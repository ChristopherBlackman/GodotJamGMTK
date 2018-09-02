extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var time = 3
var radius
var destruct = false
var _GRID_MANAGER = null


const ORIGIN = Vector2(0,0)
const UP     = Vector2(0,1)
const DOWN	 = Vector2(0,-1)
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
	pass

func init(players,grid_manager,time=3,radius=1):
	self.time = time
	self.radius = radius
	_GRID_MANAGER = grid_manager
	for player in players:
		self.add_collision_exception_with(player)
		#_touching_players.append(player)

func _process(delta):
	if destruct:
		explode()
		self.queue_free()
		pass

		

func explode():
	#use collision mask for temp walls, walls, bombs
	# send message to walls, and bombs
	var space_state = get_world_2d().direct_space_state
	#add collision mask as last argument
	print(self)
	
	var down = get_node("DOWN")
	var up = get_node("UP")
	var right = get_node("RIGHT")
	var left = get_node("LEFT")
	
	var list = [up,down,left,right]
	
	for ray in list:
		ray.enabled
		ray.add_exception($Area2D)
		ray.add_exception(self)
		ray.force_raycast_update()
	
	print("left",left.get_collider())
	print("right",right.get_collider())
	print("up",up.get_collider())
	print("down",down.get_collider())
	
	var explosion = preload("res://Explosion.tscn").instance()
	explosion.position = self.position
	_GRID_MANAGER.add_child(explosion)
	


	
	
	
func _on_Area2D_body_exited(body):
	remove_collision_exception_with(body)
	pass # replace with function body





#func _on_Area2D2_body_entered(body):
#	remove_collision_exception_with(body)
#	pass # replace with function body


func _on_Timer_timeout():
	time = time -1
	print(time)
	if time <= 0:
		get_node("Timer").stop()
		destruct = true
	pass # replace with function body
