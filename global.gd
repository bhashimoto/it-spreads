extends Node

const MAX_EXPLOSION_SIZE = 6
var next_explosion_size = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_next_explosion_size()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_next_explosion_size() -> void:
	var next = randi_range(2,MAX_EXPLOSION_SIZE)
	print('next explosion size is: {size}'.format({'size':next}))
	next_explosion_size = next
