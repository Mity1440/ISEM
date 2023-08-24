///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	// Отказываемся от выполнения типового механизма регистрации объектов.
	ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
	
	// Удаляем все узлы, добавленные по авторегистрации, если признак авторегистрации был ошибочно установлен.
	ОбменДанными.Получатели.Очистить();
	
	// Заполняем свойство УникальныйИдентификаторИсточникаСтрокой из ссылки источника.
	Если Количество() > 0 Тогда
		
		Если ЭтотОбъект[0].ОбъектВыгруженПоСсылке = Истина Тогда
			Возврат;
		КонецЕсли;
		
		ЭтотОбъект[0]["УникальныйИдентификаторИсточникаСтрокой"] = Строка(ЭтотОбъект[0]["УникальныйИдентификаторИсточника"].УникальныйИдентификатор());
		
	КонецЕсли;
	
	Если ОбменДанными.Загрузка
		ИЛИ Не ЗначениеЗаполнено(Отбор.УзелИнформационнойБазы.Значение)
		ИЛИ Не ЗначениеЗаполнено(Отбор.УникальныйИдентификаторПриемника.Значение)
		ИЛИ Не ОбщегоНазначения.СсылкаСуществует(Отбор.УзелИнформационнойБазы.Значение) Тогда
		Возврат;
	КонецЕсли;
	
	// Набор записей должен регистрироваться только на одном узле, указанном в отборе.
	ОбменДанными.Получатели.Добавить(Отбор.УзелИнформационнойБазы.Значение);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли