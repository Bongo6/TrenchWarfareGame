extends Node2D

@onready var menu_actions = $"../ui/menu_actions"
@onready var cursor = $Sprite2D

@export var texture_1: Texture2D = preload("res://Textures/UI/Cursor/Cursor_1.png")
@export var texture_2: Texture2D = preload("res://Textures/UI/Cursor/Cursor_2.png")



# Called when the node enters the scene tree for the first time.
func _ready():
	cursor.texture = texture_1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_global_mouse_position()
	
	if menu_actions.selected_troop != null:
		if menu_actions.selected_troop.is_digging == true:
			cursor.texture = texture_2
