create database bikeSales;
create table brands(
brand_id int primary key,
brand_name varchar(50)
);

create table categories(
category_id int,
category_name varchar(100),
primary key(category_id));

create table products(
product_id int not null,
product_name varchar(100) not null,
brand_id int not null,
category_id int not null,
model_year int not null,
list_price float not null,
primary key(product_id));

create table stocks(
store_id int not null,
product_id int not null,
quantity int not null,
foreign key(store_id) references stores(store_id),
foreign key (product_id) references products(product_id));

create table staffs(
staff_id int not null,
first_name varchar(100) not null,
last_name varchar(100) not null,
email varchar(100) not null,
phone text not null,
active int not null,
store_id int not null,
manager_id int ,
primary key(staff_id),
foreign key (store_id) references stores(store_id));

create table orders(
order_id int not null,
customer_id int,
order_status int not null,
order_date date not null,
required_date date not null,
shipped_date date,
store_id int not null,
staff_id int not null,
primary key(order_id),
foreign key(store_id) references stores(store_id),
foreign key(customer_id) references customers(customer_id),
foreign key (staff_id) references staffs(staff_id));


create table order_items(
order_id int not null,
item_id int not null,
product_id int not null,
quantity int not null,
list_price float not null,
discount float not null,
foreign key(order_id) references orders(order_id),
foreign key (product_id) references products(product_id));


