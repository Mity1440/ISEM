#Если Сервер ИЛИ ТолстыйКлиентОбычноеПриложение ИЛИ ВнешнееСоединение Тогда
	
// ISEM: Менеджер интеграций между информационными системами
//
// Copyright 2017-2023 Dmitry Makarevich (Mity1440)
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//
//
// URL:    https://github.com/Mity1440/ISEM
// e-mail: mitia.mackarevich@yandex.ru

#Область ПрограммныйИнтерфейс

Процедура ЗаписатьДанные(Знач Интеграция, Знач СуществующаяИнтеграция = Ложь) Экспорт
	
	Запись = ШаблонЗаписи(Интеграция, СуществующаяИнтеграция);
	НачатьТранзакцию();
	Попытка
		
		ЗаблокироватьЗаписьПоИнтеграции(Интеграция);
		Если СуществующаяИнтеграция Тогда
			ДанныеИнтеграцииСистемТекущие = ДанныеИнтеграциПоИнтеграции(Интеграция);
			ЗаполнитьЗначенияСвойств(Запись, ДанныеИнтеграцииСистемТекущие, "ДатаСоздания");
		КонецЕсли;
		
		ЗаписатьДанныеВнутренний(Запись);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ВызватьИсключение;

	КонецПопытки
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьДанныеВнутренний(Запись)
	
	Менеджер = СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Менеджер, Запись);
	
	Менеджер.Записать();
	
КонецПроцедуры

Функция ДанныеИнтеграциПоИнтеграции(Интеграция)

	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаДанныеИнтеграциПоИнтеграции();
	Запрос.УстановитьПараметр("Интеграция", Интеграция);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	
	Возврат ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Таблица[0]);
	
КонецФункции

Процедура ЗаблокироватьЗаписьПоИнтеграции(Интеграция)
	
	Блокировка = Новый БлокировкаДанных();
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ИнтеграцииСистемДанныеДляСписка");
	ЭлементБлокировки.УстановитьЗначение("Интеграция", Интеграция);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	//@skip-check lock-out-of-try
	Блокировка.Заблокировать();
	
КонецПроцедуры

// Шаблон записи.
// 
// Параметры:
//  Интеграция - СправочникСсылка.ИнтеграцииСистем - Интеграция
//  СуществующаяИнтеграция - Булево - Существующая интеграция
// 
// Возвращаемое значение:
//  Структура -- Шаблон записи::
// * Интеграция - СправочникСсылка.ИнтеграцииСистем -
// * ДатаПоследнегоИзменения - Дата -
// * ДатаСоздания - Дата -
Функция ШаблонЗаписи(Знач Интеграция = Неопределено, Знач СуществующаяИнтеграция = Ложь)
	
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	
	ШаблонЗаписи = Новый Структура;
	
	Если ЗначениеЗаполнено(Интеграция) Тогда
		ШаблонЗаписи.Вставить("Интеграция", Интеграция);
	Иначе
		ШаблонЗаписи.Вставить("Интеграция", Справочники.ИнтеграцииСистем.ПустаяСсылка());	
	КонецЕсли;
	
	ШаблонЗаписи.Вставить("ДатаПоследнегоИзменения", ТекущаяДатаСеанса);
	
	Если НЕ СуществующаяИнтеграция Тогда
		ШаблонЗаписи.Вставить("ДатаСоздания", ТекущаяДатаСеанса);
	Иначе 
		ШаблонЗаписи.Вставить("ДатаСоздания", Дата(1,1,1));
	КонецЕсли;
	
	ШаблонЗаписи.Вставить("ПользовательИзменения", Пользователи.ТекущийПользователь());
	
	Возврат ШаблонЗаписи;
	
КонецФункции

#Область ТекстЗапроса

Функция ТекстЗапросаДанныеИнтеграциПоИнтеграции()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ИнтеграцииСистемДанныеДляСписка.Интеграция КАК Интеграция,
	|	ИнтеграцииСистемДанныеДляСписка.ДатаПоследнегоИзменения КАК ДатаПоследнегоИзменения,
	|	ИнтеграцииСистемДанныеДляСписка.ДатаСоздания КАК ДатаСоздания,
	|   ИнтеграцииСистемДанныеДляСписка.ПользовательИзменения КАК ПользовательИзменения
	|ИЗ
	|	РегистрСведений.ИнтеграцииСистемДанныеДляСписка КАК ИнтеграцииСистемДанныеДляСписка
	|ГДЕ
	|	ИнтеграцииСистемДанныеДляСписка.Интеграция = &Интеграция";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти 

#КонецОбласти 

#КонецЕсли