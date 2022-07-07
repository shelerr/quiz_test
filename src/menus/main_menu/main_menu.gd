extends Control

# warning-ignore-all:unused_signal
signal start_quiz_pressed
signal exit_pressed

var block_input := false

func _ready():
    var button_color_pallete := Colors.default_button_colors()
    
    $Buttons/Start.connect("pressed", self, "on_start_quiz_pressed")
    $Buttons/Start.color_pallete = button_color_pallete
    
    $Buttons/Exit.connect("pressed", self, "emit_signal", ["exit_pressed"])
    $Buttons/Exit.color_pallete = button_color_pallete\
    
    $Back.color = Colors.pallete["blue"]


func on_start_quiz_pressed():
    if block_input:
        return
    block_input = true
    
    emit_signal("start_quiz_pressed")
    
    var tween := Tweens.get_one_use(PAUSE_MODE_PROCESS)
    tween.interpolate_property(self, "modulate:a", modulate.a, 0, 0.4, 
            Tween.TRANS_SINE, Tween.EASE_IN_OUT)
    yield(tween, "tween_all_completed")
    
    queue_free()
