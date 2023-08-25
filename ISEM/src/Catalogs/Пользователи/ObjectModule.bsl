///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Если НЕ МобильныйАвтономныйСервер Тогда

#Область ОписаниеПеременных

Перем ПараметрыОбработкиПользователяИБ; // Параметры, заполняемые при обработке пользователя ИБ.
                                        // Используются в обработчике события ПриЗаписи.

Перем ЭтоНовый; // Показывает, что был записан новый объект.
                // Используются в обработчике события ПриЗаписи.

#КонецОбласти

// *Область ПрограммныйИнтерфейс.
//
// Программный интерфейс объекта реализован через ДополнительныеСвойства:
//
// ОписаниеПользователяИБ - Структура со свойствами:
//   Действие - Строка - "Записать" или "Удалить".
//      1. Если Действие = "Удалить" другие свойства не требуются. Удаление
//      будет считаться успешным и в том случае, когда пользовательИБ
//      не найден по значению реквизита ИдентификаторПользователяИБ.
//      2. Если Действие = "Записать", тогда будет создан или обновлен
//      пользователь ИБ по указанным свойствам.
//
//   ВходВПрограммуРазрешен - Неопределено - вычислить автоматически:
//                            если вход в программу запрещен, тогда остается запрещен,
//                            иначе остается разрешен, кроме случая, когда
//                            все виды аутентификации установлены в Ложь.
//                          - Булево - если Истина, тогда установить аутентификацию, как
//                            указана или сохранена в значениях одноименных реквизитов;
//                            если Ложь, тогда снять все виды аутентификации у пользователя ИБ.
//                            Если свойство не указано - прямая установка сохраняемых и
//                            действующих видов аутентификации (для поддержки обратной совместимости).
//
//   ПотребоватьСменуПароляПриВходе - Булево - изменяет одноименный флажок карточки пользователя.
//                                  - Неопределено - флажок не изменяется (аналогично,
//                                        если свойство не указано).
//
//   АутентификацияСтандартная, АутентификацияOpenID, АутентификацияOpenIDConnect,
//   АутентификацияТокеномДоступа, АутентификацияОС - установить сохраняемые значения
//      видов аутентификации и действующие значения видов аутентификации
//      в зависимости от использования свойства ВходВПрограммуРазрешен.
// 
//   Остальные свойства.
//      Состав остальных свойств указывается аналогично составу свойств параметра.
//      ОбновляемыеСвойства для процедуры Пользователи.УстановитьСвойстваПользователяИБ(),
//      кроме свойства ПолноеИмя - устанавливается по Наименованию.
//
//      Для сопоставления существующего свободного пользователя ИБ с пользователем в справочнике,
//      с которым не сопоставлен другой существующий пользователь ИБ, нужно вставить свойство.
//      УникальныйИдентификатор. Если указать идентификатор пользователя ИБ, который
//      сопоставлен с текущим пользователем, ничего не изменится.
//
//   При выполнении действий "Записать" и "Удалить" реквизит объекта.
//   ИдентификаторПользователяИБ обновляется автоматически, его не следует изменять.
//
//   После выполнения действия в структуру вставляются (обновляются) следующие свойства:
//   - РезультатДействия - Строка, содержащая одно из значений:
//       "ДобавленПользовательИБ", "ИзмененПользовательИБ", "УдаленПользовательИБ",
//       "ОчищеноСопоставлениеСНесуществующимПользователемИБ", "НеТребуетсяУдалениеПользовательИБ".
//   - УникальныйИдентификатор - УникальныйИдентификатор пользователя ИБ.
//
// СозданиеАдминистратора - Строка - свойство должно быть вставлено с непустой строкой,
//   чтобы вызвать событие ПриСозданииАдминистратора после обработки структуры ОписаниеПользователяИБ
//   когда у созданного или измененного пользователя ИБ имеются роли администратора.
//   Это нужно, чтобы сделать связанные действия при создании администратора, например,
//   автоматически добавить пользователя в группу доступа Администраторы.
//
// *КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовый = ЭтоНовый();
	
	ПользователиСлужебный.НачатьОбработкуПользователяИБ(ЭтотОбъект, ПараметрыОбработкиПользователяИБ);
	
	УстановитьПривилегированныйРежим(Истина);
	РегистрыСведений.СведенияОПользователях.ОбновитьСведенияОПользователе(
		ПользователиСлужебный.СсылкаОбъекта(ЭтотОбъект), ЭтотОбъект);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ГруппаНовогоПользователя")
		И ЗначениеЗаполнено(ДополнительныеСвойства.ГруппаНовогоПользователя) Тогда
		
		Блокировка = Новый БлокировкаДанных;
		Блокировка.Добавить("Справочник.ГруппыПользователей");
		Блокировка.Заблокировать();
		
		ОбъектГруппы = ДополнительныеСвойства.ГруппаНовогоПользователя.ПолучитьОбъект(); // СправочникОбъект.ГруппыПользователей
		ОбъектГруппы.Состав.Добавить().Пользователь = Ссылка;
		ОбъектГруппы.Записать();
	КонецЕсли;
	
	// Обновление состава автоматической группы "Все пользователи".
	УчастникиИзменений = Новый Соответствие;
	ИзмененныеГруппы   = Новый Соответствие;
	
	ПользователиСлужебный.ОбновитьСоставыГруппПользователей(
		Справочники.ГруппыПользователей.ВсеПользователи, Ссылка, УчастникиИзменений, ИзмененныеГруппы);
	
	ПользователиСлужебный.ОбновитьИспользуемостьСоставовГруппПользователей(
		Ссылка, УчастникиИзменений, ИзмененныеГруппы);
	
	ПользователиСлужебный.ЗавершитьОбработкуПользователяИБ(
		ЭтотОбъект, ПараметрыОбработкиПользователяИБ);
	
	ПользователиСлужебный.ПослеОбновленияСоставовГруппПользователей(
		УчастникиИзменений, ИзмененныеГруппы);
	
	ИнтеграцияПодсистемБСП.ПослеДобавленияИзмененияПользователяИлиГруппы(Ссылка, ЭтоНовый);
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбщиеДействияПередУдалениемВОбычномРежимеИПриОбменеДанными();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДополнительныеСвойства.Вставить("ЗначениеКопирования", ОбъектКопирования.Ссылка);
	
	ИдентификаторПользователяИБ = Неопределено;
	ИдентификаторПользователяСервиса = Неопределено;
	Подготовлен = Ложь;
	
	КонтактнаяИнформация.Очистить();
	Комментарий = "";
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Только для внутреннего использования.
Процедура ОбщиеДействияПередУдалениемВОбычномРежимеИПриОбменеДанными() Экспорт
	
	// Требуется удалить пользователя ИБ, иначе он попадет в список ошибок в форме ПользователиИБ,
	// кроме того, вход под этим пользователем ИБ приведет к ошибке.
	
	ОписаниеПользователяИБ = Новый Структура;
	ОписаниеПользователяИБ.Вставить("Действие", "Удалить");
	ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
	
	ПользователиСлужебный.НачатьОбработкуПользователяИБ(ЭтотОбъект, ПараметрыОбработкиПользователяИБ, Истина);
	ПользователиСлужебный.ЗавершитьОбработкуПользователяИБ(ЭтотОбъект, ПараметрыОбработкиПользователяИБ);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли