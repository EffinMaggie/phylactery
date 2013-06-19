create table room
(
    id integer not null primary key,
    x integer not null,
    y integer not null,
    width integer not null,
    height integer not null,
    area integer,
    split boolean,
    cx integer default 0,
    cy integer default 0,
    rid integer null
);

create table roomconnection
(
    rid1 integer not null,
    rid2 integer not null,

    primary key (rid1, rid2),

    foreign key (rid1) references room(id),
    foreign key (rid2) references room(id)
);

create table scratchboard
(
    id integer not null primary key,
    x integer not null,
    y integer not null,

    tid integer not null,

    foreign key (tid) references tile(id)
);

create unique index scratchboardXY on scratchboard (x, y);

create view vgeneratelevel as
select null as gid;

create view vroomfill as
select null as rid;

create view vaddclutter as
select null as gid;

create trigger vgeneratelevelInsert instead of insert on vgeneratelevel
for each row begin
    insert or replace into scratchboard
        (x, y, tid)
        select
            x.b as x,
            y.b as y,
            2 as tid
        from seq8 as x,
             seq8 as y,
             game
        where game.id = new.gid
          and x.b < game.levelwidth
          and y.b < game.levelheight;

    delete
      from scratchboard
     where id in (select b.id
                    from scratchboard as b,
                         scratchboard as q
                   where abs (b.y - q.y) < 2
                     and abs (b.x - q.x) < 2
                     and b.tid = 1
                     and q.tid in (1, 20)
                   group by b.id
                   having count(*) = 9);

    delete
      from scratchboard
     where (   x = 0
            or x = (select game.levelwidth - 1
                      from game
                     where game.id = new.gid)
            or y = 0
            or y = (select game.levelheight - 1
                      from game
                     where game.id = new.gid) );

    delete
      from board;

    insert or replace into board
        (x, y, tid)
        select
            x, y, tid
        from scratchboard;

    delete
      from scratchboard;
end;

create trigger vroomfillInsert instead of insert on vroomfill
for each row begin
    insert or replace into scratchboard
        (x, y, tid)
        select
            scratchboard.x as x,
            scratchboard.y as y,
            1 as tid
        from room, scratchboard
        where room.id = new.rid
          and scratchboard.x >= room.x and scratchboard.x <= room.x + room.width
          and scratchboard.y >= room.y and scratchboard.y <= room.y + room.height;

    delete
      from room
     where room.id = new.rid;
end;

create trigger vaddclutterInsert instead of insert on vaddclutter
for each row begin
    update scratchboard
       set tid = 50
     where id in (select id
                    from scratchboard
                   where tid = 10
                   order by random()
                   limit 30 );

    update scratchboard
       set tid = 51
     where id in (select id
                    from scratchboard
                   where tid = 11
                   order by random()
                   limit 30 );
end;
