extends RichTextLabel
class_name DynamicTextLabel

# A label, size of which scales, according to a size of it's viewport

# Sizes are relative to viewport of height 1080
export var normal_font_size := 40
export var bold_font_size := 40
export var italics_font_size := 40
export var bold_italics_font_size := 40
export var mono_font_size := 40

func _ready():
    get_viewport().connect("size_changed", self, "_update_rich_text_label")
    _update_rich_text_label()

func _update_rich_text_label():
    var scale := get_viewport().get_size().y / 1080.0
    var font_sizes = {
        "normal_font": normal_font_size,   
        "bold_font": bold_font_size,
        "italics_font": italics_font_size,
        "bold_italics_font_size": bold_italics_font_size,
        "mono_font": mono_font_size,
    }
    for i in font_sizes:
        var new_font := get_font(i).duplicate(true)
        if new_font is DynamicFont:
            new_font.size = font_sizes[i] * scale
            add_font_override(i, new_font)
