@tool
extends RichTextEffect
class_name RichTextOverlord

# Syntax: [overlord hue=0.5][/overlord]

var bbcode = "overlord"

# Параметры S и V для создания цвета
var s = 1.0  # Saturation
var v = 0.6  # Value

# Параметры анимации
var animation_speed = 3.0  # скорость колебания
var saturation_range = 0.5  # амплитуда (0.0-1.0)

func _process_custom_fx(char_fx):
	# Получаем hue из параметров BBcode
	var hue = char_fx.env.get("hue", 0.0)
	
	# Вычисляем циклическое изменение насыщенности
	# sin() колеблется от -1 до 1, умножаем на половину диапазона
	var cycle = sin(char_fx.elapsed_time * animation_speed) * (saturation_range / 2.0)
	var new_saturation = s / 2.0 + cycle  # центр колебания в середине
	
	# Закрепляем значение в допустимом диапазоне
	new_saturation = clamp(new_saturation, 0.0, 1.0)
	
	# Создаём цвет с модулированной насыщенностью
	char_fx.color = Color.from_hsv(hue, new_saturation, v)
