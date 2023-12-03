extends Node

class_name Astar_Custom
var pos: Vector2
var g_cost: float  # Cost from start to the current node
var h_cost: float  # Heuristic cost from the current node to the end
var f_cost: float  # Total cost (g_cost + h_cost)
var parent: Astar_Custom = null
var start: Vector2
var end: Vector2
const Util = preload("res://Utils/Utils.gd")

func _init(start, end):
	self.start = start
	self.end = end
	self.pos = start
	self.g_cost = 0
	self.h_cost = manhattan_cost(start, end)
	self.f_cost = g_cost + h_cost

func manhattan_cost(pos1: Vector2, pos2: Vector2) -> float:
	return abs(pos1.x - pos2.x) + abs(pos1.y - pos2.y)

func a_star_search(start_position: Vector2, target_position: Vector2) -> Array:
	var open_set: MinHeap_Astar = MinHeap_Astar.new()
	var closed_set: Dictionary = {}
	var start_node = Astar_Custom.new(start_position, target_position)
	open_set.insert(start_node)

	while open_set.heap.size() > 0:
		var current_node = open_set.extract_min()
		closed_set[current_node.pos] = true

		if current_node.pos == target_position:
			return reconstruct_path(current_node)

		for neighbor in Util.get_neighbors(current_node.pos):
			neighbor = Astar_Custom.new(neighbor, target_position)
			if neighbor in closed_set:
				continue

			var tentative_g_cost = current_node.g_cost + 1  # Assuming uniform cost for simplicity

			if open_set.contains(neighbor) and tentative_g_cost >= neighbor.g_cost:
				continue

			neighbor.g_cost = tentative_g_cost
			neighbor.h_cost = manhattan_cost(neighbor.pos, target_position)
			neighbor.f_cost = neighbor.g_cost + neighbor.h_cost
			neighbor.parent = current_node

			if not open_set.contains(neighbor) and Util.is_valid_cell(neighbor.pos):
				open_set.insert(neighbor)

	return []

func reconstruct_path(current_node: Astar_Custom) -> Array:
	var path = []
	while current_node != null:
		path.push_front(current_node.pos)
		current_node = current_node.parent
	return path #path.reverse()

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
