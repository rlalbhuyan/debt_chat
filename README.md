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
13.  
