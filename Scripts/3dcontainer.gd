extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var item
var pos
var angle
var h

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func contain(newitem):
    item = newitem
    pos = Vector2()
    angle = 0.0
    h = 0.0
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
