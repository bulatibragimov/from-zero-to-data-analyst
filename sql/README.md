# SQL для аналитики данных — портфолио задач

**PostgreSQL · Karpov.Courses (учебный датасет)**

Здесь собраны мои решения аналитических SQL-задач. Вместо перечня синтаксических конструкций ниже — короткая подборка задач, по которой можно быстро оценить используемые приёмы. Полные `.sql`-файлы с условиями и решениями находятся по ссылкам в разделах.

## Начните с этих решений

| Бизнес-задача | Что делает запрос | Инструменты | Код |
|---|---|---|---|
| **Сессионализация пользователей** | Создаёт идентификаторы сессий: новая сессия начинается при разрыве между событиями более 30 минут | `LAG`, `CASE`, `CTE`, `SUM() OVER` | [Window Functions · №11](window_functions/window_functions_queries.sql#L365-L424) |
| **Повторные покупки** | Рассчитывает средний интервал между первым и вторым заказами клиента | `ROW_NUMBER`, `LEAD`, `CTE` | [Window Functions · №6](window_functions/window_functions_queries.sql#L185-L219) |
| **Скользящая выручка** | Агрегирует выручку по дням и рассчитывает среднее по трём последовательным наблюдаемым датам | `SUM() OVER`, `AVG() OVER`, `ROWS` | [Window Functions · №4](window_functions/window_functions_queries.sql#L108-L134) |
| **Разнообразие покупок** | Ранжирует клиентов по числу различных приобретённых товарных категорий | `JOIN`, `DISTINCT`, `COUNT() OVER`, `DENSE_RANK` | [Window Functions · №10](window_functions/window_functions_queries.sql#L325-L360) |
| **Сегментация активности** | Делит клиентов на группы по количеству просмотров страниц | `CTE`, `COUNT() FILTER`, `CASE` | [Subqueries · №6](subqueries/subqueries_queries.sql#L163-L192) |
| **Клиенты с небольшим числом заказов** | Находит клиентов с менее чем тремя заказами, выводит дату последнего заказа | `LEFT JOIN`, `COUNT(DISTINCT)`, `MAX`, `HAVING` | [JOIN · №11](joins/joins_queries.sql#L208-L226) |

## Полная навигация по заданиям

| Раздел | Что демонстрирует | Решения |
|---|---|---|
| Основы SQL | Выборка и базовые операции | [basic_queries.sql](basics/basic_queries.sql), [numeric_and_string_functions.sql](basics/numeric_and_string_functions.sql) |
| Фильтрация | `WHERE`, составные условия | [filtering_queries.sql](data_filtering/filtering_queries.sql) |
| Агрегации | `GROUP BY`, `HAVING`, расчёт метрик | [aggregation_queries.sql](aggregation/aggregation_queries.sql) |
| Соединения таблиц | `INNER`, `LEFT`, `RIGHT`, `FULL OUTER JOIN`; данные клиентов, заказов и товаров | [joins_queries.sql](joins/joins_queries.sql) |
| Подзапросы и CTE | Вложенные фильтры, `EXISTS`/`IN`, аналитические сегменты | [subqueries_queries.sql](subqueries/subqueries_queries.sql) |
| Оконные функции | Ранжирование, `LAG`/`LEAD`, накопительные и скользящие расчёты, сессии | [window_functions_queries.sql](window_functions/window_functions_queries.sql) |
| Оптимизация запросов | **Теоретический конспект**: `EXPLAIN`, индексы, план выполнения, рекомендации по чтению запросов | [README.md](query_optimization/README.md) |

Дополнительные описания с указателями на задачи: [JOIN](joins/README.md) · [Подзапросы](subqueries/README.md) · [Оконные функции](window_functions/README.md).

## Контекст и воспроизводимость

Задания выполнялись и проверялись в учебной среде Karpov.Courses; синтаксис ориентирован на PostgreSQL. Для запуска `.sql`-файлов самостоятельно необходимы учебная база и её схема (`customers`, `orders`, `order_items`, `products`, `customer_actions`). Раздел `query_optimization` содержит конспект, а не отдельный проект с измеренными ускорениями запросов.
