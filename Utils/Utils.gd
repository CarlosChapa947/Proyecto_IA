

static func is_valid_cell(position):
	if Globals.grid.has(str(position)):
		if Globals.grid[str(position)] != Globals.WALL:
			return true
	return false

static func world_to_grid(position):
	var cell_size = Vector2(Globals.CELL_WIDTH, Globals.CELL_HEIGHT)  # Set the size of each grid cell in pixels
	return Vector2(floor(position.x / cell_size.x), floor(position.y / cell_size.y))

static func get_neighbors(tile):
	var neighbors = []
	var directions = [Vector2(0, -1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0)] # Up, Right, Down, Left
	
	for direction in directions:
		var neighbor = tile + direction
		if is_valid_cell(neighbor): 
			neighbors.append(neighbor)
	
	return neighbors
	
static func bfs(start, target):
	var queue = []
	var visited = {}
	var path = {}
	var current_tile
	
	queue.append(start)
	visited[start] = true
	
	while queue.size() > 0:
		current_tile = queue.pop_front()
		
		if current_tile == target:
			return reconstruct_path(path, start, target)
		
		for neighbor in get_neighbors(current_tile):
			if not visited.has(neighbor):
				queue.append(neighbor)
				visited[neighbor] = true
				path[neighbor] = current_tile
				
	return [] # Return an empty path if target is not reachable

static func depth_first_search(current_position, target_position, visited=null, stack=null):
	if visited == null:
		visited = {}
	if stack == null:
		stack = []
	if current_position == target_position:
		stack.append(current_position)
		return stack # Target found
	
	# Mark the current tile as visited
	visited[current_position] = true
	stack.append(current_position)
	
	for neighbor in get_neighbors(current_position):
		if not visited.get(neighbor) and is_valid_cell(neighbor):
			stack = depth_first_search(neighbor, target_position, visited, stack)
			if stack:
				return stack # Path found
	if stack != null:
		stack.pop_back()
	return null

static func reconstruct_path(path, start, target):
	var current = target
	var path_backwards = []
	
	while current != start:
		path_backwards.push_front(current)
		current = path[current]
		
	#path_backwards.reverse()
	return path_backwards
