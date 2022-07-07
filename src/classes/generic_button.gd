extends Control
class_name GenericButton

signal pressed

var is_active := true

export var puppet_node: NodePath
export var master_node: NodePath
export var color_pallete: Resource

func _ready():
    assert(get_node(puppet_node) is CanvasItem, "Expected CanvasItem as puppet")

    get_node(master_node).connect("pressed", self, "on_button_pressed")
    
func set_active(time: float = 0):
    is_active = true
    no_highlight(time)

func set_inactive(time: float = 0):
    inactive_highlight(time)
    is_active = false

func strong_highlight(time: float = -1):
    if not is_active:
        return
    if time > 0:
        _setup_tween(color_pallete.pressed, time)
    else:
        _setup_tween(color_pallete.pressed, 0.10)

func weak_highlight(time: float = -1):
    if not is_active:
        return
    if time > 0:
        _setup_tween(color_pallete.hovered, time)
    else:
        _setup_tween(color_pallete.hovered, 0.25)

func no_highlight(time: float = -1):
    if not is_active:
        return
    if time > 0:
        _setup_tween(color_pallete.normal, time)
    else:
        _setup_tween(color_pallete.normal, 0.25)

func inactive_highlight(time: float = -1):
    if time > 0:
        _setup_tween(color_pallete.inactive, time)
    else:
        _setup_tween(color_pallete.inactive, 0)

func on_button_pressed():
    if not is_active:
        return
    if OS.has_feature("pc"):
        weak_highlight()
    elif OS.has_feature("mobile"):
        no_highlight()
    emit_signal("pressed")

func _setup_tween(target: Color, time: float):
    var puppet_node_temp: CanvasItem = get_node(puppet_node)
    Tweens.get_one_use(PAUSE_MODE_PROCESS).interpolate_property(
        puppet_node_temp, "modulate", puppet_node_temp.modulate, target, time,
        Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
    )
