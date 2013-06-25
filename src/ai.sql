create view vsimulate as
select
    null as cid;

create view vsimulatenpcmoves as
select
    null as gid;

create trigger vsimulateInsert instead of insert on vsimulate
for each row begin
    insert into vinvokecommand
        (cmid, moid)
        values
        (11 + abs(random()) % 8, 0);
end;

create trigger vsimulatenpcmovesInsert instead of insert on vsimulatenpcmoves
for each row begin
    insert into vsimulate
        (cid)
        select pov
          from game, pcharacter
         where game.id = 1
           and game.paid <> pcharacter.paid
           and pcharacter.cid = game.pov;
end;
