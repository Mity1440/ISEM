///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет форму ФИО в заданном падеже.
//
// Параметры:
//   ФИО		- Строка - строка, в которой содержится ФИО для склонения.
//   Падеж 	- Число - падеж, в который необходимо просклонять представление объекта.
//							1 - Именительный.
//							2 - Родительный.
//							3 - Дательный.
//							4 - Винительный.
//							5 - Творительный.
//							6 - Предложный.
//  Объект 	- ОпределяемыйТип.ОбъектСклонения - ссылка на объект, реквизит которого склоняется.
//  Пол		- Число - число - пол физического лица, 
//							1 - мужской, 
//							2 - женский.
//
// Возвращаемое значение:
//  Строка - результат склонения ФИО в падеже.
//
Функция ПросклонятьФИО(ФИО, Падеж, Объект = Неопределено, Пол = Неопределено) Экспорт
	
	ПараметрыСклонения = СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения();
	ПараметрыСклонения.ЭтоФИО = Истина;
	ПараметрыСклонения.Пол = Пол;
	
	Возврат Просклонять(ФИО, Падеж, Объект, ПараметрыСклонения);
	
КонецФункции

// Склоняет представление объекта.
//
// Параметры:
//   Представление 	- Строка 	- строка, в которой содержится ФИО для склонения.
//   Падеж 			- Число  	- падеж, в который необходимо просклонять представление объекта.
//  	               			1 - Именительный.
//                  			2 - Родительный.
//                  			3 - Дательный.
//                  			4 - Винительный.
//                  			5 - Творительный.
//                  			6 - Предложный.
//  Объект 	- ОпределяемыйТип.ОбъектСклонения 	- ссылка на объект, реквизит которого склоняется.
//
// Возвращаемое значение:
//  Строка - результат склонения представления объекта в падеже.
//
Функция ПросклонятьПредставление(Представление, Падеж, Объект = Неопределено) Экспорт
	
	Возврат Просклонять(Представление, Падеж, Объект);
	
КонецФункции

// Выполняет с формой действия, необходимые для подключения подсистемы Склонения.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма для подключения механизма склонения.
//  Представление - Строка - строка для склонения.
//  ИмяОсновногоРеквизитаФормы - Строка - имя основного реквизита формы. 
//
Процедура ПриСозданииНаСервере(Форма, Представление, ИмяОсновногоРеквизитаФормы = "Объект") Экспорт
	
	МассивРеквизитов = Новый Массив;
	
	ЗаголовокРеквизита = НСтр("ru = 'Изменено представление';
								|en = 'Presentation is changed'");
	РеквизитИзмененоПредставление = Новый РеквизитФормы("ИзмененоПредставление", Новый ОписаниеТипов("Булево"), , ЗаголовокРеквизита);
	МассивРеквизитов.Добавить(РеквизитИзмененоПредставление);
	
	РеквизитСклонения = Новый РеквизитФормы("Склонения", Новый ОписаниеТипов(), , "Склонения");
	МассивРеквизитов.Добавить(РеквизитСклонения);
	
	Форма.ИзменитьРеквизиты(МассивРеквизитов);
	ОсновнойРеквизитФормы = Форма[ИмяОсновногоРеквизитаФормы]; // ОпределяемыйТип.ОбъектСклонения 
	
	СтруктураСклонения = СклоненияИзРегистра(Представление, ОсновнойРеквизитФормы.Ссылка);
	Если СтруктураСклонения <> Неопределено Тогда
		Форма.Склонения = Новый ФиксированнаяСтруктура(СтруктураСклонения);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события ПриЗаписиНаСервере управляемой формы объекта для склонения.
//
// Параметры:
//  Форма				 - ФормаКлиентскогоПриложения	 - форма объекта склонения.
//  Представление		 - Строка			 - строка для склонения.
//  Объект				 - ОпределяемыйТип.ОбъектСклонения	 - объект для склонения.
//  ПараметрыСклонения	 - см. СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения
//
Процедура ПриЗаписиФормыОбъектаСклонения(Форма, Представление, Объект, ПараметрыСклонения = Неопределено) Экспорт

	Если Форма.ИзмененоПредставление Тогда
		СтруктураСклонения = ПросклонятьПредставлениеПоВсемПадежам(Представление, ПараметрыСклонения);
		Если СтруктураСклонения <> Неопределено Тогда
			Форма.Склонения = Новый ФиксированнаяСтруктура(СтруктураСклонения);
		КонецЕсли;
		Форма.ИзмененоПредставление = Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Форма.Склонения) = Тип("ФиксированнаяСтруктура") Тогда
		ЗаписатьВРегистрСклонения(Представление, Объект, Форма.Склонения);
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает признак доступности сервиса склонения.
//
// Параметры:
//  Доступность	- Булево - признак доступности сервиса склонения.
//
Процедура УстановитьДоступностьСервисаСклонения(Доступность) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ТекущиеПараметры = Новый Соответствие(ПараметрыСеанса.ПараметрыКлиентаНаСервере);
	ТекущиеПараметры.Вставить("ДоступенСервисСклонения", Доступность);
	ПараметрыСеанса.ПараметрыКлиентаНаСервере = Новый ФиксированноеСоответствие(ТекущиеПараметры);
	
КонецПроцедуры

