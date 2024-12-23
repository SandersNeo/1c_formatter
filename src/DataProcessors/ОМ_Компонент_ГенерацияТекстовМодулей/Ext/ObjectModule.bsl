﻿
Перем ТекущиеИнструкцииПрепроцессораМодуля;
Перем АнглСинтаксис;

#Область ПрограммныйИнтерфейс

Функция ТекстМодуля(СтрЭлементМодуль) Экспорт
	ТекущиеИнструкцииПрепроцессораМодуля = СтруктураИнструкцийПрепроцессораПоУмолчанию();
	Возврат ГенерироватьТекстЭлементаРек(СтрЭлементМодуль);
КонецФункции

Функция ГенерироватьТекстМетода(СтрЭлементМетод, ВключатьКод = Истина, ВключатьДокументацию = Истина, ТолькоСигнатура = Ложь) Экспорт
	Возврат МетодТекст(СтрЭлементМетод, ВключатьКод, ВключатьДокументацию, ТолькоСигнатура);
КонецФункции

#КонецОбласти

#Область ГенерацияТекста

Функция ГенерироватьТекстЭлементаРек(СтрЭлемент)
	ТекстЭлемента = "";
	
	Если СтрЭлемент.ТипЭлемента = "Модуль" Тогда
		
		ТекстЭлемента = ГенерироватьТекстМодуляПоМассиву(СтрЭлемент);
		
	ИначеЕсли СтрЭлемент.ТипЭлемента = "Область" Тогда
		
		ТекстЭлемента = ОбластьТекст(СтрЭлемент);
		
	ИначеЕсли СтрЭлемент.ТипЭлемента = "Переменная" Тогда
		
		ТекстЭлемента = ПеременнаяТекст(СтрЭлемент);
		
	ИначеЕсли СтрЭлемент.ТипЭлемента = "Процедура" Тогда
		
		ТекстЭлемента = ПроцедураТекст(СтрЭлемент);
		
	ИначеЕсли СтрЭлемент.ТипЭлемента = "Функция" Тогда
		
		ТекстЭлемента = ФункцияТекст(СтрЭлемент);
		
	ИначеЕсли СтрЭлемент.ТипЭлемента = "Комментарий" Тогда
		
		ТекстЭлемента = ОформитьКомментарий(СтрЭлемент.Содержимое.Комментарий) + Символы.ПС;
		
	ИначеЕсли СтрЭлемент.ТипЭлемента = "Код" Тогда 
		
		ТекстЭлемента = КодТекст(СтрЭлемент);	
		
	КонецЕсли;
	
	Возврат ТекстЭлемента;
КонецФункции

Функция ГенерироватьТекстМодуляПоМассиву(ГоловнойЭлемент)
	
	ТД = Новый ТекстовыйДокумент;
	
	ДирективыКомпилятораНаЭтомУровнеВставлялись = Ложь;
	ВыполнятьРасстановкуДирективКомпилятора = Ложь; // Устанавливаем директивы на этом уровне только если на данный момент директив нет
	Если ИнструкцииПрепроцессораИдентичны(ТекущиеИнструкцииПрепроцессораМодуля, СтруктураИнструкцийПрепроцессораПоУмолчанию()) Тогда
		ВыполнятьРасстановкуДирективКомпилятора = Истина;
	КонецЕсли; 
	
	Для каждого СтрЭлемент Из ГоловнойЭлемент.Строки Цикл
		
		ИнструкцииПрепроцессораТекущегоЭлемента = Неопределено;
		Если ВыполнятьРасстановкуДирективКомпилятора 
			И СтрЭлемент.Содержимое.Свойство("ИнструкцииПрепроцессора", ИнструкцииПрепроцессораТекущегоЭлемента) 
			И НЕ ИнструкцииПрепроцессораИдентичны(ТекущиеИнструкцииПрепроцессораМодуля, ИнструкцииПрепроцессораТекущегоЭлемента) Тогда
			
			Если НЕ ИнструкцииПрепроцессораИдентичны(ТекущиеИнструкцииПрепроцессораМодуля, СтруктураИнструкцийПрепроцессораПоУмолчанию()) Тогда
				ТД.ДобавитьСтроку("#КонецЕсли");	
				ТД.ДобавитьСтроку("");
				
				// Если закрыли открытую ранее директиву, то после обработки вложенных элементов закрывать директиву уже не нужно
				ДирективыКомпилятораНаЭтомУровнеВставлялись = Ложь; 
			КонецЕсли;
			
			Если Не ИнструкцииПрепроцессораИдентичны(ИнструкцииПрепроцессораТекущегоЭлемента, СтруктураИнструкцийПрепроцессораПоУмолчанию()) Тогда
				ТД.ДобавитьСтроку(ТекстИнструкцийПрепроцессора(ИнструкцииПрепроцессораТекущегоЭлемента));	
				ДирективыКомпилятораНаЭтомУровнеВставлялись = Истина;
			КонецЕсли; 

			ТекущиеИнструкцииПрепроцессораМодуля = ИнструкцииПрепроцессораТекущегоЭлемента;
		КонецЕсли;
		
		ТД.ДобавитьСтроку(ГенерироватьТекстЭлементаРек(СтрЭлемент, ТекущиеИнструкцииПрепроцессораМодуля));
		
	КонецЦикла;
	
	Если ДирективыКомпилятораНаЭтомУровнеВставлялись Тогда
		ТД.ДобавитьСтроку("#КонецЕсли");	
		ТД.ДобавитьСтроку("");
		ТекущиеИнструкцииПрепроцессораМодуля = СтруктураИнструкцийПрепроцессораПоУмолчанию();
	КонецЕсли; 
	
	Возврат ТД.ПолучитьТекст();
	
