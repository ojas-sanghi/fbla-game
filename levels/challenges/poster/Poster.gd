extends Node2D

var current_bg: int
var current_logo: int
var current_image: int
var current_text: int

func _ready() -> void:
	# Set the initial values to random ones
	randomize()
	current_bg = randi() % 3
	randomize()
	current_logo = randi() % 3
	randomize()
	current_image = randi() % 3
	randomize()
	current_text = randi() % 3

	change_bg()
	change_logo()
	change_image()
	change_text()

func change_bg() -> void:
	match current_bg:
		0:
			$ColorRect.color = Color("#def5fb")
		1:
			$ColorRect.color = Color("#fdfd96")
		2:
			$ColorRect.color = Color("#a7d3b0")

func _on_LeftRect_pressed():
	if current_bg != 0:
		current_bg -= 1
		change_bg()

func _on_RightRect_pressed():
	if current_bg != 2:
		current_bg += 1
		change_bg()

func change_logo() -> void:
	$Logo.texture = load("res://assets/challenges/poster/logo" + str(current_logo) + ".png")

func _on_LeftLogo_pressed() -> void:
	if current_logo != 0:
		current_logo -= 1
		change_logo()

func _on_RightLogo_pressed() -> void:
	if current_logo != 2:
		current_logo += 1
		change_logo()

func change_image():
	$Image.texture = load("res://assets/challenges/poster/image" + str(current_image) + ".png")

func _on_LeftImage_pressed() -> void:
	if current_image != 0:
		current_image -= 1
		change_image()

func _on_RightImage_pressed() -> void:
	if current_image != 2:
		current_image += 1
		change_image()

func change_text():
	match current_text:
		0:
			$Text/Label.text = "FBLA inspires and prepares students to become community-minded business leaders! We're the best club in town"
		1:
			$Text/Label.text = "The Business Achievement Awards (BAA) is a leadership development program for high school students! Contact your FBLA advisor now to sign up"
		2:
			$Text/Label.text = "We're proud about our FBLA and BAA program in Utah! Come join your FBLA club at your local school"

func _on_LeftText_pressed() -> void:
	if current_text != 0:
		current_text -= 1
		change_text()

func _on_RightText_pressed() -> void:
	if current_text != 2:
		current_text += 1
		change_text()
