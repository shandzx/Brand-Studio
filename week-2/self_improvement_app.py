"""
Self Improvement App

This app:
- gets a motivational quote from the Quotable API
- analyses the quote to find a theme
- gets a related book recommendation using Open Library
- prints both results
- saves the results to a file

Setup:
python3 -m pip install requests

Note:
Quotable currently has an SSL certificate issue, so verify=False is used.
"""

import requests
import urllib3
import random

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


def get_quote():
    """Fetch a motivational quote from Quotable."""
    url = "https://api.quotable.io/random"

    try:
        response = requests.get(url, timeout=10, verify=False)

        if response.status_code == 200:
            data = response.json()
            return data["content"], data["author"]
        else:
            return "Could not fetch quote.", "Unknown"
    except requests.exceptions.RequestException:
        return "Error fetching quote.", "Unknown"


def detect_theme(quote_text):
    """Work out a theme based on words in the quote."""
    quote_lower = quote_text.lower()

    if any(word in quote_lower for word in ["mind", "think", "thought", "wisdom", "learn", "knowledge"]):
        return "mindset"
    elif any(word in quote_lower for word in ["discipline", "habit", "consistency", "effort", "work"]):
        return "discipline"
    elif any(word in quote_lower for word in ["life", "purpose", "meaning", "future", "dream"]):
        return "purpose"
    elif any(word in quote_lower for word in ["fear", "courage", "confidence", "believe", "brave"]):
        return "confidence"
    else:
        return "growth"


def get_book(theme):
    """
    Get a real book title related to the quote theme.
    Uses Open Library to search for actual books.
    """
    theme_books = {
        "mindset": [
            "Mindset",
            "The Power of Your Subconscious Mind",
            "Think and Grow Rich",
            "The Magic of Thinking Big"
        ],
        "discipline": [
            "Atomic Habits",
            "The 7 Habits of Highly Effective People",
            "Deep Work",
            "Make Your Bed"
        ],
        "purpose": [
            "Man's Search for Meaning",
            "The Alchemist",
            "Ikigai",
            "The Purpose Driven Life"
        ],
        "confidence": [
            "Feel the Fear and Do It Anyway",
            "You Are a Badass",
            "The Confidence Code",
            "Daring Greatly"
        ],
        "growth": [
            "The Power of Now",
            "Awaken the Giant Within",
            "The Four Agreements",
            "The Road Less Travelled"
        ]
    }

    possible_books = theme_books[theme]
    chosen_title = random.choice(possible_books)

    url = f"https://openlibrary.org/search.json?title={chosen_title}"

    try:
        response = requests.get(url, timeout=10)

        if response.status_code == 200:
            data = response.json()
            docs = data.get("docs", [])

            for book in docs:
                title = book.get("title")
                if title:
                    return title

            return chosen_title
        else:
            return chosen_title
    except requests.exceptions.RequestException:
        return chosen_title


def save_results(quote, author, theme, book):
    """Save the final results to a text file."""
    with open("results.txt", "w", encoding="utf-8") as file:
        file.write("Self Improvement Results\n")
        file.write("------------------------\n")
        file.write(f"Quote: {quote} - {author}\n")
        file.write(f"Theme: {theme}\n")
        file.write(f"Book: {book}\n")


def main():
    """Run the application."""
    print("Welcome to the Self Improvement App!")

    quote, author = get_quote()
    theme = detect_theme(quote)
    book = get_book(theme)

    print("\nHere is your motivational quote:")
    print(f"{quote} - {author}")

    print("\nDetected theme:")
    print(theme.title())

    print("\nHere is a book recommendation:")
    print(book)

    save_results(quote, author, theme, book)

    print("\nYour results have been saved to results.txt")


if __name__ == "__main__":
    main()