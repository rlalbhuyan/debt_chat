create schema data;
create schema auth;
create schema audt;
create schema docmgr;
create schema conf;

create table conf.client
(
client_id int primary key,
client_name varchar(100),
client_address varchar(100),
client_phone varchar(20),
client_poc varchar(50),
created_by varchar(30),
created_on timestamp,
modified_by varchar(30),
modified_on timestamp
);

insert into conf.client(client_id, client_name, client_address, client_phone, client_poc)
values(1,'First Bank Llc','FirstLineAddress 1','9871022736','Ranjanlal Bhuyan');
insert into conf.client(client_id, client_name, client_address, client_phone, client_poc)
values(2,'Second Bank Llc','FirstLineAddress 2','9899739722','Praveen Bansal');

create table data.account
(
account_id bigint primary key,
client_id int references conf.client(client_id) not null,
client_account_number varchar(30) not null,
original_account_number varchar(30) not null,
assigned_balance numeric(13,3) not null,
current_balance numeric(13,3) not null,
created_by varchar(30),
created_on timestamp,
modified_by varchar(30),
modified_on timestamp
);

ALTER TABLE data.account
ADD CONSTRAINT data_account_client UNIQUE (account_id, client_id);

insert into data.account(account_id,client_id,client_account_number,original_account_number,assigned_balance, current_balance)
values(1,1,'1234','5678',12345.00,12345.00);
insert into data.account(account_id,client_id,client_account_number,original_account_number,assigned_balance, current_balance)
values(2,1,'1235','5679',2341.00,2341.00);
insert into data.account(account_id,client_id,client_account_number,original_account_number,assigned_balance, current_balance)
values(3,1,'1236','5680',3341.00,3341.00);
insert into data.account(account_id,client_id,client_account_number,original_account_number,assigned_balance, current_balance)
values(4,1,'1237','5681',4341.00,4341.00);
insert into data.account(account_id,client_id,client_account_number,original_account_number,assigned_balance, current_balance)
values(5,1,'1238','5682',5341.00,5341.00);
insert into data.account(account_id,client_id,client_account_number,original_account_number,assigned_balance, current_balance)
values(6,1,'1239','5683',6341.00,6341.00);
insert into data.account(account_id,client_id,client_account_number,original_account_number,assigned_balance, current_balance)
values(7,1,'1240','5684',7341.00,7341.00);
insert into data.account(account_id,client_id,client_account_number,original_account_number,assigned_balance, current_balance)
values(8,1,'1241','5685',8341.00,8341.00);

insert into data.account(account_id,client_id,client_account_number,original_account_number,assigned_balance, current_balance)
values(9,2,'2234','6678',12345.00,12345.00);
insert into data.account(account_id,client_id,client_account_number,original_account_number,assigned_balance, current_balance)
values(10,2,'2235','6679',2341.00,2341.00);
insert into data.account(account_id,client_id,client_account_number,original_account_number,assigned_balance, current_balance)
values(11,2,'2236','6680',3341.00,3341.00);
insert into data.account(account_id,client_id,client_account_number,original_account_number,assigned_balance, current_balance)
values(12,2,'2237','6681',4341.00,4341.00);
insert into data.account(account_id,client_id,client_account_number,original_account_number,assigned_balance, current_balance)
values(13,2,'2238','6682',5341.00,5341.00);
insert into data.account(account_id,client_id,client_account_number,original_account_number,assigned_balance, current_balance)
values(14,2,'2239','6683',6341.00,6341.00);
insert into data.account(account_id,client_id,client_account_number,original_account_number,assigned_balance, current_balance)
values(15,2,'2240','6684',7341.00,7341.00);
insert into data.account(account_id,client_id,client_account_number,original_account_number,assigned_balance, current_balance)
values(16,2,'2241','6685',8341.00,8341.00);

create table data.consumer
(
	consumer_id bigint primary key,
	contact_type int not null,
	account_id bigint references data.account(account_id),
	client_account_number varchar(30),
	client_id int references conf.client(client_id),
	client_consumer_number varchar(30),
	first_name varchar(50) not null,
	last_name varchar(50),
	identification_number varchar(16),
	is_consent boolean default true,
	consentTime timestamp default current_timestamp,
	is_active boolean default true,
	dt_birth date, 
	created_by varchar(30),
	created_on timestamp,
	modified_by varchar(30),
	modified_on timestamp
)