// Определяет доступен ли сервис склонения.
// 
// Возвращаемое значение: 
//  Булево  - Истина, если веб-сервис склонения доступен.
//
Функция ДоступенСервисСклонения() Экспорт
	
	Результат = СтандартныеПодсистемыСервер.ПараметрыКлиентаНаСервере(Ложь).Получить("ДоступенСервисСклонения");
	
	Если Результат = Неопределено Тогда
		Возврат Истина;
	Иначе 
		Возврат Результат;
	КонецЕсли;
	
КонецФункции

// Добавляет возможность склонения по падежам значения реквизита при печати.
//
// Параметры:
//  ИсточникиДанныхПечати - см. УправлениеПечатьюПереопределяемый.ПриОпределенииИсточниковДанныхПечати.ИсточникиДанныхПечати
//
Процедура ПодключитьИсточникДанныхПечатиСклоненияСтрок(ИсточникиДанныхПечати) Экспорт
	
	ИсточникиДанныхПечати.Добавить(СхемаДанныеПечатиСклоненияСтрок(), "ДанныеПечатиСклоненияСтрок");	
	
КонецПроцедуры

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать СклонениеПредставленийОбъектов.ПриЗаписиФормыОбъектаСклонения.
// Обработчик события ПриЗаписиНаСервере управляемой формы объекта для склонения.
//
// Параметры:
//  Форма 			- ФормаКлиентскогоПриложения - форма объекта склонения.
//  Представление   - Строка - строка для склонения.
//  Объект 			- ОпределяемыйТип.ОбъектСклонения - объект для склонения.
//  ЭтоФИО       	- Булево - признак склонения ФИО.
//  Пол				- Число	- пол физического лица (в случае склонения ФИО)
//							1 - мужской 
//							2 - женский.
//
Процедура ПриЗаписиНаСервере(Форма, Представление, Объект, ЭтоФИО = Ложь, Пол = Неопределено) Экспорт
	
	ПараметрыСклонения = СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения();
	ПараметрыСклонения.ЭтоФИО = ЭтоФИО;
	ПараметрыСклонения.Пол = Пол;
	
	ПриЗаписиФормыОбъектаСклонения(Форма, Представление, Объект, ПараметрыСклонения);
	
КонецПроцедуры

// Устарела. Следует использовать СклонениеПредставленийОбъектов.ПросклонятьФИО.
//
// Склоняет переданную фразу.
// Только для работы на ОС Windows.
//
// Параметры:
//  ФИО   - Строка - фамилия, имя и отчество в именительном падеже, 
//                   которые необходимо просклонять.
//  Падеж - Число  - падеж, в который необходимо поставить ФИО:
//                   1 - Именительный.
//                   2 - Родительный.
//                   3 - Дательный.
//                   4 - Винительный.
//                   5 - Творительный.
//                   6 - Предложный.
//  Результат - Строка - в этот параметр помещается результат склонения.
//                       Если ФИО не удалось просклонять, то возвращается значение ФИО.
//  Пол       - Число - пол физического лица, 1 - мужской, 2 - женский.
//
// Возвращаемое значение:
//   Булево - Истина, если ФИО удалось просклонять.
//
Функция ПросклонятьФИОСПомощьюКомпоненты(Знач ФИО, Падеж, Результат, Пол = Неопределено) Экспорт
	
	ПроверитьПараметрПол(Пол, "СклонениеПредставленийОбъектов.ПросклонятьФИОСПомощьюКомпоненты");
	ПроверитьПараметрПадеж(Падеж, "СклонениеПредставленийОбъектов.ПросклонятьФИОСПомощьюКомпоненты");
	
	Результат = ПросклонятьФИО(ФИО, Падеж, , Пол);
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область СклонениеСервисомMorpher

// Возвращает значение константы "ИспользоватьСервисСклоненияMorpher".
//
// Возвращаемое значение:
//  Булево
//
Функция ИспользоватьСервисСклоненияMorpher() Экспорт
	
	Возврат Константы.ИспользоватьСервисСклоненияMorpher.Получить();
	
КонецФункции

#КонецОбласти

// См. УправлениеПечатьюПереопределяемый.ПриПодготовкеДанныхПечати
Процедура ПриПодготовкеДанныхПечати(ИсточникиДанных, ВнешниеНаборыДанных, ИдентификаторСхемыКомпоновкиДанных, КодЯзыка,
	ДополнительныеПараметры) Экспорт
	
	Если ИдентификаторСхемыКомпоновкиДанных = "ДанныеПечатиСклоненияСтрок" Тогда
		ВнешниеНаборыДанных.Вставить("Данные", ДанныеПечатиСклоненияСтрок(ИсточникиДанных));
		Возврат;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Склоняет представление объекта.
