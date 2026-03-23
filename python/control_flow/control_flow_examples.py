"""
============================================================
Control Flow & String Processing Practice
Description:
Примеры использования условий, циклов и строк
для решения аналитических задач.
Задания взяты с KarpovCourses.
============================================================
"""


# ============================================================
# Task 1 — Email Domain Check
# ============================================================

user_email = "user@karpovmarket.ru"

is_karpov_client = user_email.find("@karpovmarket.") > 0


# ============================================================
# Task 2 — Order Summary Report
# ============================================================

user_id = 101
items = ["Телефон", "Чехол"]
prices = [10000, 500]

summary = f"Заказ пользователя {user_id}: {', '.join(items)}. Сумма заказа: {sum(prices)}"


# ============================================================
# Task 3 — Revenue Report
# ============================================================

revenues = [10000, 15000, 20000]
plan = 50000

report = f"Общая выручка за неделю {sum(revenues):,}. План выполнен на {sum(revenues)/plan:.1%}"


# ============================================================
# Task 4 — Product Analysis
# ============================================================

products = {"iPhone": "Электроника", "Куртка": "Одежда"}

is_home = "дом" in products.values()
categories = list(set(products.values()))

products_number = len(products)
product_names = sorted(list(products.keys()))
first_product = product_names[0]


# ============================================================
# Task 5 — Promo Code Filtering
# ============================================================

promocodes = ["MSK10", "SPB20", "KZN15"]
filtered_promocodes = []

for promocode in promocodes:
    if promocode.startswith("MSK") or promocode.startswith("SPB"):
        filtered_promocodes.append(promocode)


# ============================================================
# Task 6 — Event Analysis
# ============================================================

log = ["просмотр", "лайк", "лайк", "клик"]

like_indexes = []

for i, event in enumerate(log):
    if event == "лайк":
        like_indexes.append(i)


# ============================================================
# Task 7 — Ratings Analysis
# ============================================================

ratings = [5, 4, 3, 5, 2]

count_five = ratings.count(5)

count_above_three = 0
for rating in ratings:
    if rating > 3:
        count_above_three += 1


# ============================================================
# Task 8 — Users Above Average
# ============================================================

users = {"user1": 10, "user2": 20, "user3": 30}

avg = sum(users.values()) / len(users.values())

above_average_users = set(
    login for login in users if users[login] > avg
)


# ============================================================
# Task 9 — Product Frequency
# ============================================================

purchases = ["apple", "banana", "apple", "orange"]

products = set()
products_count = {}

for purchase in purchases:
    if purchase not in products:
        products.add(purchase)
        count = 0

        for i in purchases:
            if i == purchase:
                count += 1

        products_count[purchase] = count


# ============================================================
# Task 10 — Email Validation
# ============================================================

email = "test@mail.com"

if email.count("@") != 1:
    is_valid = False
else:
    user_part, domain_part = email.split("@")

    if len(user_part) < 1:
        is_valid = False
    elif " " in email:
        is_valid = False
    elif "." not in domain_part:
        is_valid = False
    elif domain_part.startswith("."):
        is_valid = False
    elif email.endswith("."):
        is_valid = False
    else:
        is_valid = True


# ============================================================
# Task 11 — Error Context Extraction
# ============================================================

events = ["Start", "Login", "Error", "Retry"]

first_error_index = events.index("Error")
error_context = {}

if first_error_index > 0:
    error_context["event_before"] = events[first_error_index - 1]

if first_error_index < len(events) - 1:
    error_context["event_after"] = events[first_error_index + 1]


# ============================================================
# Task 12 — Threshold Detection
# ============================================================

users_by_day = {"2024-01-01": 200, "2024-01-02": 500, "2024-01-03": 400}

sum_count = 0
threshold_day = None

for date, count in users_by_day.items():
    sum_count += count
    if sum_count > 1000:
        threshold_day = date
        break


# ============================================================
# Task 13 — User Analysis
# ============================================================

users = [
    {"id": 1, "purchases": 10, "email": "", "has_subscription": True},
    {"id": 2, "purchases": 3, "email": "mail@mail.com", "has_subscription": False}
]

max_purchases_user = 0
max_count = 0
users_no_email = []

for dictionary in users:

    if dictionary["purchases"] > max_count:
        max_count = dictionary["purchases"]
        max_purchases_user = dictionary["id"]

    if dictionary["email"] == "":
        users_no_email.append(dictionary["id"])

    if dictionary["purchases"] > 5 and dictionary["has_subscription"]:
        dictionary["personal_discount"] = True


# ============================================================
# Task 14 — Mutual Friends
# ============================================================

friends_dict = {
    1: [2, 3],
    2: [1],
    3: [1]
}

mutual_friends = {i: [] for i in friends_dict}

for main, friends in friends_dict.items():
    for friend in friends:
        if main in friends_dict[friend]:
            mutual_friends[main].append(friend)