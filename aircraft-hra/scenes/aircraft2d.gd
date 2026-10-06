extends CharacterBody2D

@export var acceleration := 15.0
@export var max_speed := 200.0
@export var friction := 15.0

var speed := 0.0
var status := "NA ZEMI"

@onready var status_label = $"../UI/StatusLabel"


func _physics_process(delta):

	# W = plyn
	if Input.is_action_pressed("throttle_up"):
		speed += acceleration * delta

	# S = brzda
	if Input.is_action_pressed("throttle_down"):
		speed -= acceleration * delta

	speed = clamp(speed, 0.0, max_speed)

	# Když nedržíš W, letadlo zpomaluje
	if not Input.is_action_pressed("throttle_up"):
		speed = move_toward(speed, 0.0, friction * delta)

	# A/D = zatáčení
	if Input.is_action_pressed("turn_left"):
		rotation -= 0.5 * delta

	if Input.is_action_pressed("turn_right"):
		rotation += 0.5 * delta

	# Pohyb letadla
	velocity = Vector2.UP.rotated(rotation) * speed

	move_and_slide()

	update_status()


func update_status():

	var heading = fposmod(rad_to_deg(rotation), 360.0)

	if speed < 100:
		status = "NA ZEMI"
	else:
		status = "VE VZDUCHU"

	status_label.text = "V: %d\nKURZ: %03d°\nSTATUS: %s" % [speed, heading, status]
