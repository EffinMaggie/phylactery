create view vfindnextcharacter as
select
    character.id as cid
from board, character
where board.cid = character.id
order by nextturn asc
limit 1;

create view vupdateinitiative as
select
    null as paid;

create view vcharacterturn as
select
    null as cid;

create view vnextcharacterturn as
select
    null as gid;

create view vencounter as
select
    null as gid;

create trigger vupdateinitiativeInsert instead of insert on vupdateinitiative
for each row begin
    update character
       set nextturn = (select gamedate
                         from game
                        where id = 1)
     where id in (select cid
                    from pcharacter
                   where paid = new.paid);
end;

create trigger vencounterInsert instead of insert on vencounter
for each row begin
    insert into party
        (members, karma)
        values
        (8 + random() % 2, 200);

    insert into vplaceparty
        (paid)
        values
        (last_insert_rowid());

    insert into vupdateinitiative
        (paid)
        values
        (last_insert_rowid()),
        ((select paid from game where game.id = new.gid));
end;

create trigger vcharacterturnInsert instead of insert on vcharacterturn
for each row begin
    update game
       set pov = new.cid
     where game.id = 1;

    insert into vsimulate
        (cid)
        select new.cid
          from character, game, pcharacter
         where game.id = 1
           and character.id = new.cid
           and pcharacter.cid = new.cid
           and pcharacter.paid <> game.paid;
end;

create trigger vnextcharacterturnInsert instead of insert on vnextcharacterturn
for each row begin
    insert into vcharacterturn
        (cid)
        select cid
          from vfindnextcharacter;
end;
