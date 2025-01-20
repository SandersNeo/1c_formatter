﻿#Область Переменные

Перем СтекИнструкцийПрепроцессора;

#КонецОбласти

#Область ПрограммныйИнтерфейс

Функция РазобратьТекстВДеревоМодуля(Знач ТекстМодуля, ИмяМодуля = Неопределено) Экспорт
	Парсер = Обработки.ОМ_Парсер_ПарсерВстроенногоЯзыка.Создать();	

	Парсер.СтрогийРежим = Истина;
	АСД = Парсер.Разобрать(ТекстМодуля);
	ТаблицаТокенов = Парсер.ТаблицаТокенов();
	
	ДеревоМодуля = Обработки.ОМ_ОформляторМодулей.НовоеДеревоСтруктурыМодуля();
	
	СтрокаМодуль = ДеревоМодуля.Строки.Добавить();
	СтрокаМодуль.Описание = ?(ИмяМодуля = Неопределено, "Модуль", ИмяМодуля);
	СтрокаМодуль.ТипЭлемента = "Модуль";
	
	СтрокаМодуль.Содержимое = Обработки.ОМ_ОформляторМодулей.МодульСтруктураОписания();
	СтрокаМодуль.Содержимое.Имя = СтрокаМодуль.Описание;
	СтрокаМодуль.Содержимое.Синтаксис = "Русский";

	ЗаполнитьМодульПоАСД(СтрокаМодуль, АСД, ТаблицаТокенов, ТекстМодуля);

	Возврат ДеревоМодуля;
КонецФункции

#КонецОбласти

#Область ЗаполнениеСтруктурыМодуля

