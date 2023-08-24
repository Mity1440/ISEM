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
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры,
		"ВариантСсылка, ОтчетСсылка, ПодсистемаСсылка, ОтчетНаименование, ВидимыеВарианты");
	
	Если ВидимыеВарианты = Неопределено Тогда
		ВидимыеВарианты = Новый ФиксированныйМассив(Новый Массив);
	КонецЕсли;
	
	Элементы.ГруппаДругиеВариантыОтчета.Заголовок = ОтчетНаименование
		+ " (" + НСтр("ru = 'варианты отчета';
						|en = 'report options'") + "):";
	
	ПрочитатьНастройкиЭтойФормы();
	
	СтандартныеПодсистемыСервер.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	ЗаполнитьПанельОтчетов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗакрыватьЭтоОкноПослеПереходаКОтчетуПриИзменении(Элемент)
	СохранитьНастройкиЭтойФормы();
КонецПроцедуры

// Обработчик нажатия на гиперссылку.
//
// Параметры:
//   Элемент - ДекорацияФормы
//
&НаКлиенте
Процедура Подключаемый_ВариантНажатие(Элемент)
	Найденные = ВариантыПанели.НайтиСтроки(Новый Структура("НадписьИмя", Элемент.Имя));
	Если Найденные.Количество() <> 1 Тогда
		Возврат;
	КонецЕсли;
	Вариант = Найденные[0];
	
	Если ЗначениеЗаполнено(ПодсистемаСсылка) Тогда
		ПараметрыФормы = Новый Структура("Подсистема", ПодсистемаСсылка);
	Иначе
		ПараметрыФормы = Неопределено;
	КонецЕсли;
	ВариантыОтчетовКлиент.ОткрытьФормуОтчета(ВладелецФормы, Вариант, ПараметрыФормы);
	
	Если ЗакрыватьПослеВыбора Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера, Сервер

&НаСервере
Процедура СохранитьНастройкиЭтойФормы()
	НастройкиФормы = НастройкиПоУмолчанию();
	ЗаполнитьЗначенияСвойств(НастройкиФормы, ЭтотОбъект);
	ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить(
		ВариантыОтчетовКлиентСервер.ПолноеИмяПодсистемы(),
		"ПанельДругихОтчетов", 
		НастройкиФормы);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура ПрочитатьНастройкиЭтойФормы()
	НастройкиПоУмолчанию = НастройкиПоУмолчанию();
	Элементы.ЗакрыватьПослеВыбора.Видимость = НастройкиПоУмолчанию.ПоказыватьФлажок;
	НастройкиФормы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		ВариантыОтчетовКлиентСервер.ПолноеИмяПодсистемы(),
		"ПанельДругихОтчетов",
		НастройкиПоУмолчанию);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиФормы);
КонецПроцедуры

&НаСервере
Функция НастройкиПоУмолчанию()
	Возврат ВариантыОтчетов.ГлобальныеНастройки().ДругиеОтчеты;
КонецФункции

