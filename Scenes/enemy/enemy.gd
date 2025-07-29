extends Unit
class_name Enemy

@export var flock_push := 20.0

@onready var vision_area = $VisionArea

var can_move := true

func _process(delta: float) -> void:
	if not can_move:
		return
		
	if not can_move_towards_player():
		return	
		
	position += get_move_direction() * stats.speed * delta


func get_move_direction() -> Vector2:
	if not is_instance_valid(Global.player):
		return Vector2.ZERO
		
	var direction := global_position.direction_to(Global.player.global_position)
	for area:Node2D in vision_area.get_overlapping_areas():
		if area != self and area.is_inside_tree():
			var vector := global_position - area.global_position
			direction += flock_push * vector.normalized() / vector.length()
			
	return direction
		
func can_move_towards_player()-> bool:
	return is_instance_valid(Global.player) and\
	global_position.distance_to(Global.player.global_position) > 60
	
