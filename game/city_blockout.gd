
extends Node3D

@export_group("City Layout")
@export_range(1, 50) var blocks_per_side: int = 35
@export var street_width: float = 10.0
@export var building_footprint: float = 30.0
@export var max_building_height: float = 450.0
@export var random_seed: int = 42

@export_group("Districts")
@export var central_district_radius: float = 0.28
@export var medium_district_radius: float = 0.65

@onready var buildings: Node3D = $Buildings
@onready var ground: StaticBody3D = $Ground
@onready var player: CharacterBody3D = $Player

var player_position: Vector3

func _ready() -> void:
	print("Player Position: ", player.position)
	generate_city()
	print("player_initial_position: ", player_position)
	player.position = player_position


func generate_city() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = random_seed

	var block_spacing := building_footprint + street_width
	var city_size := blocks_per_side * block_spacing

	print("City Size:", city_size)
	create_ground(city_size)

	var center_index := (blocks_per_side - 1) / 2.0
	var max_grid_distance := maxf(center_index, 1.0)
	var highest_building := 0
	for x in range(blocks_per_side):
		for z in range(blocks_per_side):
			var center_x := (x - center_index) * block_spacing
			var center_z := (z - center_index) * block_spacing

			var grid_distance := Vector2(
				x - center_index,
				z - center_index
			).length() / (sqrt(2.0) * max_grid_distance)

			var district_height := get_district_height(
				grid_distance,
				rng
			)

			var width := rng.randf_range(
				building_footprint * 0.75,
				building_footprint
			)
			var depth := rng.randf_range(
				building_footprint * 0.75,
				building_footprint
			)
			var height := clampf(
				district_height,
				8.0,
				max_building_height
			)

			create_building(
				Vector3(center_x, height / 2.0, center_z),
				Vector3(width, height, depth)
			)
			
			if highest_building < height:
				highest_building = height
				player_position = Vector3(x, highest_building, z)
			

func get_district_height(
	distance_from_center: float,
	rng: RandomNumberGenerator
) -> float:
	if distance_from_center <= central_district_radius:
		# Dense central skyline.
		return rng.randf_range(
			max_building_height * 0.65,
			max_building_height
		)

	if distance_from_center <= medium_district_radius:
		# Mid-rise buildings around the center.
		return rng.randf_range(
			max_building_height * 0.30,
			max_building_height * 0.65
		)

	# Lower buildings toward the city's edges.
	return rng.randf_range(
		max_building_height * 0.12,
		max_building_height * 0.35
	)


func create_ground(city_size: float) -> void:
	var size := Vector3(
		city_size + street_width,
		1.0,
		city_size + street_width
	)

	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	mesh_instance.position.y = -0.5
	mesh_instance.name = "GroundMesh"
	ground.add_child(mesh_instance)

	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	collision.position.y = -0.5
	collision.name = "GroundCollision"
	ground.add_child(collision)


func create_building(center: Vector3, dimensions: Vector3) -> void:
	var body := StaticBody3D.new()
	body.name = "Building"
	body.add_to_group("web_attachable")
	body.position = center
	buildings.add_child(body)

	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = dimensions
	mesh_instance.mesh = mesh
	body.add_child(mesh_instance)

	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = dimensions
	collision.shape = shape
	body.add_child(collision)
