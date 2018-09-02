extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var time = 3
var radius
var destruct = false


const ORIGIN = Vector2(0,0)
const UP     = Vector2(0,1)
const DOWN	 = Vector2(0,-1)
const LEFT   = Vector2(-1,0)
const RIGHT  = Vector2(1,0)


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	get_node("Timer").start()
	pass

func init(players,grid_manager,time=3,radius=1):
	self.time = time
	self.radius = radius
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
	
	var exclusion_list = [self]
	for child in self.get_children():
		#if(child.is_type("PhysicsBody2D")): 
		exclusion_list.append(child)
	
	print(exclusion_list)

	var left = space_state.intersect_ray(ORIGIN,LEFT*radius*32,exclusion_list)
	var right = space_state.intersect_ray(ORIGIN,RIGHT*radius*32,exclusion_list)
	var up = space_state.intersect_ray(ORIGIN,UP*radius*32,exclusion_list)
	var down = space_state.intersect_ray(ORIGIN,DOWN*radius*32,exclusion_list)

	print(up)
	print(down)
	print(left)
	print(right)
	
func _on_Area2D_body_exited(body):
	remove_collision_exception_with(body)
	pass # replace with function body





func _on_Area2D2_body_entered(body):
	remove_collision_exception_with(body)
	pass # replace with function body


func _on_Timer_timeout():
	time = time -1
	print(time)
	if time <= 0:
		get_node("Timer").stop()
		destruct = true
	pass # replace with function body
