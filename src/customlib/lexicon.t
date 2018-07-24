// Функция, возвращающая псевдослучайную фразу из заданного лексикона
replica: function(lexicon)
{
	local ind, len;
	len := length(lexicon.phrases);
	if(lexicon.any)
	{
		ind := rand(len);
		// Нейтрализуем повтор одной фразы дважды подряд
		if(ind = lexicon.last)
		{
			if(ind = 1)
				ind := ind + 1;
			else
				ind := ind - 1;
		}
	}
	else
	{
		// Если свойство order объекта лексикона является пустым списком, то наполняем его номерами фраз в псевдослучайном порядке
		if(lexicon.order = [])
		{
			local i, numbers := [], number;
			// Создаём список натуральных чисел
			for(i := 1; i <= len; i++)
			{
				numbers := numbers + [i];
			}
			// "Перекладываем" натуральные числа в свойство order в псевдослучайном порядке
			for(i := 1; i <= len; i++)
			{
				number := numbers[rand(length(numbers))];
				numbers := numbers - [number];
				lexicon.order := lexicon.order + [number];
			}
			// Нейтрализуем повтор одной фразы дважды подряд
			if(lexicon.order[1] = lexicon.last)
			{
				number := lexicon.order[1];
				lexicon.order := lexicon.order - [number];
				lexicon.order := lexicon.order + [number];
			}
		}
		ind := lexicon.order[1];
		lexicon.order := lexicon.order - [ind];
	}
	lexicon.last := ind;
	return lexicon.phrases[ind];
}

// Класс лексикона фраз
class lexicon: object
	/*
	* Свойство any определяет режим обработки лексикона.
	* Если any = true, то функция replica() будет возвращать ЛЮБУЮ фразу (за исключением последней произнесённой).
	* Если any = nil, то функция replica() сначала последовательно вернёт в псевдослучайном порядке, задаваемом в order, все фразы из phrases, а уже потом уйдёт на повтор.
	* any = true может быть использован в actorDesc, где частый повтор не очень критичен.
	* Ну а any = nil уместно использовать, например, в репликах персонажей, чтобы минимизировать их повторяемость.
	* Причём, при any = nil, псевдослучайный порядок фраз генерируется каждый раз по-новому.
	*/
	any = nil // По необходимости переопределить в дочернем объекте
	phrases = [] // Список фраз лексикона
	// Свойства last и order в дочернем объекте явно переопределят не требуется
	last = 0 // Номер последней произнесённой из лексикона фразы
	order = [] // Порядок выборки фраз лексикона
;

// Лексикон фраз для описания комнаты
//lexiconStartroomLdesc: lexicon
//	phrases = [
//		'Первое описание комнаты.'
//		'Второе описание комнаты.'
//		'Третье описание комнаты.'
//		'Четвёртое описание комнаты.'
//		'Пятое описание комнаты.'
//	]
//;