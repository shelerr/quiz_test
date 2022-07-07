extends "res://src/classes/generic_button_master.gd"
class_name TextButtonMaster

export (int, "LEFT", "CENTER", "RIGHT", "FULL") var alignment
export var text_node: NodePath
export var used_font := "normal_font"
enum {LEFT, CENTER, RIGHT, FULL}

func _ready():
    get_node(text_node).connect("resized", self, "_update_self")
    _update_self()


func _update_self():
    if get_viewport() == null or get_viewport().get_size().y < 5: # REFACTOR
        return
    
    var text_node_obj = get_node(text_node)
    var font = text_node_obj.get_font(used_font)
    var string_size: Vector2 = font.get_string_size(text_node_obj.text)
    var margin := string_size.x * 0.05

    rect_size.x = string_size.x + 2 * margin
    rect_size.y = text_node_obj.rect_size.y
    rect_position.y = 0
    if alignment == LEFT:
        rect_position.x = -1 * margin
    elif alignment == CENTER:
        rect_position.x = (text_node_obj.rect_size.x - string_size.x)/2.0 - margin
    elif alignment == RIGHT:
        rect_position.x = text_node_obj.rect_size.x - string_size.x - margin
    elif alignment == FULL:
        rect_position.x = 0
        rect_size = text_node_obj.rect_size
    # to update a button (can be useful, if it moves, but cursor does not)
    set_position(rect_position)
    set_size(rect_size)
