extends Control


# warning-ignore:unused_signal
signal selected

export var label: NodePath

var text setget set_text, get_text
var back_color setget set_back_color, get_back_color

func _ready():
    $GenericButton.connect("pressed", self, "emit_signal", ["selected"])
    $GenericButton.color_pallete = Colors.default_button_colors()

func set_back_color(val):
    $Back.color = val

func get_back_color():
    return $Back.color

func set_text(val):
    get_node(label).bbcode_text = "[center]" + val

func get_text():
    return get_node(label).text

func set_is_active(val):
    $GenericButton.no_highlight()
    $GenericButton.is_active = val
