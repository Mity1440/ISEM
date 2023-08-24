///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если Не ТребуетсяКомментарий Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПояснениеКомментария");
	КонецЕсли;
	
	Если (ТипОтвета <> Перечисления.ТипыОтветовНаВопрос.Строка)
		И (ТипОтвета <> Перечисления.ТипыОтветовНаВопрос.Число) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Длина");
	КонецЕсли;
	Если ТипОтвета <> Перечисления.ТипыОтветовНаВопрос.ЗначениеИнформационнойБазы Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ТипЗначения");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если Не ЭтоГруппа Тогда
		ОчиститьНенужныеРеквизиты();
		УстановкаТипаПВХ();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура очищает значения ненужных реквизитов,
// Такая ситуация возникает, когда пользователь изменяет тип ответа при редактировании.
//
Процедура ОчиститьНенужныеРеквизиты()
	
	Если ((ТипОтвета <> Перечисления.ТипыОтветовНаВопрос.Число) И (ТипОтвета <> Перечисления.ТипыОтветовНаВопрос.Строка)  И (ТипОтвета <> Перечисления.ТипыОтветовНаВопрос.Текст))
	   И (Длина <> 0)Тогда
		
		Длина = 0;
		
	КонецЕсли;
	
	Если (ТипОтвета <> Перечисления.ТипыОтветовНаВопрос.Число) Тогда	
		
		МинимальноеЗначение       = 0;
		МаксимальноеЗначение      = 0;
		АгрегироватьСуммуВОтчетах = Ложь;
		ПоказыватьПолосуРегулирования = Ложь;
		ШагПолосыРегулирования = 0;
		
	КонецЕсли;
	
	Если ТипОтвета = Перечисления.ТипыОтветовНаВопрос.НесколькоВариантовИз Тогда
		ТребуетсяКомментарий = Ложь;
		ПояснениеКомментария = "";
	КонецЕсли;
	
	Если Не ВыводитьПодсказкуУЧисловыхВопросов Тогда
		ДиапазонПодсказокЧисловогоВопроса.Очистить();
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает тип значения ПВХ в зависимости от типа ответа.
Процедура УстановкаТипаПВХ()
	
	Если ТипОтвета = Перечисления.ТипыОтветовНаВопрос.Строка Или ТипОтвета = Перечисления.ТипыОтветовНаВопрос.Текст Тогда
		ТипЗначения = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(Длина));
	ИначеЕсли ТипОтвета = Перечисления.ТипыОтветовНаВопрос.Число Тогда
		ТипЗначения = Новый ОписаниеТипов("Число",, Новый КвалификаторыЧисла(?(Длина = 0, 15, Длина), Точность));
	ИначеЕсли ТипОтвета = Перечисления.ТипыОтветовНаВопрос.Дата Тогда
		ТипЗначения = Новый ОписаниеТипов("Дата", Новый КвалификаторыДаты(ЧастиДаты.Дата));
	ИначеЕсли ТипОтвета = Перечисления.ТипыОтветовНаВопрос.Булево Тогда
		ТипЗначения = Новый ОписаниеТипов("Булево");
	ИначеЕсли ТипОтвета = Перечисления.ТипыОтветовНаВопрос.ОдинВариантИз
		  ИЛИ ТипОтвета = Перечисления.ТипыОтветовНаВопрос.НесколькоВариантовИз Тогда
		ТипЗначения =  Новый ОписаниеТипов("СправочникСсылка.ВариантыОтветовАнкет");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли