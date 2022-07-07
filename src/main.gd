extends Control

func _ready():
    OS.min_window_size = Vector2(800, 400)
    randomize()
    add_main_menu()

func add_main_menu():
    var main_menu: Node = preload("res://src/menus/main_menu/main_menu.tscn").instance()
    add_child(main_menu)
    main_menu.connect("exit_pressed", self, "quit")
    main_menu.connect("start_quiz_pressed", self, "start_quiz")

func start_quiz():
    var game: Node = preload("res://src/menus/game/game.tscn").instance()
    add_child(game)
    move_child(game, 0)
    game.connect("game_lost", self, "add_lose_screen")
    game.connect("game_won", self, "add_win_screen")

func add_lose_screen():
    var lose_screen: Node = preload("res://src/menus/lose_screen/lose_screen.tscn").instance()
    add_child(lose_screen)

    lose_screen.connect("exit_pressed", self, "quit")
    lose_screen.connect("retry_pressed", self, "retry")

func add_win_screen(correct_answers: int, total_questions: int):
    var win_screen: Node = preload("res://src/menus/win_screen/win_screen.tscn").instance()
    add_child(win_screen)
    
    win_screen.connect("exit_pressed", self, "quit")
    win_screen.connect("retry_pressed", self, "retry")
    
    win_screen.cust_ready(correct_answers, total_questions)

func retry():
    for c in get_children():
        c.queue_free()
        remove_child(c)
    start_quiz()

func quit():
    print("\n")
    get_tree().quit()
