extends Node2D

@export var ghost_ball_scene: PackedScene


var speed:float = 0
var selected:bool
var theta:float = 0
var bounce_count:int = 0


enum Growth {SMALL, GROWING, LARGE}
var growth_stage:Growth = Growth.SMALL
const growth_rate = Vector2(3,3)

signal left_screen
signal multiply(pos,size,tilt)
signal ball_trigger


# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = randf_range(0.0, 2*PI)
	selected = false
	name = 'Ball'
	print(name)
	#print('New ball instantiated')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	theta += delta*2*PI/2
	if theta >= 2*PI:
		theta -= 2*PI
	
	if Input.is_action_just_pressed("explode"):
		pass
		#print("mouse click")

	if selected && Input.is_action_just_pressed("explode"):
		growth_stage = Growth.GROWING
		ball_trigger.emit()

	if growth_stage == Growth.GROWING:
		$Shape.scale += growth_rate*delta
		$image.scale += growth_rate*delta
		
	if $Shape.scale.length() >= Vector2(2,2).length():
		growth_stage = Growth.LARGE
		clear_children()
		multiply.emit(position, global.next_explosion_size, theta)
		#print("Growth finished")
		queue_free()
		global.get_next_explosion_size()

	var ghosts = find_children("*Sprite*", "Sprite2D", false, false)
	for i in range(len(ghosts)):
		var a = i*2*PI/len(ghosts)
		ghosts[i].position = Vector2.RIGHT.rotated(a + theta)*35


func _on_visible_on_screen_notifier_2d_screen_exited():
	left_screen.emit()


func _on_mouse_entered():
	print('Ball {name} selected'.format({"name": name}))
	for i in range(global.next_explosion_size):
		var gball = ghost_ball_scene.instantiate()
		gball.name = 'Sprite'
		var a = i*2*PI/global.next_explosion_size
		gball.position = Vector2.RIGHT.rotated(a + theta)*35
		add_child(gball)
	selected = true


func _on_mouse_exited():
	print('Ball {name} not selected'.format({"name": name}))
	selected = false
	clear_children()
	


func _on_body_entered(body):
	if bounce_count == 1:
		$image.self_modulate = '#700015'
	if bounce_count == 2:
		$image.modulate = '#FF0000'
	if bounce_count == 3:
		growth_stage = Growth.GROWING
	else:
		bounce_count += 1


func clear_children():
	var children = find_children("*Sprite*","Sprite2D",false,false)
	for child in children:
		child.queue_free()
