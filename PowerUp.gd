extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var _GRID_MANAGER = null
export(int) var radius_increase = 1

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func destruct_explosive():
	print("PowerUp Blew Up")
	var explosion = preload("res://Explosion.tscn").instance()
	explosion.position = self.position
	_GRID_MANAGER.add_child(explosion)
	queue_free()

func destruct_safe():
	queue_free()

func _on_Area2D_destruct():
	destruct_explosive()
	pass # replace with function body


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		# increase radius of bombs
		if body.has_method("change_radius_by"):
			print("Player : ",body," picked up Power")
			body.change_radius_by(radius_increase)
			destruct_safe()