КонецФункции

#Область ОформлениеФрагментовТекста

Функция ОформитьКомментарий(СтрКомментарий)
	Если Не ЗначениеЗаполнено(СтрКомментарий) Тогда
		Возврат "";
	КонецЕсли;
	
	СтрКомментарий = СокрЛП(СтрКомментарий);
	
	ТД = Новый ТекстовыйДокумент;
	ТД.УстановитьТекст(СтрКомментарий);
	
	ТД_Результат = Новый ТекстовыйДокумент;
	Для НомСтр = 1 По ТД.КоличествоСтрок() Цикл
		ТД_Результат.ДобавитьСтроку("// " + ТД.ПолучитьСтроку(НомСтр));
	КонецЦикла;
	
	Возврат СокрП(ТД_Результат.ПолучитьТекст());
КонецФункции

Функция ОформитьКомментарийОднострочный(СтрКомментарий)
	Если Не ЗначениеЗаполнено(СтрКомментарий) Тогда
		Возврат "";
	КонецЕсли;
	
	СтрКомментарий = СокрЛП(СтрКомментарий);
	
	Возврат " // " + СтрКомментарий;
КонецФункции

Функция ОформитьКонтекст(СтрКонтекст)
	Если Не ЗначениеЗаполнено(СтрКонтекст) Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат "&" + СтрКонтекст;
КонецФункции

