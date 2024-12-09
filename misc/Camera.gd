extends Camera3D

var cam_move_speed: float = 40
var cam_move_speed_fast: float = 80
var cam_rotate_speed: float = 2
var cam_rotation: float = 0
var cam_zoom_speed: float
var rotation_basis = Vector3(0, 1, 0)

func move_cam(dir: Vector3):
	self.position += dir.rotated(rotation_basis, cam_rotation)

func get_event_magnitude(evt: InputEvent):
	if evt is InputEventMouseButton:
		if evt.factor != 0:
			return evt.factor
	return 1

func _ready():
	if OS.has_feature("web"):
		cam_zoom_speed = 2
	else:
		cam_zoom_speed = 20

func _input(evt: InputEvent):
	if evt.is_action_pressed("cam_move_in"):
		if self.position.y < 50:
			return
		move_cam(self.transform.basis.z * -cam_zoom_speed * get_event_magnitude(evt));
	elif evt.is_action_pressed("cam_move_out"):
		if self.position.y > 200:
			return
		move_cam(self.transform.basis.z * cam_zoom_speed * get_event_magnitude(evt))

func _process(delta: float):
	var move_vec = Vector3()
	if Input.is_action_pressed("cam_move_left"):
		move_vec += Vector3(-1, 0, 0)
	if Input.is_action_pressed("cam_move_right"):
		move_vec += Vector3(1, 0, 0)
	if Input.is_action_pressed("cam_move_up"):
		move_vec += Vector3(0, 0, -1)
	if Input.is_action_pressed("cam_move_down"):
		move_vec += Vector3(0, 0, 1)

	if move_vec != Vector3.ZERO:
		var speed = cam_move_speed
		if Input.is_action_pressed("cam_fast"):
			speed = cam_move_speed_fast
		move_cam(move_vec.normalized() * speed * delta)

	if Input.is_action_pressed("cam_rotate_left"):
		self.rotate_y(cam_rotate_speed * delta)
		cam_rotation += cam_rotate_speed * delta
	if Input.is_action_pressed("cam_rotate_right"):
		self.rotate_y(-cam_rotate_speed * delta)
		cam_rotation -= cam_rotate_speed * delta
