extends Node

class_name best_first_node
var pos: Vector2
var cost: float
var parent: best_first_node = null
var start
var end
var heap: MinHeapBFS
const Util = preload("res://Utils/Utils.gd")

func _init(start, end):
	self.start = start
	self.end = end
	
	
func best_first_search(start_position: Vector2, target_position: Vector2) -> Array:
	var open_set: MinHeapBFS = MinHeapBFS.new()
	var start_node = best_first_node.new(start_position, target_position)
	start_node.pos = start_position
	start_node.cost = manhattan_cost(start_position, target_position)
	open_set.insert(start_node)
	
	while not open_set.is_empty():
		var current_node: best_first_node = open_set.extract_min()
		
		if current_node.pos == target_position:
			return reconstruct_path(current_node)
		
		for neighbor in get_neighbors(current_node.pos):
			var neighbor_node = best_first_node.new(neighbor, target_position)
			neighbor_node.pos = neighbor
			neighbor_node.cost = manhattan_cost(neighbor, target_position)
			neighbor_node.parent = current_node
			open_set.insert(neighbor_node)
	
	return []

func get_neighbors(tile):
	var neighbors = []
	var directions = [Vector2(0, -1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0)] # Up, Right, Down, Left
	
	for direction in directions:
		var neighbor = tile + direction
		if Util.is_valid_cell(neighbor): 
			neighbors.append(neighbor)
	
	return neighbors
	

func reconstruct_path(node: best_first_node) -> Array:
	var path: Array = []
	while node != null:
		path.push_front(node.pos)
		node = node.parent
	
	#path.invert()
	return path

func manhattan_cost(start_pos, end_pos):
	return abs(end_pos.x - start_pos.x) + abs(end_pos.y - start_pos.y)
	


#func is_valid_cell(position):
#	if Globals.grid.has(str(position)):
#		if Globals.grid[str(position)] != Globals.WALL:
#			return true
#	return false