// Только для работы на ОС Windows.
//
// Параметры:
//   Объект	- ОпределяемыйТип.ОбъектСклонения - ссылка на объект, в котором содержится реквизит для склонения.
//   ВидПредставления - Строка 	- имя реквизита объекта для склонения.
//   Падеж 	- Число  			- падеж, в который необходимо просклонять представление объекта.
//                  			1 - Именительный.
//                  			2 - Родительный.
//                  			3 - Дательный.
//                  			4 - Винительный.
//                  			5 - Творительный.
//                  			6 - Предложный.
//
// Возвращаемое значение:
//    Строка - результат склонения представления объекта в падеже.
//
Функция Просклонять(Представление, Падеж, Объект = Неопределено, ПараметрыСклонения = Неопределено) 
	
	ИмяПадежа = СоответствиеПадежей().Получить(Падеж);
	ПроверитьПараметрПадеж(Падеж, "СклонениеПредставленийОбъектов.Просклонять");
	
	СтруктураСклоненияИзРегистра = СклоненияИзРегистра(Представление, Объект);
	
	Если СтруктураСклоненияИзРегистра <> Неопределено И ЗначениеЗаполнено(СтруктураСклоненияИзРегистра[ИмяПадежа]) Тогда
		Возврат СтруктураСклоненияИзРегистра[ИмяПадежа];
	КонецЕсли;
	
	СтруктураСклонения = ДанныеСклонения(Представление, ПараметрыСклонения);
	
	Если СтруктураСклонения = Неопределено Тогда
		Возврат Представление;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект) Тогда
		ЗаписатьВРегистрСклонения(Представление, Объект, СтруктураСклонения);
	КонецЕсли;
	
	Возврат СтруктураСклонения[ИмяПадежа];
	
КонецФункции

// Склоняет переданную фразу по всем падежам.
//
// Параметры:
//  Представление       - Строка - строка для склонения.
//  ПараметрыСклонения  - см. СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения
//  ПоказыватьСообщения - Булево - признак, определяющий нужно ли показывать пользователю сообщения об ошибках.
//
// Возвращаемое значение:  
//   см. СклонениеПредставленийОбъектовКлиентСервер.СтруктураСклонения
//
Функция ПросклонятьПредставлениеПоВсемПадежам(Представление, ПараметрыСклонения = Неопределено, ПоказыватьСообщения = Ложь)
	
	СтруктураСклонения = СклоненияИзРегистра(Представление);
	
	Если СтруктураСклонения <> Неопределено Тогда
		Возврат СтруктураСклонения;
	КонецЕсли;
	
	СтруктураСклонения = ДанныеСклонения(Представление, ПараметрыСклонения, ПоказыватьСообщения);
	
	Возврат СтруктураСклонения;
	
КонецФункции

// Склоняет переданные фразы по всем падежам.
//
// Параметры:
//  Представления       - Массив из Строка - строки для склонения.
//  ПараметрыСклонения  - см. СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения
//  ПоказыватьСообщения - Булево - признак, определяющий нужно ли показывать пользователю сообщения об ошибках.
//
// Возвращаемое значение:  
//   Соответствие из КлючИЗначение:
//     * Ключ     - Строка - строка для склонения.  
//     * Значение - см. СклонениеПредставленийОбъектовКлиентСервер.СтруктураСклонения
//
Функция ПросклонятьПредставленияПоВсемПадежам(Представления)

	Склонения = СклоненияСтрокИзРегистра(Представления);

	Для Каждого ЭлементПредставление Из Представления Цикл
		Если Склонения.Получить(ЭлементПредставление) = Неопределено Тогда
			Склонения.Вставить(ЭлементПредставление, ДанныеСклонения(ЭлементПредставление, Неопределено, Ложь));
		КонецЕсли;
	КонецЦикла;
	
	Возврат Склонения;

КонецФункции

// Получает данные склонения по всем падежам.
//
// Параметры:
//  Представление		 - Строка	 - строка для склонения.
//    ЭтоФИО          - Булево - признак склонения ФИО.
//    Пол             - Число  - пол физического лица (в случае склонения ФИО)
//  	1 - мужской
//  	2 - женский.
//  ПараметрыСклонения - см. СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения
//  ПоказыватьСообщения	 - Булево	 - признак, определяющий нужно ли показывать пользователю сообщения об ошибках.
// 
// Возвращаемое значение:
//  Структура:
//   * Именительный - Строка.
//   * Родительный  - Строка.
//   * Дательный    - Строка
//   * Винительный  - Строка.
//   * Творительный - Строка.
//   * Предложный   - Строка.
//  Неопределено - если просклонять не удалось.
//
Функция ДанныеСклонения(Знач Представление, ПараметрыСклонения = Неопределено, ПоказыватьСообщения = Ложь) Экспорт
	
	Если ПараметрыСклонения = Неопределено Тогда
		ПараметрыСклонения = СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения();
	КонецЕсли;
	
	СтруктураСклонения = СклонениеПредставленийОбъектовКлиентСервер.СтруктураСклонения();
	
	Если Не ЗначениеЗаполнено(Представление) Тогда
		Возврат СтруктураСклонения;
	КонецЕсли;
	
	СтандартнаяОбработка = Истина;
	
	ПросклонятьСПомощьюСервисаСклоненияMorpher(СтруктураСклонения, Представление, СтандартнаяОбработка, ПоказыватьСообщения);
	
	Если Не СтандартнаяОбработка Тогда
		Возврат СтруктураСклонения;
	КонецЕсли;
	
	ПросклонятьВстроеннымМетодом(СтруктураСклонения, Представление, ПараметрыСклонения, ПоказыватьСообщения);
	
	Возврат СтруктураСклонения;
	
КонецФункции