Функция ЗаполнитьМодульПоАСД(СтрокаДереваМодуль, АСД, ТаблицаТокенов, ТекстМодуля)

	СтекИнструкцийПрепроцессора = Новый Массив;
	
	СтекОбластей = Новый Массив;
	СтрокаДерева = СтрокаДереваМодуль;

	ПоследнийТокенПредИтерации = ТаблицаТокенов[0];
	
	Для каждого Объявление Из АСД.Объявления Цикл
		
		КомментарийКТекущемуОбъявлению = "";
		КомментарииМеждуТокенами = ИзвлечьКомментарииМеждуТокенами(ТаблицаТокенов, ТекстМодуля, ПоследнийТокенПредИтерации, Объявление.Начало);
		Если КомментарииМеждуТокенами <> Неопределено Тогда
			МассивКомментариев = КомментарииМеждуТокенами.МассивКомментариев;
			Если НЕ КомментарииМеждуТокенами.ЕстьПустаяСтрокаПослеКомментариев 
				И (Объявление.Тип = "ОбъявлениеСпискаПеременныхМодуля"
					ИЛИ Объявление.Тип = "ОбъявлениеМетода"
					ИЛИ Объявление.Тип = "ИнструкцияПрепроцессораОбласть") Тогда
				КомментарийКТекущемуОбъявлению = МассивКомментариев[МассивКомментариев.ВГраница()];
				МассивКомментариев.Удалить(МассивКомментариев.ВГраница());
			КонецЕсли;
			
			Для каждого Комментарий Из МассивКомментариев Цикл
				НоваяСтрокаДерева = СтрокаДерева.Строки.Добавить();
				НоваяСтрокаДерева.ТипЭлемента = "Комментарий";
				НоваяСтрокаДерева.Описание = СтрПолучитьСтроку(Комментарий, 1);
				
				НоваяСтрокаДерева.Содержимое = Обработки.ОМ_ОформляторМодулей.КомментарийСтруктураОписания();
				НоваяСтрокаДерева.Содержимое.Комментарий = Комментарий;
			КонецЦикла;
		КонецЕсли;
		
		ПоследнийТокенПредИтерации = Объявление.Конец;

		Если Объявление.Тип = "ИнструкцияПрепроцессораКонецОбласти" Тогда
			
			Если СтекОбластей.Количество() = 0 Тогда
				ВызватьИсключение "Неожиданный конец области в строке " + Объявление.Начало.НомерСтроки;
			КонецЕсли;
			
			КомментарийСразуПослеКонцаОбласти = ИзвлечьКомментарийСразуПослеТокена(ТаблицаТокенов, ТекстМодуля, Объявление.Конец);
			Если КомментарийСразуПослеКонцаОбласти <> Неопределено Тогда 
				СтрокаДерева.Содержимое.КомментарийПослеКонецОбласти = КомментарийСразуПослеКонцаОбласти.Комментарий;
				ПоследнийТокенПредИтерации = КомментарийСразуПослеКонцаОбласти.Токен;
			КонецЕсли;
			
			СтекОбластей.Удалить(0); // извлекаем из стека последнюю область
			СтрокаДерева = ?(СтекОбластей.Количество()=0, СтрокаДереваМодуль, СтекОбластей[0]);
		
		ИначеЕсли Объявление.Тип = "ИнструкцияПрепроцессораОбласть" Тогда

			КомментарийВСтрокеОбласть = "";
			КомментарийСразуПослеОбласть = ИзвлечьКомментарийСразуПослеТокена(ТаблицаТокенов, ТекстМодуля, Объявление.Конец);
			Если КомментарийСразуПослеОбласть <> Неопределено Тогда 
				КомментарийВСтрокеОбласть = КомментарийСразуПослеОбласть.Комментарий;
				ПоследнийТокенПредИтерации = КомментарийСразуПослеОбласть.Токен;
			КонецЕсли;
			
			НоваяСтрокаДерева = СтрокаДерева.Строки.Добавить();
			НоваяСтрокаДерева.ТипЭлемента = "Область";
			НоваяСтрокаДерева.Описание = Объявление.Имя;
			
			НоваяСтрокаДерева.Содержимое = Обработки.ОМ_ОформляторМодулей.ОбластьСтруктураОписания();
			НоваяСтрокаДерева.Содержимое.Имя = Объявление.Имя;
			НоваяСтрокаДерева.Содержимое.Комментарий = КомментарийКТекущемуОбъявлению;
			НоваяСтрокаДерева.Содержимое.КомментарийВСтрокеОбласть = КомментарийВСтрокеОбласть;

			СтекОбластей.Вставить(0, НоваяСтрокаДерева); // вставляем область в стек
			СтрокаДерева = НоваяСтрокаДерева;
			
		ИначеЕсли Объявление.Тип = "ИнструкцияПрепроцессораЕсли" Тогда

			ТекущиеУсловияПрепроцессора = Новый Массив;
			ТекстВыражения = ТекстУзла(Объявление.Выражение, ТекстМодуля);
			ТекущиеУсловияПрепроцессора.Добавить(ПодготовитьВыражениеИнструкцийПрепроцессора(ТекстВыражения));
			
			СтекИнструкцийПрепроцессора.Вставить(0, ТекущиеУсловияПрепроцессора);

		ИначеЕсли Объявление.Тип = "ИнструкцияПрепроцессораИначеЕсли" Тогда

			ТекстВыражения = ТекстУзла(Объявление.Выражение, ТекстМодуля);
			СтекИнструкцийПрепроцессора[0].Вставить(0, ПодготовитьВыражениеИнструкцийПрепроцессора(ТекстВыражения));
			
		ИначеЕсли Объявление.Тип = "ИнструкцияПрепроцессораИначе" Тогда

			СтекИнструкцийПрепроцессора[0].Вставить(0, "");

		ИначеЕсли Объявление.Тип = "ИнструкцияПрепроцессораКонецЕсли" Тогда
			
			СтекИнструкцийПрепроцессора.Удалить(0);
			
		ИначеЕсли Объявление.Тип = "ОбъявлениеСпискаПеременныхМодуля" Тогда
			
			НоваяСтрокаДерева = СтрокаДерева.Строки.Добавить();
			НоваяСтрокаДерева.ТипЭлемента = "Переменная";
			НоваяСтрокаДерева.Содержимое = Обработки.ОМ_ОформляторМодулей.ПеременнаяСтруктураОписания();

			ТаблицаПеременных = НоваяСтрокаДерева.Содержимое.ТаблицаПеременных;
			Для каждого ОбъявлениеПеременной Из Объявление.Объявления Цикл
				СтрТаблицаПеременных = ТаблицаПеременных.Добавить();
				ЗаполнитьЗначенияСвойств(СтрТаблицаПеременных, ОбъявлениеПеременной, "Имя,Экспорт");
			КонецЦикла;

			Директива = "";
			Если Объявление.Директивы.Количество() > 1 Тогда
				ВызватьИсключение "Не поддерживается несколько директив компиляции при объявлении переменной " + Объявление.Начало.НомерСтроки;
			ИначеЕсли Объявление.Директивы.Количество() = 1 Тогда
				Директива = Объявление.Директивы[0].Директива; 
			КонецЕсли;

			КомментарийВСтрокеОбъявления = "";
			КомментарийСразуПослеОбъявления = ИзвлечьКомментарийСразуПослеТокена(ТаблицаТокенов, ТекстМодуля, Объявление.Конец);
			Если КомментарийСразуПослеОбъявления <> Неопределено Тогда 
				КомментарийВСтрокеОбъявления = КомментарийСразуПослеОбъявления.Комментарий;
				ПоследнийТокенПредИтерации = КомментарийСразуПослеОбъявления.Токен;
			КонецЕсли;
			
			НоваяСтрокаДерева.Описание = ОформитьИменаПеременных(ТаблицаПеременных);

			НоваяСтрокаДерева.Содержимое.Контекст = Директива;
			НоваяСтрокаДерева.Содержимое.ИнструкцииПрепроцессора = ТекущиеИнструкцииПрепроцессора();
			НоваяСтрокаДерева.Содержимое.Комментарий = КомментарийКТекущемуОбъявлению;
			НоваяСтрокаДерева.Содержимое.КомментарийОднострочный = КомментарийВСтрокеОбъявления;
			
		ИначеЕсли Объявление.Тип = "ОбъявлениеМетода" Тогда
			
			НоваяСтрокаДерева = СтрокаДерева.Строки.Добавить();
			МетодСодержимое = Обработки.ОМ_ОформляторМодулей.МетодСтруктураОписания();
			
			ЭтоФункция = Ложь;
			Сигнатура = Объявление.Сигнатура;
			Если Сигнатура.Тип = "ОбъявлениеСигнатурыПроцедуры" Тогда
				НоваяСтрокаДерева.ТипЭлемента = "Процедура";
			ИначеЕсли Сигнатура.Тип = "ОбъявлениеСигнатурыФункции" Тогда
				НоваяСтрокаДерева.ТипЭлемента = "Функция";
				ЭтоФункция = Истина;
			Иначе
				ВызватьИсключение "Неизвестная сигнатура в определении метода " + Объявление.Начало.НомерСтроки;
			КонецЕсли;
			
			Директива = "";
			Если Сигнатура.Директивы.Количество() > 1 Тогда
				ВызватьИсключение "Не поддерживается несколько директив компиляции при объявлении метода " + Объявление.Начало.НомерСтроки;
			ИначеЕсли Сигнатура.Директивы.Количество() = 1 Тогда
				Директива = Сигнатура.Директивы[0].Директива; 
			КонецЕсли;

			Аннотация = "";
			ИмяМетода = "";
			Если Сигнатура.Аннотации.Количество() > 1 Тогда
				ВызватьИсключение "Не поддерживается несколько аннотаций при объявлении метода " + Объявление.Начало.НомерСтроки;
			ИначеЕсли Сигнатура.Аннотации.Количество() = 1 Тогда
				Аннотация = Сигнатура.Аннотации[0].Аннотация; 
				ИмяМетода = Сигнатура.Аннотации[0].ИмяМетода; 
			КонецЕсли;
			
			Для каждого СтрПараметр Из Сигнатура.Параметры Цикл
				СтрТаблицаПараметров = МетодСодержимое.Параметры.Добавить();
				СтрТаблицаПараметров.Имя = СтрПараметр.Имя;
				Если ТипЗнч(СтрПараметр.Значение) = Тип("СтрокаТаблицыЗначений") Тогда
					СтрТаблицаПараметров.ЗначениеПоУмолчанию = ИзвлечьТекстМеждуТокенамиВключительно(
						ТекстМодуля, 
						СтрПараметр.Значение.Начало, 
						СтрПараметр.Значение.Конец);
				КонецЕсли;
				СтрТаблицаПараметров.ПоЗначению = СтрПараметр.ПоЗначению;
			КонецЦикла;
			
			КомментарийОднострочный = "";
			КомментарийСразуПослеСигнатуры = ИзвлечьКомментарийСразуПослеТокена(ТаблицаТокенов, ТекстМодуля, Сигнатура.Конец);
			Если КомментарийСразуПослеСигнатуры <> Неопределено Тогда 
				КомментарийОднострочный = КомментарийСразуПослеСигнатуры.Комментарий;
				Позиция = КомментарийСразуПослеСигнатуры.Токен.Позиция + КомментарийСразуПослеСигнатуры.Токен.Длина;
			Иначе
				Позиция = Сигнатура.Конец.Позиция + Сигнатура.Конец.Длина;
			КонецЕсли;

			// Получаем тело метода
			Длина = Объявление.Конец.Позиция - Позиция;
			ТекстКодаМетода = Сред(ТекстМодуля, Позиция, Длина);

			КомментарийОднострочныйКонец = "";
			КомментарийСразуПослеКонцаМетода = ИзвлечьКомментарийСразуПослеТокена(ТаблицаТокенов, ТекстМодуля, Объявление.Конец);
			Если КомментарийСразуПослеКонцаМетода <> Неопределено Тогда 
				КомментарийОднострочныйКонец = КомментарийСразуПослеКонцаМетода.Комментарий;
				ПоследнийТокенПредИтерации = КомментарийСразуПослеКонцаМетода.Токен;
			КонецЕсли;
			
			НоваяСтрокаДерева.Описание = Сигнатура.Имя;
			
			МетодСодержимое.Имя = Сигнатура.Имя;
			МетодСодержимое.Контекст = Директива;
			МетодСодержимое.Экспортная = Сигнатура.Экспорт;
			МетодСодержимое.Асинх = Сигнатура.Асинх;
			МетодСодержимое.Тело = ТекстПрограммы(ТекстКодаМетода);
			МетодСодержимое.Аннотация = Аннотация;
			МетодСодержимое.ИмяРасширяемогоМетода = ИмяМетода;
			МетодСодержимое.ЭтоФункция = ЭтоФункция;
			МетодСодержимое.ИнструкцииПрепроцессора = ТекущиеИнструкцииПрепроцессора();
			МетодСодержимое.Комментарий = КомментарийКТекущемуОбъявлению;
			МетодСодержимое.КомментарийОднострочный = КомментарийОднострочный;
			МетодСодержимое.КомментарийОднострочныйКонец = КомментарийОднострочныйКонец;
			
			НоваяСтрокаДерева.Содержимое = МетодСодержимое;
			
			Если ЗначениеЗаполнено(МетодСодержимое.Комментарий) Тогда
				РазобратьКомментарийКПодпрограмме(МетодСодержимое);
			КонецЕсли;

		Иначе

			ТекстИсключения = "Не удалось разобрать модуль. Не опознанная конструкция в строке " +  + Объявление.Начало.НомерСтроки;
			ВызватьИсключение ТекстИсключения;
			
		КонецЕсли;

	КонецЦикла;
	
	Для каждого Объявление Из АСД.Операторы Цикл
		
		Если Объявление.Тип = "ИнструкцияПрепроцессораКонецОбласти" Тогда
			
			ДобавитьУзелКод(СтрокаДерева, ТекстМодуля, ПоследнийТокенПредИтерации, Объявление.Начало);
			ПоследнийТокенПредИтерации = Объявление.Конец;
			
			Если СтекОбластей.Количество() = 0 Тогда
				ВызватьИсключение "Неожиданный конец области в строке " + Объявление.Начало.НомерСтроки;
			КонецЕсли;
			
			КомментарийСразуПослеКонцаОбласти = ИзвлечьКомментарийСразуПослеТокена(ТаблицаТокенов, ТекстМодуля, Объявление.Конец);
			Если КомментарийСразуПослеКонцаОбласти <> Неопределено Тогда 
				СтрокаДерева.Содержимое.КомментарийПослеКонецОбласти = КомментарийСразуПослеКонцаОбласти.Комментарий;
				ПоследнийТокенПредИтерации = КомментарийСразуПослеКонцаОбласти.Токен;
			КонецЕсли;
			
			СтекОбластей.Удалить(0); // извлекаем из стека последнюю область
			СтрокаДерева = ?(СтекОбластей.Количество()=0, СтрокаДереваМодуль, СтекОбластей[0]);
		
		ИначеЕсли Объявление.Тип = "ИнструкцияПрепроцессораОбласть" Тогда

			ДобавитьУзелКод(СтрокаДерева, ТекстМодуля, ПоследнийТокенПредИтерации, Объявление.Начало);
			ПоследнийТокенПредИтерации = Объявление.Конец;
			
			КомментарийВСтрокеОбласть = "";
			КомментарийСразуПослеОбласть = ИзвлечьКомментарийСразуПослеТокена(ТаблицаТокенов, ТекстМодуля, Объявление.Конец);
			Если КомментарийСразуПослеОбласть <> Неопределено Тогда 
				КомментарийВСтрокеОбласть = КомментарийСразуПослеОбласть.Комментарий;
				ПоследнийТокенПредИтерации = КомментарийСразуПослеОбласть.Токен;
			КонецЕсли;
			
			НоваяСтрокаДерева = СтрокаДерева.Строки.Добавить();
			НоваяСтрокаДерева.ТипЭлемента = "Область";
			НоваяСтрокаДерева.Описание = Объявление.Имя;

			НоваяСтрокаДерева.Содержимое = Обработки.ОМ_ОформляторМодулей.ОбластьСтруктураОписания();
			НоваяСтрокаДерева.Содержимое.Имя = Объявление.Имя;
			НоваяСтрокаДерева.Содержимое.Комментарий = КомментарийКТекущемуОбъявлению;
			НоваяСтрокаДерева.Содержимое.КомментарийВСтрокеОбласть = КомментарийВСтрокеОбласть;

			СтекОбластей.Вставить(0, НоваяСтрокаДерева); // вставляем область в стек
			СтрокаДерева = НоваяСтрокаДерева;
			
		ИначеЕсли Объявление.Тип = "ИнструкцияПрепроцессораЕсли" Тогда

			ДобавитьУзелКод(СтрокаДерева, ТекстМодуля, ПоследнийТокенПредИтерации, Объявление.Начало);
			ПоследнийТокенПредИтерации = Объявление.Конец;
			
			ТекущиеУсловияПрепроцессора = Новый Массив;
			ТекстВыражения = ТекстУзла(Объявление.Выражение, ТекстМодуля);
			ТекущиеУсловияПрепроцессора.Добавить(ПодготовитьВыражениеИнструкцийПрепроцессора(ТекстВыражения));
			
			СтекИнструкцийПрепроцессора.Вставить(0, ТекущиеУсловияПрепроцессора);

		ИначеЕсли Объявление.Тип = "ИнструкцияПрепроцессораИначеЕсли" Тогда

			ДобавитьУзелКод(СтрокаДерева, ТекстМодуля, ПоследнийТокенПредИтерации, Объявление.Начало);
			ПоследнийТокенПредИтерации = Объявление.Конец;
			
			ТекстВыражения = ТекстУзла(Объявление.Выражение, ТекстМодуля);
			СтекИнструкцийПрепроцессора[0].Вставить(0, ПодготовитьВыражениеИнструкцийПрепроцессора(ТекстВыражения));
			
		ИначеЕсли Объявление.Тип = "ИнструкцияПрепроцессораИначе" Тогда

			ДобавитьУзелКод(СтрокаДерева, ТекстМодуля, ПоследнийТокенПредИтерации, Объявление.Начало);
			ПоследнийТокенПредИтерации = Объявление.Конец;
			
			СтекИнструкцийПрепроцессора[0].Вставить(0, "");

		ИначеЕсли Объявление.Тип = "ИнструкцияПрепроцессораКонецЕсли" Тогда
			
			ДобавитьУзелКод(СтрокаДерева, ТекстМодуля, ПоследнийТокенПредИтерации, Объявление.Начало);
			ПоследнийТокенПредИтерации = Объявление.Конец;
			
			СтекИнструкцийПрепроцессора.Удалить(0);
			
		КонецЕсли;

	КонецЦикла;

	ДобавитьУзелКод(СтрокаДерева, ТекстМодуля, ПоследнийТокенПредИтерации, ТаблицаТокенов[ТаблицаТокенов.Количество()-1]);
	
