extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

onready var database: SQLite = SQLite.new()

enum VerbosityLevel {
    QUIET = 0,
    NORMAL = 1,
    VERBOSE = 2,
    VERY_VERBOSE = 3
}
const verbosity_level : int = VerbosityLevel.NORMAL

var db_name := "res://resources/questions.db"

func cust_ready():
    database.path = db_name
    database.open_db()

func min_index()->int:
    database.query("SELECT min(primary_key) FROM questions")
    return database.query_result_by_reference[0].values()[0]

func max_index()->int:
    database.query("SELECT max(primary_key) FROM questions")
    return database.query_result_by_reference[0].values()[0]

func get_question_data(index: int)->Dictionary:
    database.query("SELECT * FROM questions WHERE primary_key = %d" % index)
    var data: Dictionary = database.query_result_by_reference[0]
    return {
        "question": data["question"],
        "answers": [
            data["correct_answer"], 
            data["alt_answer1"], 
            data["alt_answer2"], 
            data["alt_answer3"],
        ]
    }