insert into data.consumer(consumer_id, contact_type, account_id,client_account_number,client_id,client_consumer_number,first_name, last_name, identification_number,dt_birth)
values(1,1,1,1234,1,16781,'Praveen','Bansal','123456789','2000-10-10');
insert into data.consumer(consumer_id, contact_type, account_id,client_account_number,client_id,client_consumer_number,first_name, last_name, identification_number,dt_birth)
values(2,1,2,1235,1,16782,'Shobhit','Garg','223456789','2000-10-10');
insert into data.consumer(consumer_id, contact_type, account_id,client_account_number,client_id,client_consumer_number,first_name, last_name, identification_number,dt_birth)
values(3,1,3,1236,1,16783,'Rishabh','Sharma','323456789','2000-10-10');
insert into data.consumer(consumer_id, contact_type, account_id,client_account_number,client_id,client_consumer_number,first_name, last_name, identification_number,dt_birth)
values(4,1,4,1237,1,16784,'Dinesh','Gupta','423456789','2000-10-10');
insert into data.consumer(consumer_id, contact_type, account_id,client_account_number,client_id,client_consumer_number,first_name, last_name, identification_number,dt_birth)
values(5,1,5,1238,1,16785,'Tanvi','Aggarwal','523456789','2000-10-10');
insert into data.consumer(consumer_id, contact_type, account_id,client_account_number,client_id,client_consumer_number,first_name, last_name, identification_number,dt_birth)
values(6,1,6,1239,1,16786,'Raghav','Singh','623456789','2000-10-10');
insert into data.consumer(consumer_id, contact_type, account_id,client_account_number,client_id,client_consumer_number,first_name, last_name, identification_number,dt_birth)
values(7,1,7,1240,1,16787,'Divya','Sharma','723456789','2000-10-10');
insert into data.consumer(consumer_id, contact_type, account_id,client_account_number,client_id,client_consumer_number,first_name, last_name, identification_number,dt_birth)
values(8,1,8,1241,1,16788,'Priti','Agnani','823456789','2000-10-10');
insert into data.consumer(consumer_id, contact_type, account_id,client_account_number,client_id,client_consumer_number,first_name, last_name, identification_number,dt_birth)
values(9,1,9,2234,2,16789,'Ashish','Chaturvedi','923456789','2000-10-10');
insert into data.consumer(consumer_id, contact_type, account_id,client_account_number,client_id,client_consumer_number,first_name, last_name, identification_number,dt_birth)
values(10,1,10,2235,2,16790,'Bharath','','113456789','2000-10-10');
insert into data.consumer(consumer_id, contact_type, account_id,client_account_number,client_id,client_consumer_number,first_name, last_name, identification_number,dt_birth)
values(11,1,11,2235,2,16791,'Rutwik','Patel','133456789','2000-10-10');
insert into data.consumer(consumer_id, contact_type, account_id,client_account_number,client_id,client_consumer_number,first_name, last_name, identification_number,dt_birth)
values(12,1,12,2237,2,16792,'Mohit','Mathur','143456789','2000-10-10');
insert into data.consumer(consumer_id, contact_type, account_id,client_account_number,client_id,client_consumer_number,first_name, last_name, identification_number,dt_birth)
values(13,1,13,2238,2,16793,'Suhas','Giniswamy','153456789','2000-10-10');
insert into data.consumer(consumer_id, contact_type, account_id,client_account_number,client_id,client_consumer_number,first_name, last_name, identification_number,dt_birth)
values(14,1,14,2239,2,16794,'Aakash','Behal','163456789','2000-10-10');
insert into data.consumer(consumer_id, contact_type, account_id,client_account_number,client_id,client_consumer_number,first_name, last_name, identification_number,dt_birth)
values(15,1,15,2240,2,16795,'Arsad','Hussain','173456789','2000-10-10');
insert into data.consumer(consumer_id, contact_type, account_id,client_account_number,client_id,client_consumer_number,first_name, last_name, identification_number,dt_birth)
values(16,1,16,2241,2,16796,'Ratneswar','Singh','183456789','2000-10-10');

create table data.phone(
phone_id bigint primary key,
account_id bigint references data.account(account_id),
client_id int references conf.client(client_id),
client_account_number varchar(30),
client_consumer_number varchar(30),
phone_num varchar(15),
is_active boolean default true,
is_consented boolean default true
)

