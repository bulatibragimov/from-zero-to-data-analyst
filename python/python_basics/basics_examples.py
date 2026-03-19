"""
============================================================
Python Basics Practice
Description:
Примеры работы с переменными, арифметикой,
строками и списками в задачах аналитики.
============================================================
"""


# ============================================================
# Task 1 — Price Calculation
# ============================================================

base_price = 1000
growth_percent = 10

new_price = base_price * (1 + growth_percent / 100)
delta = new_price - base_price


# ============================================================
# Task 2 — Orders Comparison
# ============================================================

orders_today = 120
orders_yesterday = 100

total_orders = orders_today + orders_yesterday
more_orders_today = orders_today > orders_yesterday
big_day = orders_today > 1000


# ============================================================
# Task 3 — String Formatting
# ============================================================

city_name = "Москва"
full_label = "Город " + city_name


# ============================================================
# Task 4 — Time Conversion
# ============================================================

total_minutes = 135

hours = total_minutes // 60
minutes = total_minutes % 60


# ============================================================
# Task 5 — Absolute Difference
# ============================================================

plan = 150

abs_diff = abs(orders_yesterday - plan)
report = "Абсолютное отклонение от плана равняется " + str(abs_diff)


# ============================================================
# Task 6 — Float Comparison
# ============================================================

calculated_total = 100.0000001
reported_total = 100

epsilon = 1e-9
is_equal_price = abs(calculated_total - reported_total) < epsilon


# ============================================================
# Task 7 — Bonus Calculation
# ============================================================

revenue_str = "50000"
courier_name = "Иван"

bonus = int(float(revenue_str) * 0.01)
report = "Курьер " + courier_name + " получит бонус " + str(bonus) + " р."


# ============================================================
# Task 8 — Lists: Basic Operations
# ============================================================

user_clicks_by_day = [[1, 2], [1], [1, 2, 3]]

days_active = list(map(len, user_clicks_by_day))


# ============================================================
# Task 9 — List Modifications
# ============================================================

events = ["Главная", "Каталог"]
important_sections = ["Акции", "Корзина"]

events.insert(0, important_sections[0])
events.append(important_sections[1])
events.remove("Профиль")  # если есть


# ============================================================
# Task 10 — Ratings Analysis
# ============================================================

ratings = [5, 4, 5, 3, 5]

count_fives = ratings.count(5)
share_of_fives = count_fives / len(ratings)


# ============================================================
# Task 11 — Session Analysis
# ============================================================

session_durations = [10, 20, 5, 15]

shortest_session = min(session_durations)
session_durations.remove(shortest_session)

session_durations.sort()
session_durations.append(max(session_durations) + 10)
session_durations.insert(0, 0)

is_long_session = len(session_durations) > 5


# ============================================================
# Task 12 — Unique Users
# ============================================================

user_ids = [1, 2, 2, 3, 4]

user_ids_sorted = sorted(user_ids.copy())
unique_user_ids = set(user_ids_sorted)
num_unique_users = len(unique_user_ids)


# ============================================================
# Task 13 — User Segmentation by Days
# ============================================================

day_1_users = [1, 2, 3]
day_2_users = [2, 3, 4]
day_3_users = [3, 4, 5]

set_day_1 = set(day_1_users)
set_day_2 = set(day_2_users)
set_day_3 = set(day_3_users)

only_day_1 = set_day_1.difference(set_day_2, set_day_3)
only_day_2 = set_day_2.difference(set_day_1, set_day_3)
only_day_3 = set_day_3.difference(set_day_1, set_day_2)

one_day_users = only_day_1.union(only_day_2, only_day_3)
unique_users = set_day_1.union(set_day_2, set_day_3)
loyal_users = set_day_1.intersection(set_day_2, set_day_3)


# ============================================================
# Task 14 — Error Analysis
# ============================================================

registration_steps = [True, True, False, True]
events = ["Start", "Login", "Error", "Retry"]

has_errors = False in registration_steps
error_count = registration_steps.count(False)

first_error_index = events.index("Error")
error_context = [
    events[first_error_index - 1],
    events[first_error_index + 1]
]