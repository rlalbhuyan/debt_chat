import re
from datetime import datetime


def get_str_from_food_dict(food_dict: dict):
    result = ", ".join([f"{int(value)} {key}" for key, value in food_dict.items()])
    return result


def extract_session_id(session_str: str):
    match = re.search(r"/sessions/(.*?)/contexts/", session_str)

    if match:
        extracted_string = match.group(0)
        ssn = extracted_string.split('/')[2]
        print(f"inbound {ssn}")
        return ssn
    return "abcd"

def is_valid_date(date_string, date_format="%Y-%m-%d"):
    date_portion = date_string[:10]
    print(f"received value {date_portion}")

    try:
        # Tries to parse the string into a real datetime object
        datetime.strptime(date_portion, date_format)
        print("returning true")
        return True
    except ValueError:
        print("returning false")
        # Triggers if formatting is wrong OR if the date is physically impossible
        return False