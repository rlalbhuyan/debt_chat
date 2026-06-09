from fastapi import FastAPI
from fastapi import Request
from fastapi.responses import JSONResponse
import chat_generic_helper
from chat_db_helper import Account
import chat_payment_agent

app = FastAPI()

account_details = {}
user_names = {}


@app.post("/")
async def handle_request(request: Request):
    # Retrieve the JSON data from the request
    payload = await request.json()

    # Extract the necessary information from the payload
    # based on the structure of the WebhookRequest from Dialogflow
    intent = payload['queryResult']['intent']['displayName']
    parameters = payload['queryResult']['parameters']
    output_contexts = payload['queryResult']['outputContexts']
    session_id = chat_generic_helper.extract_session_id(output_contexts[0]["name"])
    if session_id not in user_names and "person" not in parameters:
        return JSONResponse(content={
            "fulfillmentText": "It is easier to interact with name. Can you let me know your name please if you dont mind?"
        })
    if intent=="logout":
        return logout_handler(parameters, session_id, payload['queryResult'])
    if session_id in account_details and 'valid_account' in account_details[session_id] and account_details[session_id]['valid_account']=="Successful":
        return agentic_handler(parameters, session_id, payload['queryResult'])
    intent_handler_dict = {
        'Default Welcome Intent': welcome_handler,
        'name communication' : name_handler,
        'balance check': balance_handler,
        'account details': account_detail_handler,
        'agentic tool decision': agentic_handler,
    }
    return intent_handler_dict[intent](parameters, session_id, payload['queryResult'])

def logout_handler(parameters: dict, session_id: str, query: str):
    fulfillment_text = f"Thank you {user_names[session_id]}. See you again. Bye......"
    if session_id in account_details:
        account_details.pop(session_id)
    if session_id in user_names:
        user_names.pop(session_id)
    return JSONResponse(content={
        "fulfillmentText": fulfillment_text
    })


def agentic_handler(parameters: dict, session_id: str, query: str):
    if session_id not in account_details or account_details[session_id].get("account_id") is None:
        return JSONResponse(content={
            "fulfillmentText": f"Dear {user_names[session_id]},  Account has not been identified. I need account details to verify. I need one of these attributes(account number/client_account_number/orginal_account_number, date of birth of the primary consumer, and last four digits Of SSN?. Please make sure the account has been validated before executing any goal"
        })
    description = f"my account id is {account_details[session_id].get("account_id")}, {query['queryText']}"
    print("description: "+description)
    result = chat_payment_agent.execute_agent(description)
    print("response: "+result)
    return JSONResponse(content={
        "fulfillmentText": f"Dear {user_names[session_id]}, {result}"
    })

def welcome_handler(parameters: dict, session_id: str, query: str):

    if session_id not in user_names:
        return JSONResponse(content={
            "fulfillmentText": "I am Riya. Your assistant for today's conversation. It is easier to interact with name. Can you let me know your name please?"
        })
    else:

        fulfillment_text = f"Hi {user_names[session_id]}. How can I Help you?"

    return JSONResponse(content={
        "fulfillmentText": fulfillment_text
    })

def name_handler(parameters: dict, session_id: str, query: str):

    if parameters["person"] is not None:
        username = parameters["person"]
        user_names[session_id] = username['name']
        return JSONResponse(content={
            "fulfillmentText": f"Thank you {username['name']} How can I help you?"
        })

    if session_id not in user_names:
        return JSONResponse(content={
            "fulfillmentText": "It is easier to interact with name. Can you let me know your name please if you dont mind?"
        })

    fulfillment_text = f" This is default response after validating the user existence"

    return JSONResponse(content={
        "fulfillmentText": fulfillment_text
    })

def balance_handler(parameters: dict, session_id: str, query: str):

    if session_id not in user_names:
        return JSONResponse(content={
            "fulfillmentText": "It is easier to interact with name. Can you let me know your name please if you dont mind?"
        })
    if session_id not in account_details:
        return JSONResponse(content={
            "fulfillmentText": "I need account details to verify. \n\n I need one of these attributes(account number/client_account_number/orginal_account_number, \n\n "
                               "date of birth of the primary consumer, \n\n and last four digits Of SSN?"
        })

    acct = Account(account_details[session_id].get("ssn"), account_details[session_id].get("dob"),
                   account_details[session_id].get("account_id"),
                   account_details[session_id].get("client_account_number"),
                   account_details[session_id].get("original_account_number"))
    fulfilment_text = "The original account balance is : " + str(acct.original_balance)


    return JSONResponse(content={"fulfillmentText": fulfilment_text})


