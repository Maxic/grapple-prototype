extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var ui_node = get_node("/root/main/UI")
	ui_node.connect("coin_increment", self, "handle_coin_increment")

func handle_coin_increment():
	var coin_amount = int($Label.text)
	coin_amount += 1
	$Label.text = str(coin_amount)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
