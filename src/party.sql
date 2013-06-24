create table party
(
    id integer not null primary key,
    karma integer not null default 300,
    karmavariance integer not null default 100,
    sentient integer not null default 0,
    members integer not null default (4 + (random() % 3))
);

create table pcharacter
(
    paid integer not null,
    cid integer not null,

    primary key (paid, cid),

    foreign key (paid) references party(id),
    foreign key (cid) references character(id)
);

create trigger partyInsert after insert on party
for each row begin
    insert into vpartymember
        (paid, karma, sentient)
        select new.id as paid,
               new.karma + (random() % new.karmavariance) as karma,
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

create view vplaceparty as
select
    null as paid;

create view vplacepartycharacter as
select
    null as paid,
    null as cid;

create trigger vplacepartyInsert instead of insert on vplaceparty
for each row begin
    insert into vplacepartycharacter
        (paid, cid)
        select paid, cid
          from pcharacter
         where paid = new.paid;
end;

create trigger vplacepartycharacterInsert instead of insert on vplacepartycharacter
for each row begin
    update board
       set cid = new.cid
     where id = (select board.id
                   from board, tile
                  where cid is null
                    and board.tid = tile.id
                    and not tile.opaque
                  order by random()
                  limit 1);
end;
