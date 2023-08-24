///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПоказатьЗагрузкуКурсовВалют(ПараметрыФормы = Неопределено) Экспорт
	
	// Локализация
	ОткрытьФорму("Обработка.ЗагрузкаКурсовВалют.Форма", ПараметрыФормы);
	// Конец Локализация
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы.
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыКлиента.Свойство("Валюты") И ПараметрыКлиента.Валюты.ТребуетсяОбновитьКурсыВалют Тогда
		ПодключитьОбработчикОжидания("РаботаСКурсамиВалютВывестиОповещениеОНеактуальности", 180, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление курсов валют

Функция НастройкиНаКлиенте()
	
	ИмяПараметра = "СтандартныеПодсистемы.Валюты";
	Настройки = ПараметрыПриложения[ИмяПараметра];
	
	Если Настройки = Неопределено Тогда
		Настройки = Новый Структура;
		Настройки.Вставить("НачалоДняПоследнегоОповещения", '00010101');
		ПараметрыПриложения[ИмяПараметра] = Настройки;
	КонецЕсли;
	
	Возврат Настройки;
	
КонецФункции

Процедура ОповеститьКурсыУстарели(Знач ПроверитьАктуальность = Ложь) Экспорт
	
	Если ПроверитьАктуальность И РаботаСКурсамиВалютВызовСервера.КурсыАктуальны() Тогда
		Возврат;
	КонецЕсли;
	
	ДатаНачалаДня = НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса());
	Настройки = НастройкиНаКлиенте();
	
	Если Настройки.НачалоДняПоследнегоОповещения >= ДатаНачалаДня Тогда
		Возврат;
	КонецЕсли;
	Настройки.НачалоДняПоследнегоОповещения = ДатаНачалаДня;
	
	ПоказатьОповещение(
		НСтр("ru = 'Курсы валют устарели';
			|en = 'Outdated exchange rates'"),
		НавигационнаяСсылкаОбработки(),
		НСтр("ru = 'Обновить курсы валют';
			|en = 'Update exchange rates'"),
		БиблиотекаКартинок.Предупреждение32,
		СтатусОповещенияПользователя.Важное,
		"КурсыВалютУстарели");
	
КонецПроцедуры

// Выводит соответствующее оповещение.
//
Процедура ОповеститьКурсыУспешноОбновлены() Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Курсы валют успешно обновлены';
			|en = 'Exchange rates updated'"),
		,
		НСтр("ru = 'Курсы валют обновлены';
			|en = 'The exchange rates are updated.'"),
		БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

// Выводит соответствующее оповещение.
//
Процедура ОповеститьКурсыАктуальны() Экспорт
	
	ПоказатьПредупреждение(,НСтр("ru = 'Актуальные курсы валют успешно загружены.';
								|en = 'Up-to-date exchange rates are imported.'"));
	
КонецПроцедуры

// Возвращает навигационную ссылку для оповещений.
//
Функция НавигационнаяСсылкаОбработки()
	Возврат "e1cib/app/Обработка.ЗагрузкаКурсовВалют";
КонецФункции

Процедура ПоказатьОповещение(Текст, ДействиеПриНажатии, Пояснение, Картинка, СтатусОповещенияПользователя, КлючУникальности)
	
	ПоказатьОповещениеПользователя(
		Текст,
		ДействиеПриНажатии,
		Пояснение,
		Картинка,
		СтатусОповещенияПользователя,
		КлючУникальности);
		
КонецПроцедуры

#КонецОбласти
