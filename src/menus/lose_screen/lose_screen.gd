extends Control

# warning-ignore-all:unused_signal
signal retry_pressed
signal exit_pressed

func _ready():
    $Back.color = Colors.pallete["grey"]
    
    $Retry.color_pallete = Colors.default_button_colors()
    $Retry.connect("pressed", self, "emit_signal", ["retry_pressed"])
    
    $Exit.color_pallete = Colors.default_button_colors()
    $Exit.connect("pressed", self, "emit_signal", ["exit_pressed"])
    
    play_in_animation()


func play_in_animation():
    modulate.a = 0
    var tween := Tweens.get_one_use()
    tween.interpolate_property(self, "modulate:a", 0, 1, 0.5)
