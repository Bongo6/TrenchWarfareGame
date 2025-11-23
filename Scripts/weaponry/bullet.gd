extends RigidBody2D

var speed = 400

var launch_direction: Vector2 = Vector2.ZERO
var launch_force: float = 0.0

@export var lifetime: float = 3.0 


# Called when the node enters the scene tree for the first time.
func _ready():
	set_sleeping(false)
	apply_central_impulse(launch_direction * launch_force)
	var timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
