﻿#Область ПрограммныйИнтерфейс

Процедура ДобавитьКомандыДействий(КомандыДействий) Экспорт
	НоваяСтрока = КомандыДействий.Добавить();
	НоваяСтрока.Представление = "Установка инструкций препроцессора";
	НоваяСтрока.Идентификатор = "УстановкаИнструкцийПрепроцессора";
	НоваяСтрока.Порядок = 500;
	НоваяСтрока.СпособЗапускаДействия = "ВызовМетодаМодуляМенеджера";

	НоваяСтрока = КомандыДействий.Добавить();
	НоваяСтрока.Представление = "Установка инструкций препроцессора";
	НоваяСтрока.Идентификатор = "УстановкаИнструкцийПрепроцессораВыбранногоМодуля";
	НоваяСтрока.ОбластьДействия = "Модуль";
	НоваяСтрока.Порядок = 500;
	НоваяСтрока.СпособЗапускаДействия = "ВызовМетодаМодуляМенеджера";
КонецПроцедуры

Процедура ВыполнитьДействие(ИдКоманды, ПараметрыКоманды) Экспорт
	Если ИдКоманды = "УстановкаИнструкцийПрепроцессора" Тогда
		УстановитьИнструкцииПрепроцессораДляМодуляМенеджера(ПараметрыКоманды.ДеревоСтруктурыМодулей);
	ИначеЕсли ИдКоманды = "УстановкаИнструкцийПрепроцессораВыбранногоМодуля" Тогда
		Для каждого СтрокаДерева Из ПараметрыКоманды.ДеревоСтруктурыМодулей.Строки Цикл
			Если СтрокаДерева.Выбрана Тогда
				УстановитьИнструкцииПрепроцессораДляМодуляМенеджера(СтрокаДерева);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Процедура УстановитьИнструкцииПрепроцессораДляМодуляМенеджера(ДеревоСтруктуры) Экспорт
	ОбработкаУстановкиИнструкций().УстановитьИнструкцииПрепроцессораДляМодуляМенеджера(ДеревоСтруктуры);
КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОбработкаУстановкиИнструкций()
	Возврат Обработки.ОМ_Компонент_УстановкаИнструкцийПрепроцессора.Создать();
КонецФункции

#КонецОбласти
