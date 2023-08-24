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
	
	Если Параметры.ИнформацияЗаявления <> Неопределено Тогда
		ПодтверждаемаяИнформация = Параметры.ИнформацияЗаявления;
		Элементы.ГруппаОшибка.Видимость = Ложь;
		Элементы.ГруппаЗаявление.Видимость = Истина;
		Элементы.ГруппаСертификат.Видимость = Ложь;
	ИначеЕсли Параметры.СодержаниеСертификата <> Неопределено Тогда
		Элементы.ГруппаЗаявление.Видимость = Ложь;
		Элементы.ГруппаСертификат.Видимость = Истина;
		Элементы.ДекорацияИнструкция.Видимость = Не Параметры.ДляПодтвержденияВЭлектронномВиде;
	Иначе
		Заголовок = НСтр("ru = 'Информация об ошибке';
						|en = 'Error details'");
		Элементы.ГруппаКомандыОшибки.Видимость = Истина;
		Элементы.ГруппаКомандыПодтверждения.Видимость = Ложь;
		Элементы.ГруппаЗаявление.Видимость = Ложь;
		Элементы.ГруппаСертификат.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.ОписаниеОшибки <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ОписаниеОшибки);
		Элементы.ГруппаОшибка.Видимость = ЗначениеЗаполнено(Описание);
		Элементы.ГруппаТекстОшибки.Видимость = ЗначениеЗаполнено(Текст);
		Если ЗначениеЗаполнено(Код) Тогда
			ОписаниеИзвестнойОшибки = ЭлектроннаяПодписьСлужебный.ОшибкаПоКлассификатору(Код);
			
			ЭтоИзвестнаяОшибка = ОписаниеИзвестнойОшибки <> Неопределено;
			Если ЭтоИзвестнаяОшибка Тогда
				Элементы.ПричиныТекст.Видимость = ЗначениеЗаполнено(ОписаниеИзвестнойОшибки.Причина);
				Элементы.РешенияТекст.Видимость = ЗначениеЗаполнено(ОписаниеИзвестнойОшибки.Решение);
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
					"ПричиныТекст", "Заголовок", ОписаниеИзвестнойОшибки.Причина);
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
					"РешенияТекст", "Заголовок", ОписаниеИзвестнойОшибки.Решение);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	СтандартныеПодсистемыСервер.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПричиныТекстОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьНавигационнуюСсылкуКлассификатора(
		Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура РешенияТекстОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьНавигационнуюСсылкуКлассификатора(
		Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПодтверждениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ПечатьСертификата();

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИнструкцияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ПечатьСертификата();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подтверждаю(Команда)
	
	Если Параметры.СодержаниеСертификата <> Неопределено Тогда
		Если Не СогласиеСПодтверждаемойИнформацией1 Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Поставьте отметку о подтверждении';
				|en = 'Check as confirmed'"), , "СогласиеСПодтверждаемойИнформацией1");
			Возврат;
		КонецЕсли;
		Если Не СогласиеСПодтверждаемойИнформацией2 Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Поставьте отметку о подтверждении';
				|en = 'Check as confirmed'"), , "СогласиеСПодтверждаемойИнформацией2");
			Возврат;
		КонецЕсли;
	Иначе
		Если Не СогласиеСПодтверждаемойИнформацией Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Поставьте отметку о подтверждении';
				|en = 'Check as confirmed'"), , "СогласиеСПодтверждаемойИнформацией");
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Закрыть(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПечатьСертификата()
	
	ИдентификаторПечатнойФормы = "СодержаниеСертификата";
	НазваниеПечатнойФормы = НСтр("ru = 'Содержание сертификата';
								|en = 'Certificate content'");
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		Параметры.СодержаниеСертификата.Показать(НазваниеПечатнойФормы);
		Возврат;
	КонецЕсли;
	
	МодульУправлениеПечатьюКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеПечатьюКлиент");
	КоллекцияПечатныхФорм = МодульУправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм(ИдентификаторПечатнойФормы);
	
	ПечатнаяФорма = МодульУправлениеПечатьюКлиент.ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, ИдентификаторПечатнойФормы);
	ПечатнаяФорма.СинонимМакета = НазваниеПечатнойФормы;
	ПечатнаяФорма.ТабличныйДокумент = Параметры.СодержаниеСертификата;
	ПечатнаяФорма.ИмяФайлаПечатнойФормы = НазваниеПечатнойФормы;
	
	ОбластиОбъектов = Новый СписокЗначений;
	МодульУправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм, ОбластиОбъектов);
	
КонецПроцедуры

#КонецОбласти