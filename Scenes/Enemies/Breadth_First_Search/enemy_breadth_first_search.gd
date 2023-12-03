extends CharacterBody2D


const SPEED = 100
const JUMP_VELOCITY = -400.0

var speed = 100 # Speed of the enemy
var current_path = []
var current_target = 0
const Util = preload("res://Utils/Utils.gd")
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	var start_position = Util.world_to_grid(self.global_position) # Example start position
	var target_position = Util.world_to_grid(Globals.player_position) # Example target position
	current_path = Util.bfs(start_position, target_position)
	

func _process(_delta):
	pass
	

func _physics_process(delta):
	print(current_path)
	if current_path.size() > 0:
		move_along_path(delta)
	else:
		current_path.clear()
		current_target = 0
		current_path = Util.bfs(Util.world_to_grid(self.global_position), Util.world_to_grid(Globals.player_position))


#func bfs(start, target):
#	var queue = []
#	var visited = {}
#	var path = {}
#	var current_tile
#
#	queue.append(start)
#	visited[start] = true
#
#	while queue.size() > 0:
#		current_tile = queue.pop_front()
#
#		if current_tile == target:
#			return reconstruct_path(path, start, target)
#
#		for neighbor in Util.get_neighbors(current_tile):
#			if not visited.has(neighbor):
#				queue.append(neighbor)
#				visited[neighbor] = true
#				path[neighbor] = current_tile
#
#	return [] # Return an empty path if target is not reachable
#
#func reconstruct_path(path, start, target):
#	var current = target
#	var path_backwards = []
#
#	while current != start:
#		path_backwards.append(current)
#		current = path[current]
#
#	path_backwards.reverse()
#	return path_backwards
#
func move_along_path(_delta):
	var target_point = current_path[current_target]
	target_point = Globals.tile_map.map_to_local(target_point)
	print(target_point)
	var direction = (target_point - global_position).normalized()
	self.velocity = direction * speed
	move_and_slide()

	if global_position.distance_to(target_point) < 1: # Check if close to the current waypoint
		current_target += 1
		if current_target >= current_path.size():
			current_path.clear() # Clear path when target is reached

#func get_neighbors(tile):
#	var neighbors = []
#	var directions = [Vector2(0, -1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0)] # Up, Right, Down, Left
#
#	for direction in directions:
#		var neighbor = tile + direction
#		if Util.is_valid_cell(neighbor): # You need to implement this function to check if the tile is walkable
#			neighbors.append(neighbor)
#
#	return neighbors
	

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