alter table data.consumer add dt_birth date;

update data.consumer set dt_birth='2000-10-10'

create table data.payment_plan
(
payment_plan_id bigint primary key generated always as identity,
account_id bigint references data.account(account_id),
client_id int,
client_account_number varchar(30),
pct_discount decimal(5,2),
no_of_months smallint,
dt_settlement date,
amt_settlement decimal(13,3),
payment_plan_status varchar(15),
created_by varchar(30),
created_on timestamp,
modified_by varchar(30),
modified_on timestamp
);

insert into data.payment_plan
(account_id,client_id,client_account_number,pct_discount,no_of_months,dt_settlement,amt_settlement,payment_plan_status,created_by,created_on,modified_by,modified_on)
values
(1,1,'1234',12.34,6,'2026-10-10',3450.50,'Active','Ranjan',current_timestamp,'Ranjan',current_timestamp),
(2,1,'1235',12,3,'2026-10-10',3450.50,'Active','Ranjan',current_timestamp,'Ranjan',current_timestamp),
(3,1,'1236',15,9,'2026-10-10',3450.50,'Voided','Ranjan',current_timestamp,'Ranjan',current_timestamp),
(3,1,'1236',20,12,'2026-10-10',3450.50,'Active','Ranjan',current_timestamp,'Ranjan',current_timestamp),
(4,1,'1237',25,12,'2026-10-10',3450.50,'Active','Ranjan',current_timestamp,'Ranjan',current_timestamp),
(5,1,'1238',22.50,24,'2026-10-10',3450.50,'Active','Ranjan',current_timestamp,'Ranjan',current_timestamp),
(6,1,'1239',40,18,'2026-10-10',3450.50,'Voided','Ranjan',current_timestamp,'Ranjan',current_timestamp),
(6,1,'1239',42.5,36,'2026-10-10',3450.50,'Active','Ranjan',current_timestamp,'Ranjan',current_timestamp),
(7,1,'1240',35,30,'2026-10-10',3450.50,'Voided','Ranjan',current_timestamp,'Ranjan',current_timestamp),
(7,1,'1240',32.5,12,'2026-10-10',3450.50,'Active','Ranjan',current_timestamp,'Ranjan',current_timestamp),
(8,1,'1241',33,18,'2026-10-10',3450.50,'Active','Ranjan',current_timestamp,'Ranjan',current_timestamp),
(9,2,'2234',28,24,'2026-10-10',3450.50,'Active','Ranjan',current_timestamp,'Ranjan',current_timestamp),
(10,2,'2235',27,12,'2026-10-10',3450.50,'Active','Ranjan',current_timestamp,'Ranjan',current_timestamp),
(12,2,'2237',15,5,'2026-10-10',3450.50,'Voided','Ranjan',current_timestamp,'Ranjan',current_timestamp),
(12,2,'2237',18,18,'2026-10-10',3450.50,'Active','Ranjan',current_timestamp,'Ranjan',current_timestamp),
(13,2,'2238',32,6,'2026-10-10',3450.50,'Active','Ranjan',current_timestamp,'Ranjan',current_timestamp),
(14,2,'2239',36,12,'2026-10-10',3450.50,'Active','Ranjan',current_timestamp,'Ranjan',current_timestamp),
(15,2,'2240',36.5,18,'2026-10-10',3450.50,'Voided','Ranjan',current_timestamp,'Ranjan',current_timestamp),
(15,2,'2240',41.50,24,'2026-10-10',3450.50,'Active','Ranjan',current_timestamp,'Ranjan',current_timestamp),
(16,2,'2241',19,36,'2026-10-10',3450.50,'Active','Ranjan',current_timestamp,'Ranjan',current_timestamp);

create table data.payment
(
payment_id bigint primary key generated always as identity,
account_id bigint references data.account(account_id),
client_id int,
client_account_number varchar(30),
amt_payment decimal(13,3),
dt_payment date,
pmt_status varchar(15),
amt_remaining decimal(13,3),
payment_plan_id bigint references data.payment_plan(payment_plan_id),
dt_void date,
pmt_method varchar(15),
created_by varchar(30),
created_on timestamp,
modified_by varchar(30),
modified_on timestamp
);

