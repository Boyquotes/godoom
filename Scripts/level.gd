extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var debug_timer = 0

func debug_print(msg):
    if debug_timer == 0:
        print(msg)

var container = load("res://Scripts/3dcontainer.gd")
var objects = []

var player_speed = 1
var player_spin = 50.0

var angle = 0.0
var loc = Vector2(0.0,0.0)
var camera = Transform2D()

# Called when the node enters the scene tree for the first time.
func _ready():
    for y in 2:
        for x in 2:
            var wall = $ResourcePreloader/Bricks.duplicate()
            var shad = $ResourcePreloader/Bricks.material.duplicate(true)
            wall.material = shad
            $ResourcePreloader/Bricks.texture.get_width()
            wall.translate(Vector2(5,5))
            wall.visible = true
            var con = container.new()
            con.contain(wall)
            con.pos.y = y / 8.0
            con.pos.x = x / 16.0
            objects.append(con)
            add_child(wall)
    
    #wall.transform.origin

func _process(delta):
    debug_timer += delta
    if(debug_timer > .5):
        debug_timer = 0
    debug_print('\n')
    if Input.is_key_pressed(KEY_A):
        angle += delta * player_spin
    if Input.is_key_pressed(KEY_D):
        angle -= delta * player_spin
    if angle < 0:
        angle += 720
    if angle > 720:
        angle -= 720
    var mathangle = float(angle)/360*PI
    
    if Input.is_key_pressed(KEY_W):
        loc.x -= sin(mathangle)*delta * player_speed
        loc.y += cos(mathangle)*delta * player_speed
    if Input.is_key_pressed(KEY_S):
        loc.x += sin(mathangle)*delta * player_speed
        loc.y -= cos(mathangle)*delta * player_speed
        
    camera.x = Vector2(cos(mathangle),-sin(mathangle))
    camera.y = Vector2(sin(mathangle),cos(mathangle))
    camera.origin = loc
    var zdepths = []
    var screensize = get_viewport().size
    for object in objects:
        #get the vector from camera to object
        var difference = object.pos - loc
        #debug_print(difference)
        var screenpos = camera.basis_xform(difference)
        debug_print(screenpos)
        if screenpos.y <= 0:
            object.item.visible = false
        else:
            object.item.visible = true
            object.item.transform.origin.x = (screenpos.x / screenpos.y) * get_viewport().size.x + get_viewport().size.x/2
            object.item.transform.origin.y = (object.h / screenpos.y) * get_viewport().size.y + get_viewport().size.y/2
            var viewangle = (object.angle - angle) /360*PI
            #debug_print(viewangle)
            object.item.transform.x = Vector2(cos(viewangle) / screenpos.y,0)
            #object.item.transform.y = Vector2(0,1 / screenpos.y)
            zdepths.append(screenpos.y)
            object.item.z_index = int(100 - screenpos.y*10)
            object.item.get_material().set_shader_param('left',1/screenpos.y+sin(viewangle) / 2)
            object.item.get_material().set_shader_param('right',1/screenpos.y-sin(viewangle) / 2)
        
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
