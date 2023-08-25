///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// См. СерверныеОповещения.НедоставленныеСерверныеОповещенияСеанса
Функция НедоставленныеСерверныеОповещенияСеанса(Знач Параметры) Экспорт
	
	Возврат СерверныеОповещения.НедоставленныеСерверныеОповещенияСеанса(Параметры);
	
КонецФункции

// Параметры:
//  Описание - Структура:
//   * Дата - Дата
//   * Идентификатор - Строка
//   * Обсуждение - Строка
//   * Текст - Строка
//   * ПодробноеПредставлениеОшибки - Строка
//
Процедура ЗарегистрироватьОшибкуПолученияДанныхИзСообщения(Знач Описание) Экспорт
	
	Если СтрЧислоСтрок(Описание.Текст) = 3 Тогда
		ИмяОповещения = СокрЛП(СтрПолучитьСтроку(Описание.Текст, 1));
		ИдентификаторОповещения = НРег(СокрЛП(СтрПолучитьСтроку(Описание.Текст, 2)));
		ИмяПроцедурыДлительнойОперации = СокрЛП(СтрПолучитьСтроку(Описание.Текст, 3));
		Если СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(ИдентификаторОповещения) Тогда
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("ИдентификаторОповещения", ИдентификаторОповещения);
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ОтправленныеСерверныеОповещения.СодержимоеОповещения КАК СодержимоеОповещения
			|ИЗ
			|	РегистрСведений.ОтправленныеСерверныеОповещения КАК ОтправленныеСерверныеОповещения
			|ГДЕ
			|	ОтправленныеСерверныеОповещения.ИдентификаторОповещения <> &ИдентификаторОповещения";
			УстановитьПривилегированныйРежим(Истина);
			Выборка = Запрос.Выполнить().Выбрать();
			УстановитьПривилегированныйРежим(Ложь);
			Если Выборка.Следующий() Тогда
				СодержимоеОповещения = Выборка.СодержимоеОповещения;
				Если ТипЗнч(СодержимоеОповещения) = Тип("ХранилищеЗначения") Тогда
					СодержимоеОповещенияXML = XMLСтрока(СодержимоеОповещения);
				КонецЕсли;
			Иначе
				СодержимоеОповещенияXML = "<" + НСтр("ru = 'Содержимое оповещения не найдено в базе данных';
													|en = 'The notification content is not found in the database'") + ">"; 
			КонецЕсли;
		Иначе
			СодержимоеОповещенияXML = "<" + НСтр("ru = 'Идентификатор оповещения не является уникальным идентификатором';
												|en = 'The notification ID is not a UUID'") + ">"; 
		КонецЕсли;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ИмяОповещения) Тогда
		ИмяОповещения = "<" + НСтр("ru = 'Нет данных';
									|en = 'No data'") + ">";
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ИдентификаторОповещения) Тогда
		ИдентификаторОповещения = "<" + НСтр("ru = 'Нет данных';
											|en = 'No data'") + ">";
	КонецЕсли;
	
	ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'При обращении к свойству ""%1"" сообщения системы взаимодействия со свойствами:
		           |- Дата: %2
		           |- Идентификатор: %3
		           |- Обсуждение: %4
		           |- Текст
		           |	Имя оповещения: %5
		           |	Идентификатор оповещения: %6';
		           |en = 'When accessing the ""%1"" property of the collaboration system message with properties:
		           |- Date: %2
		           |- ID: %3
		           |- Conversation: %4
		           |- Text
		           |	Notification name: %5
		           |	Notification ID: %6'"),
		"Данные",
		Описание.Дата,
		Описание.Идентификатор,
		Описание.Обсуждение,
		ИмяОповещения,
		ИдентификаторОповещения);
	
	Если ЗначениеЗаполнено(ИмяПроцедурыДлительнойОперации)
	   И ИмяПроцедурыДлительнойОперации <> "-" Тогда
		
		ТекстОшибки = ТекстОшибки + "
		|	" + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Имя процедуры длительной операции: %1';
				|en = 'Long-running operation procedure name: %1'"),
			ИмяПроцедурыДлительнойОперации);
	КонецЕсли;
	
	ТекстОшибки = ТекстОшибки + Символы.ПС;
	ТекстОшибки = ТекстОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Возникла ошибка:
		           |
		           |%1';
		           |en = 'An error occurred:
		           |
		           |%1'"),
		Описание.ПодробноеПредставлениеОшибки);
	
	Если ЗначениеЗаполнено(СодержимоеОповещенияXML)
	   И ИдентификаторОповещения <> "-" Тогда
		
		ТекстОшибки = ТекстОшибки + Символы.ПС + Символы.ПС;
		ТекстОшибки = ТекстОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Содержимое оповещения в формате хранилища значения в XML (из базы данных):
			           |%1';
			           |en = 'Notification content in a value storage format in XML (from the database):
			           |%1'"),
			СодержимоеОповещенияXML);
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Серверные оповещения.Ошибка получения данных оповещения из сообщения';
			|en = 'Server notifications.An error occurred when receiving the notification data from the message'",
			ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка,, ИмяОповещения, ТекстОшибки);
	
КонецПроцедуры

// Параметры:
//  Комментарий - Строка - комментарий для журнала регистрации
//
Процедура ЗаписатьПоказателиПроизводительности(Знач Комментарий) Экспорт
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Серверные оповещения.Показатели производительности';
			|en = 'Server notifications.Performance indicators'",
			ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация,,, Комментарий);
	
КонецПроцедуры

#КонецОбласти
