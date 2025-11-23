extends Node2D

@onready var player = $"../entity_holder/soldier_rifleman"

func _process(delta):
	queue_redraw()

func _draw():
	if player != null:
		if player.current_point_path.is_empty():
			return
	else:
		return
	
	draw_polyline(player.current_point_path, Color.RED)
