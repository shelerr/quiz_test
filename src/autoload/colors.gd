extends Node

var pallete := {
    "white": Color("#F1FAEE"),
    "dark_orange": Color("#FA7921"),
    "light_orange": Color("#FE9920"),
    "blue": Color("#283044"),
    "grey": Color("#435058"),
    "light_grey": Color("#7a8684"),
    "red": Color("#BA1B1D"),
    "green": Color("#0CCA4A"),
}

func default_button_colors() -> ButtonColors:
    return ButtonColors.new(
            pallete["white"],
            pallete["grey"],
            pallete["light_orange"],
            pallete["dark_orange"]
    )
