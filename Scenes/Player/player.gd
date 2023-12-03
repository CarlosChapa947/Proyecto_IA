extends CharacterBody2D

var SPEED = 500
var chargeFireball = true
var chargeFireStrike = true

signal fireball_signal(position, direction)
signal firestrike_signal(position, direction)
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.player_position = self.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var move_direction = Input.get_vector("Left", "Right", "Up", "Down")
	#self.position += direction * SPEED * delta
	self.velocity = move_direction * SPEED
	var look_direction = (get_global_mouse_position() - self.position).normalized()
	move_and_slide()
	Globals.player_position = self.global_position
	
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("Primary_Action") and chargeFireball:
		print("shooting")
		var fireball_markers: Array = $Markers.get_children()
		var selected_fireball = fireball_markers[randi() % fireball_markers.size()]
		fireball_signal.emit(selected_fireball.global_position, look_direction)
		self.chargeFireball = false
		$Timers/TimerFireball.start()
		
	elif Input.is_action_pressed("Secondary_Action") and chargeFireStrike:
		print("throw")
		var firestrike_pos = $Markers.get_children()[0].global_position
		firestrike_signal.emit(firestrike_pos, look_direction)
		self.chargeFireStrike = false
		$Timers/TimerFirestrike.start()


func _on_timer_fireball_timeout():
	self.chargeFireball = true


func _on_timer_firestrike_timeout():
	self.chargeFireStrike = true
