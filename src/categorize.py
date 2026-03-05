import re


# -------------------------
# CATEGORY KEYWORDS ENGINE
# -------------------------

CATEGORY_RULES = {
    "Shopping": [
        "amazon", "amzn", "target", "bestbuy", "samsung","swaroski"
    ],
    "Groceries": [
        "walmart", "aldi", "costco", "grocery", "price chopper", "Dollar tree"
    ],
    "Transport": [
        "uber", "lyft"
    ],
    "Gas": [
        "shell", "bp", "chevron", "exxon"
    ],
    "Subscription": [
        "tmobile", "t-mobile", "spotify", "netflix"
    ],
    "Education": [
        "university", "college", "umkc"
    ],
    "Government": [
        "uscis", "irs"
    ],
    "Dining": [
        "restaurant", "cafe", "pizza", "chipotle", "doordash","kushi", "rajadhani"
    ]
}


def normalize_text(text: str) -> str:
    """
    Clean description text.
    """
    text = text.lower()
    text = re.sub(r"[^a-z\s]", " ", text)
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def categorize_transaction(description: str) -> str:
    """
    Categorize based on keyword matching.
    """

    clean_desc = normalize_text(description)

    for category, keywords in CATEGORY_RULES.items():
        for word in keywords:
            if word in clean_desc:
                return category

    return "Other"


def apply_categorization(df):
    """
    Add category column using rule engine.
    """
    df["category"] = df["description"].apply(categorize_transaction)
    return df