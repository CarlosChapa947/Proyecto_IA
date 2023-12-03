extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var CELL_WIDTH = 160
var CELL_HEIGHT = 160
var node: Node2D
const Util = preload("res://Utils/Utils.gd")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	self.node = new()

func _physics_process(delta):
	# Add the gravity.
	var current_grid_position = Util.world_to_grid(self.global_position)
	# Now use 'current_grid_position' to access the grid
	var next_position = get_next_position(current_grid_position)
	#print("mob next", next_position)
	if next_position:
		move_to_next_position(next_position)


func get_next_position(current_position):
	var best_cost = INF
	var best_position = null
	#print("new")
	for direction in [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]:
		var neighbor: Vector2 = current_position + direction
		print(neighbor)
		if Util.is_valid_cell(neighbor):
			print("valid")
			if Globals.grid[str(neighbor)] < best_cost:
				best_cost = Globals.grid[str(neighbor)]
				best_position = neighbor
		else:
			continue
	#print("best cost round", best_cost)
	#print("best neightbor", best_position)
	return best_position


func move_to_next_position(next_position):
	# Logic to move the drone to the next position
	var next_position_nor
	next_position_nor = Globals.tile_map.map_to_local(next_position)
	next_position_nor = node.to_global(next_position_nor)
	var move_direction = (next_position_nor - self.global_position).normalized()
	self.velocity = move_direction * SPEED
	move_and_slide()

#func world_to_grid(position):
#	var cell_size = Vector2(Globals.CELL_WIDTH, Globals.CELL_HEIGHT)  # Set the size of each grid cell in pixels
#	return Vector2(floor(position.x / cell_size.x), floor(position.y / cell_size.y))
#
#func is_valid_cell(position):
#	if Globals.grid.has(str(position)):
#		if Globals.grid[str(position)] != Globals.WALL:
#			return true
#	return false
