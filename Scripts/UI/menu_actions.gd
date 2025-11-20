extends Panel

var selected_troop

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected_troop != null:
		$id_name.text = selected_troop.id_name
		
	if $Button_dig.button_pressed:
		selected_troop.action_dig()
		
	if $Button_run.button_pressed:
		selected_troop.action_run()
	
