extends CharacterBody2D

var speed = 200
var pos: Vector2
var g_cost: int
var h_cost: int
var f_cost: int
var parent: Astar_Custom = null
var astar: Astar_Custom
var current_path: Array
var current_target = 0
const Util = preload("res://Utils/Utils.gd")
func _ready():
	var start_position = Util.world_to_grid(self.global_position) # Starting position of the enemy
	var target_position = Util.world_to_grid(Globals.player_position) # Target position (e.g., player position)
	astar = Astar_Custom.new(start_position, target_position)
	self.current_path = astar.a_star_search(start_position, target_position)
	self.current_target = 0

func _process(delta):
	print(current_path)
	if current_path.size() > 0:
		move_along_path(delta)
	else:
		current_path.clear()
		current_target = 0
		current_path = astar.a_star_search(Util.world_to_grid(self.global_position), Util.world_to_grid(Globals.player_position))
	
	#if current_target < current_path.size():
		#var next_position = current_path[current_target]
		#move_towards(next_position, speed * delta)
		#if self.global_position == next_position:
			#current_target += 1

func move_along_path(delta):
	var target_point = current_path[current_target]
	target_point = Globals.tile_map.map_to_local(target_point)
	print(target_point)
	var direction = (target_point - global_position).normalized()
	self.velocity = direction * speed
	move_and_slide()
	
	if global_position.distance_to(target_point) < 25: # Check if close to the current waypoint
		current_target += 1
		if current_target >= current_path.size():
			current_path.clear() # Clear path when target is reached

func move_towards(position: Vector2, delta: float) -> void:
	var target_point = current_path[current_target]
	target_point = Globals.tile_map.map_to_local(target_point)
	print(target_point)
	var direction = (target_point - global_position).normalized()
	self.velocity = direction * speed
	move_and_slide()
	
	if global_position.distance_to(target_point) < 10: # Check if close to the current waypoint
		current_target += 1
		if current_target >= current_path.size():
			current_path.clear() # Clear path when target is reached

#func is_valid_cell(position):
#	if Globals.grid.has(str(position)):
#		if Globals.grid[str(position)] != Globals.WALL:
#			return true
#	return false
#
#func world_to_grid(position):
#	var cell_size = Vector2(Globals.CELL_WIDTH, Globals.CELL_HEIGHT)  # Set the size of each grid cell in pixels
#	return Vector2(floor(position.x / cell_size.x), floor(position.y / cell_size.y))
