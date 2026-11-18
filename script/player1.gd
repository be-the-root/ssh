extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -350.0

# Get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Link to the UI Label we created
@onready var objective_label = get_tree().root.find_child("Label", true, false)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump (Up Arrow or W key)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		# Smooth deceleration when you let go of the keys
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


# This function triggers when the player touches the Sister's Area2D
func _on_area_2d_body_entered(body: Node2D) -> void:
	# Ensure it's the player touching it
	if body.name == "player":
		# Stop the player from moving
		set_physics_process(false)
		
		# Change the objective text and make it green
		if objective_label:
			objective_label.text = "Objective Complete: Sister found."
			objective_label.add_theme_color_override("font_color", Color.GREEN)
		
		# Wait 2 seconds so the player can read the text
		await get_tree().create_timer(2.0).timeout
		
		# Create the Win Screen
		var ui_layer = CanvasLayer.new()
		get_tree().root.add_child(ui_layer)
		
		var win_label = Label.new()
		win_label.text = "YOU SAVED HER."
		win_label.add_theme_font_size_override("font_size", 64)
		win_label.add_theme_color_override("font_color", Color.WHITE)
		win_label.add_theme_color_override("font_outline_color", Color.BLACK)
		win_label.add_theme_constant_override("outline_size", 8)
		
		win_label.set_anchors_preset(Control.PRESET_FULL_RECT)
		win_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		win_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		
		ui_layer.add_child(win_label)
