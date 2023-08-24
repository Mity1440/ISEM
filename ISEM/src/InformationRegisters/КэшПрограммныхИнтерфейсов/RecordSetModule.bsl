///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОписаниеПеременных

Перем ТребуетсяКонтроль;
Перем ДанныеДляЗаписи;
Перем ПодготовленыДанные;

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	// Проверка значения свойства ОбменДанными.Загрузка отсутствует по причине того, что ограничения,
	// накладываемые данным кодом, не должны обходить установкой этого свойства равным Истина
	// (на стороне кода, который выполняет попытку записи в данный регистр).
	//
	// Данный регистр не должен входить в любые обмены или операции выгрузки / загрузки данных при включенном
	// разделении по областям данных.
	
	Если ПодготовленыДанные Тогда
		Загрузить(ДанныеДляЗаписи);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	// Проверка значения свойства ОбменДанными.Загрузка отсутствует по причине того, что ограничения,
	// накладываемые данным кодом, не должны обходить установкой этого свойства равным Истина
	// (на стороне кода, который выполняет попытку записи в данный регистр).
	//
	// Данный регистр не должен входить в любые обмены или операции выгрузки / загрузки данных при включенном
	// разделении по областям данных.
	
	Если ТребуетсяКонтроль Тогда
		
		Для Каждого Запись Из ЭтотОбъект Цикл
			
			КонтрольныеСтроки = ДанныеДляЗаписи.НайтиСтроки(
				Новый Структура("Идентификатор, ТипДанных", Запись.Идентификатор, Запись.ТипДанных));
			
			Если КонтрольныеСтроки.Количество() <> 1 Тогда
				ВызватьИсключениеКонтроля();
			КонецЕсли;
				
			КонтрольнаяСтрока = КонтрольныеСтроки.Получить(0);
			
			ТекущиеДанные = ОбщегоНазначения.ЗначениеВСтрокуXML(Запись.Данные.Получить());
			КонтрольныеДанные = ОбщегоНазначения.ЗначениеВСтрокуXML(КонтрольнаяСтрока.Данные.Получить());
			
			Если ТекущиеДанные <> КонтрольныеДанные Тогда
				ВызватьИсключениеКонтроля();
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПодготовитьДанныеДляЗаписи() Экспорт
	
	ПараметрыПолучения = Неопределено;
	Если Не ДополнительныеСвойства.Свойство("ПараметрыПолучения", ПараметрыПолучения) Тогда
		ВызватьИсключение НСтр("ru = 'Не определены параметры получения данных';
								|en = 'The data getting parameters are not defined.'");
	КонецЕсли;
	
	ДанныеДляЗаписи = Выгрузить();
	
	Для Каждого Строка Из ДанныеДляЗаписи Цикл
		
		Данные = РегистрыСведений.КэшПрограммныхИнтерфейсов.ПодготовитьДанныеКэшаВерсий(Строка.ТипДанных, ПараметрыПолучения);
		Строка.Данные = Новый ХранилищеЗначения(Данные);
		
	КонецЦикла;
	
	ПодготовленыДанные = Истина;
	
КонецПроцедуры

Процедура ВызватьИсключениеКонтроля()
	
	ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Недопустимое изменение ресурса %1 записи регистра сведений %2
			|внутри транзакции записи из сеанса с включенным разделением.';
			|en = 'The %1 resource of the %2 information register record cannot be changed
			|inside the record transaction from the session with separation enabled.'"),
		"Данные", "КэшПрограммныхИнтерфейсов");
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ДанныеДляЗаписи = Новый ТаблицаЗначений();
ТребуетсяКонтроль = ОбщегоНазначения.РазделениеВключено() И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных();
ПодготовленыДанные = Ложь;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли