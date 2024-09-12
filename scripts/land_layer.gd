extends TileMapLayer


var noise: FastNoiseLite = FastNoiseLite.new()

@export var width: int = 1000
@export var height: int = 1000

var tile_set_resource: TileSet

const TILE_SET_PATH: String = "res://assets/world/tempset.tres"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_tile_set()
	_do_noise()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _load_tile_set() -> void:
	# Actually, probably not needed.
	tile_set_resource = load(TILE_SET_PATH)
	if tile_set_resource:
		tile_set = tile_set_resource
	else:
		print("Could not load TileSet.")


func _do_noise() -> void:
	var rand_generator = RandomNumberGenerator.new()
	rand_generator.randomize()
	noise.seed = rand_generator.randi()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	print(noise.seed)
	var treasures = 0
	for x in range(-width / 2, width / 2):
		for y in range(-height / 2, height / 2):
			var atlas_coords = Vector2i(0, 0)
			var h = noise.get_noise_2d(x, y)
			if h > 0.7:
				atlas_coords = Vector2i(1, 1)
				treasures += 1
			elif h > 0.3:
				atlas_coords = Vector2i(0, 1)
			elif h > 0.25:
				atlas_coords = Vector2i(1, 0)
			set_cell(Vector2i(x, y), 0, atlas_coords)
	print(treasures)
