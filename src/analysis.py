import pandas as pd
import numpy as np


# --------------------------------------------------
# 1. Overall Summary Metrics
# --------------------------------------------------
def get_summary(df: pd.DataFrame) -> dict:
    """
    Returns overall financial summary metrics.
    """

    total_spent = df["expense"].sum()
    total_paid_back = df["paid_back"].sum()
    net_cash_flow = total_spent - total_paid_back
    total_transactions = len(df)

    return {
        "total_spent": round(total_spent, 2),
        "total_paid_back": round(total_paid_back, 2),
        "net_cash_flow": round(net_cash_flow, 2),
        "total_transactions": total_transactions
    }


# --------------------------------------------------
# 2. Monthly Summary
# --------------------------------------------------
def monthly_summary(df: pd.DataFrame) -> pd.DataFrame:
    """
    Returns monthly spending, payments and net movement.
    """

    monthly = (
        df.groupby("month")
        .agg(
            total_spent=("expense", "sum"),
            total_paid=("paid_back", "sum")
        )
        .reset_index()
    )

    monthly["net"] = monthly["total_spent"] - monthly["total_paid"]

    return monthly.sort_values("month")


# --------------------------------------------------
# 3. Category Summary (Expenses Only)
# --------------------------------------------------
def category_summary(df: pd.DataFrame) -> pd.DataFrame:
    """
    Returns spending grouped by category.
    """

    if "category" not in df.columns:
        return pd.DataFrame()

    return (
        df.groupby("category")["expense"]
        .sum()
        .sort_values(ascending=False)
        .reset_index()
    )


# --------------------------------------------------
# 4. Top Merchants
# --------------------------------------------------
def top_merchants(df: pd.DataFrame, n: int = 10) -> pd.DataFrame:
    """
    Returns top N merchants by spending.
    """

    if "merchant" not in df.columns:
        return pd.DataFrame()

    return (
        df.groupby("merchant")["expense"]
        .sum()
        .sort_values(ascending=False)
        .head(n)
        .reset_index()
    )


# --------------------------------------------------
# 5. Weekday Spending Pattern
# --------------------------------------------------
def weekday_spending(df: pd.DataFrame) -> pd.DataFrame:
    """
    Returns spending grouped by weekday.
    """

    weekday_order = [
        "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday", "Sunday"
    ]

    result = (
        df.groupby("day")["expense"]
        .sum()
        .reindex(weekday_order)
        .reset_index()
    )

    return result


# --------------------------------------------------
# 6. Payment Ratio
# --------------------------------------------------
def payment_ratio(df: pd.DataFrame) -> float:
    """
    Returns % of spending that has been paid back.
    """

    total_spent = df["expense"].sum()
    total_paid = df["paid_back"].sum()

    if total_spent == 0:
        return 0.0

    return round((total_paid / total_spent) * 100, 2)


# --------------------------------------------------
# 7. Monthly Category Breakdown
# --------------------------------------------------
def monthly_category_breakdown(df: pd.DataFrame) -> pd.DataFrame:
    """
    Returns spending per category per month.
    Useful for stacked bar charts.
    """

    if "category" not in df.columns:
        return pd.DataFrame()

    return (
        df.groupby(["month", "category"])["expense"]
        .sum()
        .reset_index()
        .sort_values("month")
    )


# --------------------------------------------------
# 8. Largest Transactions
# --------------------------------------------------
def largest_transactions(df: pd.DataFrame, n: int = 5) -> pd.DataFrame:
    """
    Returns top N largest expense transactions.
    """

    return (
        df.sort_values("expense", ascending=False)
        .head(n)[["date", "merchant", "expense"]]
        .reset_index(drop=True)
    )


#-----------------------------------------------------------------
#9.Time Range Filtering (Default = Whole Timeline)
#-----------------------------------------------------------------
def filter_by_date(df, start_date=None, end_date=None):
    if start_date:
        df = df[df["date"] >= pd.to_datetime(start_date)]
    if end_date:
        df = df[df["date"] <= pd.to_datetime(end_date)]
    return df


def combine_multiple_files(df_list):
    combined = pd.concat(df_list, ignore_index=True)
    combined = combined.sort_values("date")
    return combined

#----------------------------------------------------------------
#10.Spending Impact on Credit Score Logic
#----------------------------------------------------------------
def credit_utilization(total_spent, credit_limit):
    if credit_limit == 0:
        return 0
    return total_spent / credit_limit


def credit_score_impact(utilization):
    if utilization < 0.3:
        return "Excellent utilization 👍 (Low risk)"
    elif utilization < 0.5:
        return "Moderate utilization ⚠️"
    elif utilization < 0.75:
        return "High utilization 🚨 (May impact credit score)"
    else:
        return "Very High utilization ❗ Serious credit risk"


def safest_payment_amount(total_due, income=None):
    # Suggest paying at least 30–50% immediately
    if total_due <= 0:
        return 0
    return total_due * 0.5

#---------------------------------------------------------------
#11. Add Monthly Payback + Total Payback Tracking
#---------------------------------------------------------------
def monthly_payback_summary(df):
    summary = (
        df.groupby("month")["paid_back"]
        .sum()
        .reset_index()
    )
    return summary


def total_payback(df):
    return df["paid_back"].sum()