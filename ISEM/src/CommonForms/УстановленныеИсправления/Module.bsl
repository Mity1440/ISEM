///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ТекущийКонтекст;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	ЭтоПодчиненныйУзелРИБ = ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ();
	
	Если РазделениеВключено Тогда
		Элементы.ИнформацияОписание.Заголовок = НСтр("ru = 'Состав исправлений настраивается администратором приложения.';
													|en = 'Patches are configured by the application administrator.'");
	ИначеЕсли ЭтоПодчиненныйУзелРИБ Тогда
		Элементы.ИнформацияОписание.Заголовок = НСтр("ru = 'Управление составом исправлений выполняется в центральном узле.';
													|en = 'Patches are managed in the master node.'");
	ИначеЕсли Параметры.ПриОбновлении Тогда
		Элементы.ИнформацияОписание.Заголовок = НСтр("ru = 'Установленные исправления вступят в силу после перезапуска программы.';
													|en = 'Installed patches will be applied after the application restart.'");
	ИначеЕсли Не ОбщегоНазначения.ЭтоWindowsКлиент() Тогда
		Элементы.СтраницыИнформация.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Исправления) Тогда
		Если ТипЗнч(Параметры.Исправления) = Тип("СписокЗначений") Тогда
			Фильтр = Параметры.Исправления;
		ИначеЕсли ТипЗнч(Параметры.Исправления) = Тип("Массив") Тогда
			Фильтр.ЗагрузитьЗначения(Параметры.Исправления);
		КонецЕсли;
	КонецЕсли;
	
	ПриОбновлении = Параметры.ПриОбновлении;
	Элементы.УстановленныеИсправленияЗакрыть.Видимость = ПриОбновлении;
	
	Если РазделениеВключено
		Или ЭтоПодчиненныйУзелРИБ
		Или Не ОбщегоНазначения.ЭтоWindowsКлиент()
		Или Параметры.ПриОбновлении Тогда
		Элементы.ФормаУстановитьИсправление.Видимость = Ложь;
		Элементы.ФормаУдалитьИсправление.Видимость    = Ложь;
		Элементы.УстановленныеИсправленияВыгрузитьПодключенныеИсправления.Видимость = Ложь;
		Элементы.УстановленныеИсправленияКонтекстноеМенюДобавить.Видимость = Ложь;
		Элементы.УстановленныеИсправленияКонтекстноеМенюУдалить.Видимость  = Ложь;
		Элементы.УстановленныеИсправленияПодключать.Видимость = Ложь;
	КонецЕсли;
	
	ОбновитьСписокИсправлений();
	
	Элементы.УстановленныеИсправленияПрименимоДля.Видимость = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияЖурналРегистрацииНажатие(Элемент)
	МассивСобытий = Новый Массив;
	МассивСобытий.Добавить(НСтр("ru = 'Исправления.Установка';
								|en = 'Patch.Install'"));
	МассивСобытий.Добавить(НСтр("ru = 'Исправления.Изменение';
								|en = 'Patch.Modify'"));
	МассивСобытий.Добавить(НСтр("ru = 'Исправления.Удаление';
								|en = 'Patch.Delete'"));
	ОтборСобытийЖурналаРегистрации = Новый Структура("СобытиеЖурналаРегистрации", МассивСобытий);
	ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации(ОтборСобытийЖурналаРегистрации);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУстановленныеИсправления

&НаКлиенте
Процедура УстановленныеИсправленияПередУдалением(Элемент, Отказ)
	Отказ = Истина;
	Если Не РазделениеВключено И Не ЭтоПодчиненныйУзелРИБ Тогда
		УдалитьРасширения(Элемент.ВыделенныеСтроки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановленныеИсправленияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
	Если Не РазделениеВключено И Не ЭтоПодчиненныйУзелРИБ Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеУстановкиИсправлений", ЭтотОбъект);
		ОткрытьФорму("Обработка.УстановкаОбновлений.Форма",,,,,, Оповещение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановленныеИсправленияПодключатьПриИзменении(Элемент)
	ТекущиеДанные = Элементы.УстановленныеИсправления.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("ИдентификаторСтроки", ТекущиеДанные.ПолучитьИдентификатор());
	
	ПоказатьДлительнуюОперацию();
	ПодключитьОбработчикОжидания("УстановленныеИсправленияПодключатьПриИзмененииЗавершение", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура УстановленныеИсправленияПодключатьПриИзмененииЗавершение()
	
	Попытка
		УстановленныеИсправленияПодключатьПриИзмененииНаСервере(Контекст.ИдентификаторСтроки);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ПоказатьПредупреждение(, ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецПопытки;
	
	СкрытьДлительнуюОперацию();
	
КонецПроцедуры

&НаСервере
Процедура УстановленныеИсправленияПодключатьПриИзмененииНаСервере(ИдентификаторСтроки)
	
	СтрокаСписка = УстановленныеИсправления.НайтиПоИдентификатору(ИдентификаторСтроки);
	Если СтрокаСписка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущееИспользование = СтрокаСписка.Подключать;
	Попытка
		Справочники.ВерсииРасширений.ПереключитьИспользованиеРасширения(СтрокаСписка.ИдентификаторРасширения, ТекущееИспользование);
	Исключение
		СтрокаСписка.Подключать = Не СтрокаСписка.Подключать;
		ОбновитьСписокИсправлений();
		
		ВызватьИсключение;
	КонецПопытки;
	
	ОбновитьСписокИсправлений();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДлительнуюОперацию()
	
	Элементы.СтраницыИнформация.ТекущаяСтраница= Элементы.СтраницаДлительнаяОперация;
	ТолькоПросмотр = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьДлительнуюОперацию()
	
	Элементы.СтраницыИнформация.ТекущаяСтраница = Элементы.СтраницаИнформация;
	ТолькоПросмотр = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьКак(Команда)
	СохранитьИсправления();
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьПодключенныеИсправления(Команда)
	СохранитьИсправления(Истина);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСписокИсправлений()
	
	УстановленныеИсправления.Очистить();
	Элементы.УстановленныеИсправленияПутьКФайлу.Видимость = Ложь;
	
	УстановитьПривилегированныйРежим(Истина);
	Расширения = РасширенияКонфигурации.Получить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ОписаниеИсправлений = ОписаниеУстановленныхИсправлений();
	
	Для Каждого Расширение Из Расширения Цикл
		
		Если Не ОбновлениеКонфигурации.ЭтоИсправление(Расширение) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Фильтр.Количество() <> 0 И Фильтр.НайтиПоЗначению(Расширение.Имя) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СвойстваИсправления = ОбновлениеКонфигурации.СвойстваИсправления(Расширение.Имя);
		
		НоваяСтрока = УстановленныеИсправления.Добавить();
		НоваяСтрока.Имя = Расширение.Имя;
		НоваяСтрока.КонтрольнаяСумма = Base64Строка(Расширение.ХешСумма);
		НоваяСтрока.ИдентификаторРасширения = Расширение.УникальныйИдентификатор;
		НоваяСтрока.Подключать = Расширение.Активно;
		НоваяСтрока.Версия = Расширение.Версия;
		Если СвойстваИсправления = "ОшибкаЧтения" Тогда
			НоваяСтрока.Статус = 0;
		ИначеЕсли СвойстваИсправления <> Неопределено Тогда
			НоваяСтрока.Статус = 0;
			НоваяСтрока.Описание = СвойстваИсправления.Description;
			НоваяСтрока.ПрименимоДля = ИсправлениеПрименимоДля(СвойстваИсправления);
		Иначе
			Описание = ОписаниеИсправлений[Расширение.Имя];
			НоваяСтрока.Статус = 1;
			НоваяСтрока.Описание = Описание;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ОписаниеУстановленныхИсправлений()
	
	Если Не ПриОбновлении Тогда
		Возврат Новый Соответствие;
	КонецЕсли;
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(АдресХранилища);
	ПараметрыМетода.Добавить(Фильтр.ВыгрузитьЗначения());
	ПараметрыМетода.Добавить(Истина);
	ФоновоеЗадание = РасширенияКонфигурации.ВыполнитьФоновоеЗаданиеСРасширениямиБазыДанных(
		"ОбновлениеКонфигурации.ОписанияНовыхПатчей",
		ПараметрыМетода);
	ФоновоеЗадание.ОжидатьЗавершенияВыполнения(Неопределено);
	
	ОписаниеНовыхПатчей = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(ОписаниеНовыхПатчей) <> Тип("Соответствие") Тогда
		ОписаниеНовыхПатчей = Новый Соответствие;
	КонецЕсли;
	
	Возврат ОписаниеНовыхПатчей;
	
КонецФункции

&НаСервере
Функция ИсправлениеПрименимоДля(СвойстваИсправления)
	
	ПрименимоДля = Новый Массив;
	Для Каждого Строка Из СвойстваИсправления.AppliedFor Цикл
		ПрименимоДля.Добавить(Строка.ConfigurationName);
	КонецЦикла;
	
	Возврат СтрСоединить(ПрименимоДля, Символы.ПС);
	
КонецФункции

&НаКлиенте
Процедура УдалитьРасширения(ВыделенныеСтроки)
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторыРасширений = Новый Массив;
	Для Каждого ИдентификаторСтроки Из ВыделенныеСтроки Цикл
		СтрокаИсправления = УстановленныеИсправления.НайтиПоИдентификатору(ИдентификаторСтроки);
		ИдентификаторыРасширений.Добавить(СтрокаИсправления.ИдентификаторРасширения);
	КонецЦикла;
	
	Контекст = Новый Структура;
	Контекст.Вставить("ИдентификаторыРасширений", ИдентификаторыРасширений);
	
	Оповещение = Новый ОписаниеОповещения("УдалитьРасширениеПослеПодтверждения", ЭтотОбъект, Контекст);
	Если ИдентификаторыРасширений.Количество() > 1 Тогда
		ТекстВопроса = НСтр("ru = 'Удалить выделенные исправления?';
							|en = 'Do you want to delete the selected patches?'");
	Иначе
		ТекстВопроса = НСтр("ru = 'Удалить исправление?';
							|en = 'Do you want to delete the patch?'");
	КонецЕсли;
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьРасширениеПослеПодтверждения(Результат, Контекст) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Обработчик = Новый ОписаниеОповещения("УдалитьРасширениеПродолжение", ЭтотОбъект, Контекст);
		
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
			Запросы = ЗапросыНаОтменуРазрешенийИспользованияВнешнегоМодуля(Контекст.ИдентификаторыРасширений);
			МодульРаботаВБезопасномРежимеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаВБезопасномРежимеКлиент");
			МодульРаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(Запросы, ЭтотОбъект, Обработчик);
		Иначе
			ВыполнитьОбработкуОповещения(Обработчик, КодВозвратаДиалога.ОК);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьРасширениеПродолжение(Результат, Контекст) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ТекущийКонтекст = Контекст;
		ПодключитьОбработчикОжидания("УдалитьРасширениеЗавершение", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьРасширениеЗавершение()
	
	Контекст = ТекущийКонтекст;
	
	Попытка
		УдалитьРасширенияНаСервере(Контекст.ИдентификаторыРасширений);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ОбработкаОшибок.ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке);
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьРасширенияНаСервере(ИдентификаторыРасширений)
	
	ТекстОшибки = "";
	Справочники.ВерсииРасширений.УдалитьРасширения(ИдентификаторыРасширений, ТекстОшибки);
	
	ОбновитьСписокИсправлений();
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗапросыНаОтменуРазрешенийИспользованияВнешнегоМодуля(ИдентификаторыРасширений)
	
	Возврат Справочники.ВерсииРасширений.ЗапросыНаОтменуРазрешенийИспользованияВнешнегоМодуля(ИдентификаторыРасширений);
	
КонецФункции

&НаКлиенте
Процедура ПослеУстановкиИсправлений(Результат, ДополнительныеПараметры) Экспорт
	ОбновитьСписокИсправлений();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКакЗавершение(ПутьККаталогу, ВыделенныеСтроки) Экспорт
	
	СохраняемыеФайлы = СохранитьНаСервере(ВыделенныеСтроки, ПутьККаталогу);
	
	Если СохраняемыеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
	ПараметрыСохранения.Интерактивно     = Ложь;
	
	ФайловаяСистемаКлиент.СохранитьФайлы(Неопределено, СохраняемыеФайлы, ПараметрыСохранения);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИсправления(ТолькоПодключенные = Ложь)
	
	Если ТолькоПодключенные Тогда
		ВыделенныеСтроки = ИдентификаторыПодключенныхИсправлений();
	Иначе
		ВыделенныеСтроки = Элементы.УстановленныеИсправления.ВыделенныеСтроки;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СохранитьКакЗавершение", ЭтотОбъект, ВыделенныеСтроки);
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Если ТолькоПодключенные Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Нет подключенных исправлений.';
											|en = 'No attached patches.'"));
		КонецЕсли;
		Возврат;
	ИначеЕсли Не ТолькоПодключенные И ВыделенныеСтроки.Количество() = 1 Тогда
		СохраняемыеФайлы = СохранитьНаСервере(ВыделенныеСтроки);
	Иначе
		Заголовок = НСтр("ru = 'Выберите каталог для сохранения исправлений конфигурации';
						|en = 'Choose a directory to save the patch'");
		ФайловаяСистемаКлиент.ВыбратьКаталог(ОписаниеОповещения, Заголовок);
		Возврат;
	КонецЕсли;
	
	Если СохраняемыеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
	ПараметрыСохранения.Диалог.Заголовок = НСтр("ru = 'Выберите файл для сохранения исправления конфигурации';
												|en = 'Choose a file to save the patch'");
	ПараметрыСохранения.Диалог.Фильтр    = НСтр("ru = 'Файлы исправлений конфигурации (*.cfe)|*.cfe';
												|en = '1C:Enterprise patch files (*.cfe)|*.cfe'") + "|" 
		+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Все файлы (%1)|%1';
																		|en = 'All files (%1)|%1'"), ПолучитьМаскуВсеФайлы());
	
	ФайловаяСистемаКлиент.СохранитьФайлы(Неопределено, СохраняемыеФайлы, ПараметрыСохранения);
	
КонецПроцедуры 

&НаКлиенте
Функция ИдентификаторыПодключенныхИсправлений()
	
	Подключенные = Новый Массив;
	Для Каждого Строка Из УстановленныеИсправления Цикл
		Если Не Строка.Подключать Тогда
			Продолжить;
		КонецЕсли;
		
		Подключенные.Добавить(Строка.ПолучитьИдентификатор());
	КонецЦикла;
	
	Возврат Подключенные;
КонецФункции

&НаСервере
Функция СохранитьНаСервере(ИдентификаторыСтрок, ПутьККаталогу = "")
	
	СохраняемыеФайлы = Новый Массив;
	Для Каждого ИдентификаторСтроки Из ИдентификаторыСтрок Цикл
		СтрокаСписка = УстановленныеИсправления.НайтиПоИдентификатору(ИдентификаторСтроки);
		ИдентификаторРасширения = СтрокаСписка.ИдентификаторРасширения;
		Расширение = НайтиРасширение(ИдентификаторРасширения);
	
		Если Расширение <> Неопределено Тогда
			Если ЗначениеЗаполнено(ПутьККаталогу) Тогда
				Префикс = ПутьККаталогу + ПолучитьРазделительПути();
			Иначе
				Префикс = "";
			КонецЕсли;
			Имя = Префикс + Расширение.Имя + "_" + Расширение.Версия + ".cfe";
			Хранение = ПоместитьВоВременноеХранилище(Расширение.ПолучитьДанные(), ЭтотОбъект.УникальныйИдентификатор);
			ОписаниеПередаваемогоФайла = Новый ОписаниеПередаваемогоФайла(Имя, Хранение);
			СохраняемыеФайлы.Добавить(ОписаниеПередаваемогоФайла);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СохраняемыеФайлы;
	
КонецФункции

&НаСервереБезКонтекста
Функция НайтиРасширение(ИдентификаторРасширения)
	
	Возврат Справочники.ВерсииРасширений.НайтиРасширение(ИдентификаторРасширения);
	
КонецФункции

#КонецОбласти