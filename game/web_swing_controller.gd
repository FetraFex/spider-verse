
extends Node
class_name WebSwingController


@export_group("Debug Ray")
@export var show_debug_ray: bool = true
@export var ray_thickness: float = 0.035

var ray_mesh_instance: MeshInstance3D
var ray_mesh: ImmediateMesh
var ray_material: StandardMaterial3D


@export_group("Target Detection")
@export var max_attach_distance: float = 45.0

@onready var player: CharacterBody3D = get_parent()
@onready var camera: Camera3D = $"../Camera3D"

var has_valid_target: bool = false
var target_point: Vector3 = Vector3.ZERO
var target_object: StaticBody3D = null


func _ready() -> void:
	ray_mesh = ImmediateMesh.new()

	ray_mesh_instance = MeshInstance3D.new()
	ray_mesh_instance.name = "DebugRay"
	ray_mesh_instance.mesh = ray_mesh

	ray_material = StandardMaterial3D.new()
	ray_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	ray_material.vertex_color_use_as_albedo = true
	ray_material.no_depth_test = true

	ray_mesh_instance.material_override = ray_material
	get_tree().current_scene.add_child.call_deferred(ray_mesh_instance)


func _physics_process(_delta: float) -> void:
	find_target()

func find_target() -> void:
	has_valid_target = false
	target_object = null

	var origin := camera.global_position
	var direction: Vector3 = -camera.global_transform.basis.z.normalized()
	var end_point := origin + direction * max_attach_distance
	update_debug_ray(origin, end_point)
	var query := PhysicsRayQueryParameters3D.create(
		origin,
		end_point
	)

	query.exclude = [player.get_rid()]
	query.collide_with_bodies = true
	query.collide_with_areas = false

	var result := player.get_world_3d().direct_space_state.intersect_ray(query)

	if result.is_empty():
		return

	var collider := result.get("collider") as Node

	if collider == null:
		return

	if not collider.is_in_group("web_attachable"):
		return

	has_valid_target = true
	target_point = result["position"]
	target_object = collider as StaticBody3D
	
	update_debug_ray(origin, target_point)


func update_debug_ray(origin: Vector3, end_point: Vector3) -> void:
	if not show_debug_ray:
		ray_mesh.clear_surfaces()
		return

	ray_mesh.clear_surfaces()
	ray_mesh.surface_begin(Mesh.PRIMITIVE_LINES)

	var color := Color.RED

	if has_valid_target:
		color = Color.GREEN

	ray_mesh.surface_set_color(color)
	ray_mesh.surface_add_vertex(origin)
	ray_mesh.surface_set_color(color)
	ray_mesh.surface_add_vertex(end_point)

	ray_mesh.surface_end()
