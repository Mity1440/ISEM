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
	
	// Проверка прав доступа должна располагаться самой первой.
	Если Не ПравоДоступа("Администрирование", Метаданные) Тогда
		ВызватьИсключение НСтр("ru = 'Использование обработки в интерактивном режиме доступно только администратору.';
								|en = 'Only administrators can run the data processor manually.'");
	КонецЕсли;
	
	Объект.ИмяФайлаОбмена = Параметры.ИмяФайлаОбмена;
	Объект.ИмяФайлаПравилОбмена = Параметры.ИмяФайлаПравилОбмена;
	Объект.ИмяФайлаВнешнейОбработкиОбработчиковСобытий = Параметры.ИмяФайлаВнешнейОбработкиОбработчиковСобытий;
	Объект.РежимОтладкиАлгоритмов = Параметры.РежимОтладкиАлгоритмов;
	Объект.ОбработчикиСобытийЧитаемИзФайлаПравилОбмена = Параметры.ОбработчикиСобытийЧитаемИзФайлаПравилОбмена;
	
	Если Параметры.ОбработчикиСобытийЧитаемИзФайлаПравилОбмена Тогда
		Заголовок = НСтр("ru = 'Настройка отладки обработчиков при выгрузке данных';
						|en = 'Set up handler debugging on data export'");
		ЗаголовокКнопки = НСтр("ru = 'Сформировать модуль отладки выгрузки';
								|en = 'Generate export debugging module'");
	Иначе
		Заголовок = НСтр("ru = 'Настройка отладки обработчиков при загрузке данных';
						|en = 'Set up handler debugging on data import'");
		ЗаголовокКнопки = НСтр("ru = 'Сформировать модуль отладки загрузки';
								|en = 'Generate import debugging module'");
	КонецЕсли;		
	Элементы.ВыгрузитьКодОбработчиков.Заголовок = ЗаголовокКнопки;
	
	ЦветОсобогоТекста = ЦветаСтиля.ЦветОсобогоТекста;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтладкаАлгоритмовПриИзменении(Элемент)
	
	ПриИзмененииРежимаОтладкиИзменений();
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаВнешнейОбработкиОбработчиковСобытийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	ДиалогВыбораФайла.Фильтр     = НСтр("ru = 'Файл внешней обработки обработчиков событий (*.epf)|*.epf';
										|en = 'External data processor file (*.epf)|*.epf'");
	ДиалогВыбораФайла.Расширение = "epf";
	ДиалогВыбораФайла.Заголовок = НСтр("ru = 'Выберите файл';
										|en = 'Select file'");
	ДиалогВыбораФайла.ПредварительныйПросмотр = Ложь;
	ДиалогВыбораФайла.ИндексФильтра = 0;
	ДиалогВыбораФайла.ПолноеИмяФайла = Элемент.ТекстРедактирования;
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла = Истина;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Элемент", Элемент);
	
	Оповещение = Новый ОписаниеОповещения("ИмяФайлаВнешнейОбработкиОбработчиковСобытийОбработкаВыбора", ЭтотОбъект, ДополнительныеПараметры);
	ДиалогВыбораФайла.Показать(Оповещение);
	
КонецПроцедуры

// Параметры:
//   ВыбранныеФайлы - Массив из Строка
//                  - Неопределено - результат выбора файла.
//   ДополнительныеПараметры - Структура:
//     * Элемент - ПолеФормы - источник выбора файла.
//
&НаКлиенте
Процедура ИмяФайлаВнешнейОбработкиОбработчиковСобытийОбработкаВыбора(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ИмяФайлаВнешнейОбработкиОбработчиковСобытий = ВыбранныеФайлы[0];
	
	ИмяФайлаВнешнейОбработкиОбработчиковСобытийПриИзменении(ДополнительныеПараметры.Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаВнешнейОбработкиОбработчиковСобытийПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	ОчиститьСообщения();
	
	Если ПустаяСтрока(Объект.ИмяФайлаВнешнейОбработкиОбработчиковСобытий) Тогда
		
		СообщитьПользователю(НСтр("ru = 'Укажите имя файла внешней обработки.';
									|en = 'Please specify an external data processor file name.'"), "ИмяФайлаВнешнейОбработкиОбработчиковСобытий");
		Возврат;
		
	КонецЕсли;
	
	ФайлВнешнейОбработкиОбработчиковСобытий = Новый Файл(Объект.ИмяФайлаВнешнейОбработкиОбработчиковСобытий);
	
	Оповещение = Новый ОписаниеОповещения("ПроверкаСуществованияФайлаВнешнейОбработкиОбработчиковСобытийЗавершение", ЭтотОбъект);
	ФайлВнешнейОбработкиОбработчиковСобытий.НачатьПроверкуСуществования(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаСуществованияФайлаВнешнейОбработкиОбработчиковСобытийЗавершение(Существует, ДополнительныеПараметры) Экспорт
	
	Если Не Существует Тогда
		СообщитьПользователю(НСтр("ru = 'Указанный файл внешней обработки не существует.';
									|en = 'The specified external data processor file does not exist.'"),
			"ИмяФайлаВнешнейОбработкиОбработчиковСобытий");
		Возврат;
	КонецЕсли;
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("ИмяФайлаВнешнейОбработкиОбработчиковСобытий", Объект.ИмяФайлаВнешнейОбработкиОбработчиковСобытий);
	ПараметрыЗакрытия.Вставить("РежимОтладкиАлгоритмов", Объект.РежимОтладкиАлгоритмов);
	ПараметрыЗакрытия.Вставить("ИмяФайлаПравилОбмена", Объект.ИмяФайлаПравилОбмена);
	ПараметрыЗакрытия.Вставить("ИмяФайлаОбмена", Объект.ИмяФайлаОбмена);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	ПоказатьОбработчикиСобытийВОкне();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимость()
	
	ПриИзмененииРежимаОтладкиИзменений();
	
	// Выделение красным цветом шагов мастера, которые выполнены неправильно.
	УстановитьВыделениеИмениФайлаВнешнейОбработки(ПустаяСтрока(Объект.ИмяФайлаВнешнейОбработкиОбработчиковСобытий));
	
	Элементы.ОткрытьФайл.Доступность = Не ПустаяСтрока(Объект.ИмяВременногоФайлаОбработчиковСобытий);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВыделениеИмениФайлаВнешнейОбработки(НадоВыделить = Ложь) 
	
	Элементы.СтраницыШаг4.ТекущаяСтраница = ?(НадоВыделить, Элементы.СтраницаКрасный, Элементы.СтраницаЗеленый);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьКодОбработчиков(Команда)
	
	// Возможно выгрузку уже совершали ранее...
	Если Не ПустаяСтрока(Объект.ИмяВременногоФайлаОбработчиковСобытий) Тогда
		
		СписокКнопок = Новый СписокЗначений;
		СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Выгрузить повторно';
															|en = 'Repeat export'"));
		СписокКнопок.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Открыть модуль';
															|en = 'Open module'"));
		СписокКнопок.Добавить(КодВозвратаДиалога.Отмена);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыгрузитьКодОбработчиковЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Модуль отладки с кодом обработчиков уже выгружен.';
												|en = 'The debugging module with the handler code is already exported.'"), СписокКнопок,,КодВозвратаДиалога.Нет);
		
	Иначе
		
		ВыгрузитьКодОбработчиковЗавершение(КодВозвратаДиалога.Да, Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьКодОбработчиковЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ЕстьОшибкиВыгрузки = Ложь;
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ВыгруженоСОшибками = Ложь;
		ВыгрузитьОбработчикиСобытийНаСервере(ВыгруженоСОшибками);
		
	ИначеЕсли Результат = КодВозвратаДиалога.Отмена Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если Не ЕстьОшибкиВыгрузки Тогда
		
		УстановитьВидимость();
		
		ПоказатьОбработчикиСобытийВОкне();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОбработчикиСобытийВОкне()
	
	ОбработчикиСобытий = ОбработчикиСобытий();
	Если ОбработчикиСобытий <> Неопределено Тогда
		ОбработчикиСобытий.Показать(НСтр("ru = 'Модуль отладки обработчиков';
										|en = 'Handler debugging module'"));
	КонецЕсли;
	
	
	ПротоколОбмена = ПротоколОбмена();
	Если ПротоколОбмена <> Неопределено Тогда
		ПротоколОбмена.Показать(НСтр("ru = 'Ошибки выгрузки модуля обработчиков';
									|en = 'Errors occurred while exporting an event handler module'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработчикиСобытий()
	
	ОбработчикиСобытий = Неопределено;
	
	ФайлОбработчиков = Новый Файл(Объект.ИмяВременногоФайлаОбработчиковСобытий);
	Если ФайлОбработчиков.Существует() И ФайлОбработчиков.Размер() <> 0 Тогда
		ОбработчикиСобытий = Новый ТекстовыйДокумент;
		ОбработчикиСобытий.Прочитать(Объект.ИмяВременногоФайлаОбработчиковСобытий);
	КонецЕсли;
	
	Возврат ОбработчикиСобытий;
	
КонецФункции

&НаСервере
Функция ПротоколОбмена()
	
	ПротоколОбмена = Неопределено;
	
	ФайлОшибок = Новый Файл(Объект.ИмяВременногоФайлаПротоколаОбмена);
	Если ФайлОшибок.Существует() И ФайлОшибок.Размер() <> 0 Тогда
		ПротоколОбмена = Новый ТекстовыйДокумент;
		ПротоколОбмена.Прочитать(Объект.ИмяВременногоФайлаОбработчиковСобытий);
	КонецЕсли;
	
	Возврат ПротоколОбмена;
	
КонецФункции

&НаСервере
Процедура ВыгрузитьОбработчикиСобытийНаСервере(Отказ)
	
	ОбъектДляСервера = РеквизитФормыВЗначение("Объект");
	ЗаполнитьЗначенияСвойств(ОбъектДляСервера, Объект);
	ОбъектДляСервера.ВыгрузитьОбработчикиСобытий(Отказ);
	ЗначениеВРеквизитФормы(ОбъектДляСервера, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРежимаОтладкиИзменений()
	
	Подсказка = Элементы.ПодсказкаОтладкаАлгоритмов;
	
	Подсказка.ТекущаяСтраница = Подсказка.ПодчиненныеЭлементы["Группа_"+Объект.РежимОтладкиАлгоритмов];
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СообщитьПользователю(Текст, ПутьКДанным = "")
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = Текст;
	Сообщение.ПутьКДанным = ПутьКДанным;
	Сообщение.Сообщить();
	
КонецПроцедуры

#КонецОбласти
