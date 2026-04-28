create database hacathon1;
use hacathon1;
create table Zones (
zone_id varchar(5) primary key not null unique,
zone_name VARCHAR(100) not null,
area_square_meters DECIMAL(10,2) not null,
light_condition VARCHAR(50) not null check (light_condition='Full Sun' or light_condition='Partial Shade' or light_condition='Shade'),

status VARCHAR(20) not null check (status='Available' or status='Occupied' or status='Maintenance')
);

create table Crops(
 crop_id varchar(5) not null primary  key unique,
 crop_name varchar(100) not null unique,
 growth_time_days int not null ,
 water_requirement varchar(50) not null check(water_requirement='Low' or water_requirement='Medium' or water_requirement='High'),
 expected_yield decimal(10,2) not null 

);
create table Planting_Logs(
log_id int primary key not null auto_increment,
zone_id varchar(5) not null ,
foreign key(zone_id)references Zones(zone_id),
crop_id varchar(5) not null,
foreign key (crop_id)references Crops(crop_id),
unique(zone_id,crop_id),
planting_date date not null ,
last_watered datetime ,
is_automated boolean not null  
);
create table Harvests(
 harvest_id int primary key not null auto_increment,
 log_id int not null ,
 foreign key (log_id) references Planting_Logs(log_id),
 harvest_date date not null,
 actual_yield decimal(10,2) not null ,
 quality_grade varchar(10) not null check(quality_grade='A' or quality_grade='B' or quality_grade='C')
);
-- 3
insert into Crops
values
('C01', 'Xà lách thủy tinh', 45, 'High', 2.5),
('C02', 'Cà chua Cherry', 90, 'Medium', 5.0),
('C03', 'Cải bó xôi', 35, 'High', 1.8),
('C04', 'Dưa lưới Nhật', 85, 'Medium', 4.0),
('C05', 'Ớt chuông', 110, 'Medium', 3.5);

insert into Zones(zone_id,zone_name,area_square_meters,light_condition,status)
values
('Z01', 'Khu nhà màng 01', 50.5, 'Full Sun', 'Occupied'),
('Z02', 'Khu thủy canh 02', 30, 'Partial Shade', 'Occupied'),
('Z03', 'Vườn rau gia vị', 15, 'Full Sun', 'Available'),
('Z04', 'Nhà kính trung tâm', 100, 'Full Sun', 'Occupied'),
('Z05', 'Khu thực nghiệm', 25, 'Shade', 'Maintenance');


insert into Planting_Logs
values
(1, 'Z01', 'C02', '2025-10-01', '2025-11-10 08:00:00', 1),
(2, 'Z02', 'C01', '2025-11-05', '2025-11-10 17:30:00', 1),

(3, 'Z01', 'C03', '2025-11-08', NULL, 0),

(4, 'Z04', 'C04', '2025-09-15', '2025-11-11 09:00:00', 1),

(5, 'Z04', 'C05', '2025-11-01', '2025-11-11 10:00:00', 1);
insert into Harvests(harvest_id,log_id,harvest_date,actual_yield,quality_grade)
values
(1, 1, '2025-12-30', 250.0, 'A'),
(2, 4, '2025-12-10', 380.5, 'A'),
(3, 3, '2025-11-25', 65.0, 'B'),
(4, 2, '2025-12-20', 0.0, 'C');
-- 4
update Crops
set expected_yield=expected_yield*1.1
where crop_id='C01';
-- 5
update Zones
set status='Maintenance'
where zone_id='Z03';
-- 6
set sql_safe_updates=0;
delete  from Harvests
where actual_yield=0 or quality_grade='C';
-- 7
alter table Zones
modify column area_square_meters decimal(10,2) not null check(area_square_meters>0);
-- 8
alter table Planting_Logs 
alter column is_automated set default 1;
-- 9
alter table Crops
add column fertilizer_type VARCHAR(50);
-- 10
select *
from Crops
where growth_time_days<50;
-- 11
select zone_name ,area_square_meters 
from Zones
where light_condition='Full Sun';
-- 12
select  crop_name, expected_yield
from Crops
order by expected_yield desc;
 -- 13
select*
from Planting_Logs
order by planting_date desc
limit 3;
-- 14
select zone_name, status
from Zones 
limit 2 
offset 1;
-- 115
update Planting_Logs
set last_watered = current_timestamp
where is_automated=1;
-- 16
update Crops 
set crop_name=upper(crop_name);
-- 17
delete from Zones
where status='Maintenance';
-- 18
select  P.log_id, Z.zone_name, C.crop_name, P.planting_date
from Planting_Logs P
join Crops C on P.crop_id=C.crop_id
join Zones Z on P.zone_id=Z.zone_id
where status='Occupied';
-- 19
select Z.zone_name,count(P.log_id) as total
from Zones Z
left join Planting_Logs P on Z.zone_id=P.zone_id
group by Z.zone_name;
-- 20
select crop_name,sum(actual_yield) as total_actual
from Planting_Logs P
join Crops C on P.crop_id=C.crop_id
join Harvests H on P.log_id=H.log_id
group by C.crop_name;
-- 22
select crop_name,expected_yield
from Crops
where expected_yield>(select avg(expected_yield)from Crops);
-- 23
select distinct Z.zone_name
from Planting_Logs P
join Zones Z on P.zone_id=Z.zone_id
join Crops C on P.crop_id=C.crop_id
where C.crop_name='Cà chua Cherry'and Z.status='Occupied';