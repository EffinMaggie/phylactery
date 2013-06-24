create view vsimulate as
select
    null as cid;

create trigger vsimulateInsert instead of insert on vsimulate
for each row begin
    insert into vinvokecommand
        (cmid, moid)
        values
        (11 + abs(random()) % 8, 0);
end;
