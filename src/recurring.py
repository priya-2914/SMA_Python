import pandas as pd


def detect_recurring(df):
    """
    Detect recurring transactions based on description patterns.
    """

    recurring_list = []

    for desc, group in df.groupby("description"):

        group = group.sort_values("date")

        # need at least 3 occurrences
        if len(group) < 3:
            continue

        group["gap"] = group["date"].diff().dt.days
        avg_gap = group["gap"].median()

        # roughly monthly
        if 25 <= avg_gap <= 40:

            amount_std = group["expense"].std()

            # similar amount pattern
            if amount_std < 20:

                recurring_list.append({
                    "description": desc,
                    "transactions": len(group),
                    "avg_amount": round(group["expense"].mean(), 2),
                    "cycle_days": round(avg_gap, 1)
                })

    recurring_df = pd.DataFrame(recurring_list)

    if recurring_df.empty:
        return recurring_df

    return recurring_df.sort_values("avg_amount", ascending=False)