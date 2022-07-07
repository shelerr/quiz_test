extends Control

func clear_answers():
    for i in get_children():
        remove_child(i)
        i.queue_free()


func add_new_answers(answers: Array, callback_node: Node):
    var question_positions := range(4)
    question_positions.shuffle()
    
    var correct_answer := add_answer(answers[0], question_positions[0])
    correct_answer.connect("selected", callback_node, "on_chosen_correctly", [correct_answer])
    
    for i in range(1, 4):
        var new_answer := add_answer(answers[i], question_positions[i])
        new_answer.connect("selected", callback_node, "on_chosen_incorrectly", 
                [new_answer, correct_answer])


func add_answer(text: String, index: int)->Control:
    var answer: Control = preload("res://src/menus/game/choice_button.tscn").instance()
    add_child(answer)
        
    answer.text = text
    answer.anchor_left = 0.5 * (index % 2)
    answer.anchor_right = 0.5 * (index % 2 + 1)
# warning-ignore-all:integer_division
    answer.anchor_top = 0.5 * (index / 2)
    answer.anchor_bottom = 0.5 * (index / 2 + 1)
    
    return answer


func buttons_set_is_active(val: bool):
    for c in get_children():
        c.set_is_active(val)
