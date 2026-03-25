import requests
import urllib3

# Disable SSL warnings
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


def get_quote():
    url = "https://api.quotable.io/random"
    response = requests.get(url, verify=False)

    if response.status_code == 200:
        data = response.json()
        return f"{data['content']} - {data['author']}"
    else:
        return "Could not fetch quote."


def get_book(topic):
    url = f"https://openlibrary.org/search.json?q={topic}"
    response = requests.get(url, verify=False)

    if response.status_code == 200:
        data = response.json()
        if data["docs"]:
            return data["docs"][0].get("title", "No title found")
    return "Could not fetch book."


def save_to_file(text):
    with open("plan.txt", "a") as file:
        file.write(text + "\n\n")


def generate_plan():
    print("\n--- Daily Self Improvement ---")

    quote = get_quote()

    # 🔑 simple keyword extraction
    words = quote.split()
    topic = words[0]  # take first word as topic

    book = get_book(topic)

    plan = f"Quote:\n{quote}\n\nBook to explore:\n{book}"

    print(plan)

    save = input("\nDo you want to save this plan? (yes/no): ").strip().lower()

    if save == "yes":
        save_to_file(plan)
        print("Plan saved!")


def main():
    while True:
        print("\n1. Generate Plan")
        print("2. Exit")

        choice = input("Choose an option: ").strip()

        if choice == "1" or choice == "1.":
            generate_plan()

        elif choice == "2" or choice == "2.":
            print("Goodbye!")
            break

        else:
            print("Invalid choice, try again.")


main()