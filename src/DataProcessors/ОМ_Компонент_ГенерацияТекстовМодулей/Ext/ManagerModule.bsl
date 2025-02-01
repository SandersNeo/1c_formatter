﻿#Область ПрограммныйИнтерфейс

// Добавляет новую строку команды действий с предустановленными значениями идентификатора и представления.
// 
// Параметры:
//  КомандыДействий - ТаблицаЗначений - Таблица, в которую добавляется новая строка действия.
Процедура ДобавитьКомандыДействий(КомандыДействий) Экспорт

	НоваяСтрока = КомандыДействий.Добавить();
	НоваяСтрока.Представление = "Сформировать тексты модулей...";
	НоваяСтрока.Идентификатор = "ГенерацияТекстов";
	НоваяСтрока.Порядок = 1000;
	НоваяСтрока.СпособЗапускаДействия = "ОткрытиеФормы";

КонецПроцедуры

// Создает соответствие, связывающее элементы структуры с их текстами модулей
// 
// Параметры:
//  ДеревоСтруктуры - ДеревоЗначений - Структурное дерево, содержащее строки с элементами модулей
// 
// Возвращаемое значение:
//  Соответствие - Ассоциация строк модулей с текстами их модулей
Функция СоответствиеТекстыМодулей(ДеревоСтруктуры) Экспорт

	ПроверитьИнструкцииПрепроцессораПоДеревуСтруктуры(ДеревоСтруктуры);
	
	СоотвМодулей = Новый Соответствие;
	
	Для каждого СтрМодуль Из ДеревоСтруктуры.Строки Цикл
		ТекстМодуля = ТекстМодуля(СтрМодуль);
		СоотвМодулей.Вставить(СтрМодуль, ТекстМодуля);
	КонецЦикла;
	
	Возврат СоотвМодулей;

КонецФункции

// Возвращает текст элемента модуля
// 
// Параметры:
//  СтрЭлементМодуль - СтрокаДереваЗначений - Элемент дерева структуры модуля типа "Модуль"
// 
// Возвращаемое значение:
//  Строка - Текст модуля элемента
Функция ТекстМодуля(СтрЭлементМодуль) Экспорт

	Возврат ОбработкаГенерацииТекста().ТекстМодуля(СтрЭлементМодуль);

КонецФункции

// Генерирует текстовое представление метода с возможностью включения кода / документации отдельно
// 
// Параметры:
//  СтрЭлементМетод      - СтрокаДереваЗначений - Элемент дерева структуры модуля типа "Процедура" или "Функция"
//  ВключатьКод          - Булево     - Опционально. Включает код в сгенерированный текст. По умолчанию Истина
//  ВключатьДокументацию - Булево     - Опционально. Включает документацию. По умолчанию Истина
//  ТолькоСигнатура      - Булево     - Опционально. Генерирует только сигнатуру метода. По умолчанию Ложь
// 
// Возвращаемое значение:
//  Строка - Сгенерированный текст метода
Функция ГенерироватьТекстМетода(СтрЭлементМетод, ВключатьКод = Истина, ВключатьДокументацию = Истина, ТолькоСигнатура = Ложь, ВключатьПрепроцессор = Ложь, _АнглСинтаксис = Ложь) Экспорт

	Возврат ОбработкаГенерацииТекста().ГенерироватьТекстМетода(
		СтрЭлементМетод, 
		ВключатьКод, 
		ВключатьДокументацию, 
		ТолькоСигнатура, 
		ВключатьПрепроцессор, 
		_АнглСинтаксис);

КонецФункции

// Генерирует текст инструкций препроцессора на основе переданных инструкций и параметра синтаксиса.
// 
// Параметры:
//  ИнструкцииПрепроцессора - Структура - Структура, содержащая инструкции препроцессора для генерации текста.
//  _АнглСинтаксис          - Булево    - Флаг, указывающий на использование английского синтаксиса (по умолчанию Ложь).
// 
// Возвращаемое значение:
//  Строка - Сгенерированный текст инструкций препроцессора
Функция ГенерироватьТекстИнструкцийПрепроцессора(ИнструкцииПрепроцессора, _АнглСинтаксис = Ложь) Экспорт

	Возврат ОбработкаГенерацииТекста().ГенерироватьТекстИнструкцийПрепроцессора(ИнструкцииПрепроцессора, _АнглСинтаксис);

КонецФункции

// Функция генерирует HTML-представление сигнатуры метода
// 
// Параметры:
//  СтрЭлемент           - СтрокаДереваЗначений - Элемент дерева структуры модуля типа "Процедура" или "Функция"
//  ВключатьДокументацию - Булево - Флаг, указывающий, следует ли включать документацию в HTML-представление (по умолчанию Истина)
//  ВключатьПрепроцессор - Булево - Флаг, указывающий, следует ли включать инструкции препроцессора в HTML-представление (по умолчанию Ложь)
//  _АнглСинтаксис       - Булево - Флаг, указывающий, следует ли использовать английский синтаксис в HTML-представлении (по умолчанию Ложь)
// 
// Возвращаемое значение:
//  Строка - HTML-представление сигнатуры метода
Функция СигнатураМетодаHTML(СтрЭлемент, ВключатьДокументацию = Истина, ВключатьПрепроцессор = Ложь, _АнглСинтаксис = Ложь) Экспорт

	Возврат ОбработкаГенерацииТекста().СигнатураМетодаHTML(СтрЭлемент, ВключатьДокументацию, ВключатьПрепроцессор, _АнглСинтаксис);

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОбработкаГенерацииТекста()

	Возврат Обработки.ОМ_Компонент_ГенерацияТекстовМодулей.Создать();

КонецФункции

Процедура ПроверитьИнструкцииПрепроцессораПоДеревуСтруктуры(ДеревоСтруктуры)

	Для каждого СтрМодуль Из ДеревоСтруктуры.Строки Цикл
		ПроверитьИнструкцииПрепроцессора(СтрМодуль);
	КонецЦикла;

КонецПроцедуры

Процедура ПроверитьИнструкцииПрепроцессора(СтрЭлемент)

	Если СтрЭлемент.Содержимое.Свойство("ИнструкцииПрепроцессора") Тогда
		
		Если Не ИнструкцииПрепроцессораКорректные(СтрЭлемент.Содержимое.ИнструкцииПрепроцессора) Тогда
			
			ТекстИсключения = "У элемента " + СтрЭлемент.Содержимое.Имя + " указаны некорректные инструкции препроцессора.";
			ВызватьИсключение ТекстИсключения;
	
		КонецЕсли; 
		
	КонецЕсли;
	
	Для каждого СтрВложенныйЭлемент Из СтрЭлемент.Строки Цикл
		ПроверитьИнструкцииПрепроцессора(СтрВложенныйЭлемент)	
	КонецЦикла;

КонецПроцедуры

Функция ИнструкцииПрепроцессораКорректные(ИнструкцииПрепроцессора)

	ЕстьИнструкции = Ложь;
	Для каждого КлючИЗначение Из ИнструкцииПрепроцессора Цикл
		Если КлючИЗначение.Значение = Истина Тогда
			ЕстьИнструкции = Истина;
			Прервать;
		КонецЕсли; 		
	КонецЦикла; 
	
	Возврат ЕстьИнструкции;

КонецФункции

#КонецОбласти