Процедура ЗаписатьВРегистрСклонения(Представление, Объект, Склонения) 
	
	Если Не Метаданные.ОпределяемыеТипы.ОбъектСклонения.Тип.СодержитТип(ТипЗнч(Объект)) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьОтключениеБезопасногоРежима(Истина);
	УстановитьПривилегированныйРежим(Истина);
	
	ХешПредставления = ОбщегоНазначения.КонтрольнаяСуммаСтрокой(Представление);
	НаборЗаписейСклонения = РегистрыСведений.СклоненияПредставленийОбъектов.СоздатьНаборЗаписей();
	НаборЗаписейСклонения.Отбор.Объект.Установить(Объект.Ссылка);
	
	НоваяСтрока = НаборЗаписейСклонения.Добавить();
	НоваяСтрока.Объект = Объект.Ссылка;
	НоваяСтрока.ХешПредставления = ХешПредставления;
	НоваяСтрока.ИменительныйПадеж = Склонения.Именительный;
	НоваяСтрока.РодительныйПадеж = Склонения.Родительный;
	НоваяСтрока.ДательныйПадеж = Склонения.Дательный;
	НоваяСтрока.ВинительныйПадеж = Склонения.Винительный;
	НоваяСтрока.ТворительныйПадеж = Склонения.Творительный;
	НоваяСтрока.ПредложныйПадеж = Склонения.Предложный;
	
	НаборЗаписейСклонения.Записать();
	
КонецПроцедуры

#Область СклонениеСервисомMorpher

Процедура ПросклонятьСПомощьюСервисаСклоненияMorpher(
	СтруктураСклонения, Представление, СтандартнаяОбработка, ПоказыватьСообщения = Ложь)
	
	ИспользоватьСервисСклонения = Константы.ИспользоватьСервисСклоненияMorpher.Получить();
	Если Не ИспользоватьСервисСклонения Тогда
		Возврат;
	КонецЕсли;
	
	СклоненияЧерезСервис = СтруктураСклоненияЧерезЗапросКСервису(Представление, ПоказыватьСообщения);
	Если СклоненияЧерезСервис = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ЗаполнитьЗначенияСвойств(СтруктураСклонения, СклоненияЧерезСервис);
	
КонецПроцедуры

Функция СтруктураСклоненияЧерезЗапросКСервису(СклоняемыйТекст, ПоказыватьСообщения) 
	
	Если Не ДоступенСервисСклонения() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	УстановитьОтключениеБезопасногоРежима(Истина);
	
	Соединение = HTTPСоединениеСервисаСклонений();
	Запрос = HTTPЗапросКСервисуСклонения(СклоняемыйТекст);
	Попытка
		Ответ = ВыполнитьЗапросСервисуСклонений(Соединение, Запрос);
		СтруктураОтвета = ОбщегоНазначения.JSONВЗначение(Ответ.ПолучитьТелоКакСтроку(), , Ложь);
		СтруктураСклонения = СклонениеПредставленийОбъектовКлиентСервер.СтруктураСклонения();
		СтруктураСклонения.Именительный = СклоняемыйТекст;
		СтруктураСклонения.Родительный  = СтруктураОтвета.Р;
		СтруктураСклонения.Дательный    = СтруктураОтвета.Д;
		СтруктураСклонения.Винительный  = СтруктураОтвета.В;
		СтруктураСклонения.Творительный = СтруктураОтвета.Т;
		СтруктураСклонения.Предложный   = СтруктураОтвета.П;
	Исключение
		ЗарегистрироватьОшибкуСервисаСклонений(ИнформацияОбОшибке(), ПоказыватьСообщения);
		УстановитьДоступностьСервисаСклонения(Ложь);
		Возврат Неопределено;
	КонецПопытки;
	УстановитьОтключениеБезопасногоРежима(Ложь);
	
	Возврат СтруктураСклонения;
	
КонецФункции

Функция HTTPСоединениеСервисаСклонений()
	
	АдресСервера = "ws3.morpher.ru";
	
	ИнтернетПрокси = Неопределено;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
		МодульПолучениеФайловИзИнтернета = ОбщегоНазначения.ОбщийМодуль("ПолучениеФайловИзИнтернета");
		ИнтернетПрокси = МодульПолучениеФайловИзИнтернета.ПолучитьПрокси("https");
	КонецЕсли;
	
	Таймаут = 10;
	
	ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
	Возврат Новый HTTPСоединение(АдресСервера,,,, ИнтернетПрокси, Таймаут, ЗащищенноеСоединение);
	
КонецФункции

Функция HTTPЗапросКСервисуСклонения(СклоняемыйТекст)
	
	ТекстЗапроса = "/russian/declension?s=" + КодироватьСтроку(СклоняемыйТекст, СпособКодированияСтроки.КодировкаURL);
	
	УстановитьПривилегированныйРежим(Истина);
	ВладелецТокена = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("РегистрСведений.СклоненияПредставленийОбъектов");
	Токен = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ВладелецТокена, "ТокенДоступаКСервисуMorpher", Истина);
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ЗначениеЗаполнено(Токен) Тогда
		ТекстЗапроса = ТекстЗапроса + "&token=" + Токен;
	КонецЕсли;
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("User-Agent", "1C Enterprise 8.3");
	Заголовки.Вставить("Accept", "application/json");
	Заголовки.Вставить("charset", "UTF-8");
	
	Возврат Новый HTTPЗапрос(ТекстЗапроса, Заголовки);
	
КонецФункции

