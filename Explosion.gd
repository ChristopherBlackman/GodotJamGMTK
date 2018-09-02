extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$Sprite/AnimationPlayer.play("start")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func destroy():
	queue_free()

func _on_Explosion_body_entered(body):
	print(body)
	if body.is_in_group("Player"):
		body.death()
	pass # replace with function body
