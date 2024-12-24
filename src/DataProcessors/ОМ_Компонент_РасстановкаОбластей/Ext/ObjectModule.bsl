﻿
#Область ОписаниеПеременных

Перем АнглСинтаксис;

#КонецОбласти

#Область ПрограммныйИнтерфейс

Функция ДеревоСтруктурыМодулейСоСтандартнымиОбластями(ДеревоСтруктуры) Экспорт

	НовоеДеревоСтруктуры = Обработки.ОМ_ОформляторМодулей.НовоеДеревоСтруктурыМодуля();
	
	Для каждого СтрМодуль Из ДеревоСтруктуры.Строки Цикл
		ДобавитьМодульСоСтандартнымиОбластями(СтрМодуль, НовоеДеревоСтруктуры);
	КонецЦикла;
	
	Возврат НовоеДеревоСтруктуры;
	
КонецФункции

Функция ДобавитьМодульСоСтандартнымиОбластями(СтрМодуль, НовоеДеревоСтруктуры) Экспорт

	АнглСинтаксис = (СтрМодуль.Содержимое.Синтаксис = "Английский");

	СтрНовыйМодуль = НовоеДеревоСтруктуры.Строки.Добавить();
	ЗаполнитьЗначенияСвойств(СтрНовыйМодуль, СтрМодуль);
	
	ЭтоМодульФормыКоманды = ЭтоМодульФормыКоманды(СтрМодуль);
	
	ТаблицаЭлементовСоСтандартнымиОбластямиИПорядком = НоваяТаблицаЭлементовСоСтандартнымиОбластямиИПорядком();
	ЗаполнитьТаблицуЭлементовСоСтандартнымиОбластямиИПорядкомРек(ТаблицаЭлементовСоСтандартнымиОбластямиИПорядком, СтрМодуль, ЭтоМодульФормыКоманды);
	
	ТаблицаЭлементовСоСтандартнымиОбластямиИПорядком.Сортировать("ПорядокОбласти,ДопПорядок,ПорядокПодпрограммы");
	
	ТаблицаОбластей = ТаблицаЭлементовСоСтандартнымиОбластямиИПорядком.Скопировать(, "ИмяОбласти");
	ТаблицаОбластей.Свернуть("ИмяОбласти");
	
	Для каждого СтрТаблицыОбластей Из ТаблицаОбластей Цикл
		
		ИмяОбласти = СтрТаблицыОбластей.ИмяОбласти;
		СтрОбласть = НайтиИлиДобавитьОбласть(СтрНовыйМодуль, ИмяОбласти);
		
		ЭлементыОбласти = ТаблицаЭлементовСоСтандартнымиОбластямиИПорядком.НайтиСтроки(Новый Структура("ИмяОбласти", ИмяОбласти));
		
		Для каждого СтрокаТаблицыЭлементовОбласти Из ЭлементыОбласти Цикл
			НовыйЭлемент = СтрОбласть.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(НовыйЭлемент, СтрокаТаблицыЭлементовОбласти.ЭлементСтруктуры);
			
			//СтрокаТаблицыЭлементовОбласти.ЭлементСтруктуры.Родитель.Строки.Удалить(СтрокаТаблицыЭлементовОбласти.ЭлементСтруктуры);
		КонецЦикла;
		
	КонецЦикла;

КонецФункции
	
#КонецОбласти 

#Область РасстановкаОбластей

Функция НоваяТаблицаЭлементовСоСтандартнымиОбластямиИПорядком()
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("ЭлементСтруктуры");
	Таблица.Колонки.Добавить("ИмяОбласти");
	Таблица.Колонки.Добавить("ПорядокОбласти");
	Таблица.Колонки.Добавить("ПорядокПодпрограммы");
	Таблица.Колонки.Добавить("ДопПорядок");
	
	Возврат Таблица;
КонецФункции

