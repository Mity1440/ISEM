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

// СтандартныеПодсистемы.ВариантыОтчетов

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	МодульВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта_Горизонталь = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Основной");
	НастройкиВарианта_Горизонталь.Описание = НСтр("ru = 'Горизонтальное размещение колонок с измерениями, ресурсами и реквизитами регистров.';
													|en = 'Horizontal arrangement of columns with dimensions, resources, and register attributes.'");
	НастройкиВарианта_Горизонталь.НастройкиДляПоиска.КлючевыеСлова = НСтр("ru = 'Движения документа';
																			|en = 'Document register records'");
	НастройкиВарианта_Горизонталь.Включен = Ложь;
	НастройкиВарианта_Горизонталь.ПоказыватьВПодменюВариантов = Истина;
	
	НастройкиВарианта_Вертикаль = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Дополнительный");
	НастройкиВарианта_Вертикаль.Описание = НСтр("ru = 'Вертикальное размещение колонок с измерениями, ресурсами и реквизитами позволяет расположить данные более компактно, для просмотра регистров с большим количеством колонок.';
												|en = 'Vertical arrangement of columns with dimensions, resources, and attributes allows you to arrange data more compactly to view registers with a large number of columns.'");
	НастройкиВарианта_Вертикаль.НастройкиДляПоиска.КлючевыеСлова = НСтр("ru = 'Движения документа';
																		|en = 'Document register records'");
	НастройкиВарианта_Вертикаль.Включен = Ложь;
	НастройкиВарианта_Вертикаль.ПоказыватьВПодменюВариантов = Истина;
	
КонецПроцедуры

// Для вызова из процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.
// 
// Параметры:
//  КомандыОтчетов - ТаблицаЗначений - таблица команд для вывода в подменю, где:
//       * Идентификатор - Строка - идентификатор команды.
//       * Представление - Строка   - представление команды в форме.
//       * Важность      - Строка   - суффикс группы в подменю, в которой следует вывести эту команду.
//       * Порядок       - Число    - порядок размещения команды в группе. Используется для настройки под конкретное
//                                    рабочее место.
//       * Картинка      - Картинка - картинка команды.
//       * СочетаниеКлавиш - СочетаниеКлавиш - сочетание клавиш для быстрого вызова команды.
//       * ТипПараметра - ОписаниеТипов - типы объектов, для которых предназначена эта команда.
//       * ВидимостьВФормах    - Строка - имена форм через запятую, в которых должна отображаться команда.
//       * ФункциональныеОпции - Строка - имена функциональных опций через запятую, определяющих видимость команды.
//       * УсловияВидимости    - Массив - определяет видимость команды в зависимости от контекста.
//       * ИзменяетВыбранныеОбъекты - Булево - определяет доступность команды.
//       * МножественныйВыбор - Булево
//                            - Неопределено - если Истина, то команда поддерживает множественный выбор.
//             В этом случае в параметре выполнения будет передан список ссылок.
//             Необязательный. Значение по умолчанию: Истина.
//       * РежимЗаписи - Строка - действия, связанные с записью объекта, которые выполняются перед обработчиком команды.
//       * ТребуетсяРаботаСФайлами - Булево - если Истина, то в веб-клиенте предлагается
//             установить расширение для работы с 1С:Предприятием.
//       * Менеджер - Строка - полное имя объекта метаданных, отвечающего за выполнение команды.
//       * ИмяФормы - Строка - имя формы, которую требуется открыть или получить для выполнения команды.
//       * КлючВарианта - Строка - имя варианта отчета, открываемого при выполнении команды.
//       * ИмяПараметраФормы - Строка - имя параметра формы, в который следует передать ссылку или массив ссылок.
//       * ПараметрыФормы - Неопределено
//                        - Структура - параметры формы, указанной в ИмяФормы.
//       * Обработчик - Строка - описание процедуры, обрабатывающей основное действие команды.
//       * ДополнительныеПараметры - Структура - параметры обработчика, указанного в Обработчик.
//  Параметры                   - Структура - структура, содержащая параметры подключения команды.
//  ДокументыСОтчетомОДвижениях - Массив
//                              - Неопределено - массив документов, в которых будет выводится
//                                команда открытия отчета. Неопределено в том случае когда отчет выводится
//                                для всех документов со свойством "Проведение" установленным в "Разрешить"
//                                и непустой коллекцией движений.
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - добавленная команда или Неопределено, если нет прав на просмотр отчета.
//
Функция ДобавитьКомандуОтчетОДвиженияхДокумента(КомандыОтчетов, Параметры, ДокументыСОтчетомОДвижениях = Неопределено) Экспорт
	
	Если Не ПравоДоступа("Просмотр", Метаданные.Отчеты.ДвиженияДокумента) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ОписаниеТипаПараметраКоманды = ОписаниеТипаПараметраКоманды(КомандыОтчетов, Параметры, ДокументыСОтчетомОДвижениях);
	Если ОписаниеТипаПараметраКоманды = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Команда                    = КомандыОтчетов.Добавить();
	Команда.Представление      = НСтр("ru = 'Движения документа';
										|en = 'Document register records'");
	Команда.МножественныйВыбор = Ложь;
	Команда.ИмяПараметраФормы  = "";
	Команда.Важность           = "СмТакже";
	Команда.ТипПараметра       = ОписаниеТипаПараметраКоманды;
	Команда.Менеджер           = "Отчет.ДвиженияДокумента";
	Команда.СочетаниеКлавиш    = Новый СочетаниеКлавиш(Клавиша.A, Ложь, Истина, Истина);
	
	Возврат Команда;
	
КонецФункции

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
Процедура ПриНастройкеВариантовОтчетов(Настройки) Экспорт
	
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДвиженияДокумента);
	
	ОписаниеОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ДвиженияДокумента);
	ОписаниеОтчета.Включен = Ложь;
	
КонецПроцедуры

// См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.
Процедура ПередДобавлениемКомандОтчетов(КомандыОтчетов, Параметры, СтандартнаяОбработка) Экспорт
	
	ДобавитьКомандуОтчетОДвиженияхДокумента(КомандыОтчетов, Параметры);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОписаниеТипаПараметраКоманды(Знач КомандыОтчетов, Знач Параметры, Знач ДокументыСОтчетомОДвижениях)
	
	Если Не Параметры.Свойство("Источники") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтрокиИсточников = Параметры.Источники.Строки;
	
	Если ДокументыСОтчетомОДвижениях <> Неопределено Тогда
		ОтключитьОтчетОтДокументов(КомандыОтчетов);
		ДокументыСОтчетом = Новый Соответствие;
		Для каждого ДокументСОтчетом Из ДокументыСОтчетомОДвижениях Цикл
			ДокументыСОтчетом[ДокументСОтчетом] = Истина;
		КонецЦикла;	
	Иначе	
		ДокументыСОтчетом = Неопределено;
	КонецЕсли;
	
	ТипыДокументовСДвижениями = Новый Массив;
	Для Каждого СтрокаИсточника Из СтрокиИсточников Цикл
		
		ТипСсылкиДанных = СтрокаИсточника.ТипСсылкиДанных;
		
		Если ТипЗнч(ТипСсылкиДанных) = Тип("Тип") Тогда
			ТипыДокументовСДвижениями.Добавить(ТипСсылкиДанных);
		ИначеЕсли ТипЗнч(ТипСсылкиДанных) = Тип("ОписаниеТипов") Тогда
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ТипыДокументовСДвижениями, ТипСсылкиДанных.Типы());
		КонецЕсли;
		
	КонецЦикла;
	
	ТипыДокументовСДвижениями = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ТипыДокументовСДвижениями);
	
	Индекс = ТипыДокументовСДвижениями.Количество() - 1;
	Пока Индекс >= 0 Цикл
		Если Не ЭтоПодключаемыйТип(ТипыДокументовСДвижениями[Индекс], ДокументыСОтчетом) Тогда
			ТипыДокументовСДвижениями.Удалить(Индекс);
		КонецЕсли;
		Индекс = Индекс - 1;
	КонецЦикла;	
	
	Возврат ?(ТипыДокументовСДвижениями.Количество() > 0, Новый ОписаниеТипов(ТипыДокументовСДвижениями), Неопределено);
	
КонецФункции

Процедура ОтключитьОтчетОтДокументов(КомандыОтчетов)
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("Менеджер", "Отчет.ДвиженияДокумента");
	НайденныеСтроки = КомандыОтчетов.НайтиСтроки(СтруктураПоиска);
	
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		КомандыОтчетов.Удалить(НайденнаяСтрока);
	КонецЦикла;
	
КонецПроцедуры

Функция ЭтоПодключаемыйТип(ПроверяемыйТип, ДокументыСОтчетомОДвижениях)
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ПроверяемыйТип);
	Если ОбъектМетаданных = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ДокументыСОтчетомОДвижениях <> Неопределено И ДокументыСОтчетомОДвижениях[ОбъектМетаданных] = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ЭтоДокумент(ОбъектМетаданных) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ОбъектМетаданных.Проведение <> Метаданные.СвойстваОбъектов.Проведение.Разрешить
		Или ОбъектМетаданных.Движения.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецЕсли