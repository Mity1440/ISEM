///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Параметры формы:
//     Уровень                           - Число - Запрашиваемый уровень.
//     Родитель                          - УникальныйИдентификатор - Родительский объект.
//     СкрыватьНеактуальныеАдреса        - Булево - флаг того, что при неактуальные адреса будут скрываться.
//     ФорматАдреса - Строка - вариант классификатора.
//     Идентификатор                     - УникальныйИдентификатор - Текущий адресный элемент.
//     Представление                     - Строка - Представление текущего элемента,. используется если не указан
//                                                  Идентификатор.
//
// Результат выбора:
//     Структура - с полями
//         * Отказ                      - Булево - флаг того, что при обработке произошла ошибка.
//         * КраткоеПредставлениеОшибки - Строка - Описание ошибки.
//         * Идентификатор              - УникальныйИдентификатор - Данные адреса.
//         * Представление              - Строка                  - Данные адреса.
//         * РегионЗагружен             - Булево                  - Имеет смысл только для регионов, Истина, если есть
//                                                                  записи.
// ---------------------------------------------------------------------------------------------------------------------
//
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Параметры.Свойство("Родитель", Родитель);
	Параметры.Свойство("Уровень",  Уровень);
	
	Параметры.Свойство("ТипАдреса", ТипАдреса);
	Параметры.Свойство("СкрыватьНеактуальные", СкрыватьНеактуальные);
	
	Позиция               = 0;
	ИспользуетсяВебСервис = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Родитель) И Уровень > 1 Тогда
		// поиск адреса без родителя 
		КраткоеПредставлениеОшибки = НСтр("ru = 'Поле не содержит адресных сведений для выбора.';
											|en = 'The field has no address details to select from.'");
		Возврат;
	КонецЕсли;
	
	ДанныеЗагружены = ЗагрузитьДанныеИзКлассификатора(Позиция);
	
	Если Не ДанныеЗагружены Тогда
		Возврат;
	КонецЕсли;
	
	// Текущая строка
	ТекущееЗначение = Неопределено;
	Кандидаты       = Неопределено;
	
	Параметры.Свойство("Идентификатор", ТекущееЗначение);
	Если ЗначениеЗаполнено(ТекущееЗначение) Тогда
		Кандидаты = ВариантыАдреса.НайтиСтроки( Новый Структура("Идентификатор", ТекущееЗначение));
	Иначе
		Параметры.Свойство("Представление", ТекущееЗначение);
		Если ЗначениеЗаполнено(ТекущееЗначение) Тогда
			Кандидаты = ВариантыАдреса.НайтиСтроки( Новый Структура("Представление", ТекущееЗначение));
		КонецЕсли;
	КонецЕсли;
	
	Если Кандидаты <> Неопределено И Кандидаты.Количество() > 0 Тогда
		Элементы.ВариантыАдреса.ТекущаяСтрока = Кандидаты[0].ПолучитьИдентификатор();
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Выбрать", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВариантыАдресаКонтекстноеМенюГруппаНайти", "Видимость", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ПустаяСтрока(КраткоеПредставлениеОшибки) Тогда
		ОповеститьВладельца(Неопределено, Истина);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗакрытьФорму Тогда
		Возврат;
	КонецЕсли;
	
	ЗакрытьФорму = Истина;
	СтандартнаяОбработка = Ложь;
	
	Результат = КонструкторРезультатаВыбора();
	Результат.Отказ = Истина;
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантыАдресаВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ПроизвестиВыбор(Значение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Предыдущие(Команда)
	
	Если Позиция >= РазмерПорции() Тогда
		Позиция = Позиция - РазмерПорции();
	Иначе
		Позиция = 0;
	КонецЕсли;
	
	ЗагрузитьДанныеИзКлассификатора(Позиция);
	
КонецПроцедуры

&НаКлиенте
Процедура Следующие(Команда)
	
	Позиция = Позиция + РазмерПорции();
	ЗагрузитьДанныеИзКлассификатора(Позиция);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция РазмерПорции()
	Возврат 500;
КонецФункции

&НаКлиенте
Процедура ПроизвестиВыбор(Знач НомерСтроки)
	
	ЗакрытьФорму = Истина;
	Данные = ВариантыАдреса.НайтиПоИдентификатору(НомерСтроки);
	Если Данные = Неопределено Тогда
		Возврат;
		
	ИначеЕсли Не Данные.Неактуален Тогда
		ОповеститьВладельца(Данные);
		Возврат;
		
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПроизвестиВыборЗавершениеВопроса", ЭтотОбъект, Данные);
	
	ПредупреждениеНеактуальности = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Адрес ""%1"" неактуален.
		           |Продолжить?';
		           |en = 'Address ""%1"" is outdated.
		           |Continue?'"), Данные.Представление);
		
	ЗаголовокПредупреждения = НСтр("ru = 'Подтверждение';
									|en = 'Confirm'");
	
	ПоказатьВопрос(Оповещение, ПредупреждениеНеактуальности, РежимДиалогаВопрос.ДаНет, , ,ЗаголовокПредупреждения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроизвестиВыборЗавершениеВопроса(Знач РезультатВопроса, Знач ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОповеститьВладельца(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьВладельца(Знач Данные, Отказ = Ложь)
	
	Результат = КонструкторРезультатаВыбора();
	
	РегионЗагружен = Ложь;
	Если Данные <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Результат, Данные);
		РегионЗагружен = Данные.РегионЗагружен;
	Иначе
		Результат.Отказ = Истина;
		Результат.Уровень = Уровень;
		Если Уровень = 7 Тогда
			Результат.КраткоеПредставлениеОшибки = НСтр("ru = 'Данные об улицах для введенного населенного пункта отсутствуют.';
														|en = 'There is no data on streets for the locality you entered.'");
		Иначе
			Результат.КраткоеПредставлениеОшибки = НСтр("ru = 'Нет доступных адресных сведений для выбора.';
														|en = 'No address details to select from.'");
		КонецЕсли;
	КонецЕсли;
	
	Результат.Муниципальный = РаботаСАдресамиКлиентСервер.ЭтоМуниципальныйАдрес(ТипАдреса);
	Результат.ЗагруженныеДанные = (Уровень = 1 Или РегионЗагружен);
	
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры

&НаКлиенте
Функция КонструкторРезультатаВыбора()
	
	Результат = Новый Структура();
	Результат.Вставить("РегионЗагружен",                   Неопределено);
	Результат.Вставить("Идентификатор",                    "");
	Результат.Вставить("Представление",                    "");
	Результат.Вставить("Наименование",                     "");
	Результат.Вставить("ТипОбъекта",                       "");
	Результат.Вставить("КраткоеПредставлениеОшибки",       "");
	Результат.Вставить("Отказ",                            Ложь);
	Результат.Вставить("Уровень",                          0);
	Результат.Вставить("Муниципальный",                    Неопределено);
	Результат.Вставить("ПредлагатьЗагрузкуКлассификатора", Ложь);
	Результат.Вставить("Родитель",                         Родитель);
	Результат.Вставить("ЗагруженныеДанные",                Ложь);
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВариантыАдресаПредставление.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВариантыАдреса.Неактуален");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

&НаСервере
Функция ДанныеКлассификатораПоИдентификатору(Знач ПараметрыПоиска)
	
	Результат = Новый Структура();
	Результат.Вставить("Данные", Новый ТаблицаЗначений);
	Результат.Вставить("Заголовок", "");
	Результат.Вставить("КраткоеПредставлениеОшибки", НСтр("ru = 'Поле не содержит адресных сведений для выбора';
															|en = 'The field has no address details to select from.'"));
	Результат.Вставить("Отказ", Ложь);
	
	ДанныеКлассификатора = Обработки.РасширенныйВводКонтактнойИнформации.АдресаДляИнтерактивногоВыбора(Родитель, Уровень, ТипАдреса, ПараметрыПоиска);
	
	Если ДанныеКлассификатора.Отказ Тогда
		// Сервис на обслуживании
		Результат.КраткоеПредставлениеОшибки = НСтр("ru = 'Автоподбор и проверка адреса недоступны:';
													|en = 'Address autosuggest and validation is not available:'") + Символы.ПС + ДанныеКлассификатора.КраткоеПредставлениеОшибки;
		Результат.Отказ = Истина;
		Возврат Результат;
		
	ИначеЕсли ДанныеКлассификатора.Данные.Количество() = 0 Тогда
		
		Адрес = РаботаСАдресами.АдресПоИдентификатору(Родитель);
		
		Если Адрес = Неопределено Тогда
			
			Результат.Отказ = Истина;
			Возврат Результат;
		
		КонецЕсли;
		
		НаименованиеРегиона = РаботаСАдресами.РегионАдресаКонтактнойИнформации(Адрес);
		
		Если РаботаСАдресами.ЭтоГородФедеральногоЗначения(НаименованиеРегиона) Тогда
			
			Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор") Тогда
				
				Сведения = Новый Структура();
				Сведения.Вставить("Идентификатор", Родитель);
				
				МодульАдресныйКлассификаторСлужебный = ОбщегоНазначения.ОбщийМодуль("АдресныйКлассификаторСлужебный");
				ПолученныеАдрес = МодульАдресныйКлассификаторСлужебный.АктуальныеАдресныеСведения(Сведения);
				
				Если ПолученныеАдрес.Отказ Тогда
					Результат.Отказ = Истина;
					Возврат Результат;
				КонецЕсли;
				
				Адрес = ПолученныеАдрес.Данные;
				Родитель = Адрес.areaId;
				
				ДанныеКлассификатора = Обработки.РасширенныйВводКонтактнойИнформации.АдресаДляИнтерактивногоВыбора(Родитель, Уровень, ТипАдреса, ПараметрыПоиска);
				
				Если ДанныеКлассификатора.Данные.Количество() = 0 Тогда
					Результат.Отказ = Истина;
					Возврат Результат;
				КонецЕсли;
			Иначе
				
				Результат.Отказ = Истина;
				Возврат Результат;
				
			КонецЕсли;
		Иначе
			Результат.Отказ = Истина;
			Возврат Результат;
		КонецЕсли;
		
	КонецЕсли;
	
	Результат.Данные = ДанныеКлассификатора.Данные;
	Результат.Заголовок = ДанныеКлассификатора.Заголовок;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ЗагрузитьДанныеИзКлассификатора(Позиция, СтрокаПоиска = "")
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("КоличествоЗаписей", РазмерПорции());
	ПараметрыПоиска.Вставить("Позиция",           Позиция);
	ПараметрыПоиска.Вставить("СтрокаПоиска",      СтрокаПоиска);
	
	ДанныеИзКлассификатора = ДанныеКлассификатораПоИдентификатору(ПараметрыПоиска);
	
	Если Не ДанныеИзКлассификатора.Отказ Тогда
		ВариантыАдреса.Очистить();
		ВариантыАдреса.Загрузить(ДанныеИзКлассификатора.Данные);
		Заголовок = ДанныеИзКлассификатора.Заголовок;
	КонецЕсли;
	
	Если ДанныеИзКлассификатора.Отказ Тогда
		КраткоеПредставлениеОшибки = ДанныеИзКлассификатора.КраткоеПредставлениеОшибки;
		Возврат Ложь;
	КонецЕсли;
	
	Элементы.Предыдущие.Доступность = Позиция > 0;
	
	Если ДанныеИзКлассификатора.Данные.Количество() > 0 И Не ДанныеИзКлассификатора.Данные[0].РегионЗагружен Тогда
		ИспользуетсяВебСервис = Истина;
		СкрыватьПанельНавигации = (Позиция = 0 И ДанныеИзКлассификатора.Данные.Количество() < РазмерПорции());
		Элементы.НавигацияВебСервис.Видимость = Не СкрыватьПанельНавигации; // Веб-сервис
		Если ДанныеИзКлассификатора.Данные.Количество() = РазмерПорции() Тогда
			Элементы.Информация.Видимость = Истина;
			Элементы.Информация.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Показано %1 адресных объектов';
					|en = '%1 address objects displayed'"), РазмерПорции());
			Элементы.Следующие.Доступность = Истина;
		Иначе
			Элементы.Информация.Видимость  = Ложь;
			Элементы.Следующие.Доступность = Ложь;
		КонецЕсли;

	Иначе
		Элементы.НавигацияВебСервис.Видимость = Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти