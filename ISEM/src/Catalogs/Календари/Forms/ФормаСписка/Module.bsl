///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
	КонецЕсли;
	
	УстановитьПараметрыСписка();
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.Календари);
	ЕстьГрупповоеИзменениеРеквизитов = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов");
	Элементы.СписокИзменитьВыделенные.Видимость = ЕстьГрупповоеИзменениеРеквизитов И МожноРедактировать;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Календари", Строки.ПолучитьКлючи());
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КалендарныеГрафики.Календарь КАК ГрафикРаботы,
		|	МАКСИМУМ(КалендарныеГрафики.ДатаГрафика) КАК ДатаЗаполненности
		|ПОМЕСТИТЬ ВТДатыЗаполненностиГрафиков
		|ИЗ
		|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
		|ГДЕ
		|	КалендарныеГрафики.Календарь В(&Календари)
		|
		|СГРУППИРОВАТЬ ПО
		|	КалендарныеГрафики.Календарь
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеПроизводственныхКалендарей.ПроизводственныйКалендарь КАК ПроизводственныйКалендарь,
		|	МАКСИМУМ(ДанныеПроизводственныхКалендарей.Дата) КАК ДатаЗаполненности
		|ПОМЕСТИТЬ ВТДатыЗаполненностиКалендарей
		|ИЗ
		|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственныхКалендарей
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Календари КАК Календари
		|		ПО (Календари.ПроизводственныйКалендарь = ДанныеПроизводственныхКалендарей.ПроизводственныйКалендарь)
		|			И (Календари.Ссылка В (&Календари))
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеПроизводственныхКалендарей.ПроизводственныйКалендарь
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СправочникГрафикиРаботы.Ссылка КАК Ссылка,
		|	СправочникГрафикиРаботы.ГоризонтПланирования КАК ГоризонтПланирования,
		|	СправочникГрафикиРаботы.ДатаОкончания КАК ДатаОкончания,
		|	СправочникГрафикиРаботы.ПроизводственныйКалендарь КАК ПроизводственныйКалендарь,
		|	ЕСТЬNULL(ДанныеГрафиков.ДатаЗаполненности, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаЗаполненности,
		|	ЕСТЬNULL(ДанныеПроизводственныхКалендарей.ДатаЗаполненности, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаЗаполненностиПроизводственногоКалендаря
		|ИЗ
		|	Справочник.Календари КАК СправочникГрафикиРаботы
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДатыЗаполненностиГрафиков КАК ДанныеГрафиков
		|		ПО СправочникГрафикиРаботы.Ссылка = ДанныеГрафиков.ГрафикРаботы
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДатыЗаполненностиКалендарей КАК ДанныеПроизводственныхКалендарей
		|		ПО СправочникГрафикиРаботы.ПроизводственныйКалендарь = ДанныеПроизводственныхКалендарей.ПроизводственныйКалендарь
		|ГДЕ
		|	СправочникГрафикиРаботы.Ссылка В(&Календари)
		|	И НЕ СправочникГрафикиРаботы.ЭтоГруппа";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДатаНеобходимойЗаполненности = ДобавитьМесяц(ТекущаяДатаСеанса(), Выборка.ГоризонтПланирования);
		ТребуетЗаполнения = Выборка.ДатаЗаполненности < ДатаНеобходимойЗаполненности;
		СтрокаСписка = Строки[Выборка.Ссылка];
		СтрокаСписка.Данные["ДатаЗаполненности"] = Выборка.ДатаЗаполненности;
		СтрокаСписка.Данные["ДатаЗаполненностиПроизводственногоКалендаря"] = Выборка.ДатаЗаполненностиПроизводственногоКалендаря;
		СтрокаСписка.Данные["ТребуетЗаполнения"] = ТребуетЗаполнения;
		СтрокаСписка.Данные["ДатаНеобходимойЗаполненности"] = ДатаНеобходимойЗаполненности;
		Если Не ТребуетЗаполнения Тогда
			Продолжить;
		КонецЕсли;
		Для Каждого КлючИЗначение Из СтрокаСписка.Оформление Цикл
			КлючИЗначение.Значение.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
		КонецЦикла;
		ВозможнаяПричина = "";
		Если ЗначениеЗаполнено(Выборка.ПроизводственныйКалендарь) Тогда
			Если Не ЗначениеЗаполнено(Выборка.ДатаЗаполненностиПроизводственногоКалендаря) Тогда
				ВозможнаяПричина = НСтр("ru = 'Производственный календарь не заполнен';
										|en = 'The business calendar is blank.'");
			Иначе
				Если Выборка.ДатаЗаполненностиПроизводственногоКалендаря < ДатаНеобходимойЗаполненности Тогда
					ВозможнаяПричина = НСтр("ru = 'Производственный календарь не заполнен на очередной календарный год';
											|en = 'The business calendar for the next calendar year is blank.'");
				КонецЕсли;
			КонецЕсли;
		Иначе
			Если Не ЗначениеЗаполнено(Выборка.ДатаОкончания) Тогда
				ВозможнаяПричина = НСтр("ru = 'График не был заполнен на очередной календарный год';
										|en = 'The schedule for the next calendar year was not filled in.'");
			Иначе
				Если Выборка.ДатаОкончания < ДатаНеобходимойЗаполненности Тогда
					ВозможнаяПричина = НСтр("ru = 'Период заполнения графика ограничен (см. поле ""Дата окончания"").';
											|en = 'The schedule period is limited (see the ""End date"" field).'")
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		СтрокаСписка.Данные["ВозможнаяПричина"] = ВозможнаяПричина;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов") Тогда
		МодульГрупповоеИзменениеОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ГрупповоеИзменениеОбъектовКлиент");
		МодульГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПараметрыСписка()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ВладелецГрафика", , ВидСравненияКомпоновкиДанных.НеЗаполнено, , ,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
	
КонецПроцедуры

#КонецОбласти
