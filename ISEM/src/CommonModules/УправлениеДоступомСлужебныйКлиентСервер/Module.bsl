///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Определяет назначение профиля.
//
// Параметры:
//  Профиль - СправочникОбъект.ПрофилиГруппДоступа - профиль с табличной частью Назначение.
//          - ДанныеФормыСтруктура   - структура объекта профиля в форме.
//          - Структура              - описание поставляемого профиля.
//          - ФиксированнаяСтруктура - описание поставляемого профиля.
//
// Возвращаемое значение:
//  Строка - "ДляАдминистраторов", "ДляПользователей", "ДляВнешнихПользователей",
//           "СовместноДляПользователейИВнешнихПользователей".
//
Функция НазначениеПрофиля(Профиль) Экспорт
	
	НазначениеДляПользователей = Ложь;
	НазначениеДляВнешнихПользователей = Ложь;
	
	Для Каждого ОписаниеНазначения Из Профиль.Назначение Цикл
		Если ТипЗнч(Профиль.Назначение) = Тип("Массив")
		 Или ТипЗнч(Профиль.Назначение) = Тип("ФиксированныйМассив") Тогда
			Тип = ТипЗнч(ОписаниеНазначения);
		Иначе
			Тип = ТипЗнч(ОписаниеНазначения.ТипПользователей);
		КонецЕсли;
		Если Тип = Тип("СправочникСсылка.Пользователи") Тогда
			НазначениеДляПользователей = Истина;
		КонецЕсли;
		Если Тип <> Тип("СправочникСсылка.Пользователи") И Тип <> Неопределено Тогда
			НазначениеДляВнешнихПользователей = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если НазначениеДляПользователей И НазначениеДляВнешнихПользователей Тогда
		Возврат "СовместноДляПользователейИВнешнихПользователей";
		
	ИначеЕсли НазначениеДляВнешнихПользователей Тогда
		Возврат "ДляВнешнихПользователей";
	КонецЕсли;
	
	Возврат "ДляАдминистраторов";
	
КонецФункции

// Проверяет соответствие вида доступа назначению профиля.
//
// Параметры:
//  ВидДоступа        - Строка - имя вида доступа.
//                    - ОпределяемыйТип.ЗначениеДоступа - тип значений вида доступа.
//  НазначениеПрофиля - Строка - возвращается функцией НазначениеПрофиля.
//  
// Возвращаемое значение:
//  Булево
//
Функция ВидДоступаСоответствуетНазначениюПрофиля(Знач ВидДоступа, НазначениеПрофиля) Экспорт
	
	Если ВидДоступа = "Пользователи"
	 Или ТипЗнч(ВидДоступа) = Тип("СправочникСсылка.Пользователи") Тогда
		
		Возврат НазначениеПрофиля <> "СовместноДляПользователейИВнешнихПользователей"
		      И НазначениеПрофиля <> "ДляВнешнихПользователей";
		
	ИначеЕсли ВидДоступа = "ВнешниеПользователи"
	      Или ТипЗнч(ВидДоступа) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		
		Возврат НазначениеПрофиля = "ДляВнешнихПользователей";
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обслуживание таблиц ВидыДоступа и ЗначенияДоступа в формах редактирования.