КонецФункции

Функция ИзвлечьКомментарииМеждуТокенами(ТаблицаТокенов, ТекстМодуля, ТокенНач, ТокенКон)
	МассивКомментариев = Новый Массив;
	ЕстьПустаяСтрокаПередКомментариями = Ложь;
	ЕстьПустаяСтрокаПослеКомментариев = Ложь;
	
	ТекИндексТокена = ТокенНач.Индекс + 1;
	ИндексКонец = ТокенКон.Индекс;
	ТекКомментарий = "";
	Пока ТекИндексТокена < ИндексКонец Цикл
		ТекТокен = ТаблицаТокенов[ТекИндексТокена];
		Если ТекТокен.Токен = "ПустаяСтрока" Тогда
			Если ЗначениеЗаполнено(ТекКомментарий) Тогда
				МассивКомментариев.Добавить(ТекКомментарий);
				ТекКомментарий = "";
			ИначеЕсли МассивКомментариев.Количество() = 0 Тогда
				ЕстьПустаяСтрокаПередКомментариями = Истина;
			КонецЕсли;
			ЕстьПустаяСтрокаПослеКомментариев = Истина;
		ИначеЕсли ТекТокен.Токен = "Комментарий" Тогда
			ТекКомментарий = ТекКомментарий
				+ ?(ЗначениеЗаполнено(ТекКомментарий), Символы.ПС, "")
				+ СокрП(Сред(ТекстМодуля, ТекТокен.Позиция, ТекТокен.Длина));
			ЕстьПустаяСтрокаПослеКомментариев = Ложь;
		КонецЕсли;
		
		ТекИндексТокена = ТекИндексТокена + 1;
	КонецЦикла;

	Если ЗначениеЗаполнено(ТекКомментарий) Тогда
		МассивКомментариев.Добавить(ТекКомментарий);
	КонецЕсли;
	
	Если МассивКомментариев.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Новый Структура(
		"МассивКомментариев,ЕстьПустаяСтрокаПередКомментариями,ЕстьПустаяСтрокаПослеКомментариев", 
		МассивКомментариев,
		ЕстьПустаяСтрокаПередКомментариями,
		ЕстьПустаяСтрокаПослеКомментариев);
КонецФункции

Функция ИзвлечьКомментарийСразуПослеТокена(ТаблицаТокенов, ТекстМодуля, ТокенНач)
	ПозицияКонцаТокенаНач = ТокенНач.Позиция + ТокенНач.Длина;
	ТекИндексТокена = ТокенНач.Индекс + 1;
	КолвоТокенов = ТаблицаТокенов.Количество();
	Пока ТекИндексТокена < КолвоТокенов Цикл
		ТекТокен = ТаблицаТокенов[ТекИндексТокена];
		Если ТекТокен.Токен = "Комментарий" Тогда
			ЕстьПС = СтрНайти(Сред(ТекстМодуля, ПозицияКонцаТокенаНач, ТекТокен.Позиция-ПозицияКонцаТокенаНач), Символы.ПС) > 0;
			Если ЕстьПС Тогда
				Прервать;
			Иначе
				Возврат Новый Структура(
					"Комментарий, Токен", 
					Сред(ТекстМодуля, ТекТокен.Позиция, ТекТокен.Длина),
					ТекТокен);
			КонецЕсли;
		ИначеЕсли ТекТокен.Токен = "ТочкаСЗапятой" Тогда
			ТекИндексТокена = ТекИндексТокена + 1;
		Иначе
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Возврат Неопределено;	
КонецФункции

