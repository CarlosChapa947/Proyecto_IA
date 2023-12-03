extends CharacterBody2D


const SPEED = 100
const JUMP_VELOCITY = -400.0

var speed = 200 # Speed of the enemy
var current_path = []
var current_target = 0
var visited: Dictionary = {}
var stack: Array = []
var target_position
var isPossible = false
const Util = preload("res://Utils/Utils.gd")
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	var start_position = Util.world_to_grid(self.global_position) # Example start position
	self.target_position = Util.world_to_grid(Globals.player_position) # Example target position
	current_path = Util.depth_first_search(start_position, target_position)
	#current_path = bfs(start_position, target_position)
	

func _process(delta):
	pass
	

func _physics_process(delta):
	if current_path.size() > 0:
		print(current_path)
		move_along_path(delta)
	else:
		var start_position = Util.world_to_grid(self.global_position)
		self.target_position = Util.world_to_grid(Globals.player_position)
		self.visited.clear()
		current_target = 0
		current_path = Util.depth_first_search(start_position, target_position)


#func depth_first_search(current_position, target_position):
#	if current_position == target_position:
#		return true # Target found
#
#	# Mark the current tile as visited
#	visited[current_position] = true
#	stack.append(current_position)
#
#	for neighbor in Util.get_neighbors(current_position):
#		if not visited.get(neighbor) and depth_first_search(neighbor):
#			return true # Path found
#
#
#	# No path found, backtrack
#	stack.pop_back()
#	return false


func move_along_path(delta):
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

#func get_neighbors(tile):
#	var neighbors = []
#	var directions = [Vector2(0, -1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0)] # Up, Right, Down, Left
#
#	for direction in directions:
#		var neighbor = tile + direction
#		if is_valid_cell(neighbor): # You need to implement this function to check if the tile is walkable
#			neighbors.append(neighbor)
#
#	return neighbors
#
#
#func is_valid_cell(position):
#	if Globals.grid.has(str(position)):
#		if Globals.grid[str(position)] != Globals.WALL:
#			return true
#	return false
#
#
#func world_to_grid(position):
#	var cell_size = Vector2(Globals.CELL_WIDTH, Globals.CELL_HEIGHT)  # Set the size of each grid cell in pixels
#	return Vector2(floor(position.x / cell_size.x), floor(position.y / cell_size.y))
