extends Control

# warning-ignore-all:unused_signal
signal retry_pressed
signal exit_pressed

func _ready():
    $Back.color = Colors.pallete["grey"]
    
    $Exit.color_pallete = Colors.default_button_colors()
    $Exit.connect("pressed", self, "emit_signal", ["exit_pressed"])
    
    $Retry.color_pallete = Colors.default_button_colors()
    $Retry.connect("pressed", self, "emit_signal", ["retry_pressed"])
    
    play_in_animation()
    
    cust_ready(5, 10)


func cust_ready(correct_answers: int, total_questions: int):
    $Score.bbcode_text = "[center]Score : %d/%d" % [correct_answers, total_questions]

 
func play_in_animation():
    modulate.a = 0
    var tween := Tweens.get_one_use()
    tween.interpolate_property(self, "modulate:a", 0, 1, 0.5)
