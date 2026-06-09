import json
from dotenv import load_dotenv
from langchain.agents import create_agent
from langchain.tools import tool
from langchain_groq import ChatGroq
import chat_db_helper

load_dotenv()
llm = ChatGroq(model="qwen/qwen3-32b", temperature=0)
vision_llm = ChatGroq(model="meta-llama/llama-4-scout-17b-16e-instruct", temperature=0)

# ---------------------------------------------------------------------------
# Tools
# ---------------------------------------------------------------------------

@tool
def view_payments(account_id: int)->str:
    """
    search the list of all the payments made on the account based on account_id provided.
    in case no payment available, return empty result
    returns a JSON array of matching payments with payment date, amount, status, balance after payment.
    """
    # payments =  [{"account_id": account_id, "payment_id": 1, "payment_date": "2026-01-10", "payment_amount": 500.00, "payment_status": "settled","balance_after_payment": 4500},
    #              {"account_id": account_id, "payment_id": 2, "payment_date": "2026-02-10", "payment_amount": 400.00, "payment_status": "settled","balance_after_payment": 4100}]
    return chat_db_helper.retrieve_paymet_history(account_id);

@tool
def list_offers(account_id: int, consumer_score: float)->str:
    """
    search the list of all the discount offers for creating payment plan for the account based on account_id provided.
    in case consumer score not provided, you need to call the fetch_consumer_score function and use consumer score while fetching the offer list.
    in case no score fetched, need to consider score as zero for fetching the offer.
    returns a JSON array of matching discount offers with offer_id, discount percentage, plan duration for creating payment plan when required.
    """
    return chat_db_helper.fetch_account_offer(account_id)

@tool
def create_payment_plan(account_id: int, discount_offer: float, duration: int)->str:
    """
    create a payment plan for the account based on account_id provided.
    in case discount_offer is not provided, need to call list_offer function to get the list of discount offers.
    you need to use the best discount offer with highest discount_percentage for the account for using as part of payment plan.
    In case discount_offer not fetched, need to use discount_offer as 0 and duration as 6 months.
    returns a string with message in case payment plan got voided successfully.
    """

    return chat_db_helper.create_payment_plan(account_id, discount_offer, duration);

@tool
def void_payment_plan(account_id: int)->str:
    """
    void the payment plan for an account based on the account_id provided.
    in case payment plan does not exist, return appropriate message that, payment plan does not exist to be voided.
    in case account_id not provided, show appropriate message that, need a valid account_id for voiding a payment plan.
    if the account_is not existing or invalid account_id return an appropriate message that account_id is not valid or does not exist in database.
    returns a string with message in case payment plan got voided successfully.
    """
    return chat_db_helper.void_payment_plan(account_id)

@tool
def payment_plan_details(account_id: int)->str:
    """
    fetch the payment plan detail of the account based on the account id provided.
    if no payment plan is available, provide a message that payment plan is not existing to provide plan detail.
    in case account_id not provided, show appropriate message that, need a valid account_id for providing payment plan detail.
    if the account_is not existing or invalid account_id return an appropriate message that account_id is not valid or does not exist in database.
    returns a JSON object with required attributes for the payment plan if exists.
    """
    # payment_plan_detail = {"account_id": account_id, "payment_plan_id": 21, "discount_percentage": 12.5, "settlement_amount": 5000.00, "settlement_date":"2026-10-21"}
    return chat_db_helper.payment_plan_details(account_id)

@tool
def fetch_consumer_score(account_id: int)->str:
    """
    consumer score of an account decided based on its primary consumer.
    you need to fetch the primary consumer of the account before fetching the consumer score.
    once primary consumer is available, you need to fetch the consumer score in decimal precision and provide it to the caller to take any action.
    in case no consumer score available or no primary consumer is available, you need to provide 0 as default consumer score.
    returns a decimal value as score of the account to be used for discount decision
    """
    return chat_db_helper.account_score(account_id)

@tool
def fetch_account_details(account_id: int)->str:
    """
    account detail of an account consist of multiple attributes at account level.
    Those are account_id, original_account_number, client_account_number, original_account_balance, current_account_balance, last_payment_date.
    in case the account id not provided, provide a graceful message that account_id is mandatory to fetch account details.
    provide only attribute which are provided instead of assuming wrong attribute.
    returns a JSON object with all the attributes to the caller.
    in case account_id is not available, you need to provide an appropriate message to inform, account id is not available.
    """
    return chat_db_helper.account_details(account_id)



# ---------------------------------------------------------------------------
# Agent
# ---------------------------------------------------------------------------

agent = create_agent(
    tools=[fetch_consumer_score, fetch_account_details, create_payment_plan, view_payments, void_payment_plan, payment_plan_details, list_offers],
    model=llm,
    system_prompt=(
        "You are a helpful assistant to provide help on payment or payment plan details. Follow these rules strictly.\n\n"
        "ACTIONS — when the user describes what they want, you need to take appropriate action by calling the required tool from the list :\n"
        "1. Call fetch_consumer_score to fetch the consumer score or account score by passing the account_id.\n"
        "2. call fetch_account_details for getting entire account details by passing account_id.\n"
        "3. call view_payments to return the history of all the payments made by the consumer including date, amount, status by passing the account_id.\n"
        "4. call void payment_plan for cancelling/voiding the payment plan of the account by passing the account_id. return appropriate message in case no payment plan exists or account id not provided"
        "5. call create_payment_plan for creating a payment plan for the account by passing account_id, consumer score and duration of the payment plan.\n"
        "6. call payment_plan_details for fetching payment plan detail for the account details by passing account_id. return a graceful message stating payment plan does not exist \n"
        "7. call list_offers for getting list of discount offer for the account available by passing account_id and consumer score.\n"
        "   (plain text, no backticks, no code blocks, no bold, no italic):\n\n"
        "   #<number>. <name> (ID:<product_id>) — $<price> ★<rating> — <organic or non-organic>\n\n"
        "   Add a blank line between each product entry for readability. "
        "   Always include (ID:X) so you can reference it later.\n"
        "8. if no offer returns as a part of list_offers tool, use default discount offer as 0 and default duration as 6(months): "
        "In case you dont understand the text/question, simply respond 'In case you need any assistance out of below options, Please let me know'"
    ),
)

def execute_agent(description: str)->str:
    response = agent.invoke(
        {
            "messages": [
                {
                    "role": "user",
                    "content": (
                        description
                    ),
                }
            ]
        }
    )
    return response["messages"][-1].content

if __name__ == "__main__":
    result = agent.invoke(
        {
            "messages": [
                {
                    "role": "user",
                    "content": (
                        "My account id is 123456, date of birth is 12/1/1980, last four digits of ssn is 5432, original_accuont_id is '23456', client_account_number is '54321'. can you share the list of discount offer available for me?"
                    ),
                }
            ]
        }
    )
    print(result["messages"][-1].content)