extends TileMap

@onready var player = $"../Player"
TileData
func get_collider_type():
	return 'TileMap'
	
func _physics_process(_delta):
	if player:
		
		var clicked_cell = self.local_to_map(player.position)
		var data = self.get_cell_tile_data(0, clicked_cell)
		
		print(
			data
		)
