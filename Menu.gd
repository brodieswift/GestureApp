extends Control

var sessionTime = 30

func _on_15s_pressed():
	sessionTime = 15

func _on_30s_pressed():
	sessionTime = 30

func _on_1m_pressed():
	sessionTime = 60

func _on_2m_pressed():
	sessionTime = 120

func _on_5m_pressed():
	sessionTime = 300

func _on_10m_pressed():
	sessionTime = 600


func _on_SetFolderButton_pressed():
	pass # Replace with function body.
