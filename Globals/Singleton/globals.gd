extends Node

signal stat_change()

var laser_ammount = 100
var grenade_amount = 100
var tile_map: TileMap
var grid: Dictionary = {}
var player_position: Vector2
const EMPTY = -1
const WALL = -4
var obstacle_tile_id = -4
var CELL_WIDTH = 50
var CELL_HEIGHT = 50