// Только для внутреннего использования.
Процедура ЗаполнитьВсеРазрешеныПредставление(Форма, ОписаниеВидаДоступа, ДобавитьКоличествоЗначений = Истина) Экспорт
	
	Параметры = ПараметрыФормыРедактированияРазрешенныхЗначений(Форма);
	
	Если ОписаниеВидаДоступа.ВсеРазрешены Тогда
		Если Форма.ЭтоПрофильГруппДоступа И НЕ ОписаниеВидаДоступа.Предустановленный Тогда
			Имя = "ВначалеВсеРазрешены";
		Иначе
			Имя = "ВсеРазрешены";
		КонецЕсли;
	Иначе
		Если Форма.ЭтоПрофильГруппДоступа И НЕ ОписаниеВидаДоступа.Предустановленный Тогда
			Имя = "ВначалеВсеЗапрещены";
		Иначе
			Имя = "ВсеЗапрещены";
		КонецЕсли;
	КонецЕсли;
	
	ОписаниеВидаДоступа.ВсеРазрешеныПредставление =
		Форма.ПредставленияВсеРазрешены.НайтиСтроки(Новый Структура("Имя", Имя))[0].Представление;
	
	Если НЕ ДобавитьКоличествоЗначений Тогда
		Возврат;
	КонецЕсли;
	
	Если Форма.ЭтоПрофильГруппДоступа И НЕ ОписаниеВидаДоступа.Предустановленный Тогда
		Возврат;
	КонецЕсли;
	
	Отбор = ОтборВТаблицахФормыРедактированияРазрешенныхЗначений(Форма, ОписаниеВидаДоступа.ВидДоступа);
	
	КоличествоЗначений = Параметры.ЗначенияДоступа.НайтиСтроки(Отбор).Количество();
	
	Если Форма.ЭтоПрофильГруппДоступа Тогда
		Если КоличествоЗначений = 0 Тогда
			ЧислоИПредмет = НСтр("ru = 'не назначены';
								|en = 'not assigned'");
		Иначе
			ЧислоИПредмет = Формат(КоличествоЗначений, "ЧГ=") + " "
				+ ПользователиСлужебныйКлиентСервер.ПредметЦелогоЧисла(КоличествоЗначений,
					"", НСтр("ru = 'значение,значения,значений,,,,,,0';
							|en = 'value,values,,,0'"));
		КонецЕсли;
		
		ОписаниеВидаДоступа.ВсеРазрешеныПредставление =
			ОписаниеВидаДоступа.ВсеРазрешеныПредставление
				+ " (" + ЧислоИПредмет + ")";
		Возврат;
	КонецЕсли;
	
	Если КоличествоЗначений = 0 Тогда
		Представление = ?(ОписаниеВидаДоступа.ВсеРазрешены,
			НСтр("ru = 'Все разрешены, без исключений';
				|en = 'All allowed, no exceptions'"),
			НСтр("ru = 'Все запрещены, без исключений';
				|en = 'All denied, no exceptions'"));
	Иначе
		ЧислоИПредмет = Формат(КоличествоЗначений, "ЧГ=") + " "
			+ ПользователиСлужебныйКлиентСервер.ПредметЦелогоЧисла(КоличествоЗначений,
				"", НСтр("ru = 'значения,значений,значений,,,,,,0';
						|en = 'value,values,,,0'"));
		
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			?(ОписаниеВидаДоступа.ВсеРазрешены,
				НСтр("ru = 'Все разрешены, кроме %1';
					|en = 'All allowed, except %1'"),
				НСтр("ru = 'Все запрещены, кроме %1';
					|en = 'All denied, except %1'")),
			ЧислоИПредмет);
	КонецЕсли;
	
	ОписаниеВидаДоступа.ВсеРазрешеныПредставление = Представление;
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ЗаполнитьНомераСтрокЗначенийДоступаПоВиду(Форма, ОписаниеВидаДоступа) Экспорт
	
	Параметры = ПараметрыФормыРедактированияРазрешенныхЗначений(Форма);
	
	Отбор = ОтборВТаблицахФормыРедактированияРазрешенныхЗначений(Форма, ОписаниеВидаДоступа.ВидДоступа);
	ЗначенияДоступаПоВиду = Параметры.ЗначенияДоступа.НайтиСтроки(Отбор);
	
	ТекущийНомер = 1;
	Для каждого Строка Из ЗначенияДоступаПоВиду Цикл
		Строка.НомерСтрокиПоВиду = ТекущийНомер;
		ТекущийНомер = ТекущийНомер + 1;
	КонецЦикла;
	
КонецПроцедуры

// Только для внутреннего использования.
//
// Параметры:
//  Форма - см. ПараметрыФормыРедактированияРазрешенныхЗначений
//  ОбработкаНаКлиенте - Булево
//
Процедура ПриИзмененииТекущегоВидаДоступа(Форма, ОбработкаНаКлиенте = Истина) Экспорт
	
	Элементы = Форма.Элементы;
	Параметры = ПараметрыФормыРедактированияРазрешенныхЗначений(Форма);
	
	ЗначенияРедактируются = Ложь;
	
	Если ОбработкаНаКлиенте Тогда
		ТекущиеДанные = Элементы.ВидыДоступа.ТекущиеДанные;
	Иначе
		ТекущиеДанные = Параметры.ВидыДоступа.НайтиПоИдентификатору(
			?(Элементы.ВидыДоступа.ТекущаяСтрока = Неопределено, -1, Элементы.ВидыДоступа.ТекущаяСтрока));
	КонецЕсли;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если ТекущиеДанные.ВидДоступа <> Неопределено
		   И НЕ ТекущиеДанные.Используется Тогда
			
			Если НЕ Элементы.ТекстВидДоступаНеИспользуется.Видимость Тогда
				Элементы.ТекстВидДоступаНеИспользуется.Видимость = Истина;
			КонецЕсли;
		Иначе
			Если Элементы.ТекстВидДоступаНеИспользуется.Видимость Тогда
				Элементы.ТекстВидДоступаНеИспользуется.Видимость = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		Форма.ТекущийВидДоступа = ТекущиеДанные.ВидДоступа;
		
		Если НЕ Форма.ЭтоПрофильГруппДоступа ИЛИ ТекущиеДанные.Предустановленный Тогда
			ЗначенияРедактируются = Истина;
		КонецЕсли;
		
		Если ЗначенияРедактируются Тогда
			
			Если Форма.ЭтоПрофильГруппДоступа Тогда
				Элементы.ТипыВидовДоступа.ТекущаяСтраница = Элементы.ПредустановленныйВидДоступа;
			КонецЕсли;
			
			// Установка отбора значений.
			ОбновитьОтборСтрок = Ложь;
			ОтборСтрок = Элементы.ЗначенияДоступа.ОтборСтрок;
			Отбор = ОтборВТаблицахФормыРедактированияРазрешенныхЗначений(Форма, ТекущиеДанные.ВидДоступа);
			
			Если ОтборСтрок = Неопределено Тогда
				ОбновитьОтборСтрок = Истина;
				
			ИначеЕсли Отбор.Свойство("ГруппаДоступа") И ОтборСтрок.ГруппаДоступа <> Отбор.ГруппаДоступа Тогда
				ОбновитьОтборСтрок = Истина;
				
			ИначеЕсли ОтборСтрок.ВидДоступа <> Отбор.ВидДоступа
			        И НЕ (ОтборСтрок.ВидДоступа = "" И Отбор.ВидДоступа = Неопределено) Тогда
				
				ОбновитьОтборСтрок = Истина;
			КонецЕсли;
			
			Если ОбновитьОтборСтрок Тогда
				Если ТекущиеДанные.ВидДоступа = Неопределено Тогда
					Отбор.ВидДоступа = "";
				КонецЕсли;
				Элементы.ЗначенияДоступа.ОтборСтрок = Новый ФиксированнаяСтруктура(Отбор);
			КонецЕсли;
			
		ИначеЕсли Форма.ЭтоПрофильГруппДоступа Тогда
			Элементы.ТипыВидовДоступа.ТекущаяСтраница = Элементы.ОбычныйВидДоступа;
		КонецЕсли;
		
		Если ТекущиеДанные.ВидДоступа = Форма.ВидДоступаПользователи Тогда
			ШаблонНадписи = ?(ТекущиеДанные.ВсеРазрешены,
				НСтр("ru = 'Запрещенные значения (%1) - текущий пользователь всегда разрешен';
					|en = 'Denied values (%1), the current user is always allowed'"),
				НСтр("ru = 'Разрешенные значения (%1) - текущий пользователь всегда разрешен';
					|en = 'Allowed values (%1), the current user is always allowed'") );
		
		ИначеЕсли ТекущиеДанные.ВидДоступа = Форма.ВидДоступаВнешниеПользователи Тогда
			ШаблонНадписи = ?(ТекущиеДанные.ВсеРазрешены,
				НСтр("ru = 'Запрещенные значения (%1) - текущий внешний пользователь всегда разрешен';
					|en = 'Denied values (%1), the current external user is always allowed'"),
				НСтр("ru = 'Разрешенные значения (%1) - текущий внешний пользователь всегда разрешен';
					|en = 'Allowed values (%1), the current external user is always allowed'") );
		Иначе
			ШаблонНадписи = ?(ТекущиеДанные.ВсеРазрешены,
				НСтр("ru = 'Запрещенные значения (%1)';
					|en = 'Denied values (%1)'"),
				НСтр("ru = 'Разрешенные значения (%1)';
					|en = 'Allowed values (%1)'") );
		КонецЕсли;
		
		// Обновление поля НадписьВидДоступа.
		Форма.НадписьВидДоступа = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонНадписи,
			Строка(ТекущиеДанные.ВидДоступаПредставление));
		
		ЗаполнитьВсеРазрешеныПредставление(Форма, ТекущиеДанные);
		
	Иначе
		Если Элементы.ТекстВидДоступаНеИспользуется.Видимость Тогда
			Элементы.ТекстВидДоступаНеИспользуется.Видимость = Ложь;
		КонецЕсли;
		
		Форма.ТекущийВидДоступа = Неопределено;
		Элементы.ЗначенияДоступа.ОтборСтрок = Новый ФиксированнаяСтруктура(
			ОтборВТаблицахФормыРедактированияРазрешенныхЗначений(Форма, Неопределено));
		
		Если Параметры.ВидыДоступа.Количество() = 0 Тогда
			Параметры.ЗначенияДоступа.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	Форма.ТекущийТипВыбираемыхЗначений  = Неопределено;
	Форма.ТекущиеТипыВыбираемыхЗначений = Новый СписокЗначений;
	
	Если ЗначенияРедактируются Тогда
		Отбор = Новый Структура("ВидДоступа", ТекущиеДанные.ВидДоступа);
		ОписаниеТиповВидовДоступа = Форма.ВсеТипыВыбираемыхЗначений.НайтиСтроки(Отбор);
		ИерархияЭлементов = Истина;
		Для каждого ОписаниеТипаВидаДоступа Из ОписаниеТиповВидовДоступа Цикл
			
			Форма.ТекущиеТипыВыбираемыхЗначений.Добавить(
				ОписаниеТипаВидаДоступа.ТипЗначений,
				ОписаниеТипаВидаДоступа.ПредставлениеТипа);
				
			ИерархияЭлементов = ИерархияЭлементов И ОписаниеТипаВидаДоступа.ИерархияЭлементов;
		КонецЦикла;
		
		Элементы.ЗначенияДоступаВключаяНижестоящие.Видимость = ИерархияЭлементов;
	Иначе
		Если ТекущиеДанные <> Неопределено Тогда
			
			Отбор = ОтборВТаблицахФормыРедактированияРазрешенныхЗначений(
				Форма, ТекущиеДанные.ВидДоступа);
			
			Для каждого Строка Из Параметры.ЗначенияДоступа.НайтиСтроки(Отбор) Цикл
				Параметры.ЗначенияДоступа.Удалить(Строка);
			КонецЦикла
		КонецЕсли;
	КонецЕсли;
	
	Если Форма.ТекущиеТипыВыбираемыхЗначений.Количество() = 0 Тогда
		Форма.ТекущиеТипыВыбираемыхЗначений.Добавить(Неопределено, НСтр("ru = 'Неопределено';
																		|en = 'Undefined'"));
	КонецЕсли;
	
	Элементы.ЗначенияДоступа.Доступность = ЗначенияРедактируются;
	
КонецПроцедуры

// Только для внутреннего использования.
// См. УправлениеДоступомСлужебный.ПриСозданииНаСервереФормыРедактированияРазрешенныхЗначений
//
// Возвращаемое значение:
//   ФормаКлиентскогоПриложения:
//     * Элементы - ВсеЭлементыФормы:
//         ** Назначение                - ТаблицаФормы
//         ** ВидыДоступа               - ТаблицаФормы
//         ** ЗначенияДоступа           - ТаблицаФормы
//         ** ВсеВидыДоступа            - ТаблицаФормы
//         ** ПредставленияВсеРазрешены - ТаблицаФормы
//         ** ВсеТипыВыбираемыхЗначений - ТаблицаФормы
//     * ТекущаяГруппаДоступа                - СправочникСсылка.ГруппыДоступа
//     * Назначение                          - см. НазначениеИзФормы
//     * ВидыДоступа                         - см. ВидыДоступаИзФормы
//     * ЗначенияДоступа                     - см. ЗначенияДоступаИзФормы
//     * ИспользоватьВнешнихПользователей    - Булево - реквизит будет создан, если нет в форме
//     * НадписьВидДоступа                   - Строка - представление текущего вида доступа в форме
//     * ЭтоПрофильГруппДоступа              - Булево
//     * ТекущийВидДоступа                   - ОпределяемыйТип.ЗначениеДоступа
//     * ТекущиеТипыВыбираемыхЗначений       - СписокЗначений
//     * ТекущийТипВыбираемыхЗначений        - ОпределяемыйТип.ЗначениеДоступа
//     * ИмяРеквизитаХранилищаТаблиц         - Строка
//     * ВидДоступаПользователи              - ОпределяемыйТип.ЗначениеДоступа
//     * ВидДоступаВнешниеПользователи       - ОпределяемыйТип.ЗначениеДоступа
//     * ВсеВидыДоступа                      - см. ВсеВидыДоступаИзФормы
//     * ПредставленияВсеРазрешены           - см. ПредставленияВсеРазрешеныИзФормы
//     * ВсеТипыВыбираемыхЗначений           - см. ВсеТипыВыбираемыхЗначенийИзФормы
//
Функция ПараметрыФормыРедактированияРазрешенныхЗначений(Форма, ТекущийОбъект = Неопределено) Экспорт
	
	ПутьКТаблицам = "";
	
	Если ТекущийОбъект <> Неопределено Тогда
		ХранилищеТаблиц = ТекущийОбъект;
		
	ИначеЕсли ЗначениеЗаполнено(Форма.ИмяРеквизитаХранилищаТаблиц) Тогда
		ПутьКТаблицам = Форма.ИмяРеквизитаХранилищаТаблиц + ".";
		ХранилищеТаблиц = Форма[Форма.ИмяРеквизитаХранилищаТаблиц];
	Иначе
		ХранилищеТаблиц = Форма;
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("Назначение",                НазначениеИзФормы(ХранилищеТаблиц));
	Параметры.Вставить("ВидыДоступа",               ВидыДоступаИзФормы(ХранилищеТаблиц));
	Параметры.Вставить("ЗначенияДоступа",           ЗначенияДоступаИзФормы(ХранилищеТаблиц));
	Параметры.Вставить("ВсеВидыДоступа",            ВсеВидыДоступаИзФормы(Форма));
	Параметры.Вставить("ПредставленияВсеРазрешены", ПредставленияВсеРазрешеныИзФормы(Форма));
	Параметры.Вставить("ВсеТипыВыбираемыхЗначений", ВсеТипыВыбираемыхЗначенийИзФормы(Форма));
	Параметры.Вставить("ПутьКТаблицам",   ПутьКТаблицам);
	
	Возврат Параметры;
	
КонецФункции

// Только для внутреннего использования.
//
// Параметры:
//  Форма - см. ПараметрыФормыРедактированияРазрешенныхЗначений
//  ВидДоступа - Строка
//             - ОпределяемыйТип.ЗначениеДоступа
// 
// Возвращаемое значение:
//  Отбор - Структура:
//   * ГруппаДоступа - СправочникСсылка.ГруппыДоступа
//   * ВидДоступа - ОпределяемыйТип.ЗначениеДоступа - пустая ссылка основного типа вида доступа.
//
Функция ОтборВТаблицахФормыРедактированияРазрешенныхЗначений(Форма, ВидДоступа = "БезОтбораПоВидуДоступа") Экспорт
	
	Отбор = Новый Структура;
	
	Структура = Новый Структура("ТекущаяГруппаДоступа", "РеквизитНеСуществует");
	ЗаполнитьЗначенияСвойств(Структура, Форма);
	
	Если Структура.ТекущаяГруппаДоступа <> "РеквизитНеСуществует" Тогда
		Отбор.Вставить("ГруппаДоступа", Структура.ТекущаяГруппаДоступа);
	КонецЕсли;
	
	Если ВидДоступа <> "БезОтбораПоВидуДоступа" Тогда
		Отбор.Вставить("ВидДоступа", ВидДоступа);
	КонецЕсли;
	
	Возврат Отбор;
	
КонецФункции

// Только для внутреннего использования.
Процедура ЗаполнитьСвойстваВидовДоступаВФорме(Форма) Экспорт
	
	Параметры = ПараметрыФормыРедактированияРазрешенныхЗначений(Форма);
	
	ОтборВидовДоступа = ОтборВТаблицахФормыРедактированияРазрешенныхЗначений(Форма);
	ВидыДоступа = Параметры.ВидыДоступа.НайтиСтроки(ОтборВидовДоступа);
	
	Для каждого Строка Из ВидыДоступа Цикл
		
		Строка.Используется = Истина;
		
		Если Строка.ВидДоступа <> Неопределено Тогда
			Отбор = Новый Структура("Ссылка", Строка.ВидДоступа);
			НайденныеСтроки = Форма.ВсеВидыДоступа.НайтиСтроки(Отбор);
			Если НайденныеСтроки.Количество() > 0 Тогда
				Строка.ВидДоступаПредставление = НайденныеСтроки[0].Представление;
				Строка.Используется            = НайденныеСтроки[0].Используется;
			КонецЕсли;
		КонецЕсли;
		
		ЗаполнитьВсеРазрешеныПредставление(Форма, Строка);
		
		ЗаполнитьНомераСтрокЗначенийДоступаПоВиду(Форма, Строка);
	КонецЦикла;
	
КонецПроцедуры

// Только для внутреннего использования.
// 
// Параметры:
//  Форма - см. ПараметрыФормыРедактированияРазрешенныхЗначений
//  Отказ - Булево
//  ПроверенныеРеквизитыТаблиц - Массив из Строка
//  Ошибки - см. ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю.Ошибки
//  НеПроверять - Булево
//
Процедура ОбработкаПроверкиЗаполненияНаСервереФормыРедактированияРазрешенныхЗначений(
		Форма, Отказ, ПроверенныеРеквизитыТаблиц, Ошибки, НеПроверять = Ложь) Экспорт
	
	Элементы = Форма.Элементы;
	Параметры = ПараметрыФормыРедактированияРазрешенныхЗначений(Форма);
	Если Параметры.Назначение <> Неопределено Тогда
		НазначениеПрофиля = НазначениеПрофиля(Параметры);
	КонецЕсли;
	
	ПроверенныеРеквизитыТаблиц.Добавить(Параметры.ПутьКТаблицам + "ВидыДоступа.ВидДоступа");
	ПроверенныеРеквизитыТаблиц.Добавить(Параметры.ПутьКТаблицам + "ЗначенияДоступа.ВидДоступа");
	ПроверенныеРеквизитыТаблиц.Добавить(Параметры.ПутьКТаблицам + "ЗначенияДоступа.ЗначениеДоступа");
	
	Если НеПроверять Тогда
		Возврат;
	КонецЕсли;
	
	ОтборВидовДоступа = ОтборВТаблицахФормыРедактированияРазрешенныхЗначений(Форма);
	
	ВидыДоступа = Параметры.ВидыДоступа.НайтиСтроки(ОтборВидовДоступа);
	ИндексВидаДоступа = ВидыДоступа.Количество();
	
	// Проверка незаполненных и повторяющихся видов доступа.
	Пока ИндексВидаДоступа > 0 Цикл
		ИндексВидаДоступа = ИндексВидаДоступа - 1;
		СтрокаВидаДоступа = ВидыДоступа[ИндексВидаДоступа];
		
		// Проверка заполнения вида доступа.
		Если СтрокаВидаДоступа.ВидДоступа = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				Параметры.ПутьКТаблицам + "ВидыДоступа[%1].ВидДоступа",
				НСтр("ru = 'Вид доступа не выбран.';
					|en = 'The access kind is not selected.'"),
				"ВидыДоступа",
				ВидыДоступа.Найти(СтрокаВидаДоступа),
				НСтр("ru = 'Вид доступа в строке %1 не выбран.';
					|en = 'No access kind selected in line #%1.'"),
				Параметры.ВидыДоступа.Индекс(СтрокаВидаДоступа));
			Отказ = Истина;
			Продолжить;
		КонецЕсли;
		
		// Проверка соответствия вида доступа назначению профиля.
		Если Параметры.Назначение <> Неопределено
		  И Не ВидДоступаСоответствуетНазначениюПрофиля(СтрокаВидаДоступа.ВидДоступа, НазначениеПрофиля) Тогда
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				Параметры.ПутьКТаблицам + "ВидыДоступа[%1].ВидДоступа",
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вид доступа ""%1"" не соответствует назначению профиля.';
																			|en = 'Access kind ""%1"" does not match the profile assignment.'"),
					СтрокаВидаДоступа.ВидДоступаПредставление),
				"ВидыДоступа",
				ВидыДоступа.Найти(СтрокаВидаДоступа),
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вид доступа ""%1"" в строке %2 не соответствует назначению профиля.';
																			|en = 'Access kind ""%1"" in line #%2 does not match the profile assignment.'"),
					СтрокаВидаДоступа.ВидДоступаПредставление, "%1"),
				Параметры.ВидыДоступа.Индекс(СтрокаВидаДоступа));
			Отказ = Истина;
			Продолжить;
		КонецЕсли;
		
		// Проверка наличия повторяющихся видов доступа.
		ОтборВидовДоступа.Вставить("ВидДоступа", СтрокаВидаДоступа.ВидДоступа);
		НайденныеВидыДоступа = Параметры.ВидыДоступа.НайтиСтроки(ОтборВидовДоступа);
		
		Если НайденныеВидыДоступа.Количество() > 1 Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				Параметры.ПутьКТаблицам + "ВидыДоступа[%1].ВидДоступа",
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вид доступа ""%1"" повторяется.';
																			|en = 'Duplicate access kind: ""%1"".'"),
					СтрокаВидаДоступа.ВидДоступаПредставление),
				"ВидыДоступа",
				ВидыДоступа.Найти(СтрокаВидаДоступа),
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вид доступа ""%1"" в строке %2 повторяется.';
																			|en = 'Duplicate access kind ""%1"" in line #%2.'"),
					СтрокаВидаДоступа.ВидДоступаПредставление, "%1"),
				Параметры.ВидыДоступа.Индекс(СтрокаВидаДоступа));
			Отказ = Истина;
			Продолжить;
		КонецЕсли;
		
		ОтборЗначенийДоступа = ОтборВТаблицахФормыРедактированияРазрешенныхЗначений(
			Форма, СтрокаВидаДоступа.ВидДоступа);
		
		ЗначенияДоступа = Параметры.ЗначенияДоступа.НайтиСтроки(ОтборЗначенийДоступа);
		ИндексЗначенияДоступа = ЗначенияДоступа.Количество();
		
		Пока ИндексЗначенияДоступа > 0 Цикл
			ИндексЗначенияДоступа = ИндексЗначенияДоступа - 1;
			СтрокаЗначенияДоступа = ЗначенияДоступа[ИндексЗначенияДоступа];
			
			// Проверка заполнения значения доступа.
			Если СтрокаЗначенияДоступа.ЗначениеДоступа = Неопределено Тогда
				Элементы.ВидыДоступа.ТекущаяСтрока = СтрокаВидаДоступа.ПолучитьИдентификатор();
				Элементы.ЗначенияДоступа.ТекущаяСтрока = СтрокаЗначенияДоступа.ПолучитьИдентификатор();
				
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
					Параметры.ПутьКТаблицам + "ЗначенияДоступа[%1].ЗначениеДоступа",
					НСтр("ru = 'Значение не выбрано.';
						|en = 'No value is selected.'"),
					"ЗначенияДоступа",
					ЗначенияДоступа.Найти(СтрокаЗначенияДоступа),
					НСтр("ru = 'Значение в строке %1 не выбрано.';
						|en = 'No value selected in line #%1.'"),
					Параметры.ЗначенияДоступа.Индекс(СтрокаЗначенияДоступа));
				Отказ = Истина;
				Продолжить;
			КонецЕсли;
			
			// Проверка наличия повторяющихся значений.
			ОтборЗначенийДоступа.Вставить("ЗначениеДоступа", СтрокаЗначенияДоступа.ЗначениеДоступа);
			НайденныеЗначения = Параметры.ЗначенияДоступа.НайтиСтроки(ОтборЗначенийДоступа);
			
			Если НайденныеЗначения.Количество() > 1 Тогда
				Элементы.ВидыДоступа.ТекущаяСтрока = СтрокаВидаДоступа.ПолучитьИдентификатор();
				Элементы.ЗначенияДоступа.ТекущаяСтрока = СтрокаЗначенияДоступа.ПолучитьИдентификатор();
				
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
					Параметры.ПутьКТаблицам + "ЗначенияДоступа[%1].ЗначениеДоступа",
					НСтр("ru = 'Значение повторяется.';
						|en = 'Duplicate value.'"),
					"ЗначенияДоступа",
					ЗначенияДоступа.Найти(СтрокаЗначенияДоступа),
					НСтр("ru = 'Значение в строке %1 повторяется.';
						|en = 'Duplicate value in line #%1.'"),
					Параметры.ЗначенияДоступа.Индекс(СтрокаЗначенияДоступа));
				Отказ = Истина;
				Продолжить;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  Данные - Структура:
//   * Наименование - Строка
//   * Пользователь - СправочникСсылка.Пользователи
//   
// Возвращаемое значение:
//  Строка
//
Функция ПредставлениеГруппыДоступа(Данные) Экспорт
	
	Возврат Данные.Наименование + ": " + Данные.Пользователь;
	
КонецФункции

// Только для внутреннего использования.
// См. УправлениеДоступомСлужебный.ПриСозданииНаСервереФормыРедактированияРазрешенныхЗначений
//
// Возвращаемое значение:
//   ДанныеФормыКоллекция из ДанныеФормыЭлементКоллекции:
//     * ТипПользователя - ОпределяемыйТип.Пользователь - тип назначения.
//
Функция НазначениеИзФормы(Форма)
	
	НеобязательныеРеквизиты = Новый Структура("Назначение");
	ЗаполнитьЗначенияСвойств(НеобязательныеРеквизиты, Форма);
	Возврат НеобязательныеРеквизиты.Назначение;
	
КонецФункции

// Только для внутреннего использования.
// См. УправлениеДоступомСлужебный.ПриСозданииНаСервереФормыРедактированияРазрешенныхЗначений
//
// Возвращаемое значение:
//   ДанныеФормыКоллекция из ДанныеФормыЭлементКоллекции:
//    * ГруппаДоступа              - СправочникСсылка.ГруппыДоступа
//    * ВидДоступа                 - ОпределяемыйТип.ЗначениеДоступа
//    * Предустановленный          - Булево - (только для профиля)
//    * ВсеРазрешены               - Булево
//    * ВидДоступаПредставление    - Строка - представление настройки,
//    * ВсеРазрешеныПредставление  - Строка - представление настройки,
//    * Используется               - Булево
//
Функция ВидыДоступаИзФормы(Форма)
	
	Возврат Форма.ВидыДоступа;
	
КонецФункции

// Только для внутреннего использования.
// См. УправлениеДоступомСлужебный.ПриСозданииНаСервереФормыРедактированияРазрешенныхЗначений
//
// Возвращаемое значение:
//   ДанныеФормыКоллекция из ДанныеФормыЭлементКоллекции:
//    * ГруппаДоступа     - СправочникСсылка.ГруппыДоступа
//    * ВидДоступа        - ОпределяемыйТип.ЗначениеДоступа
//    * ЗначениеДоступа   - ОпределяемыйТип.ЗначениеДоступа
//    * НомерСтрокиПоВиду - Число
//
Функция ЗначенияДоступаИзФормы(Форма)
	
	Возврат Форма.ЗначенияДоступа;
	
КонецФункции

// Только для внутреннего использования.
// См. УправлениеДоступомСлужебный.ПриСозданииНаСервереФормыРедактированияРазрешенныхЗначений
//
// Возвращаемое значение:
//   ДанныеФормыКоллекция из ДанныеФормыЭлементКоллекции:
//    * Ссылка        - ОпределяемыйТип.ЗначениеДоступа
//    * Представление - Строка
//    * Используется  - Булево
//
Функция ВсеВидыДоступаИзФормы(Форма)
	
	НеобязательныеРеквизиты = Новый Структура("ВсеВидыДоступа");
	ЗаполнитьЗначенияСвойств(НеобязательныеРеквизиты, Форма);
	Возврат НеобязательныеРеквизиты.ВсеВидыДоступа;
	
КонецФункции

// Только для внутреннего использования.
// См. УправлениеДоступомСлужебный.ПриСозданииНаСервереФормыРедактированияРазрешенныхЗначений
//
// Возвращаемое значение:
//   ДанныеФормыКоллекция из ДанныеФормыЭлементКоллекции:
//    * Имя           - Строка
//    * Представление - Строка
//
Функция ПредставленияВсеРазрешеныИзФормы(Форма)
	
	НеобязательныеРеквизиты = Новый Структура("ПредставленияВсеРазрешены");
	ЗаполнитьЗначенияСвойств(НеобязательныеРеквизиты, Форма);
	Возврат НеобязательныеРеквизиты.ПредставленияВсеРазрешены;
	
КонецФункции

// Только для внутреннего использования.
// См. УправлениеДоступомСлужебный.ПриСозданииНаСервереФормыРедактированияРазрешенныхЗначений
//
// Возвращаемое значение:
//   ДанныеФормыКоллекция из ДанныеФормыЭлементКоллекции:
//    * ВидДоступа        - ОпределяемыйТип.ЗначениеДоступа
//    * ТипЗначений       - ОпределяемыйТип.ЗначениеДоступа
//    * ПредставлениеТипа - Строка
//    * ИмяТаблицы        - Строка
//    * ИерархияЭлементов - Булево
//
Функция ВсеТипыВыбираемыхЗначенийИзФормы(Форма)
	
	НеобязательныеРеквизиты = Новый Структура("ВсеТипыВыбираемыхЗначений");
	ЗаполнитьЗначенияСвойств(НеобязательныеРеквизиты, Форма);
	Возврат НеобязательныеРеквизиты.ВсеТипыВыбираемыхЗначений;
	
КонецФункции

#КонецОбласти
