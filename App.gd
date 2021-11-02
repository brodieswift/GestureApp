extends Control

onready var FolderDialog = $"MenuView/CenterContainer/FileDialog"
onready var FolderInfo = $"MenuView/MenuNode/FolderInfo"
onready var StartButton = $"MenuView/VBoxContainer/StartSessionButton"
onready var menu = $"MenuView"
onready var session = $"SessionView"
onready var textureRect = $"SessionView/Image"
onready var timerPath = $"SessionView/Timer"
onready var timerLabel = $"SessionView/HBoxContainer/Label"
onready var buttonPlay = $"SessionView/Toolbar/btnPlay"
onready var buttonPin = $"SessionView/Toolbar/btnPin"
onready var buttonNext = $"SessionView/Toolbar/btnNext"
onready var buttonPrevious = $"SessionView/Toolbar/btnPrev"
onready var buttonList = $"SessionView/Toolbar/btnList"
onready var buttonFlipH = $"SessionView/Toolbar/btnFlipH"
onready var itemList = $"SessionView/CenterContainer/ItemList"
onready var filterGrey = $"SessionView/Greyscale"

var iconPlay = preload("res://Icons/play.png")
var iconPause = preload("res://Icons/pause.png")
var iconPinned = preload("res://Icons/pinned.png")
var iconUnpinned = preload("res://Icons/unpin.png")

var folderPath = ""
var photos = []
var sessionTime = 30
var imagenumber = 0
var sessionImages = 5

#Choose Folder Button
func _on_Button_pressed():
	FolderDialog.popup()

func _input(event):
	if session.visible:
		if event.is_action_pressed("ui_pause"):
			button_paused()

		if event.is_action_pressed("ui_cancel"):
			button_exit()

		if event.is_action_pressed("ui_right"):
			button_load_next()

		if event.is_action_pressed("ui_left"):
			button_load_previous()

func button_paused():
	if !timerPath.is_paused():
		timerLabel.text = "Paused. "+timerLabel.text
		timerPath.set_paused(true)
		buttonPlay.icon = iconPlay
		buttonPlay.hint_tooltip = "Play."
	else:
		timerPath.set_paused(false)
		buttonPlay.icon = iconPause
		buttonPlay.hint_tooltip = "Pause."

func button_exit():
	
	timerPath.stop()
	timerLabel.visible = true
	itemList.visible = true
	buttonPlay.visible = true
	buttonPrevious.visible = true
	buttonNext.visible = true
	buttonList.visible = false
	sessionTime = 30
	imagenumber = 0
	sessionImages = 5
	itemList.visible = false
	itemList.clear()

	session.visible = false
	menu.visible = true

func button_load_next():
	load_image()

func button_load_previous():
	imagenumber -= 2
	if imagenumber < 0:
		imagenumber = photos.size()-1
	load_image()

func button_image_flip_h():
	textureRect.flip_h = !textureRect.flip_h

#Picked Folder to load images
func _on_FileDialog_dir_selected(dir):
	if folderPath != dir:
		photos = []
		folderPath = dir #FolderDialog.current_path
		get_dir_contents(folderPath)	#directory_create()

func get_dir_contents(rootPath: String) -> Array:
	var files = []
	var directories = []
	var dir = Directory.new()

	if dir.open(rootPath) == OK:
		dir.list_dir_begin(true, false)
		_add_dir_contents(dir, files, directories)
	else:
		push_error("An error occurred when trying to access the path.")

	return [files, directories]
	
func _add_dir_contents(dir: Directory, files: Array, directories: Array):
	var file_name = dir.get_next()

	while (file_name != ""):
		var path = dir.get_current_dir() + "/" + file_name

		if dir.current_is_dir():
			print("Found directory: %s" % path)
			var subDir = Directory.new()
			subDir.open(path)
			subDir.list_dir_begin(true, false)
			directories.append(path)
			_add_dir_contents(subDir, files, directories)
		else:
			if !file_name.begins_with(".") and !file_name.ends_with(".import"):
				if file_name.ends_with(".png") or file_name.ends_with(".jpg"):
					print("Found file: %s" % path)
					files.append(path)
					photos.append(path)

		file_name = dir.get_next()

	dir.list_dir_end()
	
	if photos.size() > 0:
		FolderInfo.text = str(photos.size())+" Images Found."
		StartButton.visible = true

func load_image():
	if imagenumber > photos.size()-1:
		imagenumber = 0
	
	var image = Image.new()
	image.load(photos[imagenumber])
	var newTexture = ImageTexture.new()
	newTexture.create_from_image(image, 0)
	textureRect.texture = newTexture
	imagenumber+=1
	
	textureRect.stretch_mode = textureRect.STRETCH_KEEP_CENTERED
	textureRect.expand = false
	textureRect.rect_size = OS.window_size
	if textureRect.rect_size > OS.window_size:
		textureRect.expand = true
		textureRect.stretch_mode = textureRect.STRETCH_KEEP_ASPECT_CENTERED
		textureRect.rect_size = OS.window_size
	
	timerPath.wait_time = sessionTime
	if timerPath.is_paused():
		timerPath.set_paused(false)
	timerPath.start()
	timerLabel.text = str(floor(timerPath.time_left))
	itemList.add_icon_item(newTexture, true)
	#Check the height of itemList to stop it getting too tall
	if itemList.rect_size.y >= 500:
		itemList.auto_height = false
		itemList.rect_min_size.y = 500

func start_session():
	session.visible = true
	load_image()
	
func end_session():
	timerPath.stop()
	timerLabel.visible = false
	itemList.visible = true
	buttonPlay.visible = false
	buttonPrevious.visible = false
	buttonNext.visible = false
	buttonList.visible = true

func _on_StartSessionButton_pressed():
	sessionTime = menu.sessionTime
	print(sessionTime)
	menu.visible = false
	start_session()

func _on_Timer_timeout():
	sessionImages -= 1
	print(sessionImages)
	if sessionImages <= 0:
		end_session()
	else:
		load_image()

func _on_btnFlipH_pressed():
	button_image_flip_h()

func _on_btnPrev_pressed():
	button_load_previous()

func _on_btnNext_pressed():
	button_load_next()

func _on_btnPlay_pressed():
	button_paused()

func _on_btnPin_pressed():
	if !OS.is_window_always_on_top():
		buttonPin.icon = iconPinned
		OS.set_window_always_on_top(true)
	else:
		OS.set_window_always_on_top(false)
		buttonPin.icon = iconUnpinned

func _on_btnFilter_pressed():
	filterGrey.visible = !filterGrey.visible

func _on_ItemList_item_activated(index):
	textureRect.texture = itemList.get_item_icon(index)
	textureRect.stretch_mode = textureRect.STRETCH_KEEP_CENTERED
	textureRect.expand = false
	textureRect.rect_size = OS.window_size
	if textureRect.rect_size > OS.window_size:
		textureRect.expand = true
		textureRect.stretch_mode = textureRect.STRETCH_KEEP_ASPECT_CENTERED
		textureRect.rect_size = OS.window_size
	itemList.visible = false

func _on_SpinBox_value_changed(value):
	sessionImages = value
	print(sessionImages)

func _on_btnList_pressed():
	itemList.visible = !itemList.visible

func _on_btnExit_pressed():
	if buttonPlay.visible:
		end_session()
	else:
		button_exit()
