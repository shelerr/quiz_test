extends Control

signal game_lost
signal game_won

var min_question_index := -1
var max_question_index := -1
var current_question_index := -1

var question_order: Array

var correct_answers := 0 setget set_correct_answers
var lives := 3

func set_correct_answers(val):
    correct_answers = val
    $Score.text = str(val) + "/" + str(max_question_index)

func _ready():
    init_db()    
    
    set_positions()
    set_correct_answers(0)
    
    $Lives.heart_amount = 3
    $Back.color = Colors.pallete["blue"]
    
    question_order = range(current_question_index, max_question_index + 1)
    question_order.shuffle()
    
    set_new_question()


func init_db():
    $DataBase.cust_ready()
    min_question_index = $DataBase.min_index()
    max_question_index = $DataBase.max_index()
    current_question_index = min_question_index
    

func set_positions():
    var margin := 0.03
    var lives_size := 0.08
    # -0.015 is for accounting empty space in label
    Position.set_complex($Score, [0, margin], margin - 0.015, 
            [0, margin + 0.3], margin + 0.1)
    Position.set_complex($Lives, [0, margin], 1 - margin - lives_size, 
            [0, margin + 3 * lives_size], 1 - margin)
    

func set_new_question():
    $NextQuestionButton.visible = false
    $Answers.buttons_set_is_active(true)
    
    var lookup_index:int = question_order[current_question_index - min_question_index]
    var question_data: Dictionary = $DataBase.get_question_data(lookup_index)
    
    $Question.bbcode_text = question_data["question"]
    $QuestionIndex.bbcode_text = "[center]Question " + str(current_question_index)
    
    $Answers.clear_answers()
    $Answers.add_new_answers(question_data["answers"], self)
    
    current_question_index += 1


func on_chosen_incorrectly(chosen_answer: Control, correct_answer: Control):
    chosen_answer.back_color = Colors.pallete["red"]
    correct_answer.back_color = Colors.pallete["green"]
    $Lives.heart_amount -= 1
    if $Lives.heart_amount == 0:
        $Answers.buttons_set_is_active(false)
        emit_signal("game_lost")
    else:
        on_chosen_common()


func on_chosen_correctly(correct_answer: Control):
    correct_answer.back_color = Colors.pallete["green"]
    set_correct_answers(correct_answers + 1)
    on_chosen_common()


func on_chosen_common():
    $Answers.buttons_set_is_active(false)
    if current_question_index <= max_question_index:
        $NextQuestionButton.visible = true
    else:
        emit_signal("game_won", correct_answers, max_question_index)
