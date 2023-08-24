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

	СтруктураЗаписи = Неопределено;
	Если Не Параметры.Свойство("СтруктураЗаписи", СтруктураЗаписи) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр(
			"ru = 'Просмотр снимка отчета доступен только из списка снимков отчетов пользователя.';
			|en = 'You can view a report snapshot only from the list of user report snapshots.'"), , , , Отказ);
		Возврат;
	КонецЕсли;

	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураЗаписи);

	УстановитьПривилегированныйРежим(Истина);

	Запись = РегистрыСведений.СнимкиОтчетов.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Запись, Параметры.СтруктураЗаписи);
	Запись.Прочитать();
	Если Не Запись.Выбран() Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не найдена запись по указанным параметрам.';
													|en = 'No record is found by the specified parameters.'"), , , , Отказ);
	ИначеЕсли Запись.ОшибкаОбновленияОтчета Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Снимок отчета не был сформирован.';
													|en = 'Report snapshot is not generated.'"), , , , Отказ);
	КонецЕсли;
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	РезультатОтчета = Запись.РезультатОтчета.Получить();
	Если ТипЗнч(РезультатОтчета) = Тип("ТабличныйДокумент") Тогда
		ТабДокумент.Вывести(РезультатОтчета);
	Иначе
		ОбщегоНазначения.СообщитьПользователю(НСтр(
			"ru = 'Ошибка при чтении снимка отчета - некорректные данные.';
			|en = 'An error occurred when reading the report snapshot: the data is incorrect.'"), , , , Отказ);
	КонецЕсли;

	Если Не Отказ Тогда
		Запись.ДатаПоследнегоПросмотра = ТекущаяДатаСеанса();
		Запись.Записать();
	КонецЕсли;

	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

#КонецОбласти