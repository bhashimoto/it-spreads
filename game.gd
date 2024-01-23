extends Node

@export var ball_scene: PackedScene
const impulse:float = 130

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	score = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var children = get_tree().get_nodes_in_group('balls')
	if len(children) > 100:
		for node in children:
			remove_child(node)
	


func _on_ball_left_screen():
	$Background.color = Color(1,0,0,1)
	


func _on_ball_multiply(pos, size, tilt):
	for i in range(size):
		var ball = ball_scene.instantiate()
		var theta = i*2*PI/size
		ball.position = pos + Vector2.RIGHT.rotated(theta + tilt)*35
		ball.rotation = theta + tilt
		ball.apply_central_impulse(Vector2(cos(ball.rotation), sin(ball.rotation)).normalized() * impulse)
		ball.add_to_group('balls')
		ball.connect("multiply",_on_ball_multiply)
		ball.connect("left_screen", _on_ball_left_screen)
		ball.connect("ball_trigger", _on_ball_ball_trigger)
		add_child(ball)




func _on_ball_ball_trigger():
	score += 1
	$HUD.update_score(score)
