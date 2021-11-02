extends TextureRect
#onready var browser = $"../CenterContainer/FileDialog"
#onready var timerPath = $"../Timer"
#var pics = []
#var folderpath = ""
#var imagenumber = 0

func _input(event):
	pass
#	if event.is_action_pressed("ui_next"):
#		image_load()
#		print("loadnext")

#func folder_open():
#	var dir = Directory.new()
#	dir.open(folderpath)
#	dir.list_dir_begin()
#	while true:
#		var file_name = dir.get_next()
#		if file_name == "":
#			#break the while loop when get_next() returns ""
#			break
#		elif !file_name.begins_with(".") and !file_name.ends_with(".import"):
#			#if !file_name.ends_with(".import"):
#			if file_name.ends_with(".png") or file_name.ends_with(".jpg"):
#				pics.append(folderpath + "/" + file_name)
#	dir.list_dir_end()
#	pics.shuffle()
#
#	print("Array setup")
#
#	if pics.size() > 0:
#		image_load()

#func image_load():
#	if imagenumber >= pics.size():
#		imagenumber = 0
#
#	var image = Image.new()
#	image.load(pics[imagenumber])
#	var newTexture = ImageTexture.new()
#	newTexture.create_from_image(image, 0)
#	texture = newTexture
#	imagenumber+=1
#
#	stretch_mode = STRETCH_KEEP_CENTERED
#	expand = false
#	rect_size = OS.window_size
#	if rect_size > OS.window_size:
#		expand = true
#		stretch_mode = STRETCH_KEEP_ASPECT_CENTERED
#		rect_size = OS.window_size
#	print("loaded image")
#
#	timerPath.start()
#
#
#
#func _on_Control_resized():
#	stretch_mode = STRETCH_KEEP_CENTERED
#	expand = false
#	rect_size = OS.window_size
#	if rect_size > OS.window_size:
#		expand = true
#		stretch_mode = STRETCH_KEEP_ASPECT_CENTERED
#		rect_size = OS.window_size
#
#
#func _on_Timer_timeout():
#	image_load()
