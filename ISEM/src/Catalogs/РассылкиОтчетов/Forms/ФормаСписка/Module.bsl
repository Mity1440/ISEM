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
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("Отображение") Тогда
		Элементы.Список.Отображение = ОтображениеТаблицы[Параметры.Отображение];
	КонецЕсли;
	
	ТекстОшибкиПриОткрытии = РассылкаОтчетов.ТекстОшибкиПроверкиПраваДобавления();
	Если ЗначениеЗаполнено(ТекстОшибкиПриОткрытии) Тогда
		ВызватьИсключение ТекстОшибкиПриОткрытии;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
		МодульПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// Установка отборов динамического списка.
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ВыполнятьПоРасписанию", Ложь,
		ВидСравненияКомпоновкиДанных.Равно, , Ложь,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ПериодичностьРасписания", ,
		ВидСравненияКомпоновкиДанных.Равно, , Ложь,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Подготовлена", Ложь,
		ВидСравненияКомпоновкиДанных.Равно, , Ложь,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Автор", ,
		ВидСравненияКомпоновкиДанных.Равно, , Ложь,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
	
	ЗаполнитьПараметрСписка("РежимВыбора");
	ЗаполнитьПараметрСписка("ВыборГруппИЭлементов");
	ЗаполнитьПараметрСписка("МножественныйВыбор");
	ЗаполнитьПараметрСписка("ТекущаяСтрока");
	
	Если Не ПравоДоступа("Изменение", Метаданные.Справочники.РассылкиОтчетов) Тогда
		// Режим показа только личных рассылок - скрываются группы и лишние колонки.
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ЭтоГруппа", Ложь, , , Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	КонецЕсли;
	
	ОтчетОтбор = Параметры.Отчет;
	УстановитьОтбор(Ложь);

	Список.Параметры.УстановитьЗначениеПараметра("ПустаяДата", '00010101');
	Список.Параметры.УстановитьЗначениеПараметра("ПредставлениеСостоянияНовая", НСтр("ru = 'Новая';
																					|en = 'New'"));
	Список.Параметры.УстановитьЗначениеПараметра("ПредставлениеСостоянияНеВыполнена", НСтр("ru = 'Не выполнена';
																							|en = 'Not completed'"));
	Список.Параметры.УстановитьЗначениеПараметра("ПредставлениеСостоянияВыполненаСОшибками", НСтр("ru = 'Выполнена частично';
																									|en = 'Partially completed'"));
	Список.Параметры.УстановитьЗначениеПараметра("ПредставлениеСостоянияВыполнена", НСтр("ru = 'Выполнена';
																						|en = 'Completed'"));
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов")
		Или Не ПравоДоступа("Изменение", Метаданные.Справочники.РассылкиОтчетов) Тогда
		Элементы.ИзменитьВыделенные.Видимость = Ложь;
		Элементы.ИзменитьВыделенныеСписок.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ПравоДоступа("ЖурналРегистрации", Метаданные) Тогда
		Элементы.СобытияРассылки.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	УстановитьОтборСписка(Настройки);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СостояниеОтборПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры

&НаКлиенте
Процедура ОтчетОтборПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	Если Строка = ПредопределенноеЗначение("Справочник.РассылкиОтчетов.ЛичныеРассылки") Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	МодульГрупповоеИзменениеОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ГрупповоеИзменениеОбъектовКлиент");
	МодульГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.ПоследнийЗапуск", Элементы.ПоследнийЗапуск.Имя);
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.УспешныйЗапуск", Элементы.УспешныйЗапуск.Имя);

	ЭлементУсловногоОформления = Список.УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	// Неподготовленные рассылки отчетов
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЭтоГруппа");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подготовлена");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("ЦветТекста");
	ЭлементЦветаОформления.Значение = Метаданные.ЭлементыСтиля.ТекстЗапрещеннойЯчейкиЦвет.Значение;
	ЭлементЦветаОформления.Использование = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрСписка(Ключ)
	Если Параметры.Свойство(Ключ) И ЗначениеЗаполнено(Параметры[Ключ]) Тогда
		Элементы.Список[Ключ] = Параметры[Ключ];
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьОтбор(СнятьФиксированныеОтборы = Истина)
	
	Если СнятьФиксированныеОтборы Тогда
		Список.Отбор.Элементы.Очистить();
	КонецЕсли;
	ПараметрыОтбора = Новый Соответствие();
	ПараметрыОтбора.Вставить("СОшибками", СостояниеОтбор);
	ПараметрыОтбора.Вставить("Отчет", ОтчетОтбор);
	ПараметрыОтбора.Вставить("Автор", ОтветственныйОтбор);
	УстановитьОтборСписка(ПараметрыОтбора);
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборСписка(ПараметрыОтбора)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Автор", ПараметрыОтбора["Автор"],,,
		Не ПараметрыОтбора["Автор"].Пустая());
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "СОшибками", ПараметрыОтбора["СОшибками"] = "Невыполненные",,, 
		ПараметрыОтбора["СОшибками"] <> "Все" И ЗначениеЗаполнено(ПараметрыОтбора["СОшибками"]));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ОтчетОтбор", ПараметрыОтбора["Отчет"],
		ЗначениеЗаполнено(ПараметрыОтбора["Отчет"]) И Не ПараметрыОтбора["Отчет"].Пустая());
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
		МодульПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
		МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
	КонецЕсли;
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