Функция ОформитьАннотацию(СтрАннотация, ИмяРасширяемогоМетода)
	Если Не ЗначениеЗаполнено(СтрАннотация) Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат "&" + СтрАннотация + "(""" + ИмяРасширяемогоМетода + """)";
КонецФункции

Функция ОформитьПараметрыМетода(Параметры)
	СтрПараметры = "";
	
	Для каждого СтрПараметр Из Параметры Цикл
		
		СтрПараметры = СтрПараметры + ?(ЗначениеЗаполнено(СтрПараметры), ", ", "") + ?(СтрПараметр.ПоЗначению, "Знач ", "") + СтрПараметр.Имя + ?(ЗначениеЗаполнено(СтрПараметр.ЗначениеПоУмолчанию), " = " + СтрПараметр.ЗначениеПоУмолчанию, "");
		
	КонецЦикла;
	
	Возврат СтрПараметры;
КонецФункции

Функция ОформитьТекстМетода(Текст)
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат "";
	КонецЕсли;
	
	ТД = Новый ТекстовыйДокумент;
	ТД.УстановитьТекст(Текст);
	
	ТД_Результат = Новый ТекстовыйДокумент;
	Для НомСтр = 1 По ТД.КоличествоСтрок() Цикл
		ТД_Результат.ДобавитьСтроку(Символы.Таб + ТД.ПолучитьСтроку(НомСтр));
	КонецЦикла;
	
	Возврат СокрП(ТД_Результат.ПолучитьТекст());
КонецФункции

Функция ОформитьИменаПеременных(ТаблицаПеременных)

	Результат = "";
	Для каждого СтрТаблицаПеременных Из ТаблицаПеременных Цикл
		Результат = Результат 
			+ ?(ЗначениеЗаполнено(Результат), ", ", "") 
			+ СтрТаблицаПеременных.Имя 
			+ ?(СтрТаблицаПеременных.Экспорт = Истина, " " + ТекстЭкспорт(), "");
	КонецЦикла;

	Возврат Результат;	
	
КонецФункции

#КонецОбласти

#Область ГенерацияФрагментовТекста

Функция ОбластьТекст(СтрЭлемент)
	
	Содержимое = СтрЭлемент.Содержимое;
	
	ТД = Новый ТекстовыйДокумент;
	
	СтрКомментарий = Содержимое.Комментарий;
	Если ЗначениеЗаполнено(СтрКомментарий) Тогда
		ТД.ДобавитьСтроку(ОформитьКомментарий(СтрКомментарий));
	КонецЕсли;
	
	СтрИмя = Содержимое.Имя;
	Если ЗначениеЗаполнено(СтрИмя) Тогда
		ТД.ДобавитьСтроку(
			ТекстОбластьНачало() + " " + СтрИмя
			+ ОформитьКомментарийОднострочный(Содержимое.КомментарийВСтрокеОбласть)
			+ Символы.ПС);
	КонецЕсли;
		
	КомментарийПослеКонецОбласти = Содержимое.КомментарийПослеКонецОбласти;	
	Если ЗначениеЗаполнено(СтрЭлемент) Тогда
		ТД.ДобавитьСтроку(
			ГенерироватьТекстМодуляПоМассиву(СтрЭлемент)
			+ ТекстОбластьКонец() + ОформитьКомментарийОднострочный(КомментарийПослеКонецОбласти));
	КонецЕсли;
	
	//Текст = 
	//"#Область " + СтрЭлемент.Содержимое.Имя + "
	//|
	//|" + ГенерироватьТекстМодуляПоМассиву(СтрЭлемент) + "#КонецОбласти
	//|";
	
	Возврат ТД.ПолучитьТекст();
	
КонецФункции

Функция ПеременнаяТекст(СтрЭлемент) 
	
	Содержимое = СтрЭлемент.Содержимое;
	
	ТД = Новый ТекстовыйДокумент;
	
	Если ЗначениеЗаполнено(Содержимое.Комментарий) Тогда
		ТД.ДобавитьСтроку(ОформитьКомментарий(Содержимое.Комментарий));
	КонецЕсли;
	Если ЗначениеЗаполнено(Содержимое.Контекст) Тогда
		ТД.ДобавитьСтроку(ОформитьКонтекст(Содержимое.Контекст));
	КонецЕсли;
	
	ТД.ДобавитьСтроку(
		ТекстПерем() + " " + ОформитьИменаПеременных(Содержимое.ТаблицаПеременных)
		+ ";"
		+ ОформитьКомментарийОднострочный(Содержимое.КомментарийОднострочный));
	
	Возврат ТД.ПолучитьТекст();
КонецФункции

Функция МетодТекст(СтрЭлемент, ВключатьКод = Истина, ВключатьДокументацию = Истина, ТолькоСигнатура = Ложь)
	Если СтрЭлемент.ТипЭлемента = "Процедура" Тогда
		ОбъявлениеМетода = ТекстПроцедура();
		ОбъявлениеКонецМетода = ТекстКонецПроцедуры();
	ИначеЕсли СтрЭлемент.ТипЭлемента = "Функция" Тогда
		ОбъявлениеМетода = ТекстФункция();
		ОбъявлениеКонецМетода = ТекстКонецФункции();
	Иначе
		ВызватьИсключение "Неправильное использование функции МетодТекст";
	КонецЕсли;
	
	Содержимое = СтрЭлемент.Содержимое;
	
	ТД = Новый ТекстовыйДокумент;
	
	Если ВключатьДокументацию Тогда
		КомментарийКМетоду = СформироватьКомментарийКМетоду(Содержимое);
		Если ЗначениеЗаполнено(КомментарийКМетоду) Тогда
			ТД.ДобавитьСтроку(ОформитьКомментарий(КомментарийКМетоду));
		КонецЕсли;
	КонецЕсли;
	
	Если ВключатьКод Тогда
		Если ЗначениеЗаполнено(Содержимое.Контекст) Тогда
			ТД.ДобавитьСтроку(ОформитьКонтекст(Содержимое.Контекст));
		КонецЕсли;
		Если ЗначениеЗаполнено(Содержимое.Аннотация) Тогда
			ТД.ДобавитьСтроку(ОформитьАннотацию(Содержимое.Аннотация, Содержимое.ИмяРасширяемогоМетода));
		КонецЕсли;
		ТД.ДобавитьСтроку(?(Содержимое.Асинх, "Асинх ", "") + ОбъявлениеМетода + " " + Содержимое.Имя + "(" + ОформитьПараметрыМетода(Содержимое.Параметры) + ")" + ?(Содержимое.Экспортная, " " + ТекстЭкспорт(), "") + ?(ВключатьДокументацию, ОформитьКомментарийОднострочный(СокрЛП(Содержимое.КомментарийОднострочный)), ""));
		Если Не ТолькоСигнатура Тогда
			ТД.ДобавитьСтроку(ОформитьТекстМетода(Содержимое.Тело));
			ТД.ДобавитьСтроку(ОбъявлениеКонецМетода + ?(ВключатьДокументацию, ОформитьКомментарийОднострочный(Содержимое.КомментарийОднострочныйКонец), ""));
		КонецЕсли;
	КонецЕсли;
		
	Возврат ТД.ПолучитьТекст();
КонецФункции

Функция ПроцедураТекст(СтрЭлемент)
	Содержимое = СтрЭлемент.Содержимое;
	
	ТД = Новый ТекстовыйДокумент;
	
	КомментарийКМетоду = СформироватьКомментарийКМетоду(Содержимое);
	Если ЗначениеЗаполнено(КомментарийКМетоду) Тогда
		ТД.ДобавитьСтроку(ОформитьКомментарий(КомментарийКМетоду));
	КонецЕсли;
	Если ЗначениеЗаполнено(Содержимое.Контекст) Тогда
		ТД.ДобавитьСтроку(ОформитьКонтекст(Содержимое.Контекст));
	КонецЕсли;
	Если ЗначениеЗаполнено(Содержимое.Аннотация) Тогда
		ТД.ДобавитьСтроку(ОформитьАннотацию(Содержимое.Аннотация, Содержимое.ИмяРасширяемогоМетода));
	КонецЕсли;
	ТД.ДобавитьСтроку(?(Содержимое.Асинх, ТекстАсинх() + " ", "") + ТекстПроцедура() + " " + Содержимое.Имя + "(" + ОформитьПараметрыМетода(Содержимое.Параметры) + ")" + ?(Содержимое.Экспортная, " " + ТекстЭкспорт(), "") + ОформитьКомментарийОднострочный(СокрЛП(Содержимое.КомментарийОднострочный)));
	ТД.ДобавитьСтроку(ОформитьТекстМетода(Содержимое.Тело));
	ТД.ДобавитьСтроку(ТекстКонецПроцедуры() + ОформитьКомментарийОднострочный(Содержимое.КомментарийОднострочныйКонец));
		
	Возврат ТД.ПолучитьТекст();
КонецФункции

Функция ФункцияТекст(СтрЭлемент)
	Содержимое = СтрЭлемент.Содержимое;
	
	ТД = Новый ТекстовыйДокумент;

	КомментарийКМетоду = СформироватьКомментарийКМетоду(Содержимое);
	
	Если ЗначениеЗаполнено(КомментарийКМетоду) Тогда
		ТД.ДобавитьСтроку(ОформитьКомментарий(КомментарийКМетоду));
	КонецЕсли;
	Если ЗначениеЗаполнено(Содержимое.Контекст) Тогда
		ТД.ДобавитьСтроку(ОформитьКонтекст(Содержимое.Контекст));
	КонецЕсли;
	Если ЗначениеЗаполнено(Содержимое.Аннотация) Тогда
		ТД.ДобавитьСтроку(ОформитьАннотацию(Содержимое.Аннотация, Содержимое.ИмяРасширяемогоМетода));
	КонецЕсли;
	ТД.ДобавитьСтроку(?(Содержимое.Асинх, ТекстАсинх() + " ", "") + ТекстФункция() + " " + Содержимое.Имя + "(" + ОформитьПараметрыМетода(Содержимое.Параметры) + ")" + ?(Содержимое.Экспортная, " " + ТекстЭкспорт(), "") + ОформитьКомментарийОднострочный(Содержимое.КомментарийОднострочный));
	ТД.ДобавитьСтроку(ОформитьТекстМетода(Содержимое.Тело));
	ТД.ДобавитьСтроку(ТекстКонецФункции() + ОформитьКомментарийОднострочный(Содержимое.КомментарийОднострочныйКонец));
		
	Возврат ТД.ПолучитьТекст();
КонецФункции

Функция КодТекст(СтрЭлемент) 
	
	Содержимое = СтрЭлемент.Содержимое;
	
	ТД = Новый ТекстовыйДокумент;
	
	Если ЗначениеЗаполнено(Содержимое.Тело) Тогда
		ТД.ДобавитьСтроку(Содержимое.Тело);
	КонецЕсли;
	
	Возврат ТД.ПолучитьТекст();
КонецФункции

Функция СформироватьКомментарийКМетоду(СодержимоеПодпрограммы)
	
	ТекстКомментария = СодержимоеПодпрограммы.Комментарий;
	Если Не ЗначениеЗаполнено(ТекстКомментария) Тогда
		Если ЕстьДопИнформацияПоПараметрам(СодержимоеПодпрограммы.Параметры)
			ИЛИ (СодержимоеПодпрограммы.Свойство("КомментарийВозвращаемоеЗначение")
				И ЗначениеЗаполнено(СодержимоеПодпрограммы.КомментарийВозвращаемоеЗначение)) Тогда
			ТекстКомментария = СодержимоеПодпрограммы.Имя;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если СтрНайти(НРег(ТекстКомментария), "параметры:") = 0 Тогда
		
		ТекстПараметров = "";
		
		МаксДлинаИмениПараметра = 0;
		МаксДлинаТипаПараметра = 0;
		
		Для каждого ОписаниеПараметра Из СодержимоеПодпрограммы.Параметры Цикл
			МаксДлинаИмениПараметра = Макс(МаксДлинаИмениПараметра, СтрДлина(ОписаниеПараметра.Имя));
			МаксДлинаТипаПараметра = Макс(МаксДлинаТипаПараметра, СтрДлина(ОписаниеПараметра.Тип));
		КонецЦикла;
		
		Для каждого ОписаниеПараметра Из СодержимоеПодпрограммы.Параметры Цикл
			
			ТекстПараметра = "";
			ТекстПараметра = ТекстПараметра + ДополнитьСтроку(ОписаниеПараметра.Имя, МаксДлинаИмениПараметра, " ", "Справа");
			ТекстПараметра = ТекстПараметра + " - ";
			ТекстПараметра = ТекстПараметра + ДополнитьСтроку(ОписаниеПараметра.Тип, МаксДлинаТипаПараметра, " ", "Справа");  			
			ТекстПараметра = ТекстПараметра + " - ";
			ТекстПараметра = ТекстПараметра + ОписаниеПараметра.Описание;
			
			ПодстрокиТекстаПараметра = СтрРазделить(ТекстПараметра, Символы.ПС);
			Для Счетчик = 0 По ПодстрокиТекстаПараметра.Количество() - 1 Цикл
				
				ОтступСлева = "";
				Если Счетчик = 0 Тогда
					ОтступСлева = " ";					
				Иначе
					ОтступСлева = ДополнитьСтроку(ОтступСлева, МаксДлинаИмениПараметра + МаксДлинаТипаПараметра + 7, " ");
				КонецЕсли; 
				
				ПодстрокиТекстаПараметра[Счетчик] = ОтступСлева + ПодстрокиТекстаПараметра[Счетчик];
				
			КонецЦикла; 
			
			ТекстПараметров = ТекстПараметров + ?(ТекстПараметров = "", "", Символы.ПС) + СтрСоединить(ПодстрокиТекстаПараметра, Символы.ПС);
			
		КонецЦикла; 
		
		ТекстКомментария = ТекстКомментария + "
		|
		|Параметры:
		|" + ТекстПараметров;
		
	КонецЕсли; 
	
	Если СодержимоеПодпрограммы.Свойство("КомментарийВозвращаемоеЗначение")
			И ЗначениеЗаполнено(СодержимоеПодпрограммы.КомментарийВозвращаемоеЗначение) Тогда
				
		ТекстКомментария = ТекстКомментария + "
		|
		|Возвращаемое значение:
		| " + СодержимоеПодпрограммы.КомментарийВозвращаемоеЗначение;
				
	КонецЕсли; 
	
	Возврат ТекстКомментария;
	
КонецФункции

Функция ЕстьДопИнформацияПоПараметрам(Параметры)

	Для каждого СтрПараметр Из Параметры Цикл
		
		Если ЗначениеЗаполнено(СтрПараметр.Тип)
			ИЛИ ЗначениеЗаполнено(СтрПараметр.Описание) Тогда
			
			Возврат Истина;	
			
		КонецЕсли;
		
	КонецЦикла;

	Возврат Ложь;	
	
КонецФункции

#КонецОбласти

#Область Инструкции_препроцессора

Функция ТекстИнструкцийПрепроцессора(ИнструкцииПрепроцессора)
	
	КоличествоУстановленныхОпций = 0;
	Для каждого КлючИЗначение Из ИнструкцииПрепроцессора Цикл
		
		Если КлючИЗначение.Значение = Истина Тогда
			КоличествоУстановленныхОпций = КоличествоУстановленныхОпций + 1;		
		КонецЕсли;
		
	КонецЦикла;
	
	ТекстИнструкцийПрепроцессора = "";
	Если КоличествоУстановленныхОпций >= Цел(ИнструкцииПрепроцессора.Количество() / 2) Тогда
		
		
		НачалоТекста = ?(АнглСинтаксис, "#If Not (", "#Если Не (");
		КонецТекста = ?(АнглСинтаксис, ") Then
					  |", ") Тогда
					  |");
		
		Середина = "";
		Для каждого КлючИЗначение Из ИнструкцииПрепроцессора Цикл
			
			Если КлючИЗначение.Значение = Ложь Тогда
				
				Середина = Середина + ?(Середина = "", КлючИЗначение.Ключ, ?(АнглСинтаксис, " Or ", " Или ") + КлючИЗначение.Ключ);
				
			КонецЕсли;
			
		КонецЦикла;
		
		ТекстИнструкцийПрепроцессора = НачалоТекста + Середина + КонецТекста;

	Иначе
		
		
		НачалоТекста = ?(АнглСинтаксис, "#If ", "#Если ");
		КонецТекста = ?(АнглСинтаксис, " Then
					  |", " Тогда
					  |");
		
		Середина = "";
		Для каждого КлючИЗначение Из ИнструкцииПрепроцессора Цикл
			
			Если КлючИЗначение.Значение = Истина Тогда
				
				Середина = Середина + ?(Середина = "", КлючИЗначение.Ключ, ?(АнглСинтаксис, " Or ", " Или ") + КлючИЗначение.Ключ);
				
			КонецЕсли;
			
		КонецЦикла;
		
		ТекстИнструкцийПрепроцессора = НачалоТекста + Середина + КонецТекста;
		
	КонецЕсли; 
	
	Возврат ТекстИнструкцийПрепроцессора;
	
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

Функция ИнструкцииПрепроцессораИдентичны(ИнструкцииПрепроцессора1, ИнструкцииПрепроцессора2)
	
	ИнструкцииПрепроцессораИдентичны = Истина;
	Для Каждого КлючИЗначение Из ИнструкцииПрепроцессора1 Цикл
		Если ИнструкцииПрепроцессора2[КлючИЗначение.Ключ] <> КлючИЗначение.Значение Тогда
			 ИнструкцииПрепроцессораИдентичны = Ложь;
			 Прервать;
		КонецЕсли; 
	КонецЦикла;

	Возврат ИнструкцииПрепроцессораИдентичны;
	
КонецФункции
 
Функция СкопироватьИнструкцииПрепроцессора(ИнструкцииПрепроцессора)
	
	НовыеИнструкцииПрепроцессора = Новый Структура;
	
	Для Каждого КлючИЗначение Из ИнструкцииПрепроцессора Цикл
		НовыеИнструкцииПрепроцессора.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	Возврат НовыеИнструкцииПрепроцессора;
	
КонецФункции

Функция СтруктураИнструкцийПрепроцессораПоУмолчанию()
	Возврат Обработки.ОМ_ОформляторМодулей.СтруктураИнструкцийПрепроцессораПоУмолчанию();
КонецФункции

#КонецОбласти 

#КонецОбласти

#Область КлючевыеСлова

Функция ТекстОбластьНачало() Экспорт 
	Возврат ?(АнглСинтаксис, "#Region", "#Область");
КонецФункции

Функция ТекстОбластьКонец() Экспорт
	Возврат ?(АнглСинтаксис, "#EndRegion", "#КонецОбласти");
КонецФункции

Функция ТекстПроцедура() Экспорт
	Возврат ?(АнглСинтаксис, "Procedure", "Процедура");
КонецФункции

Функция ТекстКонецПроцедуры() Экспорт
	Возврат ?(АнглСинтаксис, "EndProcedure", "КонецПроцедуры");
КонецФункции

Функция ТекстФункция() Экспорт
	Возврат ?(АнглСинтаксис, "Function", "Функция");
КонецФункции

Функция ТекстКонецФункции() Экспорт
	Возврат ?(АнглСинтаксис, "EndFunction", "КонецФункции");
КонецФункции

Функция ТекстЭкспорт() Экспорт
	Возврат ?(АнглСинтаксис, "Export", "Экспорт");
КонецФункции

Функция ТекстПерем() Экспорт
	Возврат ?(АнглСинтаксис, "Var", "Перем");
КонецФункции

Функция ТекстЗнач() Экспорт
	Возврат ?(АнглСинтаксис, "Val", "Знач");
КонецФункции

Функция ТекстАсинх() Экспорт
	Возврат ?(АнглСинтаксис, "Async", "Асинх");
КонецФункции

#КонецОбласти

#Область Служебное

// Дополняет строку символами слева или справа до заданной длины и возвращает ее.
// При этом удаляются незначащие символы слева и справа (подробнее про незначащие символы 
// см. синтакс-помощник к методу платформы СокрЛП). 
// По умолчанию функция дополняет строку символами "0" (ноль) слева.
//
// Параметры:
//  Значение    - Строка - исходная строка, которую необходимо дополнить символами;
//  ДлинаСтроки - Число  - требуемая результирующая длина строки;
//  Символ      - Строка - символ, которым необходимо дополнить строку;
//  Режим       - Строка - "Слева" или "Справа" - вариант добавления символов к исходной строке.
// 
// Возвращаемое значение:
//  Строка - строка, дополненная символами.
//
// Пример:
//  1. Результат = СтроковыеФункцииКлиентСервер.ДополнитьСтроку("1234", 10, "0", "Слева");
//  Возвращает: "0000001234".
//
//  2. Результат = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(" 1234  ", 10, "#", "Справа");
//  Строка = " 1234  "; ДлинаСтроки = 10; Символ = "#"; Режим = "Справа"
//  Возвращает: "1234######".
//
Функция ДополнитьСтроку(Знач Значение, Знач ДлинаСтроки, Знач Символ = "0", Знач Режим = "Слева") Экспорт
	
	// Длина символа не должна превышать единицы.
	Символ = Лев(Символ, 1);
	
	// Удаляем крайние пробелы слева и справа строки.
	Значение = СокрЛП(Значение);
	КоличествоСимволовНадоДобавить = ДлинаСтроки - СтрДлина(Значение);
	
	Если КоличествоСимволовНадоДобавить > 0 Тогда
		
		СтрокаДляДобавления = СформироватьСтрокуСимволов(Символ, КоличествоСимволовНадоДобавить);
		Если ВРег(Режим) = "СЛЕВА" Тогда
			Значение = СтрокаДляДобавления + Значение;
		ИначеЕсли ВРег(Режим) = "СПРАВА" Тогда
			Значение = Значение + СтрокаДляДобавления;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

// Формирует строку повторяющихся символов заданной длины.
//
// Параметры:
//  Символ      - Строка - символ, из которого будет формироваться строка.
//  ДлинаСтроки - Число  - требуемая длина результирующей строки.
//
// Возвращаемое значение:
//  Строка - строка, состоящая из повторяющихся символов.
//
Функция СформироватьСтрокуСимволов(Знач Символ, Знач ДлинаСтроки) Экспорт
	
	Результат = "";
	Для Счетчик = 1 По ДлинаСтроки Цикл
		Результат = Результат + Символ;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти 

