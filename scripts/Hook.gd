extends Area2D

export var reel_speed = 50

var hook_cast = false
var fish_on_hook = false
var min_depth
var max_depth


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.visible = false
	$CollisionShape2D.disabled = true
	self.add_to_group("hook")
	min_depth = get_node("../Boat").position.y
	
	var water = get_node("../Water")
	max_depth = min_depth + water.texture.get_height() * water.scale.y - 100
	
	

func _process(delta):
	
	if Input.is_action_just_pressed("interact_key"):
		hook_cast = true
		get_node("../Camera").target_node = self
			
	if Input.is_action_pressed("up_key") and self.position.y > min_depth:
		self.position.y -= reel_speed * delta
		
	if Input.is_action_pressed("down_key") and self.position.y < max_depth:
		self.position.y += reel_speed * delta
	
	if get_node("../Player").in_boat and hook_cast:
		$Sprite.visible = true
		$CollisionShape2D.disabled = false
		self.position.x = get_node("../Boat").position.x
	#update line for fishing line 
	update()
		
func _draw():
	if hook_cast:
		draw_line(Vector2(0,-5),Vector2(0,-(self.position.y + get_node("../Boat").position.y)),Color(255.0,255.0,255.0),1.0)
		
func _on_Hook_body_entered(body):
	if body.is_in_group("fish"):
		body.on_hook = true
