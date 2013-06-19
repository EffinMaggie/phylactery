create table party
(
    id integer not null primary key
);

create table pcharacter
(
    paid integer not null,
    cid integer not null,

    primary key (paid, cid),

    foreign key (paid) references party(id),
    foreign key (cid) references character(id)
);

create view vparty as
select
    null as members,
    null as karma,
    null as sentient;

create trigger vpartyInsert instead of insert on vparty
for each row begin
    insert into party
        (id)
        values
        (null);

    insert into vpartymember
        (paid, karma, sentient)
        select last_insert_rowid() as paid,
               new.karma as karma,
               new.sentient as sentient
          from seq8
         where seq8.b < new.members;
end;

create view vpartymember as
select
    null as paid,
    null as karma,
    null as sentient;

create trigger vpartymemberInsert instead of insert on vpartymember
for each row begin
    insert into character
        (karma, sentient)
        values
        (new.karma, new.sentient);

    insert into pcharacter
        (paid, cid)
        values
        (new.paid, last_insert_rowid());
end;
