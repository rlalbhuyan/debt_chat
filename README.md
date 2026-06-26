# debt_chat
This is a dummy AI project for debt collection organization for collector or end users to ask payment related questions or create/void payment plan.
Few actions are accomodated to accomplish by using Agentic AI.
Example - In case an account manager or the user wants to create a payment plan, the user need to communicate the intention and below action will be taken care of: 
required validation will be taken care by asking account_id/client_account_number/original_account_number, date of birth of primary consumer, last four digits of ssn. There are few combination.
In case user will ask to create a payment plan, few tasks will be accomplished like, checking the consumer score for deciding the discount percentage, the highest percentage will be used for creating payment plan and communicated on chat. In case subscribed, email will be triggered to consumer email address


Below are the steps.
1.  Get the code from Github
2.  create a database and execute db_chat.sql
3.  on python envirornment execute a command **uvicorn.exe chat_main:app**
4.  Open the command prompt and execute command to have https url **C:\ant_tut\RAG\debtchat>ngrok http 8000**. Get the URL for configuration on Google DialogFlow fulfillment
5.  Open Google DialogFlow console. https://dialogflow.cloud.google.com/
6.  Create a credential, login and create intents
7.  Configure beolow intents after going through tutorials.
8.  <img width="353" height="268" alt="image" src="https://github.com/user-attachments/assets/6a61fa0c-4063-4d4f-83f7-7f4a06166ed7" />
9.  click dialogflow integration
10.  Click Web Flow
11.  Click the link for Web Demo
12.  Below can be a demo chat
 <p align="left">hi</p>
 <p align="right" bgcolor="yellow">This is Riya. Can you let me know your name please?</p>
 <p align="left">I want account balance </p>
 <p align="right" bgcolor="yellow">This is Riya. Can you let me know your name please?</p>
 <p align="left">My name is Ranjanlal</p>
<p align="right" bgcolor="yellow">Thank you Ranjanlal How can I help you?</p>
 <p align="left">I want account balance</p>
<p align="right" bgcolor="yellow">I need account details to verify. I need one of these attributes(account number/client_account_number/orginal_account_number, date of birth of the primary consumer, and last four digits Of SSN?</p>
 <p align="left">I want to see the payment history</p>
<p align="right" bgcolor="yellow">Dear Ranjanlal, Account has not been identified. I need account details to verify. I need one of these attributes(account number/client_account_number/orginal_account_number, date of birth of the primary consumer, and last four digits Of SSN?. Please make sure the account has been validated before executing any goal</p>
 <p align="left">my account id is 5</p>
<p align="right" bgcolor="yellow">Additional details required. please provide dob and last four digits of ssn</p>
 <p align="left">last four digits of ssn is 6789</p>
<p align="right" bgcolor="yellow">Additional details required. please provide dob</p>
 <p align="left">date of birth is 10/10/2000</p>
<p align="right" bgcolor="yellow">Account identified.. What action you want to take now?. Below are the list of actions:. View payment history. View payment plan. Check various payment plan offer. Check consumer score. Creation of payment plan. Void payment plan</p>
 <p align="left">paymen tplan detail</p>
<p align="right" bgcolor="yellow">Dear Ranjanlal, Here are the payment plan details for your account: - Payment Plan ID: 24 - Account ID: 5 - Discount Offer: 30.00% - Current Balance: $3738.70 - Plan End Date: June 25, 2026</p>
 <p align="left" bgcolor="yellow">payment history</p>
<p align="right" bgcolor="yellow">Dear Ranjanlal, Here is the payment history for account ID 5: 1. Date: 2025-01-01, Amount: $250.00, Status: Settled, Balance after payment: $9750.00 2. Date: 2025-02-01, Amount: $250.00, Status: Settled, Balance after payment: $9500.00 3. Date: 2025-03-01, Amount: $250.00, Status: Settled, Balance after payment: $9250.00 4. Date: 2025-04-01, Amount: $250.00, Status: Settled, Balance after payment: $9000.00 5. Date: 2025-05-01, Amount: $250.00, Status: Settled, Balance after payment: $8750.00 6. Date: 2025-06-01, Amount: $250.00, Status: Settled, Balance after payment: $8500.00</p>
 <p align="left">my account score please</p>
<p align="right" bgcolor="yellow">Dear Ranjanlal, Your account score is 755.</p>
 <p align="left">discount offer for my account</p>
<p align="right" bgcolor="yellow">Dear Ranjanlal, Here is the discount offer available for your account: 1. Offer (ID:5) — 30% discount for a duration of 6 months.</p>
 <p align="left">please void the existing payment plan</p>
<p align="right" bgcolor="yellow">Dear Ranjanlal, Your payment plan has been successfully voided. If you need any further assistance, feel free to ask!</p>
 <p align="left">payment plan detail</p>
<p align="right" bgcolor="yellow">Dear Ranjanlal, Payment plan does not exist for account ID 5.</p>
 <p align="left">please create a payment plan with best discount offer</p>
<p align="right" bgcolor="yellow">Your payment plan has been created successfully with the best discount offer of 30% for a duration of 6 months</p>
 <p align="left">who is president of india</p>
<p align="right" bgcolor="yellow">I didn't get that. Can you repeat?</p>
 <p align="left">what is my original account number?</p>
<p align="right" bgcolor="yellow">Dear Ranjanlal, Your original account number is 5682.</p>
 <p align="left">my consumer detail please</p>
<p align="right">Dear Ranjanlal, Here are the details for your account with ID 5: - **Original Account Number:** 5682 - **Client Account Number:** 1238 - **Original Account Balance:** $5341.00 - **Current Account Balance:** $5341.00 - **Last Payment Date:** 2025-06-01 Your consumer score is **755.00**. If you need any further assistance, feel free to ask!</p>
