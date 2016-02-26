tool
extends EditorPlugin

var button

var scene

var origintexture
var destination
var originbrowsebutton
var destinbrowsebutton
var destinformat
var width
var height
var generatebutton
var filedialog
var done
var msg

var accepted_input_formats
var accepted_output_formats
var atex_path = ""

var o = false
var d = false

func get_name():
	return "Atlas Generator"


func _init():
	print("PLUGIN INIT")

func _enter_tree():
	var button = Button.new()
	button.set_text("Atlas Generator")
	button.connect("pressed", self, "_on_button_press")
	add_custom_control(CONTAINER_TOOLBAR, button)

func _on_button_press():
	scene = preload("generator.tscn").instance()
	add_child(scene)
	scene.popup()

	accepted_input_formats = ResourceLoader.get_recognized_extensions_for_type("Texture")
	accepted_output_formats = ResourceLoader.get_recognized_extensions_for_type("AtlasTexture")

	origintexture = scene.get_node("origin-texture")
	destination = scene.get_node("destination")
	originbrowsebutton = scene.get_node("origin-browse")
	destinbrowsebutton = scene.get_node("destin-browse")
	width = scene.get_node("width")
	height = scene.get_node("height")
	generatebutton = scene.get_node("submit")
	filedialog = scene.get_node("filedialog")
	done = scene.get_node("done-window")
	msg = scene.get_node("message_label")
	info_message("")
	width.set_editable(false)
	height.set_editable(false)
	width.set_val(0)
	height.set_val(0)
	width.set_max(0)
	height.set_max(0)
	atex_path = destination.get_text()

	originbrowsebutton.connect("pressed", self, "_o_browse_pressed")
	destinbrowsebutton.connect("pressed", self, "_d_browse_pressed")
	generatebutton.connect("pressed", self, "_generate")
	filedialog.connect("file_selected", self, "_change_origin_tex")
	done.connect("popup_hide", self, "_done_done")
	done.get_node("Button").connect("pressed", self, "_done_done")

func _o_browse_pressed():
	info_message("")
	filedialog.clear_filters()
	filedialog.set_mode(FileDialog.MODE_OPEN_FILE)
	for e in accepted_input_formats:
		 filedialog.add_filter("*." + e + " ; " + e.to_upper() + " Images")
	o = true
	filedialog.popup()

func _d_browse_pressed():
	info_message("")
	filedialog.clear_filters()
	filedialog.set_mode(FileDialog.MODE_SAVE_FILE)
	for e in accepted_output_formats:
		 filedialog.add_filter("*." + e + " ; " + e.to_upper() + " Images")
	d = true
	filedialog.popup()

func _change_origin_tex(path):
	info_message("")
	if o:
		var f = File.new()
		if not f.file_exists(path):
			error_message("Input texture path doesn't exist!")
		else:
			origintexture.set_text(path)
			width.set_editable(true)
			height.set_editable(true)
			var origin = load(path)
			width.set_max(origin.get_size().x)
			height.set_max(origin.get_size().y)
			width.set_val(int(floor(origin.get_size().x / 2)))
			height.set_val(int(floor(origin.get_size().y / 2)))
			if destination.get_text() == "res://":
				d = true
	if d:
		if atex_path == "res://":
			path = path.split(".")[0] + "-<idx>." + path.split(".")[1]
		if path.find("<idx>") == -1:
			error_message("Destination path must contain '<idx>', which will be replaced with index of the sprite.")
			return
		atex_path = path
		destination.set_text(path)
	o = false
	d = false

func _generate():
	info_message("Generating..")
	var w = width.get_val()
	var h = height.get_val()
	var path = origintexture.get_text()
	if path.length() <= 6:
		error_message("Faulty input path.")
		return
	var tex = load(path)
	var tex_w = tex.get_size().x
	var tex_h = tex.get_size().y
	var amount_x = int(floor(tex_w / w))
	var amount_y = int(floor(tex_h / h))
	var amount = amount_x * amount_y

	if atex_path.length() <= 6:
		error_message("Faulty output path.")
		return

	print("Saving Resources")
	for idx in range(amount):
		var x = (idx % amount_x) * w
		var y = floor(idx / amount_x) * h
		var atex = AtlasTexture.new()
		var region = Rect2(Vector2(x, y), Vector2(w, h))
		atex.set_atlas(tex)
		atex.set_region(region)
		ResourceSaver.save(atex_path.replace("<idx>", str(idx)), atex)


	done.popup()

func _done_done():
	scene.free()

func error_message(message):
	msg.add_color_override("font_color", Color(.7, 0, 0))
	msg.set_text(message)

func info_message(message):
	msg.add_color_override("font_color", Color(.5, .5, .5))
	msg.set_text(message)
