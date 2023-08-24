///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается при получении представления объекта или ссылки в зависимости от языка,
// используемого при работе пользователя.
//
// Параметры:
//  Данные               - Структура - содержит значения полей, из которых формируется представление.
//  Представление        - Строка - в данный параметр нужно поместить сформированное представление.
//  СтандартнаяОбработка - Булево - в данный параметр передается признак формирования стандартного представления.
//  ИмяРеквизита         - Строка - указывает, в каком реквизите хранится представление на основном языке.
//
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка, ИмяРеквизита = "Наименование") Экспорт
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		
		Если МультиязычностьСервер.ЭтоОсновнойЯзык() Тогда
			Возврат;
		КонецЕсли;
		
		СуффиксЯзыка = МультиязычностьСервер.СуффиксТекущегоЯзыка();
		Если ЗначениеЗаполнено(СуффиксЯзыка) Тогда
	
			Если Данные.Свойство(ИмяРеквизита + СуффиксЯзыка) Тогда
				
				Представление = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Данные.Ссылка, ИмяРеквизита, ,
					ТекущийЯзык().КодЯзыка);
				Если ПустаяСтрока(Представление) И Данные.Свойство(ИмяРеквизита) Тогда
					Представление = Данные[ИмяРеквизита];
					Если ПустаяСтрока(Представление) Тогда
						Возврат;
					КонецЕсли;
				КонецЕсли;
				
				СтандартнаяОбработка = Ложь;
				Возврат;
				
			КонецЕсли;
	
		КонецЕсли;
			
		Если Данные.Свойство("Ссылка") Или Данные.Ссылка <> Неопределено Тогда
			Если МультиязычностьСервер.ОбъектСодержитТЧПредставления(Данные.Ссылка, ИмяРеквизита) Тогда
				ТекстЗапроса = 
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	&ИмяРеквизита КАК Наименование
				|ИЗ
				|	&Представления КАК Представления
				|ГДЕ
				|	Представления.КодЯзыка = &Язык
				|	И Представления.Ссылка = &Ссылка";
				
				ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяРеквизита", "Представления." + ИмяРеквизита);
				ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Представления", Данные.Ссылка.Метаданные().ПолноеИмя() + ".Представления");
				
				Запрос = Новый Запрос(ТекстЗапроса);
				
				Запрос.УстановитьПараметр("Ссылка", Данные.Ссылка);
				Запрос.УстановитьПараметр("Язык",   ТекущийЯзык().КодЯзыка);
				
				РезультатЗапроса = Запрос.Выполнить();
				Если Не РезультатЗапроса.Пустой() Тогда
					СтандартнаяОбработка = Ложь;
					Представление = РезультатЗапроса.Выгрузить()[0].Наименование;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	#КонецЕсли
	
КонецПроцедуры

// Вызывается для формирования состава полей, из которых формируется представление объекта или ссылки.
// Состав полей формируется с учетом текущего языка пользователя.
//
// Параметры:
//  Поля                 - Массив - массив, содержащий имена полей, которые нужны для формирования представления объекта
//                                  или ссылки.
//  СтандартнаяОбработка - Булево - в данный параметр передается признак выполнения стандартной (системной) обработки события.
//                                  Если в теле процедуры-обработчика установить данному параметру значение Ложь,
//                                  стандартная обработка события производиться не будет.
//  ИмяРеквизита         - Строка - указывает, в каком реквизите хранится представление на основном языке.
//
Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка, ИмяРеквизита = "Наименование") Экспорт
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		
		Если МультиязычностьСервер.ЭтоОсновнойЯзык() Тогда
			Возврат;
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		Поля.Добавить(ИмяРеквизита);
		Поля.Добавить("Ссылка");
		
		Если МультиязычностьСервер.ИспользуетсяПервыйДополнительныйЯзык() Тогда
			Поля.Добавить(ИмяРеквизита + "Язык1");
		КонецЕсли;
		
		Если МультиязычностьСервер.ИспользуетсяВторойДополнительныйЯзык() Тогда
			Поля.Добавить(ИмяРеквизита +"Язык2");
		КонецЕсли;
	
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти