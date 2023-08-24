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
	
	Если Не ЗначениеЗаполнено(ОтветственныйЗаОбработкуПерсональныхДанных) Тогда
		ОтветственныйЗаОбработкуПерсональныхДанных = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Элементы.ПричинаУничтожения.СписокВыбора.ЗагрузитьЗначения(
		ОбщегоНазначения.ВыгрузитьКолонку(Документы.АктОбУничтоженииПерсональныхДанных.ПричиныУничтожения(), "Значение"));
	Элементы.СпособУничтожения.СписокВыбора.ЗагрузитьЗначения(
		ОбщегоНазначения.ВыгрузитьКолонку(Документы.АктОбУничтоженииПерсональныхДанных.СпособыУничтожения(), "Значение"));

	СубъектыИОрганизации = Параметры.СубъектыИОрганизации.ВыгрузитьЗначения();
	Субъекты = ОбщегоНазначения.ВыгрузитьКолонку(СубъектыИОрганизации, "Субъект") ;
	Организации = ОбщегоНазначения.ВыгрузитьКолонку(СубъектыИОрганизации, "Организация") ;
	ТекстПредупреждения = ТекстПредупреждения(Субъекты);
	
	УстановитьВидимостьОрганизации(Организации);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ВсеОрганизацииЗаполнены Тогда
		ИндексОрганизации = ПроверяемыеРеквизиты.Найти("Организация");
		Если ИндексОрганизации <> Неопределено Тогда
			ПроверяемыеРеквизиты.Удалить(ИндексОрганизации);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьАкты(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Организация", Организация);
	Результат.Вставить("ПричинаУничтожения", ПричинаУничтожения);
	Результат.Вставить("СпособУничтожения", СпособУничтожения);
	Результат.Вставить("ОтветственныйЗаОбработкуПерсональныхДанных", ОтветственныйЗаОбработкуПерсональныхДанных);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  Субъекты - Массив из ОпределяемыйТип.СубъектПерсональныхДанных
// 
// Возвращаемое значение:
//  ФорматированнаяСтрока
//
&НаСервереБезКонтекста
Функция ТекстПредупреждения(Субъекты)
	
	ПредставлениеОдного = НСтр("ru = 'Для выбранного субъекта будет создан акт';
								|en = 'A certificate will be created for the selected subject'");
	ПредставлениеНескольких = НСтр("ru = 'Для %1 выбранных субъектов будут созданы акты';
									|en = 'Certificates will be created for %1 selected subjects'");
	
	НачалоСтроки = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = ';%1;;%2;%2;';
																	|en = ';%1;;%2;%2;'"),
			ПредставлениеОдного, ПредставлениеНескольких),
		Субъекты.Количество());
	
	ШаблонСтроки = НСтр("ru = '%1, в результате чего персональные данные будут <b>полностью уничтожены</b>.
		|Обратите внимание, что это необратимая операция, и уничтоженные данные нельзя будет восстановить.';
		|en = '%1. After that, the personal data will be <b>destroyed completely</b>.
		|This operation is irreversible, and the destroyed data cannot be restored.'");
		
	ФорматированнаяСтрока = СтроковыеФункции.ФорматированнаяСтрока(ШаблонСтроки, НачалоСтроки);
	
	Возврат ФорматированнаяСтрока;
	
КонецФункции

&НаСервере
Процедура УстановитьВидимостьОрганизации(Организации)

	ВсеОрганизацииЗаполнены = Истина;
	ВсеОрганизацииПустые = Истина;
	
	ЗаполненныеОрганизации = Новый Массив;
	
	Для Каждого Организация Из Организации Цикл
		Если ЗначениеЗаполнено(Организация) Тогда
			ВсеОрганизацииПустые = Ложь;
			ЗаполненныеОрганизации.Добавить(Организация);
		Иначе
			ВсеОрганизацииЗаполнены = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Если ВсеОрганизацииПустые Тогда
		ТекстОрганизации = СтроковыеФункции.ФорматированнаяСтрока(НСтр("ru = 'Акты формируются от имени:';
																		|en = 'Certificates are generated on behalf of:'"));
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ТекстОрганизации", "Высота", 1);
		Возврат;
	КонецЕсли;
	
	ОрганизацииСтрокой = СтрСоединить(ЗаполненныеОрганизации, ", ");
	
	Если ВсеОрганизацииЗаполнены Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Организация", "Видимость", Ложь);
		ТекстОрганизации = СтроковыеФункции.ФорматированнаяСтрока(НСтр("ru = 'Акты формируются от имени: <b>%1</b>.';
																		|en = 'Certificates are generated on behalf of <b>%1</b>.'"),
			ОрганизацииСтрокой);
	Иначе	
		ТекстОрганизации = СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = 'Акты формируются от имени: <b>%1</b>, а также организации:';
				|en = 'Certificates are generated on behalf of <b>%1</b> and on behalf of:'"), ОрганизацииСтрокой);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
