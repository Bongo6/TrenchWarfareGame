extends CharacterBody2D
## ENEMY RIFLEMAN

## sprite state stuff
@onready var sprite_2d_state = $sprite_state
var sprite_state_dead = preload ("res://Textures/Icons/Soldiers/S_Icon_Skull.png")

@export var id_photo: Texture
@export var id_name : String
@onready var sprite_2d = $Sprite2D
@onready var healthbar = $Sprite2D/healthbar

@export var max_health : float = 10
@export var health : float = 10
var speed = 0.5

@onready var player = $"../../entity_holder/soldier_rifleman"

@onready var tile_map = $"../../TileMap"
var cell
var tile_id

var is_moving : bool



var current_magazine_count : int
var empty_magazine : bool = false

var astar_grid: AStarGrid2D
var current_id_path: Array[Vector2i]
var current_point_path: PackedVector2Array
var target_position: Vector2

func _ready():
	current_magazine_count = 10
	$id_name.text = id_name
	
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	var region_size = astar_grid.region.size
	var region_position = astar_grid.region.position
	
	for x in region_size.x:
		for y in region_size.y:
			var tile_position = Vector2i(
				x + region_position.x,
				y + region_position.y
			)
			
			var tile_data = tile_map.get_cell_tile_data(0, tile_position)
			
			if tile_data == null or not tile_data.get_custom_data("walkable"):
				astar_grid.set_point_solid(tile_position)
				
func _process(_delta):
	if is_moving == true:
		return
		
	move()
	healthbar.max_value = max_health
	healthbar.value = health
	
	
	
	
func move():
	var path = astar_grid.get_id_path(
		tile_map.local_to_map(global_position),
		tile_map.local_to_map(player.global_position)
	)
	
	path.pop_front()
	
	if path.is_empty():
		return
		
	var original_position = Vector2(global_position)
	
	global_position = tile_map.map_to_local(path[0])
	sprite_2d.global_position = original_position
	
	is_moving = true
	
func _physics_process(delta):
	if health <= 0:
		state_dead()
	if is_moving == true:
		sprite_2d.global_position = sprite_2d.global_position.move_toward(global_position, speed)
		
		if sprite_2d.global_position != global_position:
			return
			
		is_moving = false
		
		
func state_dead():
	sprite_2d.modulate = Color.DARK_RED
	sprite_2d_state.texture = sprite_state_dead
	speed = 0
