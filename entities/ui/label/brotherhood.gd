extends RichTextEffect
class_name RichTextBrotherhood

# Syntax: [brotherhood][/brotherhood]

var bbcode = "brotherhood"

# Параметры S и V для создания цвета
var s = 1.0  # Saturation (насыщенность)
var v = 0.8  # Value (яркость)

# Параметры волны
var wave_width = 3.33  # ширина каждого цвета (кол-во букв)
var wave_speed = 8.0  # скорость движения волны (буквы в секунду)

# HSV значения для трех цветов
var hues = [0.0, 0.333, 0.5]  # Красный, Зеленый, Голубой

func _process_custom_fx(char_fx):
	# Позиция волны в пространстве букв
	var wave_position = fmod(char_fx.elapsed_time * wave_speed, wave_width * 3)
	
	# Расстояние от буквы до переднего края волны
	var relative_position = char_fx.range.x - wave_position
	
	# Зацикливаем волну
	while relative_position < 0:
		relative_position += wave_width * 3
	
	# Определяем, какому сегменту волны принадлежит буква
	var color_index = int(relative_position / wave_width) % 3
	
	# Устанавливаем цвет
	char_fx.color = Color.from_hsv(hues[color_index], s, v)
	
	return true
