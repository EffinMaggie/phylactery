create table tile
(
    id integer primary key,
    description text null,
    tile not null,
    opaque boolean not null,
    onmap boolean not null
);

create table board
(
    id integer not null primary key,

    x integer not null,
    y integer not null,

    tid integer not null default 1,
    cid integer null,

    foreign key (tid) references tile(id),
    foreign key (cid) references character(id)
);

create unique index boardXY on board(x, y);
create unique index boardID on board(id);
create index boardTID on board(tid);
create index boardCID on board(cid);
create index boardCIDTID on board(cid, tid);

create view vboard as
select
    b.id as id,
    b.x as x,
    b.y as y,
    b.cid as cid,
    case when m.tile is not null then m.tile
         when tile.tile is not null then tile.tile
         else 'x' end
      as tile,
    (b.cid is not null or tile.opaque) as opaque,
    tile.onmap as onmap,
    p.paid = g.paid as friendly,
    p.paid <> g.paid as hostile
from board as b,
     tile,
     game as g
left join character as c on c.id = b.cid
left join metatype as m on c.mid = m.id
left join pcharacter as p on b.cid = p.cid
where g.id = 1
  and b.tid = tile.id;

insert into tile
    (id, description, tile, opaque, onmap)
    values
    ( 1, 'wall',                                     '#', 1, 1),
    ( 2, 'floor',                                    '.', 0, 0),
    ( 3, 'empty',                                    ' ', 0, 0),
    ( 4, 'stairs down',                              '>', 0, 1),
    ( 5, 'stairs up',                                '<', 0, 1),
    ( 6, 'floor (padding, corridor)',                '.', 0, 0),
    ( 7, 'floor (padding, roomsplit)',               '.', 0, 0),
    (10, 'floor (padding, vertical)',                '.', 0, 0),
    (11, 'floor (padding, horizontal)',              '.', 0, 0),
    (12, 'floor (padding, distance 2, vertical)',    '.', 0, 0),
    (13, 'floor (padding, distance 2, horizontal)',  '.', 0, 0),
    (14, 'floor (padding, distance 3, vertical)',    '.', 0, 0),
    (15, 'floor (padding, distance 3, horizontal)',  '.', 0, 0),
    (16, 'floor (padding, distance 4, vertical)',    '.', 0, 0),
    (17, 'floor (padding, distance 4, horizontal)',  '.', 0, 0),
    (18, 'floor (padding, distance 5, vertical)',    '.', 0, 0),
    (19, 'floor (padding, distance 5, horizontal)',  '.', 0, 0),
    (20, 'wall (room)',                              '#', 1, 1),
    (50, 'table (vertical)',                         '|', 1, 0),
    (51, 'table (horizontal)',                       '-', 1, 0),
    (90, 'door (closed)',                            '+', 1, 0),
    (91, 'door (open)',                              '%', 0, 0)
;
