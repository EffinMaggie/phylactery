-- basic game metadata

create table message
(
    id integer not null primary key,
    message text not null,
    popup boolean not null default 0
);

create table gamemode
(
    id integer not null primary key,
    description text
);

insert into gamemode
    (id, description)
    values
    (0,  'Roam'),
    (1,  'Select Direction'),
    (2,  'Select Inventory Slot'),
    (3,  'Select Target');

create table game
(
    id integer not null primary key,
    paid integer not null default 1,
    pov integer not null default 1,
    columns integer not null default 80,
    lines integer not null default 25,
    offsetx integer not null default 1,
    offsety integer not null default 4,
    refresh integer not null default 1,
    turn integer not null default 0,
    moid integer not null default 0,
    cmid integer null,
    msid integer not null default -1,
    -- level generator parameters
    levelwidth integer not null default 50,
    levelheight integer not null default 20,

    -- foreign key (paid) references party(id)
    -- foreign key (pov) references character(id)
    foreign key (moid) references gamemode(id)
    -- foreign key (cmid) references command(id)
    -- foreign key (msid) references message(id)
);

create view vgameoffset as
select null as x,
       null as y,
       null as width,
       null as height,
       null as gid,
       null as columns,
       null as lines;

create view vgameoffsetupdate as
select null as gid;

create trigger gameInsert after insert on game
for each row begin
    insert into corporation
        (id)
        values
        (1);

    insert into character
        (karma, sentient)
        values
        (500, 1);

    update game
       set pov = last_insert_rowid()
     where game.id = new.id;

    insert into vparty
        (members, karma, sentient)
        values
        (4, 500, 1);

    update game
       set paid = (select max(id) from party)
     where game.id = new.id;

    insert into vgeneratelevel
        (gid)
        values
        (new.id);

    update board
       set cid = (select pov
                    from game
                   where id = new.id)
     where  id = (select id
                    from vboard
                   where not opaque
                   order by random()
                   limit 1);

    insert into vgameoffsetupdate
        (gid)
        values
        (new.id);
end;

create trigger gameUpdate after update on game
for each row when old.lines <> new.lines or old.columns <> new.columns or old.moid <> new.moid begin
    insert into vgameoffsetupdate
        (gid)
        values
        (new.id);
end;

create trigger vgameoffsetInsert instead of insert on vgameoffset
for each row begin
    update game
       set offsetx = case when new.width < new.columns then 1 else  - ((new.x * (new.width-new.columns+1)) / (new.width)) end,
           offsety = case when new.height < new.lines then 4 else 3 - ((new.y * (new.height-new.lines+4)) / (new.height)) end,
           refresh = 1
     where id = new.gid
       and (   offsetx <> case when new.width < new.columns then 1 else  - ((new.x * (new.width-new.columns+1)) / (new.width)) end
            or offsety <> case when new.height < new.lines then 4 else 3 - ((new.y * (new.height-new.lines+4)) / (new.height)) end );
end;

create trigger vgameoffsetupdateInsert instead of insert on vgameoffsetupdate
for each row begin
    insert into vgameoffset
        (x, y, width, height, gid, columns, lines)
        select board.x as x,
               board.y as y,
               game.levelwidth as width,
               game.levelheight as height,
               game.id as gid,
               game.columns + case when game.moid = 2 then -50 else 0 end as columns,
               game.lines as lines
          from board, game
         where board.cid = game.pov
           and game.id = new.gid;
end;
