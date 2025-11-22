extends CharacterBody2D

var is_selected : bool = false

#actions
var is_running : bool = false
var is_digging : bool = false

@onready var marker_select: Sprite2D = $marker_selected
 
@onready var tile_map = $"../../TileMap"
var cell
var tile_id

@export var id_photo: Texture
@export var id_name : String

var speed = 1

var astar_grid: AStarGrid2D
var current_id_path: Array[Vector2i]
var current_point_path: PackedVector2Array
var target_position: Vector2
var is_moving: bool

func _ready():
	$id_name.text = id_name
	
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	for x in tile_map.get_used_rect().size.x:
		for y in tile_map.get_used_rect().size.y:
			var tile_position = Vector2i(
				x + tile_map.get_used_rect().position.x,
				y + tile_map.get_used_rect().position.y,
			)
			
			var tile_data = tile_map.get_cell_tile_data(0, tile_position)
			
			if tile_data == null or tile_data.get_custom_data("walkable") == false:
				astar_grid.set_point_solid(tile_position)
	
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if $Sprite2D.get_rect().has_point(to_local(event.position)):
			is_selected = true
			print("you clicked me")
			
	if Input.is_action_just_pressed("action_cancel"):
		is_selected = false
	
	if event.is_action_pressed("action_move") == false:
		return
		
	if is_selected == false:
		return
	
	var id_path
		
	if is_moving:
		id_path = astar_grid.get_id_path(
			tile_map.local_to_map(target_position),
			tile_map.local_to_map(get_global_mouse_position())
	)
	else:
		id_path = astar_grid.get_id_path(
			tile_map.local_to_map(global_position),
			tile_map.local_to_map(get_global_mouse_position())
		).slice(1)
	
	if id_path.is_empty() == false:
		current_id_path = id_path
		
		current_point_path = astar_grid.get_point_path(
			tile_map.local_to_map(target_position),
			tile_map.local_to_map(get_global_mouse_position())
		)
		
		for i in current_point_path.size():
			current_point_path[i] = current_point_path[i] + Vector2(8, 8)
	
 
func _physics_process(_delta):
	# action digging
	const TILE_LAYER = 0
	if is_digging == true:
		$Sprite2D.modulate = Color.RED
		var mouse_world_pos: Vector2 = get_global_mouse_position()
		var map_cell_coords: Vector2i = tile_map.local_to_map(mouse_world_pos)
		var tile_source_id = tile_map.get_cell_source_id(TILE_LAYER, map_cell_coords)
		if tile_source_id != -1 && Input.is_action_just_pressed("action_accept"):
			tile_map.set_cell(TILE_LAYER, map_cell_coords, -1)
			astar_grid.set_point_solid(map_cell_coords, false)
			astar_grid.update()
	if Input.is_action_just_pressed("action_cancel"):
		is_digging = false
		$Sprite2D.modulate = Color.WHITE
	
	
	if current_id_path.is_empty():
		return
		
	if is_moving == false:
		target_position = tile_map.map_to_local(current_id_path.front())
		is_moving = true
		
	
	global_position = global_position.move_toward(target_position, speed)
	
	if global_position == target_position:
		current_id_path.pop_front()
		is_selected = false
		
		if current_id_path.is_empty() == false:
			target_position = tile_map.map_to_local(current_id_path.front())
			
		else:
			is_moving = false
			
	


func _process(delta):
	# action selected
	if is_selected == true:
		$marker_selected.show()
		
		$"../../ui/ui_troop_info/ID_info/id_photo".texture = id_photo
		$"../../ui/ui_troop_info/ID_info/id_name".text = id_name
		
		$"../../ui/menu_actions".selected_troop = self
		
		if $"../../ui/ui_troop_info/behavior/VBoxContainer/switch_walk_slow".button_pressed == true:
			speed = 0.5
		else:
			speed = 0.75
	else:
		$marker_selected.hide()
		
		
func action_dig():
	is_digging = true
	
func action_run():
	is_running = true
	
