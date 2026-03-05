import pandas as pd
import re


def clean_data(df: pd.DataFrame) -> pd.DataFrame:
    """
    Cleans raw bank / credit card statement.
    Returns standardized expense-only dataframe ready for analysis.
    """

    # -------------------------------------------------
    # 1. Normalize Column Names
    # -------------------------------------------------
    df.columns = (
        df.columns
        .str.lower()
        .str.strip()
        .str.replace(r"[^\w\s]", "", regex=True)
        .str.replace(" ", "_")
    )

    # -------------------------------------------------
    # 2. Auto Detect Important Columns
    # -------------------------------------------------
    date_col = None
    desc_col = None
    amount_col = None

    for col in df.columns:
        if "date" in col:
            date_col = col
        elif any(x in col for x in ["desc", "detail", "memo"]):
            desc_col = col
        elif "amount" in col:
            amount_col = col

    # Handle Debit / Credit format
    if "debit" in df.columns and "credit" in df.columns:
        df["amount"] = (
            df["credit"].fillna(0).astype(str).str.replace(",", "")
        ).astype(float) - (
            df["debit"].fillna(0).astype(str).str.replace(",", "")
        ).astype(float)
        amount_col = "amount"

    # Validate required columns
    if not date_col or not desc_col or not amount_col:
        raise ValueError("Could not automatically detect required columns.")

    # Standardize column names
    df = df.rename(columns={
        date_col: "date",
        desc_col: "description",
        amount_col: "amount"
    })

    df = df[["date", "description", "amount"]].copy()

    # -------------------------------------------------
    # 3. Convert Date
    # -------------------------------------------------
    df["date"] = pd.to_datetime(df["date"], errors="coerce")
    df = df.dropna(subset=["date"])

    # -------------------------------------------------
    # 4. Clean Amount Column
    # -------------------------------------------------
    df["amount"] = (
        df["amount"]
        .astype(str)
        .str.replace(r"[,$]", "", regex=True)
        .astype(float)
    )

    # --------------------------------------------
    # 5. Classify Transaction Type
    # --------------------------------------------

    df["transaction_type"] = "expense"

    # Identify payments to credit card
    payment_keywords = [
        "payment",
        "autopay",
        "thank you",
        "credit card payment"
    ]

    pattern = "|".join(payment_keywords)

    df.loc[
        df["description"].str.lower().str.contains(pattern, regex=True, na=False),
        "transaction_type"
    ] = "payment"

    # --------------------------------------------
    # 6. Normalize Amount Sign
    # --------------------------------------------

    # Determine which sign represents purchases
    positive = (df["amount"] > 0).sum()
    negative = (df["amount"] < 0).sum()

    if positive >= negative:
        # Purchases positive, payments negative
        df["expense"] = df["amount"].apply(lambda x: x if x > 0 else 0)
        df["paid_back"] = df["amount"].apply(lambda x: abs(x) if x < 0 else 0)
    else:
        # Purchases negative
        df["expense"] = df["amount"].apply(lambda x: abs(x) if x < 0 else 0)
        df["paid_back"] = df["amount"].apply(lambda x: x if x > 0 else 0)

    # -------------------------------------------------
    # 7. Create Merchant Column
    # -------------------------------------------------
    df["merchant"] = (
        df["description"]
        .str.lower()
        .str.replace(r"[^a-z\s]", "", regex=True)
        .str.strip()
    )

    # -------------------------------------------------
    # 8. Time Features
    # -------------------------------------------------
    df["month"] = df["date"].dt.to_period("M").dt.to_timestamp()
    df["year"] = df["date"].dt.year
    df["day"] = df["date"].dt.day_name()

    df = df.sort_values("date")

    return df