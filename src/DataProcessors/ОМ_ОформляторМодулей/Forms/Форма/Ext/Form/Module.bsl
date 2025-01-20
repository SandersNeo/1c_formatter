﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ИдТекСтрокиДереваМодуля = -1;
	
	ДеревоСтруктураМодуляАдрес = Неопределено;
	Если Параметры.Свойство("ДеревоСтруктураМодуля", ДеревоСтруктураМодуляАдрес) Тогда
		ДеревоСтруктураМодуля = ПолучитьИзВременногоХранилища(ДеревоСтруктураМодуляАдрес);
		ЗаполнитьДеревоСтруктурыМодуляРек(ДеревоСтруктураМодуля, СтруктураМодуля.ПолучитьЭлементы());
	КонецЕсли;

	ЗаполнитьМенюДействий();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяПриИзменении(Элемент)
	ИдТекСтрока = Элементы.СтруктураМодуля.ТекущаяСтрока;
	Если ИдТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекСтрока = СтруктураМодуля.НайтиПоИдентификатору(ИдТекСтрока);
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекСтрока.ТипЭлемента <> "Комментарий" 
		И ТекСтрока.ТипЭлемента <> "Код" Тогда
		ТекСтрока.Описание = Имя;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СтруктураМодуляОписаниеПриИзменении(Элемент)
	ИдТекСтрока = Элементы.СтруктураМодуля.ТекущаяСтрока;
	Если ИдТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекСтрока = СтруктураМодуля.НайтиПоИдентификатору(ИдТекСтрока);
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекСтрока.ТипЭлемента <> "Комментарий" 
		И ТекСтрока.ТипЭлемента <> "Код" Тогда
		Имя = ТекСтрока.Описание;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЭтоФункцияПриИзменении(Элемент)
	ИдТекСтрока = Элементы.СтруктураМодуля.ТекущаяСтрока;
	Если ИдТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекСтрока = СтруктураМодуля.НайтиПоИдентификатору(ИдТекСтрока);
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекСтрока.ТипЭлемента = ?(ЭтоФункция, "Функция", "Процедура");
	ТекСтрока.НомерКартинки = НомерКартинкиПоТипуЭлемента(ТекСтрока.ТипЭлемента);
	
	УстановитьВидимостьДоступностьЭлементовФормы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСтруктураМодуля

