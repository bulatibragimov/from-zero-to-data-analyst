"""
============================================================
Functions Practice
Description:
Примеры использования функций для обработки данных
и решения аналитических задач.
Задания взяты с KarpovCourses.
============================================================
"""


# ============================================================
# Task 1 — Purchase Summary
# ============================================================

def summarize_purchases(user_purchases, whitelist):
    users = sorted(user_purchases.keys())

    all_purchases = set()
    for purchases in user_purchases.values():
        all_purchases.update(purchases)

    filtered = sorted(all_purchases.intersection(whitelist))

    return {
        "users": users,
        "purchases": filtered
    }


# ============================================================
# Task 2 — Repeat String Pattern
# ============================================================

def repeat_string(text, times):
    result = ""

    for char in text:
        result += char * times

    return result


# ============================================================
# Task 3 — Cart Processing
# ============================================================

def process_cart(cart, apply_discount):
    total = 0

    for name, price in cart:
        total += price

    count = len(cart)

    if apply_discount:
        total = total * 0.95

    return total, count


# ============================================================
# Task 4 — Activity Analysis
# ============================================================

def analyze_activity(actions, threshold, include_low_activity):
    result = []

    for idx, count in enumerate(actions):

        if include_low_activity:
            if count <= threshold:
                result.append(idx)
        else:
            if count > threshold:
                result.append(idx)

    return result


# ============================================================
# Task 5 — User Filtering
# ============================================================

def filter_users(users, min_purchases, active_only):
    result = []

    for user_id, user_data in users.items():
        purchases = user_data[0]
        is_active = user_data[1]

        if purchases >= min_purchases:

            if active_only:
                if is_active:
                    result.append(user_id)
            else:
                result.append(user_id)

    return sorted(result)


# ============================================================
# Task 6 — Keyword Analysis
# ============================================================

def count_keyword_occurrences(reports, keyword):
    summary = {}

    for user_id, texts in reports.items():

        count = 0

        for text in texts:
            if keyword.lower() in text.lower():
                count += 1

        summary[user_id] = count

    return summary