insert into data.payment(account_id, client_id, client_account_number, amt_payment, dt_payment, pmt_status, amt_remaining, payment_plan_id, dt_void, pmt_method, created_by, created_on, modified_by, modified_on)
values
(1,1,'1234', 100, '2026-01-01', 'settled', 9900,1,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(1,1,'1234', 100, '2026-02-01', 'settled', 9800,1,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(1,1,'1234', 100, '2026-03-01', 'settled', 9700,1,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(1,1,'1234', 100, '2026-04-01', 'settled', 9600,1,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(1,1,'1234', 100, '2026-05-01', 'settled', 9500,1,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(1,1,'1234', 100, '2026-06-01', 'settled', 9400,1,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp);

insert into data.payment(account_id, client_id, client_account_number, amt_payment, dt_payment, pmt_status, amt_remaining, payment_plan_id, dt_void, pmt_method, created_by, created_on, modified_by, modified_on)
values
(2,1,'1235', 200, '2025-01-01', 'settled', 9800,2,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(2,1,'1235', 200, '2025-02-01', 'settled', 9600,2,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(2,1,'1235', 200, '2025-03-01', 'settled', 9400,2,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(2,1,'1235', 200, '2025-04-01', 'settled', 9200,2,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(2,1,'1235', 200, '2025-05-01', 'settled', 9000,2,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(2,1,'1235', 200, '2025-06-01', 'settled', 8800,2,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp);

insert into data.payment(account_id, client_id, client_account_number, amt_payment, dt_payment, pmt_status, amt_remaining, payment_plan_id, dt_void, pmt_method, created_by, created_on, modified_by, modified_on)
values
(3,1,'1236', 500, '2025-07-01', 'settled', 9500,4,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(3,1,'1236', 500, '2025-08-01', 'settled', 9000,4,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(3,1,'1236', 500, '2025-09-01', 'settled', 8500,4,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(3,1,'1236', 500, '2025-10-01', 'settled', 8000,4,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(3,1,'1236', 500, '2025-11-01', 'settled', 7500,4,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(3,1,'1236', 500, '2025-12-01', 'settled', 7000,4,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp);

insert into data.payment(account_id, client_id, client_account_number, amt_payment, dt_payment, pmt_status, amt_remaining, payment_plan_id, dt_void, pmt_method, created_by, created_on, modified_by, modified_on)
values
(4,1,'1237', 1000, '2025-01-01', 'settled', 9800,5,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(4,1,'1237', 1000, '2025-02-01', 'settled', 9600,5,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(4,1,'1237', 1000, '2025-03-01', 'settled', 9400,5,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(4,1,'1237', 1000, '2025-04-01', 'settled', 9200,5,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(4,1,'1237', 1000, '2025-05-01', 'settled', 9000,5,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(4,1,'1237', 1000, '2025-06-01', 'settled', 8800,5,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp);

insert into data.payment(account_id, client_id, client_account_number, amt_payment, dt_payment, pmt_status, amt_remaining, payment_plan_id, dt_void, pmt_method, created_by, created_on, modified_by, modified_on)
values
(5,1,'1238', 250, '2025-01-01', 'settled', 9750,6,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(5,1,'1238', 250, '2025-02-01', 'settled', 9500,6,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(5,1,'1238', 250, '2025-03-01', 'settled', 9250,6,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(5,1,'1238', 250, '2025-04-01', 'settled', 9000,6,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(5,1,'1238', 250, '2025-05-01', 'settled', 8750,6,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(5,1,'1238', 250, '2025-06-01', 'settled', 8500,6,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp);

insert into data.payment(account_id, client_id, client_account_number, amt_payment, dt_payment, pmt_status, amt_remaining, payment_plan_id, dt_void, pmt_method, created_by, created_on, modified_by, modified_on)
values
(6,1,'1239', 300, '2025-07-01', 'settled', 9700,8,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(6,1,'1239', 300, '2025-08-01', 'settled', 9400,8,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(6,1,'1239', 300, '2025-09-01', 'settled', 9100,8,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(6,1,'1239', 300, '2025-10-01', 'settled', 8800,8,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(6,1,'1239', 300, '2025-11-01', 'settled', 8500,8,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(6,1,'1239', 300, '2025-12-01', 'settled', 8200,8,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp);

insert into data.payment(account_id, client_id, client_account_number, amt_payment, dt_payment, pmt_status, amt_remaining, payment_plan_id, dt_void, pmt_method, created_by, created_on, modified_by, modified_on)
values
(7,1,'1240', 400, '2025-07-01', 'settled', 9600,10,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(7,1,'1240', 400, '2025-08-01', 'settled', 9200,10,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(7,1,'1240', 400, '2025-09-01', 'settled', 8800,10,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(7,1,'1240', 400, '2025-10-01', 'settled', 8400,10,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(7,1,'1240', 400, '2025-11-01', 'settled', 8000,10,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(7,1,'1240', 400, '2025-12-01', 'settled', 7800,10,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp);

insert into data.payment(account_id, client_id, client_account_number, amt_payment, dt_payment, pmt_status, amt_remaining, payment_plan_id, dt_void, pmt_method, created_by, created_on, modified_by, modified_on)
values
(8,1,'1241', 400, '2025-07-01', 'settled', 9600,11,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(8,1,'1241', 400, '2025-08-01', 'settled', 9200,11,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(8,1,'1241', 400, '2025-09-01', 'settled', 8800,11,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(8,1,'1241', 400, '2025-10-01', 'settled', 8400,11,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(8,1,'1241', 400, '2025-11-01', 'settled', 8000,11,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(8,1,'1241', 400, '2025-12-01', 'settled', 7800,11,null,'CreditCard','Ranjan', current_timestamp, 'Ranjan', current_timestamp);

insert into data.payment(account_id, client_id, client_account_number, amt_payment, dt_payment, pmt_status, amt_remaining, payment_plan_id, dt_void, pmt_method, created_by, created_on, modified_by, modified_on)
values
(9,2,'2234', 1000, '2025-07-01', 'settled', 9000,12,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(9,2,'2234', 1000, '2025-08-01', 'settled', 8000,12,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(9,2,'2234', 1000, '2025-09-01', 'settled', 7000,12,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(9,2,'2234', 1000, '2025-10-01', 'settled', 6000,12,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(9,2,'2234', 1000, '2025-11-01', 'settled', 5000,12,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(9,2,'2234', 1000, '2025-12-01', 'settled', 4000,12,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp);

insert into data.payment(account_id, client_id, client_account_number, amt_payment, dt_payment, pmt_status, amt_remaining, payment_plan_id, dt_void, pmt_method, created_by, created_on, modified_by, modified_on)
values
(10,2,'2235', 400, '2026-07-01', 'settled', 9600,13,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(10,2,'2235', 400, '2026-08-01', 'settled', 9200,13,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(10,2,'2235', 400, '2026-09-01', 'settled', 8800,13,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(10,2,'2235', 400, '2026-10-01', 'settled', 8400,13,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(10,2,'2235', 400, '2026-11-01', 'settled', 8000,13,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(10,2,'2235', 400, '2026-12-01', 'settled', 7800,13,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp);

insert into data.payment(account_id, client_id, client_account_number, amt_payment, dt_payment, pmt_status, amt_remaining, payment_plan_id, dt_void, pmt_method, created_by, created_on, modified_by, modified_on)
values
(13,2,'2237', 400, '2026-07-01', 'settled', 9600,16,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(13,2,'2237', 400, '2026-08-01', 'settled', 9200,16,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(13,2,'2237', 400, '2026-09-01', 'settled', 8800,16,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(13,2,'2237', 400, '2026-10-01', 'settled', 8400,16,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(13,2,'2237', 400, '2026-11-01', 'settled', 8000,16,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(13,2,'2237', 400, '2026-12-01', 'settled', 7800,16,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp);

insert into data.payment(account_id, client_id, client_account_number, amt_payment, dt_payment, pmt_status, amt_remaining, payment_plan_id, dt_void, pmt_method, created_by, created_on, modified_by, modified_on)
values
(14,2,'2238', 300, '2026-07-01', 'settled', 9700,17,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(14,2,'2238', 300, '2026-08-01', 'settled', 9400,17,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(14,2,'2238', 300, '2026-09-01', 'settled', 9100,17,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(14,2,'2238', 300, '2026-10-01', 'settled', 8800,17,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(14,2,'2238', 300, '2026-11-01', 'settled', 8500,17,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(14,2,'2238', 300, '2026-12-01', 'settled', 8200,17,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp);

insert into data.payment(account_id, client_id, client_account_number, amt_payment, dt_payment, pmt_status, amt_remaining, payment_plan_id, dt_void, pmt_method, created_by, created_on, modified_by, modified_on)
values
(15,2,'2240', 500, '2025-07-01', 'settled', 9500,19,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(15,2,'2240', 500, '2025-08-01', 'settled', 9000,19,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(15,2,'2240', 500, '2025-09-01', 'settled', 8500,19,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(15,2,'2240', 500, '2025-10-01', 'settled', 8000,19,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(15,2,'2240', 500, '2025-11-01', 'settled', 7500,19,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp),
(15,2,'2240', 500, '2025-12-01', 'settled', 7000,19,null,'ACH','Ranjan', current_timestamp, 'Ranjan', current_timestamp);

create table data.account_score
(
account_score_id bigint primary key generated always as identity,
account_id bigint references data.account(account_id),
account_score int,
source varchar(15),
created_by varchar(30),
created_on timestamp,
modified_by varchar(30),
modified_on timestamp
);

insert into data.account_score(account_id,account_score, source, created_by, created_on, modified_by, modified_on)
values
(1, 655, 'Experian','ranjan', current_timestamp, 'ranjan', current_timestamp),
(2, 785, 'Experian','ranjan', current_timestamp, 'ranjan', current_timestamp),
(3, 355, 'Experian','ranjan', current_timestamp, 'ranjan', current_timestamp),
(4, 455, 'Experian','ranjan', current_timestamp, 'ranjan', current_timestamp),
(5, 755, 'Experian','ranjan', current_timestamp, 'ranjan', current_timestamp),
(6, 455, 'Experian','ranjan', current_timestamp, 'ranjan', current_timestamp),
(7, 345, 'Experian','ranjan', current_timestamp, 'ranjan', current_timestamp),
(8, 535, 'Experian','ranjan', current_timestamp, 'ranjan', current_timestamp),
(9, 455, 'Experian','ranjan', current_timestamp, 'ranjan', current_timestamp),
(10, 355, 'Experian','ranjan', current_timestamp, 'ranjan', current_timestamp),
(11, 725, 'Experian','ranjan', current_timestamp, 'ranjan', current_timestamp),
(12, 100, 'Experian','ranjan', current_timestamp, 'ranjan', current_timestamp),
(13, 234, 'Experian','ranjan', current_timestamp, 'ranjan', current_timestamp),
(14, 435, 'Experian','ranjan', current_timestamp, 'ranjan', current_timestamp),
(15, 344, 'Experian','ranjan', current_timestamp, 'ranjan', current_timestamp),
(16, 256, 'Experian','ranjan', current_timestamp, 'ranjan', current_timestamp);

create table data.system_offer(
system_offer_id bigint primary key generated always as identity,
account_id bigint references data.account(account_id),
number_of_month smallint,
discount_percentage decimal(6,2),
is_active bool default true,
created_by varchar(30),
created_on timestamp,
modified_by varchar(30),
modified_on timestamp
);

insert into data.system_offer(account_id, number_of_month, discount_percentage, created_by, created_on, modified_by, modified_on)
select account_id, 2, 40, 'ranjan', current_timestamp, 'ranjan', current_timestamp from data.account_score where account_score<400;
insert into data.system_offer(account_id, number_of_month, discount_percentage, created_by, created_on, modified_by, modified_on)
select account_id, 12, 30, 'ranjan', current_timestamp, 'ranjan', current_timestamp from data.account_score where account_score<400;
insert into data.system_offer(account_id, number_of_month, discount_percentage, created_by, created_on, modified_by, modified_on)
select account_id, 3, 35, 'ranjan', current_timestamp, 'ranjan', current_timestamp from data.account_score where account_score>=400 and account_score<550;
insert into data.system_offer(account_id, number_of_month, discount_percentage, created_by, created_on, modified_by, modified_on)
select account_id, 6, 25, 'ranjan', current_timestamp, 'ranjan', current_timestamp from data.account_score where account_score>=400 and account_score<550;
insert into data.system_offer(account_id, number_of_month, discount_percentage, created_by, created_on, modified_by, modified_on)
select account_id, 6, 30, 'ranjan', current_timestamp, 'ranjan', current_timestamp from data.account_score where account_score>=550;
insert into data.system_offer(account_id, number_of_month, discount_percentage, created_by, created_on, modified_by, modified_on)
select account_id, 12, 20, 'ranjan', current_timestamp, 'ranjan', current_timestamp from data.account_score where account_score>=550;