&НаСервере
Процедура ЗаполнитьПанельОтчетов()
	ЕстьДругиеОтчеты = Ложь;
	
	ТаблицаВывода = РеквизитФормыВЗначение("ВариантыПанели");
	ТаблицаВывода.Колонки.Добавить("ЭлементНадоДобавить", Новый ОписаниеТипов("Булево"));
	ТаблицаВывода.Колонки.Добавить("ЭлементНадоОставить", Новый ОписаниеТипов("Булево"));
	ТаблицаВывода.Колонки.Добавить("Группа");
	
	ОбщиеНастройки = ВариантыОтчетов.ОбщиеНастройкиПанели();
	ПоказыватьПодсказки = ОбщиеНастройки.ПоказыватьПодсказки = 1;
	
	ТаблицаВариантов = ДоступныеВариантыОтчетов();
	Для Каждого СтрокаТаблицы Из ТаблицаВариантов Цикл
		// Только другие варианты.
		Если СтрокаТаблицы.Ссылка = ВариантСсылка Тогда
			Продолжить;
		КонецЕсли;
		ЕстьДругиеОтчеты = Истина;
		ВывестиГиперссылкуВПанель(ТаблицаВывода, СтрокаТаблицы, Элементы.ГруппаДругиеВариантыОтчета, ПоказыватьПодсказки);
	КонецЦикла;
	Элементы.ГруппаДругиеВариантыОтчета.Видимость = (ТаблицаВариантов.Количество() > 0);
	
	Если ЗначениеЗаполнено(ПодсистемаСсылка) Тогда
		Подсистемы = ПодсистемыРаздела(ПодсистемаСсылка);
		
		ПараметрыПоиска = Новый Структура;
		ПараметрыПоиска.Вставить("Подсистемы", Подсистемы);
		ПараметрыПоиска.Вставить("ТолькоВидимыеВПанелиОтчетов", Истина);
		ТаблицаВариантов = ВариантыОтчетов.ТаблицаВариантовОтчетов(ПараметрыПоиска);
		
		НайденнаяКолонка = ТаблицаВариантов.Колонки.Найти("НаименованиеВарианта");
		НайденнаяКолонка.Имя = "Наименование";
		
		ТаблицаВариантов.Сортировать("Наименование");
		
		// Удаление строк, соответствующих текущему (открытому сейчас) варианту.
		Найденные = ТаблицаВариантов.НайтиСтроки(Новый Структура("Ссылка", ВариантСсылка));
		Для Каждого СтрокаТаблицы Из Найденные Цикл
			ТаблицаВариантов.Удалить(СтрокаТаблицы);
		КонецЦикла;
		
		ВсеПодсистемы = ВариантыОтчетовПовтИсп.ПодсистемыТекущегоПользователя().Дерево;
		ВсеРазделы = ВсеПодсистемы.Строки[0].Строки;
		
		// Обход подсистем и вывод найденных вариантов.
		Для Каждого ТекущаяПодсистема Из Подсистемы Цикл
			Найденные = ТаблицаВариантов.НайтиСтроки(Новый Структура("Подсистема", ТекущаяПодсистема));
			Если Найденные.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли;
			НайденныеСтроки = ВсеРазделы.НайтиСтроки(Новый Структура("Ссылка", ТекущаяПодсистема));
			Если НайденныеСтроки.Количество() = 0 Тогда
				НаименованиеПодсистемы = Найденные[0].НаименованиеПодсистемы;
			ИначеЕсли ТекущаяПодсистема = ПодсистемаСсылка Тогда
				НаименованиеПодсистемы = НайденныеСтроки[0].ПолноеПредставление;
			Иначе
				НаименованиеПодсистемы = НайденныеСтроки[0].Представление;
			КонецЕсли;
			Группа = ОпределитьГруппуВывода(НаименованиеПодсистемы);
			Для Каждого СтрокаТаблицы Из Найденные Цикл
				ЕстьДругиеОтчеты = Истина;
				ВывестиГиперссылкуВПанель(ТаблицаВывода, СтрокаТаблицы, Группа, ПоказыватьПодсказки);
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	// ВариантыПанелиНомерЭлемента
	НайденныеДляУдаления = ТаблицаВывода.НайтиСтроки(Новый Структура("ЭлементНадоОставить", Ложь));
	Для Каждого СтрокаТаблицы Из НайденныеДляУдаления Цикл
		ЭлементВарианта = Элементы.Найти(СтрокаТаблицы.НадписьИмя);
		Если ЭлементВарианта <> Неопределено Тогда
			Элементы.Удалить(ЭлементВарианта);
		КонецЕсли;
		ТаблицаВывода.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
	ТаблицаВывода.Колонки.Удалить("ЭлементНадоОставить");
	ТаблицаВывода.Колонки.Удалить("Группа");
	ЗначениеВРеквизитФормы(ТаблицаВывода, "ВариантыПанели");
	
	Элементы.ГруппаДругихОтчетовНет.Видимость = Не ЕстьДругиеОтчеты;
	Элементы.ЗакрыватьПослеВыбора.Видимость = ЕстьДругиеОтчеты;
	Если Не ЕстьДругиеОтчеты Тогда
		Ширина = 25;
	КонецЕсли;
	
КонецПроцедуры

// Возвращаемое значение:
//  ТаблицаЗначений:
//    * Ссылка - СправочникСсылка.ВариантыОтчетов
//    * Отчет - СправочникСсылка.ИдентификаторыОбъектовМетаданных
//            - СправочникСсылка.ИдентификаторыОбъектовРасширений
//            - СправочникСсылка.ДополнительныеОтчетыИОбработки
//            - Строка
//    * КлючВарианта - Строка
//    * Наименование - Строка
//    * Описание - Строка
//    * Автор - СправочникСсылка.ВнешниеПользователи
//            - СправочникСсылка.Пользователи
//    * Пользовательский - Булево
//    * ТипОтчета - ПеречислениеСсылка.ТипыОтчетов
//    * ИмяОтчета - Строка
//
&НаСервере
Функция ДоступныеВариантыОтчетов()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВариантыОтчетов.Ссылка КАК Ссылка,
	|	ВариантыОтчетов.Отчет КАК Отчет,
	|	ВариантыОтчетов.КлючВарианта КАК КлючВарианта,
	|	ВариантыОтчетов.Наименование КАК Наименование,
	|	ВЫБОР
	|		КОГДА ПОДСТРОКА(ВариантыОтчетов.Описание, 1, 1) = """"
	|			ТОГДА ВЫРАЗИТЬ(ВариантыОтчетов.ПредопределенныйВариант.Описание КАК СТРОКА(1000))
	|		ИНАЧЕ ВЫРАЗИТЬ(ВариантыОтчетов.Описание КАК СТРОКА(1000))
	|	КОНЕЦ КАК Описание,
	|	ВариантыОтчетов.Автор КАК Автор,
	|	ВариантыОтчетов.Пользовательский КАК Пользовательский,
	|	ВариантыОтчетов.ТипОтчета КАК ТипОтчета,
	|	&ИмяОтчета КАК ИмяОтчета
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	|ГДЕ
	|	(ВариантыОтчетов.Ссылка В (&ВидимыеВарианты)
	|			ИЛИ ВариантыОтчетов.Отчет = &Отчет
	|				И НЕ ВариантыОтчетов.ПометкаУдаления
	|				И (НЕ ВариантыОтчетов.ТолькоДляАвтора
	|					ИЛИ ВариантыОтчетов.Автор = &ТекущийПользователь)
	|				И НЕ ВариантыОтчетов.ПредопределенныйВариант В (&ОтключенныеВариантыПрограммы)
	|				И ВариантыОтчетов.КлючВарианта <> """"
	|				И ВариантыОтчетов.Контекст = """")
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование");
	
	ИмяОтчета = "ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ВариантыОтчетов.Отчет) = ТИП(Справочник.ИдентификаторыОбъектовМетаданных)
	|			ТОГДА ВЫРАЗИТЬ(ВариантыОтчетов.Отчет КАК Справочник.ИдентификаторыОбъектовМетаданных).Имя
	|		КОГДА ТИПЗНАЧЕНИЯ(ВариантыОтчетов.Отчет) = ТИП(Справочник.ИдентификаторыОбъектовРасширений)
	|			ТОГДА ВЫРАЗИТЬ(ВариантыОтчетов.Отчет КАК Справочник.ИдентификаторыОбъектовРасширений).Имя
	|		ИНАЧЕ ВЫРАЗИТЬ(ВариантыОтчетов.Отчет КАК СТРОКА(150))
	|	КОНЕЦ";
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда 
		МодульДополнительныеОтчетыИОбработки = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
		ИмяТаблицыДополнительныеОтчеты = МодульДополнительныеОтчетыИОбработки.ИмяТаблицыДополнительныеОтчеты();
		
		ИмяОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ВЫБОР
		|		КОГДА ТИПЗНАЧЕНИЯ(ВариантыОтчетов.Отчет) = ТИП(Справочник.ИдентификаторыОбъектовМетаданных)
		|			ТОГДА ВЫРАЗИТЬ(ВариантыОтчетов.Отчет КАК Справочник.ИдентификаторыОбъектовМетаданных).Имя
		|		КОГДА ТИПЗНАЧЕНИЯ(ВариантыОтчетов.Отчет) = ТИП(Справочник.ИдентификаторыОбъектовРасширений)
		|			ТОГДА ВЫРАЗИТЬ(ВариантыОтчетов.Отчет КАК Справочник.ИдентификаторыОбъектовРасширений).Имя
		|		КОГДА ТИПЗНАЧЕНИЯ(ВариантыОтчетов.Отчет) = ТИП(%1)
		|			ТОГДА ВЫРАЗИТЬ(ВариантыОтчетов.Отчет КАК %1).ИмяОбъекта
		|		ИНАЧЕ ВЫРАЗИТЬ(ВариантыОтчетов.Отчет КАК СТРОКА(150))
		|	КОНЕЦ", ИмяТаблицыДополнительныеОтчеты);
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ИмяОтчета", ИмяОтчета);
	
	Запрос.УстановитьПараметр("ВидимыеВарианты", ВидимыеВарианты);
	Запрос.УстановитьПараметр("Отчет", ОтчетСсылка);
	Запрос.УстановитьПараметр("ТекущийПользователь", Пользователи.АвторизованныйПользователь());
	Запрос.УстановитьПараметр("ОтключенныеВариантыПрограммы", ВариантыОтчетовПовтИсп.ОтключенныеВариантыПрограммы());
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Создает элементы формы, ссылающиеся на вариант отчета.
// 
// Параметры:
//   ТаблицаВывода - ТаблицаЗначений:
//     * ЭлементНадоДобавить - Булево
//     * ЭлементНадоОставить - Булево
//     * Группа - ГруппаФормы
//   Вариант - СтрокаТаблицыЗначений:
//     * Ссылка - СправочникСсылка.ВариантыОтчетов
//     * ТипОтчета - ПеречислениеСсылка.ТипыОтчетов
//     * Описание - Строка
//     * Автор - СправочникСсылка.ВнешниеПользователи
//             - СправочникСсылка.Пользователи
//   Группа - ГруппаФормы
//          - Неопределено
//          - ПолеФормы
//          - ТаблицаФормы
//          - КнопкаФормы
//          - ДекорацияФормы
//   ПоказыватьПодсказки - Булево
//
&НаСервере
Процедура ВывестиГиперссылкуВПанель(ТаблицаВывода, Вариант, Группа, ПоказыватьПодсказки)
	
	Найденные = ТаблицаВывода.НайтиСтроки(Новый Структура("Ссылка, Группа", Вариант.Ссылка, Группа.Имя));
	Если Найденные.Количество() > 0 Тогда
		СтрокаВывода = Найденные[0];
		СтрокаВывода.ЭлементНадоОставить = Истина;
		Возврат;
	КонецЕсли;
	
	СтрокаВывода = ТаблицаВывода.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаВывода, Вариант);
	ВариантыПанелиНомерЭлемента = ВариантыПанелиНомерЭлемента + 1;
	СтрокаВывода.НадписьИмя = "Вариант" + Формат(ВариантыПанелиНомерЭлемента, "ЧГ=");
	СтрокаВывода.Дополнительный = (Вариант.ТипОтчета = Перечисления.ТипыОтчетов.Дополнительный);
	СтрокаВывода.ИмяГруппы = Группа.Имя;
	СтрокаВывода.ЭлементНадоОставить = Истина;
	СтрокаВывода.Группа = Группа;
	
	ЭлементыСтиля = Метаданные.ЭлементыСтиля;
	
	// Добавление надписи-гиперссылки варианта отчета.
	Надпись = Элементы.Вставить(СтрокаВывода.НадписьИмя, Тип("ДекорацияФормы"), СтрокаВывода.Группа); // ДекорацияФормы, РасширениеДекорацииФормыДляНадписи
	Надпись.Вид = ВидДекорацииФормы.Надпись;
	Надпись.Гиперссылка = Истина;
	Надпись.РастягиватьПоГоризонтали = Истина;
	Надпись.РастягиватьПоВертикали = Ложь;
	Надпись.Высота = 1;
	Надпись.ЦветТекста = ЭлементыСтиля.ГиперссылкаЦвет.Значение;
	Надпись.Заголовок = СокрЛП(Строка(Вариант.Ссылка));
	Надпись.АвтоМаксимальнаяШирина = Ложь;
	
	Если ЗначениеЗаполнено(Вариант.Описание) Тогда
		Надпись.Подсказка = СокрЛП(Вариант.Описание);
	КонецЕсли;
	Если ЗначениеЗаполнено(Вариант.Автор) Тогда
		Надпись.Подсказка = СокрЛ(Надпись.Подсказка + Символы.ПС) + НСтр("ru = 'Автор:';
																		|en = 'Author:'") + " " + СокрЛП(Строка(Вариант.Автор));
	КонецЕсли;
	Если ПоказыватьПодсказки Тогда
		Надпись.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
		Надпись.РасширеннаяПодсказка.РастягиватьПоГоризонтали = Истина;
		Надпись.РасширеннаяПодсказка.ЦветТекста = ЭлементыСтиля.ПоясняющийТекст.Значение;
	КонецЕсли;
	Надпись.УстановитьДействие("Нажатие", "Подключаемый_ВариантНажатие");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПодсистемыРаздела(КорневойРаздел)
	Результат = Новый Массив;
	Результат.Добавить(КорневойРаздел);
	
	ДеревоПодсистем = ВариантыОтчетовПовтИсп.ПодсистемыТекущегоПользователя().Дерево;
	Найденные = ДеревоПодсистем.Строки.НайтиСтроки(Новый Структура("Ссылка", КорневойРаздел), Истина);
	Индекс = 0;
	Пока Индекс < Найденные.Количество() Цикл
		КоллекцияСтрок = Найденные[Индекс].Строки;
		Индекс = Индекс + 1;
		Для Каждого СтрокаДерева Из КоллекцияСтрок Цикл
			Результат.Добавить(СтрокаДерева.Ссылка);
			Найденные.Добавить(СтрокаДерева);
		КонецЦикла;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

&НаСервере
Функция ОпределитьГруппуВывода(ПодсистемаПредставление)
	ЭлементСписка = ГруппыПодсистем.НайтиПоЗначению(ПодсистемаПредставление);
	Если ЭлементСписка <> Неопределено Тогда
		Возврат Элементы.Найти(ЭлементСписка.Представление);
	КонецЕсли;
	
	НомерГруппы = ГруппыПодсистем.Количество() + 1;
	ДекорацияИмя = "ОтступПодсистемы_" + НомерГруппы;
	ГруппаИмя = "ГруппаПодсистемы_" + НомерГруппы;
	
	Если ЕстьДругиеОтчеты Тогда
		Декорация = Элементы.Добавить(ДекорацияИмя, Тип("ДекорацияФормы"), Элементы.СтраницаДругиеОтчеты);
		Декорация.Вид = ВидДекорацииФормы.Надпись;
		Декорация.Заголовок = " ";
	КонецЕсли;
	
	Группа = Элементы.Добавить(ГруппаИмя, Тип("ГруппаФормы"), Элементы.СтраницаДругиеОтчеты);
	Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	Группа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	Группа.Заголовок = ПодсистемаПредставление;
	Группа.ОтображатьЗаголовок = Истина;
	Группа.Отображение = ОтображениеОбычнойГруппы.ОбычноеВыделение;
	Группа.РастягиватьПоГоризонтали = Истина;
	
	ГруппыПодсистем.Добавить(ПодсистемаПредставление, ГруппаИмя);
	
	Возврат Группа;
КонецФункции

#КонецОбласти