Функция ВыполнитьЗапросСервисуСклонений(Соединение, Запрос)
	
	Попытка
		Ответ = Соединение.Получить(Запрос);
	Исключение
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
			МодульПолучениеФайловИзИнтернета = ОбщегоНазначения.ОбщийМодуль("ПолучениеФайловИзИнтернета");
			РезультатДиагностики = МодульПолучениеФайловИзИнтернета.ДиагностикаСоединения(Соединение.Сервер);
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1
				           |
				           |Результат диагностики:
				           |%2';
				           |en = '%1
				           |
				           |Diagnostics result:
				           |%2'"),
				ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()),
				РезультатДиагностики.ОписаниеОшибки);
		Иначе 
			ВызватьИсключение;
		КонецЕсли
		
	КонецПопытки;
	
	Если Ответ.КодСостояния <> 200 Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Непредвиденная ситуация при обращении к сервису склонения:
			           |%1';
			           |en = 'An unexpected error occurred when accessing the declension service:
			           |%1'"),
			Ответ.ПолучитьТелоКакСтроку());
	КонецЕсли;
		
	Возврат Ответ;
	
КонецФункции

Процедура ЗарегистрироватьОшибкуСервисаСклонений(ИнформацияОбОшибке, ПоказыватьСообщения)
	
	// АПК:154-выкл Ошибка при вызове сервиса склонений не является критичной.
	
	ИмяСобытия = НСтр("ru = 'Склонение.Вызов веб-сервиса';
						|en = 'Declension.Call web service'", ОбщегоНазначения.КодОсновногоЯзыка());
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Предупреждение,,, 
		ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	
	// АПК:154-вкл
	
	Если Не ПоказыватьСообщения Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Ошибка при вызове сервиса склонения. Обратитесь к администратору.
			       |Техническая информация:
			       |%1';
			       |en = 'An error occurred while calling the declension service. Contact your administrator.
			       |Technical information:
			       |%1'"), 
		ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	
	ВызватьИсключение ТекстСообщения;
	
КонецПроцедуры

#КонецОбласти

#Область СклонениеВстроеннымМетодом

Процедура ПросклонятьВстроеннымМетодом(СтруктураСклонения, Представление, ПараметрыСклонения, ПоказыватьСообщения)
	
	ОписаниеСтроки = Неопределено;
	ЗаполнитьОписаниеСтрокиПоПараметрамСклонения(ОписаниеСтроки, ПараметрыСклонения, "СклонениеПредставленийОбъектов.ДанныеСклонения");
	
	ИменаПадежей = ОбщегоНазначения.ВыгрузитьКолонку(СтруктураСклонения, "Ключ");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ИменаПадежей, "Именительный");
	СтруктураСклонения["Именительный"] = Представление;
	
	Если ПараметрыСклонения.ЭтоФИО Тогда
		ОписанияСловФИО = Новый Соответствие;
		ПреобразоватьФИОДляСклонения(Представление, ОписанияСловФИО);
	КонецЕсли;
	
	Для Каждого ИмяПадежа Из ИменаПадежей Цикл
		Попытка
			РезультатСклонения = ПолучитьСклоненияСтроки(Представление, ОписаниеСтроки, "ПД=" + ИмяПадежа)[0];
		Исключение
			ЗарегистрироватьОшибкуВстроенногоМетодаСклонения(ИнформацияОбОшибке(), ПоказыватьСообщения);
			СтруктураСклонения = Неопределено;
			Возврат;
		КонецПопытки;
		Если ПараметрыСклонения.ЭтоФИО Тогда
			ВосстановитьФИОПослеСклонения(РезультатСклонения, ОписанияСловФИО);
		КонецЕсли;
		СтруктураСклонения[ИмяПадежа] = РезультатСклонения;
	КонецЦикла;
КонецПроцедуры

Процедура ЗарегистрироватьОшибкуВстроенногоМетодаСклонения(ИнформацияОбОшибке, ПоказыватьСообщения)
	
	ПодробноеПредставление = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Склонение.Получение склонения строки';
			|en = 'Declension.Get string declension'", ОбщегоНазначения.КодОсновногоЯзыка()), 
		УровеньЖурналаРегистрации.Предупреждение, , , 
		ПодробноеПредставление);
	
	Если Не ПоказыватьСообщения Тогда
		Возврат;
	КонецЕсли;
	
	КраткоеПредставление = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	ВызватьИсключение КраткоеПредставление;
	
КонецПроцедуры

Процедура ЗаполнитьОписаниеСтрокиПоПараметрамСклонения(ОписаниеСтроки, ПараметрыСклонения, ИмяПроцедурыИлиФункции)
	
	ПроверитьПараметрыСклонения(ПараметрыСклонения, ИмяПроцедурыИлиФункции);
	
	ПараметрыСтроки = Новый Массив;
	ПараметрыСтроки.Добавить("Л=ru_RU");
	
	Если ПараметрыСклонения.ЭтоФИО Тогда
		Если ПараметрыСклонения.Пол = 1 Тогда
			ПараметрыСтроки.Добавить("ПЛ=Мужской");
		КонецЕсли;
		Если ПараметрыСклонения.Пол = 2 Тогда
			ПараметрыСтроки.Добавить("ПЛ=Женский");
		КонецЕсли;
	КонецЕсли;
	
	ОписаниеСтроки = СтрСоединить(ПараметрыСтроки, ";");
	
КонецПроцедуры

Функция ПредставлениеСлова()
	
	Структура = Новый Структура;
	Структура.Вставить("ВариантРегистра");
	Структура.Вставить("Разделители", "");
	Возврат Структура;
	
