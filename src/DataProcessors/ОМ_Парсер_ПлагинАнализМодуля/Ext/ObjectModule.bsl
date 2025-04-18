﻿#Область ОписаниеПеременных

Перем Типы;
Перем Токены;
Перем Исходник;
Перем ТаблицаТокенов;
Перем ТаблицаОшибок;
Перем ТаблицаЗамен;
Перем Стек;
Перем Счетчики;
Перем Директивы;
Перем Аннотации;
Перем СимволыПрепроцессора;

Перем ТипыВызоваМетода;

// Контекст анализа
Перем СтруктураОбщиеМодули; // ключ - имя модуля, значение - произвольное (можно тоже имя)
Перем СтруктураМодулиМенеджера; // структура структур, в структуре верхнего уровклю ключ - тип объекта метаданных (см. ИнициализироватьСтруктуруМенеджерыТиповМД()), значение - структура, где ключ - имя объекта метаданных
Перем СтруктураДоступныеПоляМодуля; // ключи - имя поля, значение - произвольное (может быть имя объекта метаданных - реквизит формы, объекта)
Перем СтруктураМенеджерыТиповМД;
Перем Конфигурация;
Перем АнализируемыйМодуль;
Перем ЕстьКонфигурацияКонтекст;

// Результаты анализа
Перем ТаблицаВызовов;
Перем ТаблицаОбращенияКПолям;
Перем ТаблицаСоздаваемыеОбъекты;

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область ВыдачаРезультатов

// Возвращает таблицу вызовов методов, которая содержит информацию о вызовах методов в анализируемом модуле.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица вызовов методов с колонками: ИмяМетода, ИмяМетодаВРЕГ, ИмяВызываемогоМетода, ТипВызова, Модуль
Функция ТаблицаВызовов() Экспорт
	Возврат ТаблицаВызовов;
КонецФункции

// Возвращает таблицу обращений к полям, которая содержит информацию об обращениях к полям в анализируемом модуле.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица обращений к полям с колонками: ИмяМетода, ИмяПоля, Объект
Функция ТаблицаОбращенияКПолям() Экспорт
	Возврат ТаблицаОбращенияКПолям;
КонецФункции

// Возвращает таблицу создаваемых объектов, которая содержит информацию о создаваемых объектах в анализируемом модуле.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица создаваемых объектов с колонками: ИмяМетода, ИдентификаторТипа, Параметр
Функция ТаблицаСоздаваемыеОбъекты() Экспорт
	Возврат ТаблицаСоздаваемыеОбъекты;
КонецФункции

// Возвращает структуру, содержащую информацию о вызовах локальных методов в анализируемом модуле. Структура содержит имена локальных методов и методы, из которых они вызываются.
// 
// Возвращаемое значение:
//  Структура - Ключи - имена локальных методов, Значения - массивы с именами методов, из которых они вызываются
Функция ВызовыЛокальныхМетодов() Экспорт
	СтруктЛокальныеМетоды = Новый Структура;
	
	СтрокиЛокальныеВызовы = ТаблицаВызовов.НайтиСтроки(Новый Структура("ТипВызова", ТипыВызоваМетода.Локальный));
	Для каждого Стр Из СтрокиЛокальныеВызовы Цикл
		ИмяВызываемогоМетода = Стр.ИмяВызываемогоМетода;
		МетодыИзКоторыхВызывается = Неопределено;
		Если Не СтруктЛокальныеМетоды.Свойство(ИмяВызываемогоМетода, МетодыИзКоторыхВызывается) Тогда
			МетодыИзКоторыхВызывается = Новый Массив;
			СтруктЛокальныеМетоды.Вставить(ИмяВызываемогоМетода, МетодыИзКоторыхВызывается);
		КонецЕсли;
		
		МетодыИзКоторыхВызывается.Добавить(Стр.ИмяМетода);
	КонецЦикла;
	
	Возврат СтруктЛокальныеМетоды;
КонецФункции

// Возвращает структуру, содержащую информацию о вызовах методов в анализируемом модуле. Ключ структуры - имя метода, значение - массив строк с информацией о вызовах.
// 
// Возвращаемое значение:
//  Структура - Структура с ключами - именами методов, значения - массивы строк вызовов.
Функция СтруктураМетодВызовы() Экспорт
	Структ = Новый Структура;
	
	Для каждого Стр Из ТаблицаВызовов Цикл
		ИмяМетода = Стр.ИмяМетода;
		Если НЕ ЗначениеЗаполнено(ИмяМетода) Тогда
			Продолжить;
		КонецЕсли;
		
		Вызовы = Неопределено;
		Если Не Структ.Свойство(ИмяМетода, Вызовы) Тогда
			Вызовы = Новый Массив;
			Структ.Вставить(ИмяМетода, Вызовы);
		КонецЕсли;
		
		Вызовы.Добавить(Стр);
	КонецЦикла;
	
	Возврат Структ;
КонецФункции

#КонецОбласти

#Область ИнтерфейсПлагина

Процедура Открыть(Парсер, Параметры) Экспорт
	
	ИнициализироватьПеременныеОкруженияПарсера(Парсер);
	ИнициализироватьТипы();
	
	// Инициализация контекста анализа (конфигурации)
	Конфигурация = Неопределено;
	АнализируемыйМодуль = Неопределено;
	Если ТипЗнч(Параметры) = Тип("Структура") Тогда
		Параметры.Свойство("СтруктураОбщиеМодули", СтруктураОбщиеМодули);
		Параметры.Свойство("СтруктураМодулиМенеджера", СтруктураМодулиМенеджера);
		Параметры.Свойство("СтруктураДоступныеПоляМодуля", СтруктураДоступныеПоляМодуля);
		Параметры.Свойство("Модуль", АнализируемыйМодуль);
	КонецЕсли;
	ИнициализироватьСтруктуруМенеджерыТиповМД();
	
	ТаблицаВызовов = ПустаяТаблицаВызовов();
	ТаблицаОбращенияКПолям = ПустаяТаблицаОбращенияКПолям();
	ТаблицаСоздаваемыеОбъекты = ПустаяТаблицаСоздаваемыеОбъекты();
КонецПроцедуры

Функция Закрыть() Экспорт
	// Выдача результатов в виде текста для теста через консоль
	ТД = Новый ТекстовыйДокумент;
	
	СчетчикВызовов = Новый Структура;
	Для каждого КлючЗначения Из ТипыВызоваМетода Цикл
		СчетчикВызовов.Вставить(КлючЗначения.Ключ, 0);
	КонецЦикла;
	
	ТабВызовов = ТаблицаВызовов();
	
	Для каждого Стр Из ТабВызовов Цикл
		ТД.ДобавитьСтроку("ИмяМетода = " + Стр.ИмяМетода);
		ТД.ДобавитьСтроку("ИмяВызываемогоМетода = " + Стр.ИмяВызываемогоМетода);
		ТД.ДобавитьСтроку("ТипВызова = " + Стр.ТипВызова);
		Если ЗначениеЗаполнено(Стр.Модуль) Тогда
			Если ТипЗнч(Стр.Модуль) = Тип("Строка") Тогда
				МодульСтр = Стр.Модуль;
			Иначе
				МодульСтр = Строка(Стр.Модуль.ТипМодуля) + " " + Стр.Модуль.ОбъектМетаданных;
				Если ТипЗнч(Стр.Модуль.ОбъектМетаданных) = Тип("СправочникСсылка.ОбъектыМетаданных") Тогда
					МодульСтр = МодульСтр 
						+ " " 
						+ Стр.Модуль.ОбъектМетаданных 
						+ " (" 
						+ Стр.Модуль.ОбъектМетаданных.ТипОбъектаМетаданных 
						+ ")";
				Иначе
					МодульСтр = МодульСтр 
						+ " " 
						+ Стр.Модуль.ОбъектМетаданных 
						+ " (" 
						+ Стр.Модуль.ОбъектМетаданных.ОбъектМетаданных.ТипОбъектаМетаданных 
						+ " " 
						+ Стр.Модуль.ОбъектМетаданных.ОбъектМетаданных 
						+ ")";
				КонецЕсли;
			КонецЕсли;
			
			ТД.ДобавитьСтроку("Модуль = " + МодульСтр);
		КонецЕсли; 
		ТД.ДобавитьСтроку("=========================="); 
		
		СчетчикВызовов[Стр.ТипВызова] = СчетчикВызовов[Стр.ТипВызова] + 1;
	КонецЦикла;
	
	Для каждого КлючЗначения Из СчетчикВызовов Цикл
		ТД.ДобавитьСтроку(КлючЗначения.Ключ + " = " + КлючЗначения.Значение);
	КонецЦикла;
	
	
	ТД.ДобавитьСтроку("=========================="); 
	ТД.ДобавитьСтроку("Вызовы локальных методов"); 
	ТД.ДобавитьСтроку("=========================="); 
	
	СтруктВызовыЛокальныхМетодов = ВызовыЛокальныхМетодов();
	
	Для каждого КлючЗначения Из СтруктВызовыЛокальныхМетодов Цикл
		ТД.ДобавитьСтроку(КлючЗначения.Ключ + " вызывается из: " + СтрСоединить(КлючЗначения.Значение, ", ")); 
	КонецЦикла;

	ТД.ДобавитьСтроку("=========================="); 
	ТД.ДобавитьСтроку("Обращения к полям"); 
	ТД.ДобавитьСтроку("=========================="); 
	
	ТабОбращенияКПолям = ТаблицаОбращенияКПолям();
	
	Для каждого Стр Из ТабОбращенияКПолям Цикл
		ТД.ДобавитьСтроку("ИмяМетода = " + Стр.ИмяМетода);
		ТД.ДобавитьСтроку("ИмяПоля = " + Стр.ИмяПоля);
		Если ЗначениеЗаполнено(Стр.Объект) Тогда
			ТД.ДобавитьСтроку("Объект = " + Стр.Объект);
		КонецЕсли; 
		ТД.ДобавитьСтроку("=========================="); 
		
		//СчетчикВызовов[Стр.ТипВызова] = СчетчикВызовов[Стр.ТипВызова] + 1;
	КонецЦикла;

	ТД.ДобавитьСтроку("=========================="); 
	ТД.ДобавитьСтроку("Создаваемые объекты"); 
	ТД.ДобавитьСтроку("=========================="); 
	
	ТабСоздаваемыеОбъекты = ТаблицаСоздаваемыеОбъекты();
	
	Для каждого Стр Из ТабСоздаваемыеОбъекты Цикл
		ТД.ДобавитьСтроку("ИмяМетода = " + Стр.ИмяМетода);
		ТД.ДобавитьСтроку("ИД Типа = " + Стр.ИдентификаторТипа);
		Если ЗначениеЗаполнено(Стр.Параметр) Тогда
			ТД.ДобавитьСтроку("Параметр = " + Стр.Параметр);
		КонецЕсли; 
		ТД.ДобавитьСтроку("=========================="); 
		
		//СчетчикВызовов[Стр.ТипВызова] = СчетчикВызовов[Стр.ТипВызова] + 1;
	КонецЦикла;
	
	Возврат ТД.ПолучитьТекст();
КонецФункции

Функция Подписки() Экспорт
	Перем Подписки;
	Подписки = Новый Массив;
	Подписки.Добавить("ПосетитьВыражениеИдентификатор");
	Подписки.Добавить("ПосетитьВыражениеНовый");
	Подписки.Добавить("ПокинутьМодуль");
	Возврат Подписки;
КонецФункции

Процедура ПокинутьМодуль(Модуль) Экспорт
	ТаблицаВызовов.Свернуть("ИмяМетода,ИмяМетодаВРЕГ,ИмяВызываемогоМетода,ТипВызова,Модуль");
	ТаблицаОбращенияКПолям.Свернуть("ИмяМетода,ИмяПоля,Объект");
	ТаблицаСоздаваемыеОбъекты.Свернуть("ИмяМетода,ИдентификаторТипа,Параметр");
КонецПроцедуры

