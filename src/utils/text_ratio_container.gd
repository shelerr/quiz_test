extends Container

export var ratio := 0.0

func _ready():
    connect("sort_children", self, "update")
    get_child(0).connect("resized", self, "update")


func update():
    var text = get_child(0)
    text.rect_size.x = rect_size.x
    text.rect_position.x = 0
    
    # workaround, because get_content_height doesn't get updated immediately
    yield(get_tree(), "idle_frame")
    
    var text_actual_size = text.get_content_height()
            
    text.rect_position.y = (rect_size.y - text_actual_size) * ratio
    text.rect_size.y = text_actual_size
