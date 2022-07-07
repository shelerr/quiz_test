extends Node

# A lot of times, we need to use tween only once, and adding it to tree
# is not convenient. This func solves it
func get_one_use(pause_mode: int = PAUSE_MODE_INHERIT) -> Tween:
    var tween := Tween.new()
    add_child(tween)
    tween.pause_mode = pause_mode
    tween.connect("tween_all_completed", self, "_free_tween", [tween])
    tween.start()
    return tween
    
func _free_tween(tween: Tween):
    tween.queue_free()