КонецФункции

Функция ВидыРегистраСлова()
	Возврат Новый Структура("ВРег, НРег", "ВРег", "НРег");
КонецФункции

Функция ВидРегистраСлова(Слово)

	Если Слово = ВРег(Слово) Тогда
		Возврат ВидыРегистраСлова().ВРег;
	ИначеЕсли Слово = НРег(Слово) Тогда
		Возврат ВидыРегистраСлова().НРег;
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции

Функция СловоПоВидуРегистра(Слово, ВидРегистра)

	Если ВидРегистра = ВидыРегистраСлова().ВРег Тогда
		Возврат ВРег(Слово);
	ИначеЕсли ВидРегистра = ВидыРегистраСлова().НРег Тогда
		Возврат НРег(Слово);
	Иначе
		Возврат Слово;
	КонецЕсли;
	
КонецФункции

Процедура ПреобразоватьФИОДляСклонения(ФИО, ПредставленияСлов)

	ЧастиФИО = Новый Массив;

	НачалоСлова = 1;
	Для Позиция = 1 По СтрДлина(ФИО) Цикл
		КодСимвола = КодСимвола(ФИО, Позиция);
		Если СтроковыеФункцииКлиентСервер.ЭтоРазделительСлов(КодСимвола) Тогда
			Если Позиция <> НачалоСлова Тогда
				Слово = Сред(ФИО, НачалоСлова, Позиция - НачалоСлова);
				ЧастиФИО.Добавить(ТРег(Слово));
				ОписаниеСлова = ПредставлениеСлова();
				ОписаниеСлова.ВариантРегистра = ВидРегистраСлова(Слово);
				ПредставленияСлов.Вставить(ЧастиФИО.ВГраница(), ОписаниеСлова);
			КонецЕсли;
			Если ОписаниеСлова = Неопределено Тогда
				ЧастиФИО.Добавить("");
				ОписаниеСлова = ПредставлениеСлова();
				ПредставленияСлов.Вставить(ЧастиФИО.ВГраница(), ОписаниеСлова);
			КонецЕсли;
			ОписаниеСлова.Разделители = ОписаниеСлова.Разделители + Символ(КодСимвола);
			НачалоСлова = Позиция + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если Позиция <> НачалоСлова Тогда
		Слово = Сред(ФИО, НачалоСлова, Позиция - НачалоСлова);
		ЧастиФИО.Добавить(ТРег(Слово));
		ОписаниеСлова = ПредставлениеСлова();
		ОписаниеСлова.ВариантРегистра = ВидРегистраСлова(Слово);
		ПредставленияСлов.Вставить(ЧастиФИО.ВГраница(), ОписаниеСлова);
	КонецЕсли;
	
	ФИО = СтрСоединить(ЧастиФИО, " ");
	
КонецПроцедуры

Процедура ВосстановитьФИОПослеСклонения(ФИО, ПредставленияСлов)
	
	ЧастиФИО = СтрРазделить(ФИО, " ");
	Индекс = 0;
	Пока Индекс < ЧастиФИО.Количество() Цикл
		ОписаниеСлова = ПредставленияСлов[Индекс];
		Если ОписаниеСлова <> Неопределено Тогда
			ЧастиФИО[Индекс] = СловоПоВидуРегистра(ЧастиФИО[Индекс], ОписаниеСлова.ВариантРегистра) + ОписаниеСлова.Разделители;
		КонецЕсли;
		Индекс = Индекс + 1;
	КонецЦикла;
	
	ФИО = СтрСоединить(ЧастиФИО);
	
КонецПроцедуры

Процедура ПроверитьПараметрыСклонения(ПараметрыСклонения, ИмяПроцедурыИлиФункции)
	
	ПроверитьПараметрЭтоФИО(ПараметрыСклонения.ЭтоФИО, ИмяПроцедурыИлиФункции);
	ПроверитьПараметрПол(ПараметрыСклонения.Пол, ИмяПроцедурыИлиФункции);
	
КонецПроцедуры

#КонецОбласти

