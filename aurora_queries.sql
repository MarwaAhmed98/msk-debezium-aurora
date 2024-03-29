--create new user for debezium
create user 'debezium'@'%' identified by 'debezium-user';

--grant privileges to user
grant select, reload, show databases, replication slave,
replication client on *.* to 'debezium'@'%';
grant lock tables on *.* to 'debezium'@'%';
flush privileges;

--check privileges were applied to user
show grants for 'debezium';

--confirm binary logging is enabled
select variable_value as "binary logging status (log-bin) ::"
from performance_schema.global_variables where variable_name='log_bin';


--create database and switch to it
create database if not exists raw_tickets;
use raw_tickets;

--creat initial schema of table
create table sporting_event (
  --op varchar(10), -- no longer needed since the pipeline is active now
  cdc_timestamp timestamp,
  id bigint,
  sport_type_name varchar(1024), 
  home_team_id int,
  away_team_id int,
  location_id smallint,
  start_date_time timestamp,
  start_date date,
  sold_out smallint
);

--test adding new rows with null values for certain columns
insert into sporting_event (cdc_timestamp, id,sport_type_name,home_team_id,away_team_id,start_date_time,start_date,sold_out)
values 
('2022-09-21 16:54:15.690393',111,'baseball',1,121,'2022-06-19 00:00:00.000000','2022-06-19',0);

--test new inserts
insert into sporting_event (op, cdc_timestamp, id,sport_type_name,home_team_id,away_team_id,location_id,start_date_time,start_date,sold_out)
values 
('I','2022-09-21 16:54:15.690383',91,'baseball',1,101,5,'2022-06-05 00:00:00.000000', '2022-06-05',0),
('I','2022-09-21 16:54:15.690388',101,'baseball',1,111,5,'2022-06-12 00:00:00.000000','2022-06-12',0),
('I','2022-09-21 16:54:15.690410',141,'baseball',1,151,5,'2022-07-10 00:00:00.000000','2022-07-10',0),
('I','2022-09-21 16:54:15.690415',151,'baseball',1,161,5,'2022-07-17 00:00:00.000000','2022-07-17',0),
('I','2022-09-21 16:54:15.690420',161,'baseball',1,171,5,'2022-07-24 00:00:00.000000','2022-07-24',0);

insert into sporting_event (op, cdc_timestamp, id,sport_type_name,home_team_id,away_team_id,location_id,start_date_time,start_date,sold_out)
values 
('I','2022-09-21 16:54:15.690426',171,'baseball',1,181,5,'2022-07-31 00:00:00.000000','2022-07-31',0),
('I','2022-09-21 16:54:15.690431',181,'baseball',1,191,5,'2022-08-07 00:00:00.000000','2022-08-07',0),
('I','2022-09-21 16:54:15.690436',191,'baseball',1,201,5,'2022-08-14 00:00:00.000000','2022-08-14',0),
('I','2022-09-21 16:54:15.690442',201,'baseball',1,211,5,'2022-08-21 00:00:00.000000','2022-08-21',0),
('I','2022-09-21 16:54:15.690447',211,'baseball',1,221,5,'2022-08-28 00:00:00.000000','2022-08-28',0),
('I','2022-09-21 16:54:15.690453',221,'baseball',1,231,5,'2022-09-04 00:00:00.000000','2022-09-04',0),
('I','2022-09-21 16:54:15.690458',231,'baseball',1,241,5,'2022-09-11 00:00:00.000000','2022-09-11',0),
('I','2022-09-21 16:54:15.690463',241,'baseball',1,251,5,'2022-09-18 00:00:00.000000','2022-09-18',0),
('I','2022-09-21 16:54:15.690469',251,'baseball',1,261,5,'2022-09-25 00:00:00.000000','2022-09-25',0),
('I','2022-09-21 16:54:15.690474',261,'baseball',1,271,5,'2022-10-02 00:00:00.000000','2022-10-02',0),
('I','2022-09-21 16:54:15.690480',271,'baseball',1,281,5,'2022-10-09 00:00:00.000000','2022-10-09',0),
('I','2022-09-21 16:54:15.690485',281,'baseball',1,291,5,'2022-10-16 00:00:00.000000','2022-10-16',0),
('I','2022-09-21 16:54:15.690491',291,'baseball',11,21,7,'2022-04-03 00:00:00.000000','2022-04-03',0),
('I','2022-09-21 16:54:15.690496',301,'baseball',11,31,7,'2022-04-10 00:00:00.000000','2022-04-10',0),
('I','2022-09-21 16:54:15.690502',311,'baseball',11,41,7,'2022-04-17 00:00:00.000000','2022-04-17',0),
('I','2022-09-21 16:54:15.690507',321,'baseball',11,51,7,'2022-04-24 00:00:00.000000','2022-04-24',0),
('I','2022-09-21 16:54:15.690513',331,'baseball',11,61,7,'2022-05-01 00:00:00.000000','2022-05-01',0),
('I','2022-09-21 16:54:15.690518',341,'baseball',11,71,7,'2022-05-08 00:00:00.000000','2022-05-08',0),
('I','2022-09-21 16:54:15.690523',351,'baseball',11,81,7,'2022-05-15 00:00:00.000000','2022-05-15',0),
('I','2022-09-21 16:54:15.690529',361,'baseball',11,91,7,'2022-05-22 00:00:00.000000','2022-05-22',0);


--schema evolution 
alter table sporting_event add ticket_status varchar(20);

--test inserts with new schema
insert into sporting_event (cdc_timestamp, id,sport_type_name,home_team_id,away_team_id,location_id,start_date_time,start_date,sold_out, ticket_status)
values 
('2022-09-21 16:54:15.690741',691,'baseball',21,141,27,'2022-06-19 00:00:00.000000','2022-06-19',1,'on hold'),
('2022-09-21 16:54:15.690747',701,'baseball',21,151,27,'2022-06-26 00:00:00.000000','2022-06-26',1,'on hold'),
('2022-09-21 16:54:15.690752',711,'baseball',21,161,27,'2022-07-03 00:00:00.000000','2022-07-03',1,'sold out'),
('2022-09-21 16:54:15.690758',721,'baseball',21,171,27,'2022-07-10 00:00:00.000000','2022-07-10',1,'on hold'),
('2022-09-21 16:54:15.690763',731,'baseball',21,181,27,'2022-07-17 00:00:00.000000','2022-07-17',0,'available');

--test updates
update sporting_event 
set sold_out=1 
where id=91;

--test deletes
delete from sporting_event where id=141