Функция НайтиИлиДобавитьОбласть(СтрМодуль, ИмяОбласти)
	
	ИмяОбластиВРег = ВРег(ИмяОбласти);
	Для каждого Стр Из СтрМодуль.Строки Цикл
		
		Если Стр.ТипЭлемента = "Область"
			И ВРег(Стр.Содержимое.Имя) = ИмяОбластиВРег Тогда
			
			Возврат Стр;
			
		КонецЕсли;
		
	КонецЦикла;
	
	НоваяСтрокаДерева = СтрМодуль.Строки.Добавить();
	НоваяСтрокаДерева.ТипЭлемента = "Область";
	НоваяСтрокаДерева.Описание = ИмяОбласти;
	НоваяСтрокаДерева.Содержимое = Обработки.ОМ_ОформляторМодулей.ОбластьСтруктураОписания();
	НоваяСтрокаДерева.Содержимое.Имя = ИмяОбласти;
	
	Возврат НоваяСтрокаДерева;
	
КонецФункции

Процедура ЗаполнитьТаблицуЭлементовСоСтандартнымиОбластямиИПорядкомРек(ТаблицаЭлементовСоСтандартнымиОбластямиИПорядком, СтрЭлемент, ЭтоМодульФормыКоманды)
	
	КудаОпределяемЭлемент = ПолучитьКудаОпределяемЭлемент(СтрЭлемент, ЭтоМодульФормыКоманды);
	Если КудаОпределяемЭлемент = Неопределено Тогда
		Для каждого СтрВложЭлемент Из СтрЭлемент.Строки Цикл
			ЗаполнитьТаблицуЭлементовСоСтандартнымиОбластямиИПорядкомРек(ТаблицаЭлементовСоСтандартнымиОбластямиИПорядком, СтрВложЭлемент, ЭтоМодульФормыКоманды);
		КонецЦикла;
	Иначе
		СтрокаТаблицыЭлементовСоСтандартнымиОбластямиИПорядком = ТаблицаЭлементовСоСтандартнымиОбластямиИПорядком.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицыЭлементовСоСтандартнымиОбластямиИПорядком, КудаОпределяемЭлемент);
	КонецЕсли;
	
КонецПроцедуры

Функция ЭтоМодульФормыКоманды(СтрЭлемент)

	Для каждого СтрЭлемент2 Из СтрЭлемент.Строки Цикл
		
		Если (СтрЭлемент2.ТипЭлемента = "Процедура"
				ИЛИ СтрЭлемент2.ТипЭлемента = "Функция")
			И ЗначениеЗаполнено(СтрЭлемент2.Содержимое.Контекст) Тогда
			Возврат Истина;
		ИначеЕсли СтрЭлемент2.ТипЭлемента = "Область" Тогда
			Если ЭтоМодульФормыКоманды(СтрЭлемент2) Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция ПолучитьКудаОпределяемЭлемент(СтрЭлемент, ЭтоМодульФормыКоманды)
	
	КудаОпределяем = Неопределено;
	Если СтрЭлемент.ТипЭлемента = "Переменная" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОписаниеПеременных", 1);
		
	ИначеЕсли СтрЭлемент.ТипЭлемента = "Процедура" 
		ИЛИ СтрЭлемент.ТипЭлемента = "Функция" Тогда
		
		КудаОпределяем = КудаОпределяемМетод(СтрЭлемент, ЭтоМодульФормыКоманды);
		
	ИначеЕсли СтрЭлемент.ТипЭлемента = "Код" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "Инициализация", 350);
		
	КонецЕсли;
	
	Возврат КудаОпределяем;
	
КонецФункции

Функция КудаОпределяемЭлемент(ЭлементСтруктуры, ИмяОбласти, ПорядокОбласти, ПорядокПодпрограммы = 10000, ДопПорядок = "")
	
	Возврат Новый Структура(
		"ЭлементСтруктуры, ИмяОбласти, ПорядокОбласти, ПорядокПодпрограммы, ДопПорядок", 
		ЭлементСтруктуры, ИмяОбласти, ПорядокОбласти, ПорядокПодпрограммы, ДопПорядок);
	
КонецФункции

Функция КудаОпределяемМетод(СтрЭлемент, ЭтоМодульФормыКоманды)
	
	КудаОпределяем = Неопределено;
	
	ИмяПодпрограммы = СтрЭлемент.Содержимое.Имя;
	ИмяПодпрограммыВРег = ВРег(ИмяПодпрограммы);
	Если ИмяПодпрограммыВРег = "ПРИСОЗДАНИИНАСЕРВЕРЕ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 1);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ПРИОТКРЫТИИ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 2);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ПРИПОВТОРНОМОТКРЫТИИ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 3);
	
	ИначеЕсли ИмяПодпрограммыВРег = "ПЕРЕДЗАКРЫТИЕМ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 4);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ПРИЗАКРЫТИИ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 5);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКАВЫБОРА" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 6);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКАОПОВЕЩЕНИЯ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 7);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКААКТИВИЗАЦИИ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 8);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКАЗАПИСИНОВОГО" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 9);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ПРИЧТЕНИИНАСЕРВЕРЕ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 10);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ПЕРЕДЗАПИСЬЮ" Тогда
		
		Если ЭтоМодульФормыКоманды Тогда
			КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 11);
		Иначе
			КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 4);
		КонецЕсли;
	
		
	ИначеЕсли ИмяПодпрограммыВРег = "ПЕРЕДЗАПИСЬЮНАСЕРВЕРЕ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 12);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ПРИЗАПИСИНАСЕРВЕРЕ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 13);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ПОСЛЕЗАПИСИНАСЕРВЕРЕ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 14);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ПОСЛЕЗАПИСИ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 15);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКАПРОВЕРКИЗАПОЛНЕНИЯНАСЕРВЕРЕ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 16);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ВНЕШНЕЕСОБЫТИЕ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 17);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ПРИСОХРАНЕНИИДАННЫХВНАСТРОЙКАХНАСЕРВЕРЕ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 18);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ПЕРЕДЗАГРУЗКОЙДАННЫХИЗНАСТРОЕКНАСЕРВЕРЕ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 19);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ПРИЗАГРУЗКЕДАННЫХИЗНАСТРОЕКНАСЕРВЕРЕ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 20);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКАНАВИГАЦИОННОЙССЫЛКИ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 21);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКАПЕРЕХОДА" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 22);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ПРИИЗМЕНЕНИИПАРАМЕТРОВЭКРАНА" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 23);
		
	ИначеЕсли ИмяПодпрограммыВРег = "АВТОПОДБОРПОЛЬЗОВАТЕЛЕЙСИСТЕМЫВЗАИМОДЕЙСТВИЯ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 24);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКАПОЛУЧЕНИЯФОРМЫВЫБОРАПОЛЬЗОВАТЕЛЕЙСИСТЕМЫВЗАИМОДЕЙСТВИЯ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 25);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ПРИИЗМЕНЕНИИДОСТУПНОСТИОСНОВНОГОСЕРВЕРА" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 26);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ПЕРЕДПЕРЕОТКРЫТИЕМСДРУГОГОСЕРВЕРА" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 27);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ПРИПЕРЕОТКРЫТИИСДРУГОГОСЕРВЕРА" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийФормы", 50, 28);
	
	// Обработчики событий элементов шапки Формы
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 12)  = "ПРИИЗМЕНЕНИИ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовШапкиФормы", 100, 1, Лев(ИмяПодпрограммыВРег, СтрДлина(ИмяПодпрограммы) - 12));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 12)  = "НАЧАЛОВЫБОРА" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовШапкиФормы", 100, 2, Лев(ИмяПодпрограммыВРег, СтрДлина(ИмяПодпрограммы) - 12));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 20)  = "НАЧАЛОВЫБОРАИЗСПИСКА" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовШапкиФормы", 100, 3, Лев(ИмяПодпрограммыВРег, СтрДлина(ИмяПодпрограммы) - 20));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 7)  = "ОЧИСТКА" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовШапкиФормы", 100, 4, Лев(ИмяПодпрограммыВРег, СтрДлина(ИмяПодпрограммы) - 7));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 13)  = "РЕГУЛИРОВАНИЕ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовШапкиФормы", 100, 5, Лев(ИмяПодпрограммыВРег, СтрДлина(ИмяПодпрограммы) - 13));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 8)  = "ОТКРЫТИЕ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовШапкиФормы", 100, 6, Лев(ИмяПодпрограммыВРег, СтрДлина(ИмяПодпрограммы) - 8));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 8)  = "СОЗДАНИЕ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовШапкиФормы", 100, 7, Лев(ИмяПодпрограммыВРег, СтрДлина(ИмяПодпрограммы) - 8));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 15)  = "ОБРАБОТКАВЫБОРА" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовШапкиФормы", 100, 8, Лев(ИмяПодпрограммыВРег, СтрДлина(ИмяПодпрограммы) - 15));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 29)  = "ИЗМЕНЕНИЕТЕКСТАРЕДАКТИРОВАНИЯ" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовШапкиФормы", 100, 9, Лев(ИмяПодпрограммыВРег, СтрДлина(ИмяПодпрограммы) - 29));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 10)  = "АВТОПОДБОР" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовШапкиФормы", 100, 10, Лев(ИмяПодпрограммыВРег, СтрДлина(ИмяПодпрограммы) - 10));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 20)  = "ОКОНЧАНИЕВВОДАТЕКСТА" Тогда
		
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовШапкиФормы", 100, 11, Лев(ИмяПодпрограммыВРег, СтрДлина(ИмяПодпрограммы) - 20));
		
	// Обработчики событий таблицы Формы и элементов таблицы Формы
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 12)  = "ПРИИЗМЕНЕНИИ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 12);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 1, ВРег(ИмяТаблицы));
	
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 5)  = "ВЫБОР" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 5);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 2, ВРег(ИмяТаблицы));
				
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 20)  = "ПРИАКТИВИЗАЦИИСТРОКИ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 20);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 3, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 13)  = "ВЫБОРЗНАЧЕНИЯ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 13);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 4, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 18)  = "ПРИАКТИВИЗАЦИИПОЛЯ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 18);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 5, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 20)  = "ПРИАКТИВИЗАЦИИЯЧЕЙКИ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 20);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 6, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 22)  = "ПЕРЕДНАЧАЛОМДОБАВЛЕНИЯ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 22);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 7, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 21)  = "ПЕРЕДНАЧАЛОМИЗМЕНЕНИЯ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 21);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 8, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 14)  = "ПЕРЕДУДАЛЕНИЕМ" И СтрДлина(ИмяПодпрограммыВРег) > 14 Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 14);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 9, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 23)  = "ПРИНАЧАЛЕРЕДАКТИРОВАНИЯ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 23);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 10, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 29)  = "ПЕРЕДОКОНЧАНИЕМРЕДАКТИРОВАНИЯ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 29);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 11, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 26)  = "ПРИОКОНЧАНИИРЕДАКТИРОВАНИЯ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 26);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 12, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 20)  = "ПЕРЕДРАЗВОРАЧИВАНИЕМ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 20);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 13, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 18)  = "ПЕРЕДСВОРАЧИВАНИЕМ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 18);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 14, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 13)  = "ПОСЛЕУДАЛЕНИЯ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 13);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 15, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 24)  = "ПРИСМЕНЕТЕКУЩЕГОРОДИТЕЛЯ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 24);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 16, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 21)  = "ОБРАБОТКАЗАПИСИНОВОГО" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 21);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 17, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 26)  = "ОБРАБОТКАЗАПРОСАОБНОВЛЕНИЯ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 26);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 18, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 20)  = "НАЧАЛОПЕРЕТАСКИВАНИЯ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 20);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 19, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 22)  = "ПРОВЕРКАПЕРЕТАСКИВАНИЯ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 22);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 20, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 23)  = "ОКОНЧАНИЕПЕРЕТАСКИВАНИЯ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 23);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 21, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 14)  = "ПЕРЕТАСКИВАНИЕ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 14);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 22, ВРег(ИмяТаблицы));
		
	//ИначеЕсли Прав(ИмяПодпрограммыВРег, 12)  = "ПРИИЗМЕНЕНИИ" Тогда
	//	
	//	ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 12);
	//	КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 23, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 12)  = "НАЧАЛОВЫБОРА" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 12);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 24, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 20)  = "НАЧАЛОВЫБОРАИЗСПИСКА" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 20);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 25, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 7)  = "ОЧИСТКА" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 7);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 26, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 13)  = "РЕГУЛИРОВАНИЕ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 13);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 27, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 8)  = "ОТКРЫТИЕ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 8);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 28, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 8)  = "СОЗДАНИЕ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 8);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 29, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 15)  = "ОБРАБОТКАВЫБОРА" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 15);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 30, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 29)  = "ИЗМЕНЕНИЕТЕКСТАРЕДАКТИРОВАНИЯ" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 29);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 31, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 10)  = "АВТОПОДБОР" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 10);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 32, ВРег(ИмяТаблицы));
		
	ИначеЕсли Прав(ИмяПодпрограммыВРег, 20)  = "ОКОНЧАНИЕВВОДАТЕКСТА" Тогда
		
		ИмяТаблицы = Лев(ИмяПодпрограммы, СтрДлина(ИмяПодпрограммы) - 20);
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытийЭлементовТаблицыФормы" + ИмяТаблицы, 150, 33, ВРег(ИмяТаблицы));

	//Обработчики событий
	ИначеЕсли ИмяПодпрограммыВРег = "ПРИУСТАНОВКЕНОВОГОКОДА" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 1);
	
	ИначеЕсли ИмяПодпрограммыВРег = "ПРИКОПИРОВАНИИ" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 2);
	
	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКАЗАПОЛНЕНИЯ" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 3);
	
	//ИначеЕсли ИмяПодпрограммыВРег = "ПЕРЕДЗАПИСЬЮ" Тогда // там где обработчики формы
	
	ИначеЕсли ИмяПодпрограммыВРег = "ПРИЗАПИСИ" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 5);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ПЕРЕДУДАЛЕНИЕМ" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 6);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКАПРОВЕРКИЗАПОЛНЕНИЯ" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 7);
	
	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКАФОРМИРОВАНИЯПОВЕРСИИИСТОРИИДАННЫХ" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 8);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКАПОЛУЧЕНИЯДАННЫХВЫБОРА" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 9);

	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКАПОЛУЧЕНИЯФОРМЫ" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 10);

	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКАПОЛУЧЕНИЯПОЛЕЙПРЕДСТАВЛЕНИЯ" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 11);

	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКАПОЛУЧЕНИЯПРЕДСТАВЛЕНИЯ" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 12);

	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКАПОСЛЕЗАПИСИВЕРСИЙИСТОРИИДАННЫХ" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 13);
	
	ИначеЕсли ИмяПодпрограммыВРег = "ПРИУСТАНОВКЕНОВОГОНОМЕРА" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 14);

	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКАПРОВЕДЕНИЯ" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 15);

	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКАУДАЛЕНИЯПРОВЕДЕНИЯ" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 16);

	ИначеЕсли ИмяПодпрограммыВРег = "ПРИКОМПОНОВКЕРЕЗУЛЬТАТА" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 17);

	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКАИНТЕРАКТИВНОЙАКТИВАЦИИ" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 18);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ПЕРЕДВЫПОЛНЕНИЕМ" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 19);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ПРИВЫПОЛНЕНИИ" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 20);

	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКАПРОВЕРКИВЫПОЛНЕНИЯ" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 21);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ПЕРЕДИНТЕРАКТИВНЫМВЫПОЛНЕНИЕМ" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 22);
		
	ИначеЕсли ИмяПодпрограммыВРег = "ОБРАБОТКАКОМАНДЫ" Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиСобытий", 50, 23);
		
	ИначеЕсли СтрЭлемент.Содержимое.Экспортная = Истина Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ПрограммныйИнтерфейс", 40, ИмяПодпрограммыВРег);
		
	// Обработчики команд Формы 	
	ИначеЕсли ЗначениеЗаполнено(СтрЭлемент.Содержимое.Параметры)
			  И СтрЭлемент.Содержимое.Параметры.Количество() = 1
			  И ВРег(СтрЭлемент.Содержимое.Параметры[0].Имя) = "КОМАНДА" Тогда
			  
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "ОбработчикиКомандФормы", 250, 1);
		
	// Служебные процедуры и Функции
	Иначе//Если НЕ (ЗначениеЗаполнено(СтрЭлемент.Родитель) И СтрЭлемент.Родитель.ТипЭлемента = "Область") Тогда
	
		КудаОпределяем = КудаОпределяемЭлемент(СтрЭлемент, "СлужебныеПроцедурыИФункции", 300, 1);
	
	КонецЕсли;

	Возврат КудаОпределяем;
	
КонецФункции

#КонецОбласти