Функция СклоненияИзРегистра(Представление, Объект = Неопределено)
	
	УстановитьОтключениеБезопасногоРежима(Истина);
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураСклонения = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ХешПредставления", ОбщегоНазначения.КонтрольнаяСуммаСтрокой(Представление));
	Запрос.УстановитьПараметр("Объект", Объект);
	Запрос.УстановитьПараметр("ИспользуетсяОтборПоОбъекту", Объект <> Неопределено);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(ВЫРАЗИТЬ(СклоненияПредставленийОбъектов.ИменительныйПадеж КАК СТРОКА(255))) КАК КоличествоНаборовСклонений,
		|	СклоненияПредставленийОбъектов.ХешПредставления КАК ХешПредставления
		|ПОМЕСТИТЬ ТаблицаРегистраБезОтбораПоОбъекту
		|ИЗ
		|	РегистрСведений.СклоненияПредставленийОбъектов КАК СклоненияПредставленийОбъектов
		|ГДЕ
		|	СклоненияПредставленийОбъектов.ХешПредставления = &ХешПредставления
		|
		|СГРУППИРОВАТЬ ПО
		|	СклоненияПредставленийОбъектов.ХешПредставления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СклоненияПредставленийОбъектов.ИменительныйПадеж КАК Именительный,
		|	СклоненияПредставленийОбъектов.РодительныйПадеж КАК Родительный,
		|	СклоненияПредставленийОбъектов.ДательныйПадеж КАК Дательный,
		|	СклоненияПредставленийОбъектов.ВинительныйПадеж КАК Винительный,
		|	СклоненияПредставленийОбъектов.ТворительныйПадеж КАК Творительный,
		|	СклоненияПредставленийОбъектов.ПредложныйПадеж КАК Предложный,
		|	0 КАК Приоритет
		|ИЗ
		|	РегистрСведений.СклоненияПредставленийОбъектов КАК СклоненияПредставленийОбъектов
		|ГДЕ
		|	&ИспользуетсяОтборПоОбъекту
		|	И СклоненияПредставленийОбъектов.Объект = &Объект
		|	И СклоненияПредставленийОбъектов.ХешПредставления = &ХешПредставления
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СклоненияПредставленийОбъектов.ИменительныйПадеж,
		|	СклоненияПредставленийОбъектов.РодительныйПадеж,
		|	СклоненияПредставленийОбъектов.ДательныйПадеж,
		|	СклоненияПредставленийОбъектов.ВинительныйПадеж,
		|	СклоненияПредставленийОбъектов.ТворительныйПадеж,
		|	СклоненияПредставленийОбъектов.ПредложныйПадеж,
		|	1
		|ИЗ
		|	РегистрСведений.СклоненияПредставленийОбъектов КАК СклоненияПредставленийОбъектов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаРегистраБезОтбораПоОбъекту КАК ТаблицаРегистраБезОтбораПоОбъекту
		|		ПО СклоненияПредставленийОбъектов.ХешПредставления = ТаблицаРегистраБезОтбораПоОбъекту.ХешПредставления
		|			И (ТаблицаРегистраБезОтбораПоОбъекту.КоличествоНаборовСклонений = 1)
		|ГДЕ
		|	СклоненияПредставленийОбъектов.ХешПредставления = &ХешПредставления
		|
		|УПОРЯДОЧИТЬ ПО
		|	Приоритет";
	
	Выборка = Запрос.Выполнить().Выбрать();
		
	Если Выборка.Следующий() Тогда
		СтруктураСклонения = СклонениеПредставленийОбъектовКлиентСервер.СтруктураСклонения();
		ЗаполнитьЗначенияСвойств(СтруктураСклонения, Выборка);
	КонецЕсли;
	
	Возврат СтруктураСклонения;
	
КонецФункции

Функция СклоненияСтрокИзРегистра(Представления)
	
	УстановитьОтключениеБезопасногоРежима(Истина);
	УстановитьПривилегированныйРежим(Истина);
	
	ХешиПредставлений = Новый СписокЗначений;
	Для Каждого ЭлементПредставление Из Представления Цикл
		ХешПредставления = ОбщегоНазначения.КонтрольнаяСуммаСтрокой(ЭлементПредставление);
		ХешиПредставлений.Добавить(ХешПредставления, ЭлементПредставление);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ХешПредставления", ХешиПредставлений);

	Запрос.Текст = 
		"ВЫБРАТЬ
		|
		|	СклоненияПредставленийОбъектов.ИменительныйПадеж КАК Именительный,
		|	СклоненияПредставленийОбъектов.РодительныйПадеж КАК Родительный,
		|	СклоненияПредставленийОбъектов.ДательныйПадеж КАК Дательный,
		|	СклоненияПредставленийОбъектов.ВинительныйПадеж КАК Винительный,
		|	СклоненияПредставленийОбъектов.ТворительныйПадеж КАК Творительный,
		|	СклоненияПредставленийОбъектов.ПредложныйПадеж КАК Предложный,
		|	СклоненияПредставленийОбъектов.ХешПредставления КАК ХешПредставления
		|ИЗ
		|	РегистрСведений.СклоненияПредставленийОбъектов КАК СклоненияПредставленийОбъектов
		|ГДЕ
		|	СклоненияПредставленийОбъектов.ХешПредставления В (&ХешПредставления)";
	
	Выборка = Запрос.Выполнить().Выбрать();

	СклоненияПредставлений = Новый Соответствие;

	Для Каждого ЭлементПредставление Из ХешиПредставлений Цикл
		Выборка.Сбросить();
		ПараметрыПоиска = Новый Структура("ХешПредставления", ЭлементПредставление.Значение);
		Если Выборка.НайтиСледующий(ПараметрыПоиска) Тогда
			СтруктураСклонения = СклонениеПредставленийОбъектовКлиентСервер.СтруктураСклонения();
			ЗаполнитьЗначенияСвойств(СтруктураСклонения, Выборка);
			СклоненияПредставлений.Вставить(ЭлементПредставление.Представление, СтруктураСклонения);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СклоненияПредставлений;

КонецФункции

Функция СоответствиеПадежей()
	
	СоответствиеПадежей = Новый Соответствие;
	
	СоответствиеПадежей.Вставить(1, "Именительный");
	СоответствиеПадежей.Вставить(2, "Родительный");
	СоответствиеПадежей.Вставить(3, "Дательный");
	СоответствиеПадежей.Вставить(4, "Винительный");
	СоответствиеПадежей.Вставить(5, "Творительный");
	СоответствиеПадежей.Вставить(6, "Предложный");
	
	Возврат СоответствиеПадежей;
	
