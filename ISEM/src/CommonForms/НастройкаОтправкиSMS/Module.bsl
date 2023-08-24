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
	
	УстановитьПривилегированныйРежим(Истина);
	НастройкиОтправкиSMS = ОтправкаSMS.НастройкиОтправкиSMS();
	УстановитьПривилегированныйРежим(Ложь);
	
	НастройкиПровайдера = ОтправкаSMS.НастройкиПровайдера(НастройкиОтправкиSMS.Провайдер);
	ЗаполнитьСпособыАвторизации(ЭтотОбъект);
	
	СпособАвторизации = "ПоЛогинуИПаролю";
	Если НастройкиОтправкиSMS.Свойство("СпособАвторизации")
		И ЗначениеЗаполнено(НастройкиОтправкиSMS.СпособАвторизации)
		И Элементы.СпособАвторизации.СписокВыбора.НайтиПоЗначению(НастройкиОтправкиSMS.СпособАвторизации) <> Неопределено Тогда
		
		СпособАвторизации = НастройкиОтправкиSMS.СпособАвторизации;
	КонецЕсли;
	
	УстановитьПоляАвторизации(ЭтотОбъект);
	ВывестиДополнительнуюИнформацию(ЭтотОбъект);
	
	ЛогинДляОтправкиSMS = НастройкиОтправкиSMS.Логин;
	ИмяОтправителя = НастройкиОтправкиSMS.ИмяОтправителя;
	ПарольДляОтправкиSMS = НастройкиОтправкиSMS.Пароль;
	
	Если Элементы.Пароль.РежимПароля Тогда
		ПарольДляОтправкиSMS = ?(ЗначениеЗаполнено(НастройкиОтправкиSMS.Пароль), ЭтотОбъект.УникальныйИдентификатор, "");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьТекстИнструкцииПоПодключениюУслуги();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьПовторноИспользуемыеЗначения();
	Оповестить("Запись_НастройкиОтправкиSMS", ПараметрыЗаписи, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	УстановитьПривилегированныйРежим(Истина);
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Константа.ПровайдерSMS");
	Если ПарольДляОтправкиSMS <> Строка(ЭтотОбъект.УникальныйИдентификатор) Тогда
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, ПарольДляОтправкиSMS);
	КонецЕсли;
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, ЛогинДляОтправкиSMS, "Логин");
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, ИмяОтправителя, "ИмяОтправителя");
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, СпособАвторизации, "СпособАвторизации");
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПровайдерSMSПриИзменении(Элемент)
	
	НастройкиПровайдера = НастройкиПровайдера(НаборКонстант.ПровайдерSMS);
	
	ЗаполнитьСпособыАвторизации(ЭтотОбъект);
	УстановитьПоляАвторизации(ЭтотОбъект);
	ВывестиДополнительнуюИнформацию(ЭтотОбъект);
	
	ЛогинДляОтправкиSMS = "";
	ПарольДляОтправкиSMS = "";
	ИмяОтправителя = "";
	
	УстановитьТекстИнструкцииПоПодключениюУслуги();
	
КонецПроцедуры

&НаКлиенте
Процедура СпособАвторизацииПриИзменении(Элемент)
	
	ЛогинДляОтправкиSMS = "";
	ПарольДляОтправкиSMS = "";
	
	УстановитьПоляАвторизации(ЭтотОбъект);
	ВывестиДополнительнуюИнформацию(ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НастройкиПровайдера(Провайдер)
	
	Возврат ОтправкаSMS.НастройкиПровайдера(Провайдер);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПоляАвторизации(Форма)

	ПоляАвторизации = Форма.НастройкиПровайдера.ПоляАвторизации[Форма.СпособАвторизации];
	
	Для Каждого ИмяПоля Из СтрРазделить("Логин,Пароль", ",") Цикл
		Поле = ПоляАвторизации.НайтиПоЗначению(ИмяПоля);
		Если Поле <> Неопределено Тогда
			Элемент = Форма.Элементы[ИмяПоля]; // ПолеФормы
			Элемент.Заголовок = Поле.Представление;
		КонецЕсли;
		
		Форма.Элементы[ИмяПоля].Видимость = Поле <> Неопределено;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСпособыАвторизации(Форма)
	
	Форма.Элементы.СпособАвторизации.СписокВыбора.Очистить();
	
	СпособыАвторизацииПоУмолчанию = Форма.НастройкиПровайдера.СпособыАвторизации;
	
	Для Каждого Элемент Из СпособыАвторизацииПоУмолчанию Цикл
		Если Форма.НастройкиПровайдера.ПоляАвторизации.Свойство(Элемент.Значение) Тогда
			Форма.Элементы.СпособАвторизации.СписокВыбора.Добавить(Элемент.Значение, Элемент.Представление);
		КонецЕсли;
	КонецЦикла;
	
	Форма.СпособАвторизации = Форма.Элементы.СпособАвторизации.СписокВыбора[0].Значение;
	Форма.Элементы.СпособАвторизации.Видимость = Форма.Элементы.СпособАвторизации.СписокВыбора.Количество() > 1;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ВывестиДополнительнуюИнформацию(Форма)
	
	Форма.Элементы.ДополнительнаяИнформация.Заголовок = "";
	
	ДополнительнаяИнформация = Форма.НастройкиПровайдера.ИнформацияПоСпособамАвторизации;
	Если ДополнительнаяИнформация.Свойство(Форма.СпособАвторизации) Тогда
		Форма.Элементы.ДополнительнаяИнформация.Заголовок = ДополнительнаяИнформация[Форма.СпособАвторизации];
	КонецЕсли;
	
	Форма.Элементы.ГруппаДополнительнаяИнформация.Видимость = ЗначениеЗаполнено(Форма.Элементы.ДополнительнаяИнформация.Заголовок);
	
КонецПроцедуры

&НаКлиенте
Функция АдресОписанияУслугиВИнтернете()
	
	АдресВИнтернете = НастройкиПровайдера.АдресОписанияУслугиВИнтернете;
	ОтправкаSMSКлиентПереопределяемый.ПриПолученииАдресаПровайдераВИнтернете(НаборКонстант.ПровайдерSMS, АдресВИнтернете);
	Возврат АдресВИнтернете;
	
КонецФункции

&НаКлиенте
Процедура УстановитьТекстИнструкцииПоПодключениюУслуги()
	
	ШаблонИнструкции = НСтр("ru = 'Для подключения услуги отправки SMS заключите договор с провайдером <a href = ""%1"">%2</a>.
	|Имя отправителя следует заполнять только в случае, если оно предусмотрено договором.
	|По вопросам оплаты услуги и проблемам авторизации следует обращаться к провайдеру услуги.';
	|en = 'To start sending text messages, you need to sign an agreement with <a href = ""%1"">%2</a>.
	|Enter the sender''s name only if it is provided by the agreement.
	|For payment details and authorization issues, contact the SMS service provider.'");
	
	Элементы.ИнструкцияПоПодключениюУслуги.Заголовок = СтроковыеФункцииКлиент.ФорматированнаяСтрока(
	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонИнструкции, АдресОписанияУслугиВИнтернете(), НаборКонстант.ПровайдерSMS));
	
КонецПроцедуры

#КонецОбласти
