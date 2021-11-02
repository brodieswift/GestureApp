extends Label
onready var timerPath = $"../../Timer"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !timerPath.is_paused():
		text = str(floor(timerPath.time_left))
