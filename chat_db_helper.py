from datetime import date
from datetime import datetime
import traceback
import psycopg2
global cnx
import json

cnx = psycopg2.connect(host="localhost",database="mcp",user="postgres",password="DigitalChannel123!",port="5432")

class NoDataFoundException(Exception):
    pass

class Account:

    def __init__(self, ssn: int, dob: date, account_id: int, client_account_number: str, original_account_number: str):
        print(f"the account number is {account_id}")
        param = f"({datetime.fromisoformat(dob).strftime("%Y-%m-%d")},{ssn},"
        third_param = ""
        try:
            cursor = cnx.cursor()
            select_query = "select act.account_id, act.original_account_number, act.client_account_number,con.dt_birth, con.identification_number from data.account act join data.consumer con on act.account_id=con.account_id where con.dt_birth=%s and right(con.identification_number,4)=%s"
            if account_id is not None:
                select_query+="and act.account_id=%s"
                third_param = account_id
            elif client_account_number is not None:
                select_query+="and con.client_account_number=%s"
                third_param = client_account_number
            elif original_account_number is not None:
                select_query+="and con.original_account_number=%s"
                third_param = original_account_number
            print(f" the select query is :{select_query}")
            print(f" the dob is :{dob}")
            print(f" the ssn is :{ssn}")
            print(f" the third param is :{third_param}")
            cursor.execute(select_query, (dob,str(ssn),third_param))
            result = cursor.fetchone()
            if result and not isinstance(result, int):
                self.ssn = result[4]
                self.dob = result[3]
                self.account_id = result[0]
                self.client_account_number = result[2]
                self.original_account_number = result[1]
            cursor.close()
        except Exception as e:
            print(f"Error selecting account from database: {e}")
            traceback.print_exc()

        # if int(account_id) % 3 == 0:
        #     self.current_balance = 1234.56
        #     self.original_balance = 2345.64
        #     self.last_payment_date = "12/12/2020"
        #     self.last_payment_amount = 34.56
        #     self.consumer_name = "Test User1"
        # elif int(account_id) % 3 == 1:
        #     self.current_balance = 6543.21
        #     self.original_balance = 7654.32
        #     self.last_payment_date = "10/10/2022"
        #     self.last_payment_amount = 65.43
        #     self.consumer_name = "Test User2"
        # else:
        #     raise NoDataFoundException("No account found in database with provided combination of account/ssn/dob details")

def retrieve_paymet_history(account_id: int) -> str:
    cursor = cnx.cursor()
    query = (
        "select payment_id, account_id, amt_payment as payment_amount, dt_payment as payment_date, amt_remaining as remaining_amount,pmt_status as payment_status from data.payment where account_id=%s and pmt_status='settled'")

    cursor.execute(query, [account_id])
    result = cursor.fetchall()
    json_string = json.dumps(result, default=str)
    cursor.close()
    return json_string

def validate_account_Details(ssn: str, dob:date, account_id: int, client_account_number: str, original_account_number: str):
    acct = Account(ssn, dob, account_id, client_account_number, original_account_number)
    return acct

def fetch_account_offer(account_id: int)->str:
    cursor = cnx.cursor()
    query = (
        "select account_id, system_offer_id as offer_id, discount_percentage, number_of_month as plan_duration from data.system_offer where account_id=%s and is_active=true")

    cursor.execute(query, [account_id])
    result = cursor.fetchone()
    json_string = json.dumps(result, default=str)
    cursor.close()
    return json_string

def create_payment_plan(account_id: int, discount_offer: float, duration)->str:
    updated_rows = 0
    try:
        cursor = cnx.cursor()
        cursor.execute(
            "insert into data.payment_plan (account_id, client_id, client_account_number, pct_discount, dt_settlement, amt_settlement, no_of_months, "
            "payment_plan_status, created_by, created_on, modified_by, modified_on) values (%s, (select client_id from data.account where account_id=%s), "
            "(select client_account_number from data.account where account_id=%s), %s, current_date, (select current_balance * (100-%s)/100 from data.account where account_id =%s), %s, "
            "'Active', 'System', current_timestamp, 'System', current_timestamp)", [account_id,account_id, account_id, discount_offer, discount_offer,account_id, duration])
        cnx.commit()
        updated_rows = cursor.rowcount
        cursor.close()
        print("Payment Plan created successfully")
    except (Exception, psycopg2.DatabaseError) as error:
        print(f"Error creating payment plan: {error}")
        # Rollback changes if necessary
        cnx.rollback()
        updated_rows = 0
    except Exception as e:
        print(f"An error occurred: {e}")
        # Rollback changes if necessary
        cnx.rollback()
        updated_rows = 0
    if updated_rows > 0:
        return "Your payment plan created successfully"
    else:
        return "Internal issue or no payment plan created"