&НаКлиенте
Процедура СтруктураМодуляПриАктивизацииСтроки(Элемент)
	ИдТекСтрока = Элементы.СтруктураМодуля.ТекущаяСтрока;
	Если ИдТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИдАктивизированнойСтроки = ИдТекСтрока;
	
	ПодключитьОбработчикОжидания("СтруктураМодуляПриАктивизацииСтрокиЗавершение", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура СтруктураМодуляПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СтруктураМодуляПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
	
	ЭлементПриемник = СтруктураМодуля.НайтиПоИдентификатору(Строка);
	Если Не ВозможноПеремещениеВТипЭлемента(ЭлементПриемник.ТипЭлемента) Тогда
		Возврат;
	КонецЕсли;	
	
	ЭлементИсточник = СтруктураМодуля.НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение);
	
	Если ЭлементИсточник.ПолучитьРодителя() = ЭлементПриемник Тогда
		Возврат;
	КонецЕсли;
	
	ТекРодительПриемника = ЭлементПриемник.ПолучитьРодителя();
	Пока ТекРодительПриемника <> Неопределено Цикл
		Если ТекРодительПриемника = ЭлементИсточник Тогда
			Возврат;
		КонецЕсли;
		
		ТекРодительПриемника = ТекРодительПриемника.ПолучитьРодителя();
	КонецЦикла;
	
	СкопироватьСтрокуДерева(СтруктураМодуля, ЭлементПриемник, ЭлементИсточник);
	
	РодительИсточника = ЭлементИсточник.ПолучитьРодителя();
	Если РодительИсточника = Неопределено Тогда
	        СтруктураМодуля.ПолучитьЭлементы().Удалить(ЭлементИсточник);
	    Иначе
	        РодительИсточника.ПолучитьЭлементы().Удалить(ЭлементИсточник);
	    КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СтруктураМодуляОписаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекДанные = Элементы.СтруктураМодуля.ТекущиеДанные;
	
	Если ТекДанные.ТипЭлемента = "Область" Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.Добавить("ПрограммныйИнтерфейс");
		ДанныеВыбора.Добавить("СлужебныеПроцедурыИФункции");
		ДанныеВыбора.Добавить("ОбработчикиСобытий");
		ДанныеВыбора.Добавить("ОбработчикиСобытийФормы");
		ДанныеВыбора.Добавить("ОбработчикиСобытийЭлементовШапкиФормы");
		ДанныеВыбора.Добавить("ОбработчикиСобытийЭлементовТаблицыФормы<ИмяТаблицыФормы>");
		ДанныеВыбора.Добавить("ОбработчикиКомандФормы");
		ДанныеВыбора.Добавить("ОписаниеПеременных");
		ДанныеВыбора.Добавить("ОбновлениеИнформационнойБазы");
		ДанныеВыбора.Добавить("СлужебныйПрограммныйИнтерфейс");
		ДанныеВыбора.Добавить("Инициализация");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДействие(Команда)
	ИмяКоманды = Команда.Имя;
	
	// Ищем команду в таблице КомандыДействий
	НайденныеСтроки = КомандыДействий.НайтиСтроки(Новый Структура("ИмяКоманды", ИмяКоманды));
	Если НайденныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекКоманда = НайденныеСтроки[0];
	
	// Если у команды задана область действия, обновляем признак выбора
	ПоВыбраннымСтрокам = ЗначениеЗаполнено(ТекКоманда.ОбластьДействия);
	Если ПоВыбраннымСтрокам Тогда
		ОбновитьПризнакВыбораВСтрокахСтруктурыМодуля(ТекКоманда.ОбластьДействия);
	КонецЕсли;
	
	Если ТекКоманда.СпособЗапускаДействия = "ОткрытиеФормы" Тогда
		// Открываем форму обработки
		ОткрытьФормуДействия(ТекКоманда, ПоВыбраннымСтрокам);
	ИначеЕсли ТекКоманда.СпособЗапускаДействия = "ВызовМетодаМодуляМенеджера" Тогда
		ИдКомандыДействие = ТекКоманда.ПолучитьИдентификатор();
		
		// Вызываем серверный метод
		ВыполнитьДействие(ИдКомандыДействие, ПоВыбраннымСтрокам);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПодчиненныйВидЭлемента(Команда)
	ИдТекСтрока = Элементы.СтруктураМодуля.ТекущаяСтрока;
	Если ИдТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекСтрока = СтруктураМодуля.НайтиПоИдентификатору(ИдТекСтрока);
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТипЭлементаРодителя = ТекСтрока.ТипЭлемента;
	
	СписокВидовЭлементов = ПолучитьСписокВидовЭлементов(ТипЭлементаРодителя);
	
	Если СписокВидовЭлементов.Количество() > 0 Тогда
	
		ПоказатьВыборИзМеню(
			Новый ОписаниеОповещения("ВыборТипаЭлементаПриЗавершении", ЭтаФорма, Новый Структура("Родитель", ИдТекСтрока)),
			СписокВидовЭлементов,
			Элементы.СтруктураМодуля);
			
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьМодульНовый(Команда)
	ЭлементДерева = ДобавитьЭлементДереваСтруктуры(Неопределено, "Модуль");
	
	АктивизироватьРедактироватьЭлементДерева(ЭлементДерева);
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьМодульИзТекста(Команда)
	ОткрытьФорму(
		"Обработка.ОМ_ОформляторМодулей.Форма.ФормаВводаТекстаМодуля",
		,
		ЭтаФорма,
		,
		,
		,
		Новый ОписаниеОповещения("ДобавитьМодульИзТекстаЗавершение", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьМодулиИзФайлов(Команда)
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.Фильтр = "Тексты модулей (*.bsl)|*.bsl|Все файлы|*.*"; 
	ДиалогВыбораФайла.Заголовок = "Выберите файлы модуля";
	ДиалогВыбораФайла.ПредварительныйПросмотр = Истина;
	ДиалогВыбораФайла.МножественныйВыбор = Истина;
	ДиалогВыбораФайла.ИндексФильтра = 0;
	
	ДиалогВыбораФайла.Показать(Новый ОписаниеОповещения("ДобавитьМодулиИзФайловЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьДеревоСтруктуры(Команда)
	СтруктураМодуля.ПолучитьЭлементы().Очистить();
	Элементы.ГруппаПараметрыЭлементаСтруктуры.ТекущаяСтраница = Элементы.ПараметрыЭлементаПустаяСтраница;
	ИдТекСтрокиДереваМодуля = -1;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимостьДоступностьЭлементовФормы()
	// Управление видимостью поля возвращаемого значения
	Элементы.КомментарийВозвращаемоеЗначение.Видимость = ЭтоФункция;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьИмяСтраницыПараметровПоТипуЭлемента(ТипЭлемента)
	Если ТипЭлемента = "Модуль" Тогда
		Возврат "ПараметрыЭлементаМодуль";
	ИначеЕсли ТипЭлемента = "Область" Тогда
		Возврат "ПараметрыЭлементаОбласть";
	ИначеЕсли ТипЭлемента = "Процедура" 
		ИЛИ ТипЭлемента = "Функция" Тогда
		Возврат "ПараметрыЭлементаПодпрограмма";
	ИначеЕсли ТипЭлемента = "Переменная" Тогда
		Возврат "ПараметрыЭлементаПеременная";
	ИначеЕсли ТипЭлемента = "Код" Тогда
		Возврат "ПараметрыЭлементаКод";
	ИначеЕсли ТипЭлемента = "Комментарий" Тогда
		Возврат "ПараметрыЭлементаКомментарий";
	ИначеЕсли ТипЭлемента = "Код" Тогда
		Возврат "ПараметрыЭлементаКод";
	ИначеЕсли ТипЭлемента = "ПустаяСтрока" Тогда
		Возврат "ПараметрыЭлементаПустаяСтраница";
	КонецЕсли;
КонецФункции

&НаКлиенте
Функция СкопироватьСтрокуДерева(РеквизитДерево, Приемник, Источник)
	Перем НоваяСтрока, ОбратныйИндекс, КолПодчиненныхСтрок;
	
	    // Источник может быть уже перенесен
	    // Это происходит если выделены несколько элементов
	    // одной и той же ветви дерева на разных уровнях иерархии
	    Если Источник = Неопределено Тогда
	        Возврат Неопределено;
	    КонецЕсли;
	
	    Если Приемник = Неопределено Тогда
	        // Добавляем в корень
	        НоваяСтрока = РеквизитДерево.ПолучитьЭлементы().Добавить();
	    Иначе
	        НоваяСтрока = Приемник.ПолучитьЭлементы().Добавить();
	    КонецЕсли;
	
	    ЗаполнитьЗначенияСвойств(НоваяСтрока, Источник);
	
	    КолПодчиненныхСтрок = Источник.ПолучитьЭлементы().Количество();
	    Для каждого ПодчиненнаяСтрока Из Источник.ПолучитьЭлементы() Цикл
	        СкопироватьСтрокуДерева(РеквизитДерево, НоваяСтрока, ПодчиненнаяСтрока);
	    КонецЦикла;
	
	    Возврат НоваяСтрока;
КонецФункции

&НаКлиенте
Функция ВозможноПеремещениеВТипЭлемента(ТипЭлемента)
	Возврат (ТипЭлемента = "Модуль" ИЛИ ТипЭлемента = "Область");
КонецФункции

&НаКлиенте
Функция ПолучитьСписокВидовЭлементов(ТипЭлементаРодителя)
	сз = Новый СписокЗначений;
	
	Если ТипЭлементаРодителя = Неопределено Тогда
		
		сз.Добавить("Модуль");
		
	ИначеЕсли ТипЭлементаРодителя = "Модуль" 
		ИЛИ ТипЭлементаРодителя = "Область" Тогда
		
		сз.Добавить("Область");
		сз.Добавить("Процедура");
		сз.Добавить("Функция");
		сз.Добавить("Комментарий");
		
	КонецЕсли;		
	
	Возврат сз;
КонецФункции

&НаКлиенте
Процедура ВыборТипаЭлементаПриЗавершении(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИдРодительскогоЭлемента = ?(ДополнительныеПараметры = Неопределено, Неопределено, ДополнительныеПараметры.Родитель);
	ТипЭлемента = ВыбранныйЭлемент.Значение;
	ЭлементДерева = ДобавитьЭлементДереваСтруктуры(ИдРодительскогоЭлемента, ТипЭлемента);

	АктивизироватьРедактироватьЭлементДерева(ЭлементДерева);
КонецПроцедуры

&НаКлиенте
Функция ДобавитьЭлементДереваСтруктуры(ИдРодительскогоЭлемента, ТипЭлемента)

	Если ИдРодительскогоЭлемента = Неопределено Тогда
		ЭлементДерева = СтруктураМодуля.ПолучитьЭлементы().Добавить();
	Иначе
		ТекЭлементДерева = СтруктураМодуля.НайтиПоИдентификатору(ИдРодительскогоЭлемента);
		ЭлементДерева = ТекЭлементДерева.ПолучитьЭлементы().Добавить();
	КонецЕсли;
	ЭлементДерева.ТипЭлемента = ТипЭлемента;
	ЭлементДерева.НомерКартинки = НомерКартинкиПоТипуЭлемента(ЭлементДерева.ТипЭлемента);
	
	ЭтоФункция = (ЭлементДерева.ТипЭлемента = "Функция");
	Содержимое = ?(ЭтоФункция, Новый Структура("ЭтоФункция", Истина), Неопределено);
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Содержимое, УникальныйИдентификатор);
	ЭлементДерева.АдресСодержимого = АдресХранилища;

	Возврат ЭлементДерева;
	
КонецФункции

&НаКлиенте
Процедура АктивизироватьРедактироватьЭлементДерева(ЭлементДерева)
	Элементы.СтруктураМодуля.ТекущаяСтрока = ЭлементДерева.ПолучитьИдентификатор();
	Элементы.СтруктураМодуля.ИзменитьСтроку();
КонецПроцедуры

&НаКлиенте
Процедура СтруктураМодуляПриАктивизацииСтрокиЗавершение()
	ПереключитьСтрокуСтруктуры(ИдАктивизированнойСтроки);
	УстановитьВидимостьДоступностьЭлементовФормы();
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьДеревоСтруктурыМодуля(ТекстМодуляДляЗагрузки, ИмяМодуля = Неопределено)
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ДеревоСтруктураМодуля = ОбработкаОбъект.РазобратьТекстВДеревоМодуля(ТекстМодуляДляЗагрузки, ИмяМодуля);
	ЗаполнитьДеревоСтруктурыМодуляРек(ДеревоСтруктураМодуля, СтруктураМодуля.ПолучитьЭлементы());
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоСтруктурыМодуляРек(дзСтруктураМодуля, ЭлементыДереваРеализации)
	Для каждого СтрДерева Из дзСтруктураМодуля.Строки Цикл
		
		ЭлементДереваРеализации = ЭлементыДереваРеализации.Добавить();
		
		ЗаполнитьЗначенияСвойств(ЭлементДереваРеализации, СтрДерева, "ТипЭлемента, Описание");
		
		Содержимое = СтрДерева.Содержимое;
		Если Содержимое <> Неопределено Тогда
			ЭлементДереваРеализации.АдресСодержимого = ПоместитьВоВременноеХранилище(Содержимое, УникальныйИдентификатор);
		КонецЕсли;
		ЭлементДереваРеализации.НомерКартинки = НомерКартинкиПоТипуЭлемента(ЭлементДереваРеализации.ТипЭлемента);
		
		ЗаполнитьДеревоСтруктурыМодуляРек(СтрДерева, ЭлементДереваРеализации.ПолучитьЭлементы());
	КонецЦикла;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НомерКартинкиПоТипуЭлемента(ТипЭлемента)
	Если ТипЭлемента = "Модуль" Тогда
		Возврат 0;
	ИначеЕсли ТипЭлемента = "Область" Тогда
		Возврат 10;
	ИначеЕсли ТипЭлемента = "Процедура" Тогда
		Возврат 1;
	ИначеЕсли ТипЭлемента = "Функция" Тогда
		Возврат 2;
	ИначеЕсли ТипЭлемента = "Переменная" Тогда
		Возврат 11;
	ИначеЕсли ТипЭлемента = "Код" Тогда
		Возврат 12;
	ИначеЕсли ТипЭлемента = "Комментарий" Тогда
		Возврат 9;
	ИначеЕсли ТипЭлемента = "ПустаяСтрока" Тогда
		Возврат 6;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

&НаСервере
Функция АдресДереваСтруктурыМодулей(ДобавитьКолонкуВыбранныхСтрок = Ложь)
	дз = ВыгрузитьСтруктуруМодулей(ДобавитьКолонкуВыбранныхСтрок);
	
	Возврат ПоместитьВоВременноеХранилище(дз, ЭтаФорма.УникальныйИдентификатор);
КонецФункции

&НаСервере
Функция ВыгрузитьСтруктуруМодулей(ДобавитьКолонкуВыбранныхСтрок = Ложь)
    СохранитьДанныеТекСтроки(); // сохранение здесь добавлено, т.к. сохранение происходит только при переключении активной строки
	
	дз = Обработки.ОМ_ОформляторМодулей.НовоеДеревоСтруктурыМодуля();
	Если ДобавитьКолонкуВыбранныхСтрок Тогда
		дз.Колонки.Добавить("Выбрана");
	КонецЕсли;
	
	ВыгрузитьСтруктуруМодуляРек(дз, СтруктураМодуля.ПолучитьЭлементы());
	
	Возврат дз;
КонецФункции

&НаСервере
Процедура ВыгрузитьСтруктуруМодуляРек(дз, ЭлементыСтруктурыМодуля)
	Для каждого ЭлементСтруктуры Из ЭлементыСтруктурыМодуля Цикл
		
		СтрДерева = дз.Строки.Добавить();
		
		ЗаполнитьЗначенияСвойств(СтрДерева, ЭлементСтруктуры);
		
		Если ЗначениеЗаполнено(ЭлементСтруктуры.АдресСодержимого) Тогда
			Содержимое = ПолучитьИзВременногоХранилища(ЭлементСтруктуры.АдресСодержимого);
			СтрДерева.Содержимое = Содержимое;
		КонецЕсли;
		
		ВыгрузитьСтруктуруМодуляРек(СтрДерева, ЭлементСтруктуры.ПолучитьЭлементы());
		
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПереключитьСтрокуСтруктуры(ИдСтроки)
	СохранитьДанныеТекСтроки();
	
	ТекСтрока = СтруктураМодуля.НайтиПоИдентификатору(ИдСтроки);
	Если ТекСтрока = Неопределено Тогда
		Элементы.ГруппаПараметрыЭлементаСтруктуры.ТекущаяСтраница = Элементы.ПараметрыЭлементаПустаяСтраница;
		ИдТекСтрокиДереваМодуля = -1;
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаПараметрыЭлементаСтруктуры.ТекущаяСтраница = Элементы[ПолучитьИмяСтраницыПараметровПоТипуЭлемента(ТекСтрока.ТипЭлемента)];
	
	ЗагрузитьСодержимоеСтрокиСтруктуры(ТекСтрока);
	
	ИдТекСтрокиДереваМодуля = ИдСтроки;
КонецПроцедуры

&НаСервере
Процедура СохранитьДанныеТекСтроки()
	ТекСтрока = Неопределено;
	Если ИдТекСтрокиДереваМодуля <> -1 Тогда
		ТекСтрока = СтруктураМодуля.НайтиПоИдентификатору(ИдТекСтрокиДереваМодуля);
	КонецЕсли;
	
	Если ТекСтрока <> Неопределено Тогда 
		СохранитьСодержимоеСтрокиСтруктуры(ТекСтрока);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СохранитьСодержимоеСтрокиСтруктуры(ЭлементДереваСтруктуры)
	Если ЭлементДереваСтруктуры.АдресСодержимого = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Содержимое = Обработки.ОМ_ОформляторМодулей.СтруктураОписанияЭлемента(ЭлементДереваСтруктуры.ТипЭлемента);
	
	Если ЭлементДереваСтруктуры.ТипЭлемента = "Модуль" Тогда
		
		Содержимое.Имя = Имя;
		Содержимое.Синтаксис = Синтаксис;
		
	ИначеЕсли ЭлементДереваСтруктуры.ТипЭлемента = "Область" Тогда
		
		Содержимое.Имя = Имя;
		Содержимое.Комментарий = Комментарий;
		Содержимое.КомментарийВСтрокеОбласть = КомментарийОднострочный;
		Содержимое.КомментарийПослеКонецОбласти = КомментарийОднострочныйКонец;
		
	ИначеЕсли ЭлементДереваСтруктуры.ТипЭлемента = "Переменная" Тогда
		
		Содержимое.ТаблицаПеременных = Переменные.Выгрузить();
		Содержимое.Контекст = Контекст;
		Содержимое.Комментарий = Комментарий;
		Содержимое.КомментарийОднострочный = КомментарийОднострочный;
		ЗаполнитьЗначенияСвойств(Содержимое.ИнструкцииПрепроцессора, ЭтаФорма);
		
	ИначеЕсли ЭлементДереваСтруктуры.ТипЭлемента = "Процедура"
		ИЛИ ЭлементДереваСтруктуры.ТипЭлемента = "Функция" Тогда
		
		Содержимое.Имя = Имя;
		Содержимое.ЭтоФункция = ЭтоФункция;
		Содержимое.Экспортная = Экспортная;
		Содержимое.Асинх = _Асинх;
		Содержимое.Контекст = Контекст;
		Содержимое.Аннотация = Аннотация;
		Содержимое.ИмяРасширяемогоМетода = ИмяРасширяемогоМетода;
		Содержимое.Комментарий = Комментарий;
		Содержимое.КомментарийОднострочный = КомментарийОднострочный;
		Содержимое.КомментарийОднострочныйКонец = КомментарийОднострочныйКонец;
		Содержимое.КомментарийВозвращаемоеЗначение = КомментарийВозвращаемоеЗначение;
		Содержимое.Тело = Текст;
		Содержимое.Параметры = ПараметрыПодпрограммы.Выгрузить();
		ЗаполнитьЗначенияСвойств(Содержимое.ИнструкцииПрепроцессора, ЭтаФорма);
		
	ИначеЕсли ЭлементДереваСтруктуры.ТипЭлемента = "Комментарий" Тогда
		
		Содержимое.Комментарий = Комментарий;
		
	ИначеЕсли ЭлементДереваСтруктуры.ТипЭлемента = "Код" Тогда
		
		Содержимое.Тело = Текст;
		ЗаполнитьЗначенияСвойств(Содержимое.ИнструкцииПрепроцессора, ЭтаФорма);
		
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Содержимое, ЭлементДереваСтруктуры.АдресСодержимого);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСодержимоеСтрокиСтруктуры(ЭлементДереваСтруктуры)
	Если ЭлементДереваСтруктуры.АдресСодержимого = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Очищаем все элементы
	Имя = "";
	Синтаксис = "";
	ИмяПодпрограммы = "";
	Комментарий = "";
	КомментарийОднострочный = "";
	КомментарийОднострочныйКонец = "";
	Контекст = "";
	Аннотация = "";
	ИмяРасширяемогоМетода = "";
	Комментарий = "";
	Экспортная = Ложь;
	_Асинх = Ложь;
	ЭтоФункция = Ложь;
	Текст = "";
	
	ПараметрыПодпрограммы.Очистить();
	Переменные.Очистить();
	
	// Загружаем содержимое
	Содержимое = ПолучитьИзВременногоХранилища(ЭлементДереваСтруктуры.АдресСодержимого);
	
	Если ТипЗнч(Содержимое) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭлементДереваСтруктуры.ТипЭлемента = "Модуль" Тогда
		
		Содержимое.Свойство("Имя", Имя);
		Содержимое.Свойство("Синтаксис", Синтаксис);
		
	ИначеЕсли ЭлементДереваСтруктуры.ТипЭлемента = "Область" Тогда
		
		Содержимое.Свойство("Имя", Имя);
		Содержимое.Свойство("Комментарий", Комментарий);
		Содержимое.Свойство("КомментарийВСтрокеОбласть", КомментарийОднострочный);
		Содержимое.Свойство("КомментарийПослеКонецОбласти", КомментарийОднострочныйКонец);
		
	ИначеЕсли ЭлементДереваСтруктуры.ТипЭлемента = "Переменная" Тогда
		
		Если Содержимое.Свойство("ТаблицаПеременных")
			И ТипЗнч(Содержимое.ТаблицаПеременных) = Тип("ТаблицаЗначений") Тогда
			Переменные.Загрузить(Содержимое.ТаблицаПеременных);
		КонецЕсли;
		Содержимое.Свойство("Контекст", Контекст);
		Содержимое.Свойство("Комментарий", Комментарий);
		Содержимое.Свойство("КомментарийОднострочный", КомментарийОднострочный);
		
		Если Содержимое.Свойство("ИнструкцииПрепроцессора") Тогда
			ЗаполнитьЗначенияСвойств(ЭтаФорма, Содержимое.ИнструкцииПрепроцессора);
		КонецЕсли;
		
	ИначеЕсли ЭлементДереваСтруктуры.ТипЭлемента = "Процедура"
		ИЛИ ЭлементДереваСтруктуры.ТипЭлемента = "Функция" Тогда
		
		Содержимое.Свойство("Имя", Имя);
		Содержимое.Свойство("ЭтоФункция", ЭтоФункция);
		Содержимое.Свойство("Экспортная", Экспортная);
		Содержимое.Свойство("Асинх", _Асинх);
		Содержимое.Свойство("Контекст", Контекст);
		Содержимое.Свойство("Аннотация", Аннотация);
		Содержимое.Свойство("ИмяРасширяемогоМетода", ИмяРасширяемогоМетода);
		Содержимое.Свойство("Комментарий", Комментарий);
		Содержимое.Свойство("КомментарийОднострочный", КомментарийОднострочный);
		Содержимое.Свойство("КомментарийОднострочныйКонец", КомментарийОднострочныйКонец);
		Содержимое.Свойство("КомментарийВозвращаемоеЗначение", КомментарийВозвращаемоеЗначение);
		Содержимое.Свойство("Тело", Текст);
		Если Содержимое.Свойство("Параметры")
			И ТипЗнч(Содержимое.Параметры) = Тип("ТаблицаЗначений") Тогда
			ПараметрыПодпрограммы.Загрузить(Содержимое.Параметры);
		КонецЕсли;
		
		Если Содержимое.Свойство("ИнструкцииПрепроцессора") Тогда
			ЗаполнитьЗначенияСвойств(ЭтаФорма, Содержимое.ИнструкцииПрепроцессора);
		КонецЕсли;
		
	ИначеЕсли ЭлементДереваСтруктуры.ТипЭлемента = "Комментарий" Тогда
		
		Содержимое.Свойство("Комментарий", Комментарий);
		
	ИначеЕсли ЭлементДереваСтруктуры.ТипЭлемента = "Код" Тогда
		
		Содержимое.Свойство("Тело", Текст);
		Если Содержимое.Свойство("ИнструкцииПрепроцессора") Тогда
			ЗаполнитьЗначенияСвойств(ЭтаФорма, Содержимое.ИнструкцииПрепроцессора);
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьМодульИзТекстаЗавершение(ТекстМодуля, ДополнительныеПараметры) Экспорт
	Если ТекстМодуля = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//СохранитьРезервнуюКопиюМодуля();
	
	ЗаполнитьДеревоСтруктурыМодуля(ТекстМодуля);
	
	ЭлементыДерева = СтруктураМодуля.ПолучитьЭлементы();
	КолвоЭлементов = ЭлементыДерева.Количество();
	Если КолвоЭлементов > 0 Тогда
		Элементы.СтруктураМодуля.Развернуть(ЭлементыДерева[КолвоЭлементов-1].ПолучитьИдентификатор());
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьМодулиИзФайловЗавершение(МассивФайлов, ДополнительныеПараметры) Экспорт
	Если МассивФайлов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ИмяФайла Из МассивФайлов Цикл
		ЧТ = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.UTF8);
		ТекстМодуля = ЧТ.Прочитать();

		ИмяМодуля = "";
		Файл = Новый Файл(ИмяФайла);
		ПутьКФайлу = Файл.Путь;
		Если Прав(ПутьКФайлу, 5) = "\Ext\" Тогда
			МассивКаталогов = СтрРазделить(ПутьКФайлу, "\", Ложь);
			ИндексТекУровня = МассивКаталогов.Количество()-1;
			КолвоУровней = 3;
			Пока КолвоУровней > 0 И ИндексТекУровня >= 0 Цикл
				Кат = МассивКаталогов[ИндексТекУровня];
				Если Кат = "Forms" Тогда
					КолвоУровней = 2;
				КонецЕсли;
				
				Если Кат <> "Ext" Тогда
					ИмяМодуля = Кат + ?(ЗначениеЗаполнено(ИмяМодуля), ".", "") + ИмяМодуля;
				КонецЕсли;
				
				КолвоУровней = КолвоУровней - 1;
				ИндексТекУровня = ИндексТекУровня - 1;
			КонецЦикла;
		КонецЕсли;

		ИмяМодуля = ИмяМодуля + ?(ЗначениеЗаполнено(ИмяМодуля), ".", "") + Файл.ИмяБезРасширения;
		
		ЗаполнитьДеревоСтруктурыМодуля(ТекстМодуля, ИмяМодуля);
		
		ЭлементыДерева = СтруктураМодуля.ПолучитьЭлементы();
		КолвоЭлементов = ЭлементыДерева.Количество();
		Если КолвоЭлементов > 0 Тогда
			Элементы.СтруктураМодуля.Развернуть(ЭлементыДерева[КолвоЭлементов-1].ПолучитьИдентификатор());
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьПоОбластямЗавершение(АдресНовогоДереваСтруктуры, ДополнительныеПараметры) Экспорт
	//Если АдресНовогоДереваСтруктуры = Неопределено Тогда
	//	Возврат;
	//КонецЕсли;

	//РаспределитьПоОбластямНаСервере(АдресНовогоДереваСтруктуры);
КонецПроцедуры

&НаКлиенте
Процедура АнализВызововЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГенерацииОписанияМетодаЗавершение(Результат, ТипОписания) Экспорт
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипОписания = "Описание" Тогда
		Комментарий = Результат;
	ИначеЕсли ТипОписания = "ВозвращаемоеЗначение" Тогда
		КомментарийВозвращаемоеЗначение = Результат;
	ИначеЕсли ТипОписания = "Параметры" Тогда
		Попытка
			РезультатМассивСтруктур = JsonВСтруктуру(Результат);
			Для каждого Парам Из РезультатМассивСтруктур Цикл
				ИмяПараметра = Парам.name;
				НайденныеСтроки = ПараметрыПодпрограммы.НайтиСтроки(Новый Структура("Имя", ИмяПараметра));
				Если ЗначениеЗаполнено(НайденныеСтроки) Тогда
					СтрокаПараметр = НайденныеСтроки[0];
					Парам.Свойство("type", СтрокаПараметр.Тип);
					Парам.Свойство("descr", СтрокаПараметр.Описание);
				КонецЕсли;
			КонецЦикла;
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Функция JsonВСтруктуру(СтрокаJSON, ПараметрыПреобразования = Неопределено)
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
	
	СтруктураJSON = ПрочитатьJSON(ЧтениеJSON);
	
	ЧтениеJSON.Закрыть();
	
	Возврат СтруктураJSON;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуДействия(КомандаДействие, ПоВыбраннымСтрокам)
	АдресДереваСтруктурыМодулей = АдресДереваСтруктурыМодулей(ПоВыбраннымСтрокам);
	
	ПараметрыОткрытия = Новый Структура(
		"Идентификатор,ПараметрыКоманды", 
		КомандаДействие.Идентификатор, 
		Новый Структура(
			"Идентификатор,АдресДереваСтруктурыМодулей",
			КомандаДействие.Идентификатор,
			АдресДереваСтруктурыМодулей));
	ОткрытьФорму(
		"Обработка." + КомандаДействие.ИмяОбработки + ".Форма",
		ПараметрыОткрытия,
		ЭтотОбъект,
		,
		,
		,
		Новый ОписаниеОповещения("ОткрытьФормуДействияЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуДействияЗавершение(РезультатВыполненияКоманды, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(РезультатВыполненияКоманды) = Тип("Структура") Тогда
		АдресДереваСтруктурыМодулей = Неопределено;
		Если РезультатВыполненияКоманды.Свойство("АдресДереваСтруктурыМодулей", АдресДереваСтруктурыМодулей) Тогда
			дз = ПолучитьИзВременногоХранилища(АдресДереваСтруктурыМодулей);

			СтруктураМодуля.ПолучитьЭлементы().Очистить();
			ЗаполнитьДеревоСтруктурыМодуляРек(дз, СтруктураМодуля.ПолучитьЭлементы());
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ВыполнитьДействие(ИдКомандыДействие, ПоВыбраннымСтрокам)
	КомандаДействие = КомандыДействий.НайтиПоИдентификатору(ИдКомандыДействие);
	
	дз = ВыгрузитьСтруктуруМодулей(ПоВыбраннымСтрокам);
	ПараметрыКоманды = Новый Структура("ДеревоСтруктурыМодулей", дз);
	
	МенеджерОбработки = Обработки[КомандаДействие.ИмяОбработки];
	МенеджерОбработки.ВыполнитьДействие(КомандаДействие.Идентификатор, ПараметрыКоманды);
	
	СтруктураМодуля.ПолучитьЭлементы().Очистить();
	ЗаполнитьДеревоСтруктурыМодуляРек(ПараметрыКоманды.ДеревоСтруктурыМодулей, СтруктураМодуля.ПолучитьЭлементы());
КонецПроцедуры

#Область МетодыРаботыСМенюДействий

&НаСервере
Процедура ЗаполнитьМенюДействий()
	
	ТабКомандыДействий = КомандыДействий.Выгрузить();
	// Колонка СпособЗапускаДействия = ОткрытиеФормы или ВызовМетодаМодуляМенеджера
	// Колонка ОбластьДействия = пусто или через запятую: Модуль,Область,Процедура,Функция,Переменные,Комментарий,Код
	
	СоставПодсистемыДействия = Метаданные.Подсистемы.ОМ_Оформлятор.Подсистемы.ОМ_Действия.Состав;
	Для Каждого МД Из СоставПодсистемыДействия Цикл
		Если Не Метаданные.Обработки.Содержит(МД) Тогда
			Продолжить;
		КонецЕсли;
		
		МенеджерОбработки = Обработки[МД.Имя];
		
		ТекКомандыДействий = ТабКомандыДействий.СкопироватьКолонки();
		МенеджерОбработки.ДобавитьКомандыДействий(ТекКомандыДействий);

		Для каждого Стр Из ТекКомандыДействий Цикл
			СтрОбщегоСпискаКоманд = ТабКомандыДействий.Добавить();
			ЗаполнитьЗначенияСвойств(СтрОбщегоСпискаКоманд, Стр);
			СтрОбщегоСпискаКоманд.ИмяОбработки = МД.Имя;
		КонецЦикла;
	КонецЦикла;

	ТабКомандыДействий.Сортировать("Порядок,Представление");
	Для Каждого ТекКоманда Из ТабКомандыДействий Цикл
		ИмяКоманды = "КомандаДействие_" + ТекКоманда.ИмяОбработки + "_" + ТекКоманда.Идентификатор;
		ТекКоманда.ИмяКоманды = ИмяКоманды;
		
		// Добавляем команду
		НоваяКоманда = Команды.Добавить(ИмяКоманды); 
		НоваяКоманда.Действие = "КомандаДействие";
		НоваяКоманда.Заголовок = ТекКоманда.Представление;
		
		// Добавляем кнопку
		Если ЗначениеЗаполнено(ТекКоманда.ОбластьДействия) Тогда
			НоваяКнопка = Элементы.Добавить(ИмяКоманды + "_Кнопка", Тип("КнопкаФормы"), Элементы.СтруктураМодуляКонтекстноеМенюДействия);
		Иначе
			НоваяКнопка = Элементы.Добавить(ИмяКоманды + "_Кнопка", Тип("КнопкаФормы"), Элементы.СтруктураМодуляДействия);
		КонецЕсли;
		
		НоваяКнопка.ИмяКоманды = ИмяКоманды;
		НоваяКнопка.Заголовок = ТекКоманда.Представление;
	КонецЦикла;

	КомандыДействий.Загрузить(ТабКомандыДействий);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПризнакВыбораВСтрокахСтруктурыМодуля(ОбластьДействия)
	// Формируем структуру допустимых типов для быстрого поиска
	ДопустимыеТипы = Новый Структура(ОбластьДействия);
	
	// Очищаем признак выбора во всех строках
	ОчиститьПризнакВыбораРекурсивно(СтруктураМодуля.ПолучитьЭлементы());
	
	// Устанавливаем признак для выделенных строк, если их тип входит в область действия
	ВыделенныеСтроки = Элементы.СтруктураМодуля.ВыделенныеСтроки;
	Для Каждого ИдСтроки Из ВыделенныеСтроки Цикл
		ТекСтрока = СтруктураМодуля.НайтиПоИдентификатору(ИдСтроки);
		Если ТекСтрока <> Неопределено Тогда
			Если ДопустимыеТипы.Свойство(ТекСтрока.ТипЭлемента) Тогда
				ТекСтрока.Выбрана = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПризнакВыбораРекурсивно(Строки)
	Для Каждого Строка Из Строки Цикл
		Строка.Выбрана = Ложь;
		ОчиститьПризнакВыбораРекурсивно(Строка.ПолучитьЭлементы());
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

