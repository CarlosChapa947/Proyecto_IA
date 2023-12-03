extends Node2D

var lvl_tilemap
var grid

# Called when the node enters the scene tree for the first time.
func _ready():
	var Player_lvl = $Player
	Globals.player_position = Player_lvl.global_position
	lvl_tilemap = $Node2D/Custom_Tilemap
	Globals.tile_map = lvl_tilemap
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
