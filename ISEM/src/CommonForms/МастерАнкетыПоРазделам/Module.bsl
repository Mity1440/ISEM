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
	
	Если НЕ Параметры.Свойство("ШаблонАнкеты") Тогда
		Отказ = Истина;
		Возврат;
	Иначе
		ШаблонАнкеты = Параметры.ШаблонАнкеты;
	КонецЕсли;
	
	УстановитьЗначенияРеквизитовФормыСогласноШаблонаАнкеты();
	Анкетирование.УстановитьЭлементДереваРазделовАнкетыВступлениеЗаключение(ДеревоРазделов, НСтр("ru = 'Вступление';
																								|en = 'Introduction'"), "Вступление");
	Анкетирование.ЗаполнитьДеревоРазделов(ЭтотОбъект,ДеревоРазделов);
	Анкетирование.УстановитьЭлементДереваРазделовАнкетыВступлениеЗаключение(ДеревоРазделов, НСтр("ru = 'Заключение';
																								|en = 'Closing statement'"), "Заключение");
	АнкетированиеКлиентСервер.СформироватьНумерациюДерева(ДеревоРазделов,Истина);
	
	Элементы.ДеревоРазделов.ТекущаяСтрока = 0;
	ПостроениеФормыСогласноРаздела();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеДоступностьюКнопкиНавигацияРазделов();
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДеревоРазделовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДеревоРазделов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьПостроениеФормыЗаполнения();
	УправлениеДоступностьюКнопкиНавигацияРазделов();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииВопросовСУсловием(Элемент)

	УправлениеДоступностьюПодчиненныеВопросы();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииПолосыРегулирования(Элемент)
	
	АнкетированиеКлиент.ПриИзмененииПолосыРегулирования(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииПоляЧисло(Элемент)
	
	АнкетированиеКлиент.ПриИзмененииПоляЧисло(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РегулированиеПоляЧисло(Элемент, Направление, СтандартнаяОбработка)
	
	АнкетированиеКлиент.РегулированиеПоляЧисло(ЭтотОбъект, Элемент, Направление, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СкрытьРазделы(Команда)

	ИзменитьВидимостьДеревоРазделов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредыдущийРаздел(Команда)
	
	ИзменитьРаздел("Назад");
	
КонецПроцедуры

&НаКлиенте
Процедура СледующийРаздел(Команда)
	
	ИзменитьРаздел("Вперед");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборРаздела(Команда)
	
	ВыполнитьПостроениеФормыЗаполнения();
	УправлениеДоступностьюКнопкиНавигацияРазделов();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

КонецПроцедуры

&НаСервере
Процедура ПостроениеФормыСогласноРаздела()
	
	// Определение выбранного раздела.
	ТекущиеДанныеДеревоРазделов = ДеревоРазделов.НайтиПоИдентификатору(Элементы.ДеревоРазделов.ТекущаяСтрока);
	Если ТекущиеДанныеДеревоРазделов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НомерТекущегоРаздела = Элементы.ДеревоРазделов.ТекущаяСтрока;
	Анкетирование.ПостроениеФормыЗаполненияПоРазделу(ЭтотОбъект,ТекущиеДанныеДеревоРазделов);
	Анкетирование.СформироватьТаблицуПодчиненияВопросов(ЭтотОбъект);
	
	Элементы.ПредыдущийРазделПодвал.Видимость = (ТаблицаВопросовРаздела.Количество() > 0);
	Элементы.СледующийРазделПодвал.Видимость  = (ТаблицаВопросовРаздела.Количество() > 0);
	
	АнкетированиеКлиентСервер.ПереключитьВидимостьГруппТелаАнкеты(ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПостроениеФормыЗаполнения()
	
	АнкетированиеКлиентСервер.ПереключитьВидимостьГруппТелаАнкеты(ЭтотОбъект, Ложь);
	ПодключитьОбработчикОжидания("ОкончаниеПостроенияФормыЗаполнения",0.1,Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеПостроенияФормыЗаполнения()
	
	ПостроениеФормыСогласноРаздела();
	УправлениеДоступностьюПодчиненныеВопросы();
	УправлениеДоступностьюКнопкиНавигацияРазделов();
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеДоступностьюКнопкиНавигацияРазделов()
	
	ЭтоПервыйРаздел = Элементы.ДеревоРазделов.ТекущаяСтрока = 0;
	ЭтоПоследнийРаздел = ДеревоРазделов.НайтиПоИдентификатору(Элементы.ДеревоРазделов.ТекущаяСтрока +  1) = Неопределено;

	Элементы.ПредыдущийРаздел.Видимость        = Не ЭтоПервыйРаздел;
	Элементы.ПредыдущийРазделПодвал.Видимость  = Не ЭтоПервыйРаздел;
	Элементы.СледующийРаздел.Видимость         = Не ЭтоПоследнийРаздел;
	Элементы.СледующийРаздел.КнопкаПоУмолчанию = Не ЭтоПоследнийРаздел;
	Элементы.СледующийРазделПодвал.Видимость   = Не ЭтоПоследнийРаздел;
	Элементы.Закрыть.Видимость                 = ЭтоПоследнийРаздел;
	Элементы.Закрыть.КнопкаПоУмолчанию         = ЭтоПоследнийРаздел;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРаздел(Направление)
	
	Элементы.ДеревоРазделов.ТекущаяСтрока = НомерТекущегоРаздела + ?(Направление = "Вперед",1,-1);
	НомерТекущегоРаздела = НомерТекущегоРаздела + ?(Направление = "Вперед",1,-1);
	ТекущиеДанныеДеревоРазделов = ДеревоРазделов.НайтиПоИдентификатору(Элементы.ДеревоРазделов.ТекущаяСтрока);
	Если ТекущиеДанныеДеревоРазделов.КоличествоВопросов = 0 И ТекущиеДанныеДеревоРазделов.ТипСтроки = "Раздел"  Тогда
		ИзменитьРаздел(Направление);
	КонецЕсли;
	ВыполнитьПостроениеФормыЗаполнения();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидимостьДеревоРазделов()

	Элементы.ГруппаДеревоРазделов.Видимость         = НЕ Элементы.ГруппаДеревоРазделов.Видимость;
	Элементы.СкрытьРазделы.Заголовок = ?(Элементы.ГруппаДеревоРазделов.Видимость,НСтр("ru = 'Скрыть разделы';
																						|en = 'Hide sections'"), НСтр("ru = 'Показать разделы';
																													|en = 'Show sections'"));

КонецПроцедуры 

// Управляет доступностью элементов формы.
&НаКлиенте
Процедура УправлениеДоступностьюПодчиненныеВопросы()
	
	Для каждого ЭлементКоллекции Из ПодчиненныеВопросы Цикл
		
		ИмяВопроса = АнкетированиеКлиентСервер.ИмяВопроса(ЭлементКоллекции.Вопрос);
		
		Для каждого ПодчиненныйВопрос Из ЭлементКоллекции.Подчиненные Цикл
			
			ЭлементПодчиненногоВопроса = Элементы[ПодчиненныйВопрос.ИмяЭлементаПодчиненногоВопроса];
			ЭлементПодчиненногоВопроса.ТолькоПросмотр = Не ЭтотОбъект[ИмяВопроса];
			Если СтрЧислоВхождений(ПодчиненныйВопрос.ИмяЭлементаПодчиненногоВопроса, "Реквизит") = 0 Тогда
				
				Попытка
					ЭлементПодчиненногоВопроса.АвтоОтметкаНезаполненного = 
						ЭтотОбъект[ИмяВопроса] И ПодчиненныйВопрос.Обязательный;
				Исключение
					// АПК:280 У флажка и переключателя нет свойства АвтоОтметкаНезаполненного.
				КонецПопытки;
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры 

// Устанавливает значения реквизитов формы, определенных в шаблоне анкеты.
//
&НаСервере
Процедура УстановитьЗначенияРеквизитовФормыСогласноШаблонаАнкеты()

	РеквизитыШаблонАнкеты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ШаблонАнкеты,"Заголовок,Вступление,Заключение");
	ЗаполнитьЗначенияСвойств(ЭтотОбъект,РеквизитыШаблонАнкеты);

КонецПроцедуры

#КонецОбласти