Процедура ПосетитьВыражениеИдентификатор(ВыражениеИдентификатор) Экспорт
	// Голова выражения (вызовы локальных и стандартных методов)
	ИмяГолова = Неопределено; // это может быть имя общ. модуля или тип объекта МД (Справочники, Документы, ...)
	ОбъявлениеГолова = ВыражениеИдентификатор.Голова.Объявление; // это что-то известное или нет?
	Если ВыражениеИдентификатор.Аргументы = Неопределено Тогда // это НЕ вызов метода
		ИмяГолова = ВыражениеИдентификатор.Голова.Имя;

		Если ОбъявлениеГолова = Неопределено // это явно ошиибочное с точки зрения парсера обращение
			ИЛИ ОбъявлениеГолова.Тип = Типы.ОбъявлениеАвтоПеременной Тогда // что-то непонятное внутри модуля (не локальная переменная, например)
			// Проверим, возможно это обращение к доступному полю?
			ДобавитьИнфоОбОбращенииКПолюЕслиВДоступныхПоляхМодуля(ИмяГолова);
		ИначеЕсли ОбъявлениеГолова.Тип = Типы.ОбъявлениеПеременнойМодуля Тогда // Это обращение к переменной модуля?
			ДобавитьИнфоОбОбращенииКПолю(ИмяГолова, АнализируемыйМодуль);
		КонецЕсли;
	Иначе
		ИмяВызываемогоМетода = ВыражениеИдентификатор.Голова.Имя;
		Если ОбъявлениеГолова = Неопределено Тогда
			ТипВызова = ТипыВызоваМетода.Неизвестно;
		ИначеЕсли ОбъявлениеГолова.Тип = Типы.ОбъявлениеГлобальногоМетода Тогда // объявление из глобального окружения
			ТипВызова = ТипыВызоваМетода.СтандартныйМетод;
			
			// Рассматриваем вызов стандартного метода - не создает ли он обработчик оповещения или ожидания
			ДобавитьИнфоОВызовеОжидания(ИмяВызываемогоМетода, ВыражениеИдентификатор.Аргументы);
			
		ИначеЕсли ОбъявлениеГолова.Тип = Типы.ОбъявлениеСигнатурыФункции 
			ИЛИ ОбъявлениеГолова.Тип = Типы.ОбъявлениеСигнатурыПроцедуры Тогда // локальное объявление
			ТипВызова = ТипыВызоваМетода.Локальный;
		КонецЕсли;
		ДобавитьИнфоОВызове(ИмяВызываемогоМетода, ТипВызова, Неопределено);
	КонецЕсли;
	
	// 1-й элемент хвоста выражения (вызовы ОМ)
	Имя2 = Неопределено; // здесь будет имя МД
	КоличествоЭлементовХвоста = ВыражениеИдентификатор.Хвост.Количество();
	Если КоличествоЭлементовХвоста > 0 Тогда
		ЭлементХвоста = ВыражениеИдентификатор.Хвост[0];
		Если ЭлементХвоста.Тип = Типы.ВыражениеПоле Тогда // может быть еще индекс
			Если ЭлементХвоста.Аргументы = Неопределено Тогда // это НЕ вызов метода?
				Имя2 = ЭлементХвоста.Имя;
				
				// Если ИмяГолова = "ЭтотОбъект" или "ЭтаФорма", то поля 1-го элемента хвоста - будут аналогичны голове
				Если Равно_ЭтотОбъект(ИмяГолова) Тогда
					// Проверим, возможно это обращение к доступному полю?
					ДобавитьИнфоОбОбращенииКПолюЕслиВДоступныхПоляхМодуля(Имя2);
				КонецЕсли;
			Иначе
				ТипВызова = ТипыВызоваМетода.Неизвестно;
				ОбщийМодуль = Неопределено;
				Если ЗначениеЗаполнено(ИмяГолова) // голова был НЕ вызов метода 
					И ОбъявлениеГолова = Неопределено Тогда // и НЕ известный элемент из глоб. окружения (системное перечисление, Справочники)
					
					Если СтруктураОбщиеМодули <> Неопределено Тогда
						Если СтруктураОбщиеМодули.Свойство(ИмяГолова, ОбщийМодуль) Тогда // ищем общий модуль по имени
							ТипВызова = ТипыВызоваМетода.ОбщийМодуль;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
				ДобавитьИнфоОВызове(ЭлементХвоста.Имя, ТипВызова, ОбщийМодуль);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// 2-й элемент хвоста выражения (вызовы модулей менеджера)
	Имя3 = Неопределено; // не понятно для чего может пригодиться..
	Если КоличествоЭлементовХвоста > 1 Тогда
		ЭлементХвоста = ВыражениеИдентификатор.Хвост[1];
		Если ЭлементХвоста.Тип = Типы.ВыражениеПоле Тогда
			Если ЭлементХвоста.Аргументы = Неопределено Тогда
				Имя3 = ЭлементХвоста.Имя;
			Иначе
				ТипВызова = ТипыВызоваМетода.Неизвестно;
				Модуль = Неопределено;
				Если ЗначениеЗаполнено(ИмяГолова)
					И ЗначениеЗаполнено(Имя2)
					И ОбъявлениеГолова <> Неопределено
					И ОбъявлениеГолова.Тип = Типы.ОбъявлениеГлобальногоОбъекта Тогда // (Документы, Справочники, ...)

					Если СтруктураМодулиМенеджера <> Неопределено Тогда
						СтруктураТипОбъекта = Неопределено;
						Если СтруктураМодулиМенеджера.Свойство(ИмяГолова, СтруктураТипОбъекта) // ищем по типу МД
							И СтруктураТипОбъекта.Свойство(Имя2, Модуль) Тогда // ищем по объекту МД
							ТипВызова = ТипыВызоваМетода.МодульМенеджера;
						КонецЕсли;
					Иначе
						Если СтруктураМенеджерыТиповМД.Свойство(ИмяГолова) Тогда
							ТипВызова = ТипыВызоваМетода.МодульМенеджера;
							Модуль = ИмяГолова + "." + Имя2;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
				ДобавитьИнфоОВызове(ЭлементХвоста.Имя, ТипВызова, Модуль);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// просматриваем остальные элементы хвоста
	ИндексЭлемента = 2;
	Пока ИндексЭлемента < КоличествоЭлементовХвоста Цикл
		ЭлементХвоста = ВыражениеИдентификатор.Хвост[ИндексЭлемента];
		Если ЭлементХвоста.Тип = Типы.ВыражениеПоле Тогда // может быть еще индекс
			Если ЭлементХвоста.Аргументы <> Неопределено Тогда
				ДобавитьИнфоОВызове(ЭлементХвоста.Имя, ТипыВызоваМетода.Неизвестно, Неопределено);
			КонецЕсли;
		КонецЕсли;
		
		ИндексЭлемента = ИндексЭлемента + 1;
	КонецЦикла;
КонецПроцедуры // ПосетитьВыражениеИдентификатор()

Процедура ПосетитьВыражениеНовый(ВыражениеНовый) Экспорт
	Имя = ВыражениеНовый.Имя;
	Параметр = "";
	
	Если ВыражениеНовый.Аргументы <> Неопределено Тогда // есть параметры создаваемого объекта
		Параметр = ПараметрСоздаваемогоОбъекта(Имя, ВыражениеНовый.Аргументы);
		
		ДобавитьИнфоОВызовеОповещения(Имя, ВыражениеНовый.Аргументы);
	КонецЕсли;

	ДобавитьИнфоОСоздаваемомОбъекте(Имя, Параметр);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Инициализация

Процедура ИнициализироватьТипы()
	ТипыВызоваМетода = Новый Структура(
		"СтандартныйМетод,Локальный,ОбщийМодуль,МодульМенеджера,Объектный,ОбработчикОповещения,ОбработчикОжидания,Неизвестно",
	    "СтандартныйМетод",
		"Локальный",
		"ОбщийМодуль",
		"МодульМенеджера",
		"Объектный",
		"ОбработчикОповещения",
		"ОбработчикОжидания",
		"Неизвестно");
КонецПроцедуры

Процедура ИнициализироватьПеременныеОкруженияПарсера(Парсер)
	Типы = Парсер.Типы();
	Токены = Парсер.Токены();
	Исходник = Парсер.Исходник();
	ТаблицаТокенов = Парсер.ТаблицаТокенов();
	ТаблицаОшибок = Парсер.ТаблицаОшибок();
	ТаблицаЗамен = Парсер.ТаблицаЗамен();
	Стек = Парсер.Стек();
	Счетчики = Парсер.Счетчики();
	Директивы = Парсер.Директивы();
	Аннотации = Парсер.Аннотации();
	СимволыПрепроцессора = Парсер.СимволыПрепроцессора();
КонецПроцедуры

Процедура ИнициализироватьСтруктуруМенеджерыТиповМД()

	СтруктураМенеджерыТиповМД = Новый Структура(
		"РегистрыНакопления, AccumulationRegisters,
		|БизнесПроцессы, BusinessProcesses,
		|Справочники, Catalogs,
		|ПланыВидовХарактеристик, ChartsOfCharacteristicTypes,
		|ПланыСчетов, ChartsOfAccounts,
		|ПланыВидовРасчета, ChartsOfCalculationTypes,
		|Константы, Constants,
		|Обработки, DataProcessors,
		|Документы, Documents,
		|ЖурналыДокументов, DocumentJournals,
		|Перечисления, Enums,
		|ПланыОбмена, ExchangePlans,
		|КритерииОтбора, FilterCriteria,
		|РегистрыСведений, InformationRegisters,
		|Отчеты, Reports,
		|Задачи, Tasks,
		|РегистрыБухгалтерии, AccountingRegisters,
		|РегистрыРасчета, CalculationRegisters,
		|ХранилищаНастроек, SettingsStorages");
	
КонецПроцедуры

Функция ПустаяТаблицаВызовов()
	Таб = Новый ТаблицаЗначений;
	Таб.Колонки.Добавить("ИмяМетода", Новый ОписаниеТипов("Строка")); // если пусто, то из кода в теле модуля
	Таб.Колонки.Добавить("ИмяМетодаВРЕГ", Новый ОписаниеТипов("Строка")); // если пусто, то из кода в теле модуля
	Таб.Колонки.Добавить("ИмяВызываемогоМетода", Новый ОписаниеТипов("Строка"));
	Таб.Колонки.Добавить("ТипВызова", Новый ОписаниеТипов("Строка")); // СтандартныйМетод / Локальный / ОбщийМодуль / МодульМенеджера / Объектный / ОбработчикОповещения / ОбработчикОжидания 
	Таб.Колонки.Добавить("Модуль"); //Новый ОписаниеТипов("СправочникСсылка.Модули")
	
	Возврат Таб;
КонецФункции

Функция ПустаяТаблицаОбращенияКПолям()
	Таб = Новый ТаблицаЗначений;
	Таб.Колонки.Добавить("ИмяМетода", Новый ОписаниеТипов("Строка")); // если пусто, то из кода в теле модуля
	Таб.Колонки.Добавить("ИмяПоля", Новый ОписаниеТипов("Строка"));
	Таб.Колонки.Добавить("Объект"); //СправочникСсылка.ОбъектыМетаданны,СправочникСсылка.Формы,СправочникСсылка.Модули
	
	Возврат Таб;
КонецФункции

Функция ПустаяТаблицаСоздаваемыеОбъекты()
	Таб = Новый ТаблицаЗначений;
	Таб.Колонки.Добавить("ИмяМетода", Новый ОписаниеТипов("Строка")); // если пусто, то из кода в теле модуля
	Таб.Колонки.Добавить("ИдентификаторТипа", Новый ОписаниеТипов("Строка"));
	Таб.Колонки.Добавить("Параметр", Новый ОписаниеТипов("Строка")); // для COMОбъект - имя 
	
	Возврат Таб;
КонецФункции

#КонецОбласти

#Область Анализ

Функция ИмяМетодаИзСтека()
	Для каждого ЭлементСтека Из Стек Цикл
		Если ЭлементСтека.Тип = Типы.ОбъявлениеМетода Тогда
			Возврат ЭлементСтека.Сигнатура.Имя;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

Функция ЗначениеСтроковогоАргумента(Аргументы, Номер)
	Если Аргументы.Количество() > Номер Тогда
		Аргумент = Аргументы[Номер];
		Если Аргумент <> Неопределено
			И Аргумент.Тип = Типы.ВыражениеСтроковое 
			И ЗначениеЗаполнено(Аргумент.Элементы) Тогда
			Элемент1 = Аргумент.Элементы[0];
			Возврат Элемент1.Значение;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

Функция ПараметрСоздаваемогоОбъекта(Имя, Аргументы)
	ИмяВРЕГ = ВРег(Имя);
	Если ИмяВРЕГ = "COMОБЪЕКТ"
		ИЛИ ИмяВРЕГ = "COMOBJECT" Тогда
		Параметр = ЗначениеСтроковогоАргумента(Аргументы, 0);
		Возврат ?(ЗначениеЗаполнено(Параметр), Параметр, Неопределено);
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

Функция Равно_ЭтотОбъект(Имя)
	ИмяВРЕГ = ВРег(Имя);
	Возврат (ИмяВРЕГ = "ЭТОТОБЪЕКТ" ИЛИ ИмяВРЕГ = "THISOBJECT"
		ИЛИ ИмяВРЕГ = "ЭТАФОРМА" ИЛИ ИмяВРЕГ = "THISFORM");
КонецФункции

Процедура ДобавитьИнфоОВызове(ИмяВызываемогоМетода, ТипВызова, Модуль)
	ИмяАнализируемогоМетода = ИмяМетодаИзСтека();
	
	СтрВызов = ТаблицаВызовов.Добавить();
	СтрВызов.ИмяМетода = ИмяАнализируемогоМетода;
	СтрВызов.ИмяВызываемогоМетода = ИмяВызываемогоМетода;
	СтрВызов.ТипВызова = ТипВызова;
	СтрВызов.Модуль = Модуль;
КонецПроцедуры

Процедура ДобавитьИнфоОВызовеОжидания(ИмяВызываемогоМетода, Аргументы)
	// Если вызывается метод ПодключитьОбработчикОжидания, то это рассматриваем как вызов вида ОбработчикОжидания
	ИмяВызываемогоМетодаВРЕГ = ВРег(ИмяВызываемогоМетода);
	Если ИмяВызываемогоМетодаВРЕГ = "ПОДКЛЮЧИТЬОБРАБОТЧИКОЖИДАНИЯ" 
		ИЛИ ИмяВызываемогоМетодаВРЕГ = "ATTACHIDLEHANDLER" Тогда
		ИмяМетодаОбработчика = ЗначениеСтроковогоАргумента(Аргументы, 0);
		Если ЗначениеЗаполнено(ИмяМетодаОбработчика) Тогда
			ДобавитьИнфоОВызове(ИмяМетодаОбработчика, ТипыВызоваМетода.ОбработчикОжидания, АнализируемыйМодуль);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ДобавитьИнфоОВызовеОповещения(ИмяСоздаваемогоОбъекта, Аргументы)
	// Если создается объект ОписаниеОповещения, то это рассматриваем как вызов вида ОбработчикОповещения
	// TODO НЕПЛОХО БЫЛО БЫ ДОДЕЛАТЬ ОПРЕДЛЕНИЕ МОДУЛЯ
	ИмяСоздаваемогоОбъектаВРЕГ = ВРег(ИмяСоздаваемогоОбъекта);
	Если ИмяСоздаваемогоОбъектаВРЕГ = "ОПИСАНИЕОПОВЕЩЕНИЯ" 
		ИЛИ ИмяСоздаваемогоОбъектаВРЕГ = "CALLBACKDESCRIPTION" Тогда
		ИмяМетодаОбработчика = ЗначениеСтроковогоАргумента(Аргументы, 0);
		Если ЗначениеЗаполнено(ИмяМетодаОбработчика) Тогда
			ДобавитьИнфоОВызове(ИмяМетодаОбработчика, ТипыВызоваМетода.ОбработчикОповещения, АнализируемыйМодуль);
		КонецЕсли;

		ИмяМетодаОбработчикаОшибки = ЗначениеСтроковогоАргумента(Аргументы, 3);
		Если ЗначениеЗаполнено(ИмяМетодаОбработчикаОшибки) Тогда
			ДобавитьИнфоОВызове(ИмяМетодаОбработчикаОшибки, ТипыВызоваМетода.ОбработчикОповещения, АнализируемыйМодуль);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ДобавитьИнфоОбОбращенииКПолю(ИмяПоля, ОбъектМД)
	ИмяАнализируемогоМетода = ИмяМетодаИзСтека();
	
	Стр = ТаблицаОбращенияКПолям.Добавить();
	Стр.ИмяМетода = ИмяАнализируемогоМетода;
	Стр.ИмяПоля = ИмяПоля;
	Стр.Объект = ОбъектМД;
КонецПроцедуры

Процедура ДобавитьИнфоОСоздаваемомОбъекте(ИдентификаторТипа, Параметр = "")
	ИмяАнализируемогоМетода = ИмяМетодаИзСтека();
	
	Стр = ТаблицаСоздаваемыеОбъекты.Добавить();
	Стр.ИмяМетода = ИмяАнализируемогоМетода;
	Стр.ИдентификаторТипа = ИдентификаторТипа;
	Стр.Параметр = Параметр;
КонецПроцедуры

Процедура ДобавитьИнфоОбОбращенииКПолюЕслиВДоступныхПоляхМодуля(ИмяПоля)
	Если СтруктураДоступныеПоляМодуля = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектМД = Неопределено;
	Если СтруктураДоступныеПоляМодуля.Свойство(ИмяПоля, ОбъектМД) Тогда
		ДобавитьИнфоОбОбращенииКПолю(ИмяПоля, ОбъектМД);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область НеИспользуется

Процедура Ошибка(Текст, Начало, Конец = Неопределено, ЕстьЗамена = Ложь)
	//Ошибка = ТаблицаОшибок.Добавить();
	//Ошибка.Источник = "ИмяЭтогоПлагина";
	//Ошибка.Текст = Текст;
	//Ошибка.ПозицияНачала = Начало.Позиция;
	//Ошибка.НомерСтрокиНачала = Начало.НомерСтроки;
	//Ошибка.НомерКолонкиНачала = Начало.НомерКолонки;
	//Если Конец = Неопределено Или Конец = Начало Тогда
	//	Ошибка.ПозицияКонца = Начало.Позиция + Начало.Длина;
	//	Ошибка.НомерСтрокиКонца = Начало.НомерСтроки;
	//	Ошибка.НомерКолонкиКонца = Начало.НомерКолонки + Начало.Длина;
	//Иначе
	//	Ошибка.ПозицияКонца = Конец.Позиция + Конец.Длина;
	//	Ошибка.НомерСтрокиКонца = Конец.НомерСтроки;
	//	Ошибка.НомерКолонкиКонца = Конец.НомерКолонки + Конец.Длина;
	//КонецЕсли;
	//Ошибка.ЕстьЗамена = ЕстьЗамена;
КонецПроцедуры

Процедура Замена(Текст, Начало, Конец = Неопределено)
	//НоваяЗамена = ТаблицаЗамен.Добавить();
	//НоваяЗамена.Источник = "ИмяЭтогоПлагина";
	//НоваяЗамена.Текст = Текст;
	//НоваяЗамена.Позиция = Начало.Позиция;
	//Если Конец = Неопределено Тогда
	//	НоваяЗамена.Длина = Начало.Длина;
	//Иначе
	//	НоваяЗамена.Длина = Конец.Позиция + Конец.Длина - Начало.Позиция;
	//КонецЕсли;
КонецПроцедуры

Процедура Вставка(Текст, Позиция)
	//НоваяЗамена = ТаблицаЗамен.Добавить();
	//НоваяЗамена.Источник = "ИмяЭтогоПлагина";
	//НоваяЗамена.Текст = Текст;
	//НоваяЗамена.Позиция = Позиция;
	//НоваяЗамена.Длина = 0;
КонецПроцедуры

#КонецОбласти

#КонецОбласти