def void_payment_plan(account_id)->str:
    updated_rows = 0
    try:
        cursor = cnx.cursor()
        cursor.execute("update data.payment_plan set payment_plan_status='Voided', modified_by='System', modified_on=current_timestamp where payment_plan_status='Active' and account_id=%s", [account_id])
        cnx.commit()
        updated_rows = cursor.rowcount
        cursor.close()
        print("Payment Plan voided successfully")
    except (Exception, psycopg2.DatabaseError) as error:
        print(f"Error voiding payment plan: {error}")
        # Rollback changes if necessary
        cnx.rollback()
        updated_rows = 0
    except Exception as e:
        print(f"An error occurred: {e}")
        # Rollback changes if necessary
        cnx.rollback()
        updated_rows = 0
    if updated_rows > 0:
        return "Your payment plan voided successfully"
    else:
        return "Internal issue or no payment plan already existing. Payment plan could not be voided"

def payment_plan_details(account_id: int)-> str:
    cursor = cnx.cursor()
    query = (
        "select payment_plan_id, account_id, pct_discount as discount_percentage, amt_settlement as settlement_amount, dt_settlement as settlement_date  from data.payment_plan where payment_plan_status='Active' and account_id=%s")

    cursor.execute(query, [account_id])
    result = cursor.fetchone()
    json_string = json.dumps(result, default=str)
    cursor.close()
    return json_string

def account_score(account_id: int)-> str:
    cursor = cnx.cursor()
    query = (
        "select avg(account_score) from data.account_score where account_id=%s")

    cursor.execute(query, [account_id])
    result = cursor.fetchone()
    json_string = json.dumps(result, default=str)
    cursor.close()
    return json_string

def account_score(account_id: int)-> str:
    cursor = cnx.cursor()
    query = (
        "select avg(account_score) from data.account_score where account_id=%s")

    cursor.execute(query, [account_id])
    result = cursor.fetchone()
    json_string = json.dumps(result, default=str)
    cursor.close()
    return json_string

def account_details(account_id: int):
    cursor = cnx.cursor()
    query = ("select act.account_id, act.original_account_number, act.client_account_number, act.assigned_balance, act.current_balance ,"
             "(select max(dt_payment) from data.payment pmt where pmt.account_id=act.account_id) last_payment_date ,(select amt_payment from "
             "data.payment pmt where pmt.account_id=act.account_id order by payment_id desc fetch first 1 row only) last_payment_amount,"
             "con.dt_birth, con.identification_number from data.account act join data.consumer con on act.account_id=con.account_id where act.account_id=%s")

    cursor.execute(query, [account_id])
    result = cursor.fetchone()
    json_string = json.dumps(result, default=str)
    cursor.close()
    return json_string



# Function to call the PostGreSQL stored procedure and insert an order item
def insert_order_item(food_item: str, quantity: int, order_id: int):
    try:
        cursor = cnx.cursor()
        cursor.execute("CALL food.insert_order_item(%s, %s, %s);", (food_item, quantity, order_id))
        cnx.commit()
        cursor.close()
        print("Order item inserted successfully!")
        return 1
    except (Exception, psycopg2.DatabaseError) as error:
        print(f"Error inserting order item: {error}")
        # Rollback changes if necessary
        cnx.rollback()
        return -1
    except Exception as e:
        print(f"An error occurred: {e}")
        # Rollback changes if necessary
        cnx.rollback()
        return -1

# Function to insert a record into the order_tracking table
def insert_order_tracking(order_id, status):
    try:
        cursor = cnx.cursor()
        insert_query = "INSERT INTO food.order_tracking (order_id, status) VALUES (%s, %s)"
        cursor.execute(insert_query, (order_id, status))
        cnx.commit()
        cursor.close()
    except Exception as e:
        print(f"Error inserting order item: {e}")
        # Rollback changes if necessary
        cnx.rollback()
        return -1

def get_total_order_price(order_id):
    cursor = cnx.cursor()
    query = f"SELECT food.get_total_order_price({order_id})"
    cursor.execute(query)
    result = cursor.fetchone()[0]
    cursor.close()
    return result

def get_next_order_id():
    cursor = cnx.cursor()
    query = "SELECT MAX(order_id) FROM food.orders"
    cursor.execute(query)
    result = cursor.fetchone()[0]

    cursor.close()

    if result is None:
        return 1
    else:
        return result + 1

def get_order_status(order_id):
    cursor = cnx.cursor()

    query = f"SELECT status FROM food.order_tracking WHERE order_id = {order_id}"
    cursor.execute(query)
    result = cursor.fetchone()
    cursor.close()
    if result:
        return result[0]
    else:
        return None


if __name__ == "__main__":
    print(get_next_order_id())