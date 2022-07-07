extends Resource
class_name ButtonColors

export var normal: Color
export var inactive: Color
export var hovered: Color
export var pressed: Color

func _init(normal_: Color, inactive_: Color, hovered_: Color, pressed_: Color):
    normal = normal_
    inactive = inactive_
    hovered = hovered_
    pressed = pressed_
