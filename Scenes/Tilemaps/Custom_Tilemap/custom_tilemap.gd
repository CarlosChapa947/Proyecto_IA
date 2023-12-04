extends TileMap

var updateWavefront = false
var grid:Dictionary = {}
var gridSize
const EMPTY = -1
const WALL = -4
var obstacle_tile_id = -3
var CELL_WIDTH = 160
var CELL_HEIGHT = 160
var tiles_cords
var walls_cords
var node: Node2D
const Util = preload("res://Utils/Utils.gd")
# Called when the node enters the scene tree for the first time.
func _ready():
	self.node = new()
	tiles_cords = self.get_used_cells(0)
	for tile_cordinate in tiles_cords:
		#self.get_cell_tile_data(0, tile_cordinate).set_custom_data("Valid", 1)
		#var temp: TileData = self.get_cell_tile_data(0, tile_cordinate)
		Globals.grid[str(tile_cordinate)] = EMPTY

	# Fill the grid based on the used cells
	walls_cords = self.get_used_cells(1)
	for cell in walls_cords: # Adjust to grid's coordinate system
		Globals.grid[str(cell)] = Globals.WALL
	self.grid = Globals.grid.duplicate(true)
	propagate_wavefront(Util.world_to_grid(Globals.player_position))
	$Refresh.start()

func _physics_process(_delta):
	if updateWavefront:
		Globals.grid = self.grid.duplicate(true)
		var player_coord = Util.world_to_grid(Globals.player_position)
		propagate_wavefront(player_coord)
		self.updateWavefront = false
		$Refresh.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func propagate_wavefront(goal_position):
	var to_visit = []
	to_visit.push_back(goal_position)
	Globals.grid[str(goal_position)] = 0
	
	while to_visit.size() > 0:
		var current = to_visit.pop_front()
		var current_cost = Globals.grid[str(current)]
		for direction in [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]:
			var neighbor = current + direction
			if Util.is_valid_cell(neighbor) and Globals.grid[str(neighbor)] == Globals.EMPTY:
				Globals.grid[str(neighbor)] = current_cost + 1
				to_visit.push_back(neighbor)
	


#func is_valid_cell(position):
#	if Globals.grid.has(str(position)):
#		if Globals.grid[str(position)] != WALL:
#			return true
#	return false
#
#func world_to_grid(position):
#	var cell_size = Vector2(CELL_WIDTH, CELL_HEIGHT)  # Set the size of each grid cell in pixels
#	return Vector2(floor(position.x / cell_size.x), floor(position.y / cell_size.y))



func _on_refresh_timeout():
	self.updateWavefront = true # Replace with function body.
