extends Node2D


# Declare member variables here. Examples:
signal coin_increment


# Called when the node enters the scene tree for the first time.
func _ready():
	var coin_node = get_node("./Coin")
	coin_node.connect("coin_pickup", self, "handle_coin_pickup")

func handle_coin_pickup():
	emit_signal("coin_increment")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
