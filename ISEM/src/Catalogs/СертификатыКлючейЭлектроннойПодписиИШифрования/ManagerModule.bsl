///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("КомуВыдан");
	НеРедактируемыеРеквизиты.Добавить("Фирма");
	НеРедактируемыеРеквизиты.Добавить("Фамилия");
	НеРедактируемыеРеквизиты.Добавить("Имя");
	НеРедактируемыеРеквизиты.Добавить("Отчество");
	НеРедактируемыеРеквизиты.Добавить("Должность");
	НеРедактируемыеРеквизиты.Добавить("КемВыдан");
	НеРедактируемыеРеквизиты.Добавить("ДействителенДо");
	НеРедактируемыеРеквизиты.Добавить("Подписание");
	НеРедактируемыеРеквизиты.Добавить("Шифрование");
	НеРедактируемыеРеквизиты.Добавить("Отпечаток");
	НеРедактируемыеРеквизиты.Добавить("ДанныеСертификата");
	НеРедактируемыеРеквизиты.Добавить("Программа");
	НеРедактируемыеРеквизиты.Добавить("Отозван");
	НеРедактируемыеРеквизиты.Добавить("ВводитьПарольВПрограммеЭлектроннойПодписи");
	НеРедактируемыеРеквизиты.Добавить("Организация");
	НеРедактируемыеРеквизиты.Добавить("Пользователь");
	НеРедактируемыеРеквизиты.Добавить("Добавил");
	
	Если Метаданные.Обработки.Найти("ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата") <> Неопределено Тогда
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата =
			ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
				"Обработка.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата");
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.РеквизитыНеРедактируемыеВГрупповойОбработке(
			НеРедактируемыеРеквизиты);
	КонецЕсли;
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаСписка" Тогда
		СтандартнаяОбработка = Ложь;
		Параметры.Вставить("ПоказатьСтраницуСертификаты");
		ВыбраннаяФорма = Метаданные.ОбщиеФормы.НастройкиЭлектроннойПодписиИШифрования;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления.

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// для которых необходимо обновить записи в регистре.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СертификатыКлючейЭлектроннойПодписиИШифрованияПользователи.Ссылка,
	|	КОЛИЧЕСТВО(СертификатыКлючейЭлектроннойПодписиИШифрованияПользователи.Пользователь) КАК Пользователь
	|ПОМЕСТИТЬ ОдинПользовательВТабличнойЧасти
	|ИЗ
	|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.Пользователи КАК
	|		СертификатыКлючейЭлектроннойПодписиИШифрованияПользователи
	|СГРУППИРОВАТЬ ПО
	|	СертификатыКлючейЭлектроннойПодписиИШифрованияПользователи.Ссылка
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(СертификатыКлючейЭлектроннойПодписиИШифрованияПользователи.Пользователь) = 1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СертификатыКлючейЭлектроннойПодписиИШифрования.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК СертификатыКлючейЭлектроннойПодписиИШифрования
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОдинПользовательВТабличнойЧасти КАК ОдинПользовательВТабличнойЧасти
	|		ПО СертификатыКлючейЭлектроннойПодписиИШифрования.Ссылка = ОдинПользовательВТабличнойЧасти.Ссылка
	|ГДЕ
	|	СертификатыКлючейЭлектроннойПодписиИШифрования.УдалитьПользовательОповещенОСрокеДействия
	|	ИЛИ &УсловиеЗаявления
	|	ИЛИ НЕ ОдинПользовательВТабличнойЧасти.Ссылка ЕСТЬ NULL";

	
	Если ЭлектроннаяПодпись.ОбщиеНастройки().ЗаявлениеНаВыпускСертификатаДоступно Тогда
		
		МодульЗаявлениеНаВыпускНовогоКвалифицированногоСертификата = ОбщегоНазначения.ОбщийМодуль(
			"Обработки.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеЗаявления",
			"СертификатыКлючейЭлектроннойПодписиИШифрования.УдалитьСостояниеЗаявления <> &ПустаяСсылка");
		Запрос.УстановитьПараметр("ПустаяСсылка", 
			МодульЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.СостоянияЗаявленияПустаяСсылка());
		
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИЛИ &УсловиеЗаявления", "");
	КонецЕсли;

	МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

