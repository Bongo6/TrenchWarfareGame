extends Panel

var selected_troop

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected_troop != null:
		$id_name.text = selected_troop.id_name
		



func _on_button_dig_pressed():
	selected_troop.action_dig()


func _on_button_run_pressed():
	selected_troop.action_run()