def account_detail_handler(parameters: dict, session_id: str, query: str):
    fulfilment_text = f"Additional details required. please provide "
    validation: bool = True
    if session_id not in user_names:
        return JSONResponse(content={
            "fulfillmentText": "It is easier to interact with name. Can you let me know your name please?"
        })
    if parameters["dob"] != '' and chat_generic_helper.is_valid_date(parameters["dob"]):
        pair = {"dob": parameters["dob"]}
        if session_id in account_details:
            useraccount = account_details[session_id]
            useraccount.update(pair)
            account_details[session_id] = useraccount
        else:
            account_details[session_id] = pair
    elif session_id not in account_details or account_details[session_id].get("dob") is None:
        fulfilment_text += " dob"
        validation = False

    if parameters["ssn"] != '':  # and isinstance(parameters["ssn"], (int,float)): #and int(parameters["ssn"])>999 and int(parameters["ssn"])<10000:
        pair = {"ssn": int(parameters["ssn"])}
        if session_id in account_details:
            useraccount = account_details[session_id]
            useraccount.update(pair)
            account_details[session_id] = useraccount
        else:
            account_details[session_id] = pair
    elif session_id not in account_details or account_details[session_id].get("ssn") is None:
        if validation:
            validation = False
        else:
            fulfilment_text += " and"
        fulfilment_text += " last four digits of ssn"
    if parameters["account_id"] != '' and isinstance(parameters["account_id"], (int, float)):
        pair = {"account_id": int(parameters["account_id"])}
        if session_id in account_details:
            useraccount = account_details[session_id]
            useraccount.update(pair)
            account_details[session_id] = useraccount
        else:
            account_details[session_id] = pair

    if parameters["client_account_number"] != '':
        pair = dict(zip(["client_account_number"], [parameters["client_account_number"]]))
        if session_id in account_details:
            useraccount = account_details[session_id]
            useraccount.update(pair)
            account_details[session_id] = useraccount
        else:
            account_details[session_id] = pair
        print(f"client_eaccont_number statement {account_details[session_id]}")

    if parameters["original_account_number"] != '':
        pair = dict(zip(["original_account_number"], [parameters["original_account_number"]]))
        if session_id in account_details:
            useraccount = account_details[session_id]
            useraccount.update(pair)
            account_details[session_id] = useraccount
        else:
            account_details[session_id] = pair

    if session_id not in account_details:
        return JSONResponse(content={
            "fulfillmentText": "Please provide the account details"
        })
    # if account_details[session_id].get("account_id") is None and account_details[session_id].get("client_account_number") is None and account_details[session_id].get("original_account_number") is None:
    #     if validation:
    #         validation = False
    #     else:
    #         fulfilment_text += " and"
    #     fulfilment_text += " (need either account_id or client_account_number or origina_account_number)"

    if session_id not in account_details or (account_details[session_id].get("account_id") is None and account_details[session_id]["client_account_number"] is None and account_details[session_id]["original_account_number"] is None):
        print(session_id not in account_details)
        print(f"client_eaccont_number statement {account_details[session_id]['client_account_number']}")
        if validation:
            validation = False
        else:
            fulfilment_text += " and"
        fulfilment_text += " (need either account_id or client_account_number or origina_account_number)"

    if validation:
        acct = Account(account_details[session_id].get("ssn"), account_details[session_id].get("dob"), account_details[session_id].get("account_id"), account_details[session_id].get("client_account_number"),account_details[session_id].get("original_account_number"))
        if hasattr(acct, "account_id"):
            pair = dict(zip(["valid_account"], ["Successful"]))
            useraccount = account_details[session_id]
            useraccount.update(pair)
            account_details[session_id] = useraccount
            pair = {"account_id": acct.account_id}
            if session_id in account_details:
                useraccount = account_details[session_id]
                useraccount.update(pair)
                account_details[session_id] = useraccount
            else:
                account_details[session_id] = pair
        else:
            return JSONResponse(content={
                "fulfillmentText": f"Invalid details. Please verify and provide accurate detail for validation. the ssn you provided: {account_details[session_id].get('ssn')}, the date of birth you provided: {account_details[session_id].get('dob')}, account number you provided: {account_details[session_id].get('account_id')}, the client_account_number you provided: {account_details[session_id].get('client_account_number')},the original_account_number you provided:{account_details[session_id].get('original_account_number')}"
            })
        fulfilment_text = "Account identified."
        fulfilment_text += f".\nWhat action you want to take now?"
        fulfilment_text += f".\nBelow are the list of actions:"
        fulfilment_text += f".\nView payment history"
        fulfilment_text += f".\nView payment plan"
        fulfilment_text += f".\nCheck various payment plan offer"
        fulfilment_text += f".\nCheck consumer score"
        fulfilment_text += f".\nCreation of payment plan"
        fulfilment_text += f".\nVoid payment plan"
    return JSONResponse(content={
        "fulfillmentText": fulfilment_text
    })
