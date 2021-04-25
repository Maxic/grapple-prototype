extends Control

# From UI layer
signal hook_gravity_change
signal hook_speed_change
signal hook_pull_change

# To UI layer
signal coin_increment


# Called when the node enters the scene tree for the first time.
func _ready():
	var control_node = get_node("/root/main/Control")
	control_node.connect("coin_increment", self, "handle_coin_increment")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func handle_coin_increment():
	emit_signal("coin_increment")

func _on_Hook_Gravity_value_changed(value):
	emit_signal("hook_gravity_change", value)


func _on_Hook_Speed_value_changed(value):
	emit_signal("hook_speed_change", value)
	

func _on_Hook_Pull_value_changed(value):
	emit_signal("hook_pull_change", value)
