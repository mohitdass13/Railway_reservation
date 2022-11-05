DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
     
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;

Create table trains(train_no  int  primary key Not Null);

create table bookingsystem(
train_no int,
doj date not null, 
AC int not null,
SL int not null,
AC_seat_count int not null check(AC_seat_count >=0),
SL_seat_count int not null check(SL_seat_count >=0),
primary key(train_no,doj), 
foreign key(train_no) references trains(train_no)
);

create table ticket(
train_no int not null,
doj date not null,
pass_no int not null,
pnr varchar(20),
names varchar[],
age int[],
gender varchar[],
coach_no int[],
coach_type varchar[],
birth_no int[],
birth_type varchar[],
primary key(pnr),
foreign key(train_no,doj) references bookingsystem(train_no,doj));



create or replace procedure insert_train(train_no int)
language plpgsql
as $$

begin

insert into trains values(train_no);

end;
$$;



create or replace procedure create_table(in t_name varchar)
language plpgsql as
$$

declare

begin
EXECUTE format('create table %s(train_no int,
doj date,
coach_no int not null,
coach_type varchar(2) not null ,
birth_no int not null,
birth_type varchar(2) not null ,
stat varchar(2) not null ,
primary key(train_no,doj,coach_no,coach_type,birth_no),
foreign key(train_no,doj) references bookingsystem(train_no,doj));
',t_name);

end;
$$;


create or replace procedure fill_table(in ac_tabname varchar,in sl_tabname varchar,in trainno int,in doj date,in ac int,in sl int)
language plpgsql
as $$

declare
ac_type varchar[][] := ARRAY['LB', 'UB', 'LB', 'UB', 'SL', 'SU'];
sl_type varchar[][] := ARRAY['LB', 'MB', 'UB', 'LB', 'MB', 'UB', 'SL', 'SU'];
temp1 varchar :='';

begin

call create_table(ac_tabname);
call create_table(sl_tabname);
insert into bookingsystem values(trainno,doj,ac,sl,18*ac,24*sl);
for c in 1..ac ,
loop
for b in 1..18
loop
temp1=ac_type[b%6+1];
EXECUTE format ('insert into %s values($1,$2,$3,$4,$5,$6,$7)',ac_tabname) using trainno,doj,c,'AC',b,temp1,'E';
end loop;
end loop;

for c2 in 1..sl 
loop
for b2 in 1..24
loop
temp1=sl_type[b2%8+1];
EXECUTE format ('insert into %s values($1,$2,$3,$4,$5,$6,$7)',sl_tabname) using trainno,doj,c2,'SL',b2,temp1,'E';
end loop;
end loop;

end;
$$;


create or replace function release_train(in trainno int ,in dat date  ,in ac int,   in sl int)
returns void language plpgsql AS $$
declare
flag int default 0;
temp record;
t_name1 varchar(30);
t_name2 varchar(30);
begin
for temp in select * from bookingsystem
loop

if temp.trainno=trainno and temp.doj=dat then flag=1;
end if;

end loop;

if flag=0 then 
insert into bookingsystem values(trainno,dat,ac,sl);
end if;

end;
$$;







