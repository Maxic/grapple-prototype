extends Control


# Declare member variables here. Examples:
signal hook_gravity_change
signal hook_speed_change
signal hook_pull_change


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Hook_Gravity_value_changed(value):
	emit_signal("hook_gravity_change", value)


func _on_Hook_Speed_value_changed(value):
	emit_signal("hook_speed_change", value)
	

func _on_Hook_Pull_value_changed(value):
	emit_signal("hook_pull_change", value)
