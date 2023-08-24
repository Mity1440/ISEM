///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает полный путь к информационной базе (строку соединения).
//
// Параметры:
//  ПризнакФайловогоРежима  - Булево - выходной параметр. Принимает значение.
//                                     Истина, если текущая ИБ - файловая;
//                                     Ложь - если клиент-серверная.
//  ПортКластераСерверов    - Число  - входной параметр. Задается в случае, если
//                                     кластер серверов использует нестандартный номер порта.
//                                     Значение по умолчанию - 0, означает, что 
//                                     кластер серверов занимает номер порта по умолчанию.
//
// Возвращаемое значение:
//   Строка   - строка соединения ИБ.
//
Функция ПутьКИнформационнойБазе(ПризнакФайловогоРежима = Неопределено, Знач ПортКластераСерверов = 0) Экспорт
	
	СтрокаСоединения = СтрокаСоединенияИнформационнойБазы();
	
	ПозицияПоиска = СтрНайти(ВРег(СтрокаСоединения), "FILE=");
	
	Если ПозицияПоиска = 1 Тогда // файловая ИБ
		
		ПутьКИБ = Сред(СтрокаСоединения, 6, СтрДлина(СтрокаСоединения) - 6);
		ПризнакФайловогоРежима = Истина;
		
	Иначе
		ПризнакФайловогоРежима = Ложь;
		
		ПозицияПоиска = СтрНайти(ВРег(СтрокаСоединения), "SRVR=");
		
		Если НЕ (ПозицияПоиска = 1) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ПозицияТочкиСЗапятой = СтрНайти(СтрокаСоединения, ";");
		НачальнаяПозицияКопирования = 6 + 1;
		КонечнаяПозицияКопирования = ПозицияТочкиСЗапятой - 2;
		
		ИмяСервера = Сред(СтрокаСоединения, НачальнаяПозицияКопирования, КонечнаяПозицияКопирования - НачальнаяПозицияКопирования + 1);
		
		СтрокаСоединения = Сред(СтрокаСоединения, ПозицияТочкиСЗапятой + 1);
		
		// позиция имени сервера
		ПозицияПоиска = СтрНайти(ВРег(СтрокаСоединения), "REF=");
		
		Если НЕ (ПозицияПоиска = 1) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		НачальнаяПозицияКопирования = 6;
		ПозицияТочкиСЗапятой = СтрНайти(СтрокаСоединения, ";");
		КонечнаяПозицияКопирования = ПозицияТочкиСЗапятой - 2;
		
		ИмяИБНаСервере = Сред(СтрокаСоединения, НачальнаяПозицияКопирования, КонечнаяПозицияКопирования - НачальнаяПозицияКопирования + 1);
		
		ПутьКИБ = """" + ИмяСервера + "\" + ИмяИБНаСервере + """";
	КонецЕсли;
	
	Возврат ПутьКИБ;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Удаляет все сеансы информационной базы кроме текущего.
//
Процедура УдалитьВсеСеансыКромеТекущего(ПараметрыАдминистрирования) Экспорт
	
	СоединенияИБВызовСервера.УдалитьВсеСеансыКромеТекущего(ПараметрыАдминистрирования);
	
КонецПроцедуры

// Возвращает текстовую константу для формирования сообщений.
// Используется в целях локализации.
//
// Возвращаемое значение:
//  Строка - текст для администратора.
//
Функция ТекстДляАдминистратора() Экспорт
	
	Возврат НСтр("ru = 'Для администратора:';
				|en = 'Message for administrator:'");
	
КонецФункции

// Возвращает пользовательский текст сообщения блокировки сеансов.
//
// Параметры:
//   Сообщение - Строка - полное сообщение.
// 
// Возвращаемое значение:
//  Строка - сообщение блокировки.
//
Функция ИзвлечьСообщениеБлокировки(Знач Сообщение) Экспорт
	
	ИндексМаркера = СтрНайти(Сообщение, ТекстДляАдминистратора());
	Если ИндексМаркера = 0  Тогда
		Возврат Сообщение;
	ИначеЕсли ИндексМаркера >= 3 Тогда
		Возврат Сред(Сообщение, 1, ИндексМаркера - 3);
	Иначе
		Возврат "";
	КонецЕсли;
		
КонецФункции

#КонецОбласти
