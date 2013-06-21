create table corporation
(
    id integer not null primary key,
    name text null,
    founders integer null,
    foundingyear integer not null default (2020 + (abs(random()) % 40)),
    founderkarma integer not null default 100,
    networth integer null
);

create table trade
(
    id integer not null,
    name text not null primary key
);

create table cofunction
(
    id integer not null,
    description text not null
);

create table costaff
(
    coid integer not null,
    cid integer not null,
    cofid integer not null,

    primary key (coid, cid),

    foreign key (coid) references corporation(id),
    foreign key (cid) references character(id),
    foreign key (cofid) references cofunction(id)
);

create table cotrade
(
    coid integer not null,
    baid integer not null,

    primary key (coid, baid),

    foreign key (coid) references corporation(id),
    foreign key (baid) references trade(id)
);

insert into cofunction
    (id, description)
    values
    (1, 'Founder')
;

insert into trade
    (id, name)
    values
    (1,  'Pharmaceutical'),
    (1,  'Pharmaceuticals'),
    (2,  'Tactical'),
    (3,  'Arms'),
    (4,  'Electronics'),
    (4,  'Electric'),
    (5,  'Chemical'),
    (6,  'Engineering'),
    (7,  'Equipment'),
    (8,  'Manufacturing'),
    (9,  'Research'),
    (10, 'Medical'),
    (11, 'Communications'),
    (12, 'Ergonomics'),
    (13, 'Motors'),
    (14, 'Mobile'),
    (15, 'Cybernetics'),
    (16, 'Hardware'),
    (17, 'Software'),
    (18, 'Security'),
    (19, 'Technical'),
    (20, 'Financial'),
    (21, 'Industrial')
;

create view vcorporationaddcharacter as
select
    null as coid,
    null as karma,
    null as cofid;

create trigger corporationInsert after insert on corporation
for each row begin
    insert into vcorporationaddcharacter
        (coid, karma, cofid)
        select new.id as coid,
               new.founderkarma as karma,
               1 as cofid
          from seq4
         where b < (1 + abs(random()) % 3);

    update corporation
       set founders = (select count(*)
                         from costaff
                        where coid = new.id)
     where id = new.id;

    insert into cotrade
        (coid, baid)
        select new.id as coid,
               trade.id as baid
          from trade
        order by random()
        limit 1;

    insert into vnamecorporation
        (coid)
        select corporation.id
          from corporation
         where corporation.id = new.id
           and corporation.name is null;
end;

create trigger vcorporationaddcharacter instead of insert on vcorporationaddcharacter
for each row begin
    insert into character (karma, sentient) values (new.karma, 1);
    insert into costaff (coid, cid, cofid) values (new.coid, last_insert_rowid(), new.cofid);
end;