// Добавить записи регистра.
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь,
		"Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования");
	Если Выборка.Количество() > 0 Тогда
		ОбработатьЗаявленияИОповещенияСертификатов(Выборка);
	КонецЕсли;

	ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь,
		"Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования");
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработатьЗаявленияИОповещенияСертификатов(Выборка)
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;

	ЗаявлениеНаВыпускСертификатаДоступно = ЭлектроннаяПодпись.ОбщиеНастройки().ЗаявлениеНаВыпускСертификатаДоступно;
	
	Если ЗаявлениеНаВыпускСертификатаДоступно Тогда
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата =
			ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
				"Обработка.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата");
	КонецЕсли;		
	
	Пока Выборка.Следующий() Цикл

		ПредставлениеСсылки = Строка(Выборка.Ссылка);

		НачатьТранзакцию();
		Попытка

			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
			Блокировка.Заблокировать();

			СертификатОбъект = Выборка.Ссылка.ПолучитьОбъект(); // СправочникОбъект.СертификатыКлючейЭлектроннойПодписиИШифрования
			
			// Перенос оповещений о необходимости замены сертификата в регистр сведений.
			Если СертификатОбъект.УдалитьПользовательОповещенОСрокеДействия Тогда
				НаборЗаписейОповещений = РегистрыСведений.ОповещенияПользователейСертификатов.СоздатьНаборЗаписей();
				НаборЗаписейОповещений.Отбор.Сертификат.Установить(Выборка.Ссылка);

				Если СертификатОбъект.Пользователи.Количество() > 0 Тогда
					
					ТаблицаПользователей = СертификатОбъект.Пользователи.Выгрузить();
					ТаблицаПользователей.Свернуть("Пользователь");
					
					Для Каждого СтрокаПользователь Из ТаблицаПользователей Цикл
						ЗаписьНабораОповещений = НаборЗаписейОповещений.Добавить();
						ЗаписьНабораОповещений.Сертификат = Выборка.Ссылка;
						ЗаписьНабораОповещений.Пользователь = СтрокаПользователь.Пользователь;
						ЗаписьНабораОповещений.Оповещен = Истина;
					КонецЦикла;
					
				ИначеЕсли ЗначениеЗаполнено(СертификатОбъект.Пользователь) Тогда
					ЗаписьНабораОповещений = НаборЗаписейОповещений.Добавить();
					ЗаписьНабораОповещений.Сертификат = Выборка.Ссылка;
					ЗаписьНабораОповещений.Пользователь = СертификатОбъект.Пользователь;
					ЗаписьНабораОповещений.Оповещен = Истина;
				КонецЕсли;
				Если НаборЗаписейОповещений.Количество() > 0 Тогда
					ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписейОповещений, Истина);
				КонецЕсли;
				СертификатОбъект.УдалитьПользовательОповещенОСрокеДействия = Ложь;
			КонецЕсли;
			
			// Перенос данных заявлений в регистр сведений.
			Если ЗаявлениеНаВыпускСертификатаДоступно
			   И ЗначениеЗаполнено(СертификатОбъект.УдалитьСостояниеЗаявления) Тогда
				
				ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.ОбработатьДанныеДляПереходаНаНовуюВерсию(
					СертификатОбъект);

			КонецЕсли;
			
			Если СертификатОбъект.Пользователи.Количество() = 1 Тогда
				СертификатОбъект.Пользователь = СертификатОбъект.Пользователи[0].Пользователь;
				СертификатОбъект.Пользователи.Очистить();
			КонецЕсли;

			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СертификатОбъект);

			ОбъектовОбработано = ОбъектовОбработано + 1;
			ЗафиксироватьТранзакцию();

		Исключение

			ОтменитьТранзакцию();
			// Если не удалось обработать какой-либо сертификат, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;

			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать сертификат: %1 по причине:
					 |%2';
					 |en = 'Couldn''t process certificate %1. Reason:
					 |%2'"), ПредставлениеСсылки, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));

			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение, Выборка.Ссылка.Метаданные(), Выборка.Ссылка, ТекстСообщения);

		КонецПопытки;

	КонецЦикла;

	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обработать некоторые сертификаты (пропущены): %1';
				|en = 'Couldn''t process (skipped) some certificates: %1'"),
			ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация,
			Метаданные.Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования,,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Обработана очередная порция сертификатов: %1';
					|en = 'Yet another batch of certificates is processed: %1'"), ОбъектовОбработано));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