Функция ИзвлечьТекстМеждуТокенами(ТекстМодуля, ТокенНач, ТокенКон)
	ПозицияТекста = ТокенНач.Позиция + ТокенНач.Длина;
	ДлинаТекста = ТокенКон.Позиция - ПозицияТекста;
	Возврат Сред(ТекстМодуля, ПозицияТекста, ДлинаТекста);
КонецФункции

Функция ИзвлечьТекстМеждуТокенамиВключительно(ТекстМодуля, ТокенНач, ТокенКон)
	ПозицияТекста = ТокенНач.Позиция;
	ДлинаТекста = ТокенКон.Позиция + ТокенКон.Длина - ПозицияТекста;
	Возврат Сред(ТекстМодуля, ПозицияТекста, ДлинаТекста);
КонецФункции

Процедура ДобавитьУзелКод(СтрокаДерева, ТекстМодуля, ТокенНач, ТокенКон)
	ТекстКод = СокрЛП(ИзвлечьТекстМеждуТокенами(ТекстМодуля, ТокенНач, ТокенКон));
	
	Если ЗначениеЗаполнено(ТекстКод) Тогда
		НоваяСтрокаДерева = СтрокаДерева.Строки.Добавить();
		НоваяСтрокаДерева.ТипЭлемента = "Код";
		НоваяСтрокаДерева.Описание = СтрПолучитьСтроку(ТекстКод, 1) + ?(СтрЧислоСтрок(ТекстКод) > 1, " <...>", "");

		НоваяСтрокаДерева.Содержимое = Обработки.ОМ_ОформляторМодулей.КодСтруктураОписания();
		НоваяСтрокаДерева.Содержимое.Тело = ТекстКод;
		НоваяСтрокаДерева.Содержимое.ИнструкцииПрепроцессора = ТекущиеИнструкцииПрепроцессора();
	КонецЕсли;
КонецПроцедуры

Функция ТекстУзла(Узел, ТекстМодуля)
	Позиция = Узел.Начало.Позиция;
	Длина = Узел.Конец.Позиция + Узел.Конец.Длина - Узел.Начало.Позиция;
	
	Возврат Сред(ТекстМодуля, Позиция, Длина);
КонецФункции

Функция ТекстПрограммы(стр)
	ТД_ТекстПодпрограммы = Новый ТекстовыйДокумент;
	ТД_ТекстПодпрограммыРезультат = Новый ТекстовыйДокумент;
	
	ТД_ТекстПодпрограммы.УстановитьТекст(СокрЛП(стр));
	Для Инд1 = 1 По ТД_ТекстПодпрограммы.КоличествоСтрок() Цикл
		Стр = ТД_ТекстПодпрограммы.ПолучитьСтроку(Инд1);
		Если Лев(Стр, 1) = Символы.Таб Тогда
			Стр = Сред(Стр, 2);
		КонецЕсли;
		ТД_ТекстПодпрограммыРезультат.ДобавитьСтроку(Стр);
	КонецЦикла;
	
	Возврат СокрП(ТД_ТекстПодпрограммыРезультат.ПолучитьТекст());
КонецФункции

Функция ОформитьИменаПеременных(ТаблицаПеременных)

	Результат = "";
	Для каждого СтрТаблицаПеременных Из ТаблицаПеременных Цикл
		Результат = Результат 
			+ ?(ЗначениеЗаполнено(Результат), ", ", "") 
			+ СтрТаблицаПеременных.Имя 
			+ ?(СтрТаблицаПеременных.Экспорт = Истина, " Экспорт", "");
	КонецЦикла;

	Возврат Результат;	
	
КонецФункции

#Область РазборИнструкцийПрепроцессора