КонецФункции

Функция ЕстьПравоДоступаКОбъекту(Ссылка) Экспорт
	
	Возврат ПравоДоступа("Редактирование", Ссылка.Метаданные());
	
КонецФункции

Процедура ПроверитьПараметрЭтоФИО(ЭтоФИО, ИмяПроцедурыИлиФункции)
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		ИмяПроцедурыИлиФункции, "ЭтоФИО", ЭтоФИО, Тип("Булево"));
	
КонецПроцедуры

Процедура ПроверитьПараметрПол(Пол, ИмяПроцедурыИлиФункции)
	
	Если Пол = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		ИмяПроцедурыИлиФункции, "Пол", Пол, Тип("Число"));
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Недопустимое значение параметра %1 в %2.
		           |параметр должен числом 1 (мужской) или 2 (женский); передано значение: %3 (тип %4).';
		           |en = 'Invalid value of the %1 parameter in %2.
		           |Parameter should be 1 (male) or 2 (female); value passed: %3 (type %4).'"),
		"Пол", ИмяПроцедурыИлиФункции, Пол, ТипЗнч(Пол));
	ОбщегоНазначенияКлиентСервер.Проверить(Пол = 1 Или Пол = 2, ТекстСообщения);
	
КонецПроцедуры

Процедура ПроверитьПараметрПадеж(Падеж, ИмяПроцедурыИлиФункции)
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Недопустимое значение параметра %1 в %2.
              |Параметр должен быть числом, обозначающим порядковый номер падежа, от 1 до 6.
              |Передано значение %3 (тип %4).';
              |en = 'Invalid value of parameter %1 in %2.
              |The parameter must be a number indicating a case sequence number, from 1 to 6.
              |Value %3 (type %4) is passed.'"),
		"Падеж",
		"СклонениеПредставлениеОбъектов.Просклонять",
		Падеж,
		ТипЗнч(Падеж));
		
	ОбщегоНазначенияКлиентСервер.Проверить(
		ТипЗнч(Падеж) = Тип("Число") И (Падеж >= 1 И Падеж <= 6), 
		ТекстСообщения, 
		ИмяПроцедурыИлиФункции);
	
КонецПроцедуры

Функция СхемаДанныеПечатиСклоненияСтрок()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		МодульУправлениеПечатью = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатью");
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	СписокПолей = МодульУправлениеПечатью.ДеревоПолейДанныхПечати();
	
	Поле = СписокПолей.Строки.Добавить();
	Поле.Идентификатор = "Ссылка";
	Поле.Представление = НСтр("ru = 'Ссылка';
								|en = 'Reference'");
	Поле.ТипЗначения = Новый ОписаниеТипов();	
	
	Группа = СписокПолей.Строки.Добавить();
	Группа.Идентификатор = "Падеж";
	Группа.Представление = НСтр("ru = 'Падеж';
								|en = 'Case'");
	Группа.Порядок = 1;
	Группа.Папка = Истина;
	
	Падежи = Новый Структура;
	Падежи.Вставить("Именительный", НСтр("ru = 'Именительный';
										|en = 'Nominative'"));
	Падежи.Вставить("Родительный", НСтр("ru = 'Родительный';
										|en = 'Genitive'"));
	Падежи.Вставить("Дательный", НСтр("ru = 'Дательный';
										|en = 'Dative'"));
	Падежи.Вставить("Винительный", НСтр("ru = 'Винительный';
										|en = 'Accusative'"));
	Падежи.Вставить("Творительный", НСтр("ru = 'Творительный';
										|en = 'Instrumental'"));
	Падежи.Вставить("Предложный", НСтр("ru = 'Предложный';
										|en = 'Prepositional'"));
	
	Счетчик = 0;
	Для Каждого Падеж Из Падежи Цикл
		Счетчик = Счетчик + 1;
		Поле = Группа.Строки.Добавить();
		Поле.Идентификатор = Падеж.Ключ;
		Поле.Представление = Падеж.Значение;
		Поле.ТипЗначения = Новый ОписаниеТипов("Строка");
		Поле.Порядок = Счетчик;
	КонецЦикла;
	
	Возврат МодульУправлениеПечатью.СхемаКомпоновкиДанныхПечати(СписокПолей);
	
КонецФункции

Функция ДанныеПечатиСклоненияСтрок(Объекты)
	
	ДанныеПечати = Новый ТаблицаЗначений();
	ДанныеПечати.Колонки.Добавить("Ссылка");
	ДанныеПечати.Колонки.Добавить("Именительный");
	ДанныеПечати.Колонки.Добавить("Родительный");
	ДанныеПечати.Колонки.Добавить("Дательный");
	ДанныеПечати.Колонки.Добавить("Винительный");
	ДанныеПечати.Колонки.Добавить("Творительный");
	ДанныеПечати.Колонки.Добавить("Предложный"); 

	СклоненияСтрок = ПросклонятьПредставленияПоВсемПадежам(Объекты);

	Для Каждого Объект Из Объекты Цикл
		НоваяСтрока = ДанныеПечати.Добавить();
		НоваяСтрока.Ссылка = Объект;
		СклоненияСтроки = СклоненияСтрок.Получить(Объект);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СклоненияСтроки);
	КонецЦикла;
	
	Возврат ДанныеПечати;
	
КонецФункции

#КонецОбласти