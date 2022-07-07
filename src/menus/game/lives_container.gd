extends HBoxContainer

var heart_amount := 0 setget set_heart_amount

func set_heart_amount(val: int):
    val = clamp(val, 0, 3)
    while val < heart_amount:
        heart_amount -= 1
        get_child(heart_amount).modulate = Colors.pallete["grey"]
        get_child(heart_amount).texture = preload("res://resources/images/heart_broken.png")
    while val > heart_amount:
        get_child(heart_amount).modulate = Colors.pallete["red"]
        get_child(heart_amount).texture = preload("res://resources/images/heart.png")
        heart_amount += 1