Функция СтруктураИнструкцийПрепроцессора(ВыражениеИнструкцийПрепроцессора)
	СтруктураВариантовРаботыПредприятия = Новый Структура(
		"Клиент,Сервер,ТонкийКлиент,ВебКлиент,
		|МобильныйАвтономныйСервер,МобильноеПриложениеКлиент,МобильноеПриложениеСервер,МобильныйКлиент,
		|ТолстыйКлиентОбычноеПриложение,ТолстыйКлиентУправляемоеПриложение,
		|ВнешнееСоединение");
	Для каждого КлючЗначение Из СтруктураВариантовРаботыПредприятия Цикл
		
		ТекстКодаВыполненияИнструкцииПрепроцессора = "";
		
		// Устанавливаем значения переменных, соответтсвующих варианту режима запуска
		Для каждого КлючЗначение2 Из СтруктураВариантовРаботыПредприятия Цикл
			ТекстКодаВыполненияИнструкцииПрепроцессора = ТекстКодаВыполненияИнструкцииПрепроцессора + КлючЗначение2.Ключ + " = " + Формат((КлючЗначение.Ключ = КлючЗначение2.Ключ), "БЛ=Ложь; БИ=Истина") + ";" + Символы.ПС;
		КонецЦикла;

		ТекстКодаВыполненияИнструкцииПрепроцессора = ТекстКодаВыполненияИнструкцииПрепроцессора + "СтруктураВариантовРаботыПредприятия.Вставить(КлючЗначение.Ключ, " + ВыражениеИнструкцийПрепроцессора + ");";
		Выполнить(ТекстКодаВыполненияИнструкцииПрепроцессора);
		
	КонецЦикла;
	
	Возврат СтруктураВариантовРаботыПредприятия;
КонецФункции

Функция ПодготовитьВыражениеИнструкцийПрепроцессора(Знач ВыражениеИнструкцийПрепроцессора)
	ВыражениеИнструкцийПрепроцессора = НРег(ВыражениеИнструкцийПрепроцессора);
	ВыражениеИнструкцийПрепроцессора = СтрЗаменить(ВыражениеИнструкцийПрепроцессора, "наклиенте", "клиент");
	ВыражениеИнструкцийПрепроцессора = СтрЗаменить(ВыражениеИнструкцийПрепроцессора, "насервере", "сервер");
	Возврат ВыражениеИнструкцийПрепроцессора;
КонецФункции

Функция ТекущиеИнструкцииПрепроцессора()

	Если ЗначениеЗаполнено(СтекИнструкцийПрепроцессора) Тогда
		УсловиеПрепроцессора = "";
		Для каждого Инструкция Из СтекИнструкцийПрепроцессора Цикл
			УсловиеПрепроцессора = УсловиеПрепроцессора + ?(ЗначениеЗаполнено(УсловиеПрепроцессора), " И ", "") + "(" + СтрокаУсловий(Инструкция) + ")";
		КонецЦикла;
		
		Возврат СтруктураИнструкцийПрепроцессора(УсловиеПрепроцессора);
	Иначе
		Возврат Обработки.ОМ_ОформляторМодулей.СтруктураИнструкцийПрепроцессораПоУмолчанию();
	КонецЕсли;
	
КонецФункции

Функция СтрокаУсловий(МассивУсловий)
	
	УсловиеСтр = МассивУсловий[0];

	Для ИндексУсловия = 1 По МассивУсловий.ВГраница() Цикл
		УсловиеСтр = УсловиеСтр + ?(ЗначениеЗаполнено(УсловиеСтр), " И ", "") + "НЕ (" + МассивУсловий[ИндексУсловия] + ")";
	КонецЦикла;
	
	Возврат УсловиеСтр;
		
КонецФункции

#КонецОбласти

#Область СлужебныеФункции

Функция МногострочноеСокрЛП(Текст)
	ТД_Текст = Новый ТекстовыйДокумент;
	ТД_ТекстРезультат = Новый ТекстовыйДокумент;
	
	ТД_Текст.УстановитьТекст(СокрЛП(Текст));
	Для Инд1 = 1 По ТД_Текст.КоличествоСтрок() Цикл
		Стр = СокрЛП(ТД_Текст.ПолучитьСтроку(Инд1));
		ТД_ТекстРезультат.ДобавитьСтроку(Стр);
	КонецЦикла;
	
	Возврат ТД_ТекстРезультат.ПолучитьТекст();
КонецФункции

Функция НайтиСтрокуВТекстовомДокументе(ТД, СтрокаПоиска)
	
	КоличествоСтрок = ТД.КоличествоСтрок();
	СтрокаПоискаВРег = НРег(СтрокаПоиска);
	
	Для НомерСтроки = 1 По КоличествоСтрок Цикл
		ТекущаяСтрока = СокрЛП(ТД.ПолучитьСтроку(НомерСтроки));
		Если НРег(ТекущаяСтрока) = СтрокаПоискаВРег Тогда
			Возврат НомерСтроки;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПолучитьОбластьТекстовогоДокумента(ТД, НомерНачСтроки, НомерКонСтроки = Неопределено)
	
	Если НомерКонСтроки = Неопределено Тогда
		НомерКонСтроки = ТД.КоличествоСтрок();
	КонецЕсли;
	
	РезультатТекст = "";
	Для НомерСтроки = НомерНачСтроки По НомерКонСтроки Цикл
		ТекущаяСтрока = ТД.ПолучитьСтроку(НомерСтроки);
		РезультатТекст = РезультатТекст + ?(РезультатТекст = "", "", Символы.ПС) + ТекущаяСтрока;
	КонецЦикла;
	
	Возврат РезультатТекст;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ПостобработкаРазобранногоМодуля

Функция РазобратьКомментарийПараметровКПодпрограмме(СодержимоеЭлемента, ТекстКомментария)
	
	ТаблицаПараметров = Обработки.ОМ_ОформляторМодулей.НоваяТаблицаПараметров();
	
	ТД = Новый ТекстовыйДокумент;
	ТД.УстановитьТекст(ТекстКомментария);
	
	ИндексПоследнегоЭлемента = СодержимоеЭлемента.Параметры.Количество() - 1;
	
	Для Счетчик = 0 По ИндексПоследнегоЭлемента Цикл
		
		ТекущийПараметр = СодержимоеЭлемента.Параметры[Счетчик];
		
		ИмяСледующегоПараметра = "";
		Если Счетчик < ИндексПоследнегоЭлемента Тогда
			ИмяСледующегоПараметра = СодержимоеЭлемента.Параметры[Счетчик + 1].Имя;
		КонецЕсли;
		
		РезультатПоиска = НайтиОписаниеПараметра(ТД, ТекущийПараметр.Имя, ИмяСледующегоПараметра);
		
		Если Не РезультатПоиска.Найдено Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		РезультатРазбора = РазобратьОписаниеПараметра(РезультатПоиска.ТекстОписания);
		
		Если Не РезультатРазбора.Успех Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		НоваяСтрока = ТаблицаПараметров.Добавить();
		НоваяСтрока.Имя = ТекущийПараметр.Имя;
		НоваяСтрока.Тип = РезультатРазбора.Тип;
		НоваяСтрока.Описание = РезультатРазбора.Описание;

		ТД.УстановитьТекст(РезультатПоиска.ОстатокТекста);
		
	КонецЦикла;
	
	Возврат ТаблицаПараметров;
	
КонецФункции
 
Процедура РазобратьКомментарийКПодпрограмме(СодержимоеЭлемента)
	
	ТекстКомментария = МногострочноеСокрЛП(СодержимоеЭлемента.Комментарий);
	
	ТД = Новый ТекстовыйДокумент;
	ТД.УстановитьТекст(ТекстКомментария);
	
	// Ищем строки с ключевыми словами
	НомерСтрокиПараметров = НайтиСтрокуВТекстовомДокументе(ТД, "параметры:");
	Если НомерСтрокиПараметров = Неопределено Тогда
		НомерСтрокиПараметров = НайтиСтрокуВТекстовомДокументе(ТД, "параметры");
		Если НомерСтрокиПараметров = Неопределено Тогда
			НомерСтрокиПараметров = НайтиСтрокуВТекстовомДокументе(ТД, "parameters:");
			Если НомерСтрокиПараметров = Неопределено Тогда
				НомерСтрокиПараметров = НайтиСтрокуВТекстовомДокументе(ТД, "parameters");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	НомерСтрокиВозврата = НайтиСтрокуВТекстовомДокументе(ТД, "возвращаемое значение:");
	Если НомерСтрокиВозврата = Неопределено Тогда
		НомерСтрокиВозврата = НайтиСтрокуВТекстовомДокументе(ТД, "возвращаемое значение");
		Если НомерСтрокиВозврата = Неопределено Тогда
			НомерСтрокиВозврата = НайтиСтрокуВТекстовомДокументе(ТД, "return value:");
			Если НомерСтрокиВозврата = Неопределено Тогда
				НомерСтрокиВозврата = НайтиСтрокуВТекстовомДокументе(ТД, "return value");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если НомерСтрокиПараметров <> Неопределено И НомерСтрокиВозврата <> Неопределено Тогда
		// Есть и параметры и возвращаемое значение
		ОписаниеМетода = ПолучитьОбластьТекстовогоДокумента(ТД, 1, НомерСтрокиПараметров - 1);
		ТекстПараметров = ПолучитьОбластьТекстовогоДокумента(ТД, НомерСтрокиПараметров + 1, НомерСтрокиВозврата - 1);
		ТекстВозврата = ПолучитьОбластьТекстовогоДокумента(ТД, НомерСтрокиВозврата + 1);
		
		ОписаниеПараметров = РазобратьКомментарийПараметровКПодпрограмме(СодержимоеЭлемента, ТекстПараметров);
		Если ОписаниеПараметров <> Неопределено Тогда
			ОбновитьТипОписаниеПараметровВСодержимомПодпрограммы(СодержимоеЭлемента, ОписаниеПараметров);
			СодержимоеЭлемента.Вставить("КомментарийВозвращаемоеЗначение", СокрЛП(ТекстВозврата));
			СодержимоеЭлемента.Комментарий = СокрЛП(ОписаниеМетода);
		КонецЕсли;
		
	ИначеЕсли НомерСтрокиПараметров <> Неопределено Тогда
		// Есть только параметры
		ОписаниеМетода = ПолучитьОбластьТекстовогоДокумента(ТД, 1, НомерСтрокиПараметров - 1);
		ТекстПараметров = ПолучитьОбластьТекстовогоДокумента(ТД, НомерСтрокиПараметров + 1);
		
		ОписаниеПараметров = РазобратьКомментарийПараметровКПодпрограмме(СодержимоеЭлемента, ТекстПараметров);
		Если ОписаниеПараметров <> Неопределено Тогда
			ОбновитьТипОписаниеПараметровВСодержимомПодпрограммы(СодержимоеЭлемента, ОписаниеПараметров);
			СодержимоеЭлемента.Комментарий = СокрЛП(ОписаниеМетода);
		КонецЕсли;
		
	ИначеЕсли НомерСтрокиВозврата <> Неопределено Тогда
		// Есть только возвращаемое значение
		ОписаниеМетода = ПолучитьОбластьТекстовогоДокумента(ТД, 1, НомерСтрокиВозврата - 1);
		ТекстВозврата = ПолучитьОбластьТекстовогоДокумента(ТД, НомерСтрокиВозврата + 1);
		
		СодержимоеЭлемента.Вставить("КомментарийВозвращаемоеЗначение", СокрЛП(ТекстВозврата));
		СодержимоеЭлемента.Комментарий = СокрЛП(ОписаниеМетода);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьТипОписаниеПараметровВСодержимомПодпрограммы(СодержимоеПодпрограммы, ТаблицаПараметров)
	
	Для каждого ОписаниеПараметра Из ТаблицаПараметров Цикл
		
		ИскомыйПараметр = СодержимоеПодпрограммы.Параметры.НайтиСтроки(Новый Структура("Имя", ОписаниеПараметра.Имя));
		Если ИскомыйПараметр.Количество() Тогда
			ИскомыйПараметр[0].Тип = ОписаниеПараметра.Тип;
			ИскомыйПараметр[0].Описание = ОписаниеПараметра.Описание;
		КонецЕсли; 
		
	КонецЦикла;
	
КонецПроцедуры

Функция НайтиОписаниеПараметра(ТД, ИмяПараметра, ИмяСледующегоПараметра = "")
	
	Результат = Новый Структура;
	Результат.Вставить("Найдено", Ложь);
	Результат.Вставить("ТекстОписания", "");
	Результат.Вставить("ОстатокТекста", "");

	ИмяПараметраНРег = НРег(ИмяПараметра);
	
	// Ищем строку с текущим параметром
	НомерНачальнойСтроки = Неопределено;
	КоличествоСтрок = ТД.КоличествоСтрок();
	
	Для НомерСтроки = 1 По КоличествоСтрок Цикл
		ТекущаяСтрока = СокрЛП(ТД.ПолучитьСтроку(НомерСтроки));
		
		// Проверяем, что пропускаемые строки пустые
		Если ЗначениеЗаполнено(ТекущаяСтрока) Тогда
			ТекущаяСтрокаНРег = НРег(ТекущаяСтрока);
			
			Если СтрНачинаетсяС(ТекущаяСтрокаНРег, ИмяПараметраНРег) Тогда
				// Проверяем, что после имени параметра идет тире
				ОстатокСтроки = Сред(ТекущаяСтрока, СтрДлина(ИмяПараметра) + 1);
				ОстатокСтроки = СокрЛ(ОстатокСтроки);
				
				Если СтрНачинаетсяС(ОстатокСтроки, "-") Тогда
					НомерНачальнойСтроки = НомерСтроки;
					Прервать;
				КонецЕсли;
			КонецЕсли;
			
			// Если строка не пустая и не наш параметр - ошибка
			Возврат Результат;
		КонецЕсли;
	КонецЦикла;
	
	Если НомерНачальнойСтроки = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	// Ищем строку со следующим параметром
	НомерКонечнойСтроки = КоличествоСтрок;
	
	Если ЗначениеЗаполнено(ИмяСледующегоПараметра) Тогда
		ИмяСледующегоПараметраНРег = НРег(ИмяСледующегоПараметра);
		Для НомерСтроки = НомерНачальнойСтроки + 1 По КоличествоСтрок Цикл
			ТекущаяСтрока = СокрЛП(ТД.ПолучитьСтроку(НомерСтроки));
			ТекущаяСтрокаНРег = НРег(ТекущаяСтрока);
			Если СтрНачинаетсяС(ТекущаяСтрокаНРег, ИмяСледующегоПараметраНРег) Тогда
				НомерКонечнойСтроки = НомерСтроки - 1;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Получаем текст описания
	Результат.Найдено = Истина;
	Результат.ТекстОписания = ПолучитьОбластьТекстовогоДокумента(ТД, НомерНачальнойСтроки, НомерКонечнойСтроки);
	Если НомерКонечнойСтроки = КоличествоСтрок Тогда
		Результат.ОстатокТекста = "";
	Иначе
		Результат.ОстатокТекста = ПолучитьОбластьТекстовогоДокумента(ТД, НомерКонечнойСтроки + 1, КоличествоСтрок);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция РазобратьОписаниеПараметра(ТекстОписания)
	
	Результат = Новый Структура;
	Результат.Вставить("Успех", Ложь);
	Результат.Вставить("Тип", "");
	Результат.Вставить("Описание", "");
	
	// Ищем первый разделитель после имени параметра
	ПозицияТире = СтрНайти(ТекстОписания, "-");
	Если ПозицияТире = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	ТекстПослеИмени = СокрЛП(Сред(ТекстОписания, ПозицияТире + 1));
	
	// Ищем разделитель типа и описания
	ПозицияРазделителя = СтрНайти(ТекстПослеИмени, ":");
	Если ПозицияРазделителя = 0 Тогда
		ПозицияРазделителя = СтрНайти(ТекстПослеИмени, "-");
	КонецЕсли;
	
	Если ПозицияРазделителя > 0 Тогда
		// Есть тип и описание
		Результат.Тип = СокрЛП(Лев(ТекстПослеИмени, ПозицияРазделителя - 1));
		Результат.Описание = СокрЛП(Сред(ТекстПослеИмени, ПозицияРазделителя + 1));
		Результат.Успех = Истина;
	ИначеЕсли ЗначениеЗаполнено(ТекстПослеИмени) Тогда
		// Только описание
		Результат.Описание = ТекстПослеИмени;
		Результат.Успех = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Служебное

Процедура ДополнитьМассив(Приемник, Источник)

	Для каждого Элемент Из Источник Цикл
		Приемник.Добавить(Элемент);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 
