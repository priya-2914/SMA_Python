import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt

# Import from src folder
from src.cleaning import clean_data
from src.categorize import apply_categorization
from src.analysis import (
    get_summary,
    monthly_summary,
    category_summary,
    top_merchants,
    weekday_spending,
    payment_ratio,
    monthly_category_breakdown,
    largest_transactions,
    filter_by_date,
    combine_multiple_files,
    credit_utilization,
    credit_score_impact,
    safest_payment_amount,
    monthly_payback_summary,
    total_payback
)

st.set_page_config(page_title="Spending Analyzer", layout="wide")

st.title("💳 Smart Spending Analyzer")

# ---------------------------------------------------
# File Upload
# ---------------------------------------------------

uploaded_files = st.file_uploader(
    "Upload one or more CSV files",
    type=["csv"],
    accept_multiple_files=True
)

if uploaded_files:

    df_list = []

    for file in uploaded_files:
        df = pd.read_csv(file)

        # Apply cleaning + categorization
        df = clean_data(df)
        df = apply_categorization(df)

        df_list.append(df)

    # ---------------------------------------------------
    # Combine or Individual Selection
    # ---------------------------------------------------

    analysis_mode = st.radio(
        "Select Analysis Mode",
        ["Combine All Files", "Analyze Individually"]
    )

    if analysis_mode == "Combine All Files":
        df = combine_multiple_files(df_list)
    else:
        selected_index = st.selectbox(
            "Select file to analyze",
            range(len(uploaded_files)),
            format_func=lambda i: uploaded_files[i].name
        )
        df = df_list[selected_index]

    # ---------------------------------------------------
    # Date Filtering
    # ---------------------------------------------------

    st.subheader("📅 Filter by Date Range")

    min_date = df["date"].min()
    max_date = df["date"].max()

    start_date = st.date_input("Start Date", value=min_date)
    end_date = st.date_input("End Date", value=max_date)

    df = filter_by_date(df, start_date, end_date)

    # ---------------------------------------------------
    # Summary Metrics
    # ---------------------------------------------------

    summary = get_summary(df)

    col1, col2, col3, col4 = st.columns(4)

    col1.metric("Total Spent", f"${summary['total_spent']}")
    col2.metric("Total Paid Back", f"${summary['total_paid_back']}")
    col3.metric("Net Cash Flow", f"${summary['net_cash_flow']}")
    col4.metric("Transactions", summary['total_transactions'])

    # ---------------------------------------------------
    # Monthly Summary
    # ---------------------------------------------------

    st.subheader("📆 Monthly Summary")
    st.dataframe(monthly_summary(df), use_container_width=True)

    st.subheader("📈 Monthly Spending Trend")

    monthly_df = monthly_summary(df)

    if not monthly_df.empty:
        fig, ax = plt.subplots()

        ax.plot(monthly_df["month"], monthly_df["total_spent"], marker="o")
        ax.plot(monthly_df["month"], monthly_df["total_paid"], marker="o")

        ax.set_xlabel("Month")
        ax.set_ylabel("Amount")
        ax.set_title("Monthly Spending vs Payments")
        ax.legend(["Spent", "Paid Back"])

        plt.xticks(rotation=45)
        st.pyplot(fig)

    # ---------------------------------------------------
    # Category Summary
    # ---------------------------------------------------

    st.subheader("📊 Category Spending")
    cat_df = category_summary(df)
    if not cat_df.empty:
        st.dataframe(cat_df, use_container_width=True)
    st.subheader("🥧 Expense Distribution by Category")

    cat_df = category_summary(df)

    if not cat_df.empty:
        fig, ax = plt.subplots()

        ax.pie(
            cat_df["expense"],
            labels=cat_df["category"],
            autopct="%1.1f%%",
            startangle=90
        )

        ax.set_title("Spending by Category")
        st.pyplot(fig)

    # ---------------------------------------------------
    # Top Merchants
    # ---------------------------------------------------

    st.subheader("🏪 Top 10 Merchants")

    merchant_df = top_merchants(df)

    if not merchant_df.empty:
        fig, ax = plt.subplots()

        ax.barh(merchant_df["merchant"], merchant_df["expense"])
        ax.set_xlabel("Total Spent")
        ax.set_title("Top Merchants")

        ax.invert_yaxis()  # highest at top

        st.pyplot(fig)

    # ---------------------------------------------------
    # Weekday Pattern
    # ---------------------------------------------------

    st.subheader("📅 Weekday Spending Pattern")

    weekday_df = weekday_spending(df)

    if not weekday_df.empty:
        fig, ax = plt.subplots()

        ax.bar(weekday_df["day"], weekday_df["expense"])

        ax.set_xlabel("Day")
        ax.set_ylabel("Total Spent")
        ax.set_title("Spending by Day of Week")

        plt.xticks(rotation=45)
        st.pyplot(fig)

    # ---------------------------------------------------
    # Largest Transactions
    # ---------------------------------------------------

    st.subheader("💰 Largest Transactions")
    st.dataframe(largest_transactions(df), use_container_width=True)

    # ---------------------------------------------------
    # Payment Behavior
    # ---------------------------------------------------

    st.subheader("💳 Payment Analysis")

    ratio = payment_ratio(df)
    st.write(f"Payment Ratio: {ratio}% of spending paid back")

    total_paid = total_payback(df)
    st.write(f"Total Paid Back in Selected Period: ${round(total_paid, 2)}")

    st.subheader("💳 Spending vs Payback Comparison")

    summary = get_summary(df)

    fig, ax = plt.subplots()

    labels = ["Total Spent", "Total Paid Back"]
    values = [summary["total_spent"], summary["total_paid_back"]]

    ax.bar(labels, values)
    ax.set_title("Overall Spending vs Payback")

    st.pyplot(fig)

    # ---------------------------------------------------
    # Credit Score Insight
    # ---------------------------------------------------

    st.subheader("📈 Credit Utilization Insight")

    credit_limit = st.number_input("Enter Credit Limit", value=5000.0)

    utilization = credit_utilization(summary["total_spent"], credit_limit)

    st.write(f"Utilization Ratio: {round(utilization * 100, 2)}%")
    st.write(credit_score_impact(utilization))

    suggested_payment = safest_payment_amount(summary["net_cash_flow"])

    st.info(
        f"💡 Suggested Immediate Safe Payment: "
        f"${round(suggested_payment, 2)}"
    )

else:
    st.info("Please upload at least one CSV file to begin.")