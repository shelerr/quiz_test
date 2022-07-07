extends TextureButton

export var handler_node: NodePath = ".."

func _ready():
    var handler_node_obj: Control = get_node(handler_node)
    if OS.has_feature("mobile"):
        connect("button_up", handler_node_obj, "on_button_pressed")
        connect("button_down", handler_node_obj, "strong_highlight")
    elif OS.has_feature("pc"):
        connect("mouse_entered", handler_node_obj, "weak_highlight")
        connect("mouse_exited", handler_node_obj, "no_highlight")
        connect("button_down", handler_node_obj, "strong_highlight")
