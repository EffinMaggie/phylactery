create table nameusage
(
    id integer not null primary key,
    description text not null
);

insert into nameusage
    (id, description)
    values
    (1,  'human female'),
    (2,  'human male'),
    (3,  'experiment'),
    (11, 'corporation - one founder'),
    (12, 'corporation - two founders'),
    (13, 'corporation - three founders')
;

create table namescheme
(
    id integer not null primary key,
    nuid integer not null,
    description text not null,
    prio integer not null,

    foreign key (nuid) references nameusage(id)
);

insert into namescheme
    (id, nuid, description, prio)
    values
    (  1,   1,  'first/female last',                           20),
    (  3,   1,  'first/female first/any last',                 10),
    (  5,   1,  'first/female-first/female last',               5),
    (  2,   2,  'first/male last',                             20),
    (  4,   2,  'first/male first/any last',                   10),
    (  6,   2,  'first/male-first/male last',                   2),

    (100,  11,  'last-name',                                   10),
    (101,  12,  'last-name-last-name',                         10),
    (103,  12,  'last-name[1]last-name[1] branch',             10),
    (102,  13,  'last-name-last-name-last-name',               10),
    (104,  13,  'last-name[1]last-name[1]last-name[1] branch', 10)
;

create table namecomponent
(
    id integer not null primary key,
    description text not null
);

insert into namecomponent
    (id, description)
    values
    (1,  'first name, female'),
    (2,  'first name, male'),
    (3,  'first name, any'),
    (4,  'last name'),
    (5,  'hyphen'),
    (6,  'space'),
    (7,  'literal'),
    (8,  'branch'),
    (9,  'first name, founder'),
    (10, 'last name, founder')
;

create table nametemplate
(
    id integer not null primary key,
    nsid integer not null,
    pos integer not null,
    ncid integer not null,
    literal text null,
    ref integer null,
    minlength integer not null default 2,
    maxlength integer not null default 16,
    maxsublen integer not null default 16,

    foreign key (nsid) references namescheme(id),
    foreign key (ncid) references namecomponent(id)
);

insert into nametemplate
    (nsid, pos, ncid, literal)
    values
    -- first/female last
    (1, 1, 1, null),
    (1, 2, 6, null),
    (1, 3, 4, null),

    -- first/male last
    (2, 1, 2, null),
    (2, 2, 6, null),
    (2, 3, 4, null),

    -- first/female first/any last
    (3, 1, 1, null),
    (3, 2, 6, null),
    (3, 3, 3, null),
    (3, 4, 6, null),
    (3, 5, 4, null),

    -- first/male first/any last
    (4, 1, 2, null),
    (4, 2, 6, null),
    (4, 3, 3, null),
    (4, 4, 6, null),
    (4, 5, 4, null)
;

insert into nametemplate
    (nsid, pos, ncid, literal, minlength, maxlength, maxsublen)
    values
    -- first/female-first/female last
    (5, 1, 1, null,    3,    8,    8),
    (5, 2, 5, null,    1,    1,    1),
    (5, 3, 1, null,    3,    8,    8),
    (5, 4, 6, null,    1,    1,    1),
    (5, 5, 4, null,    2,   16,   16),

    -- first/male-first/male last
    (6, 1, 2, null,    3,    8,    8),
    (6, 2, 5, null,    1,    1,    1),
    (6, 3, 2, null,    3,    8,    8),
    (6, 4, 6, null,    1,    1,    1),
    (6, 5, 4, null,    2,   16,   16)
;

insert into nametemplate
    (nsid, pos, ncid, literal, ref, minlength, maxlength, maxsublen)
    values
    -- last-name
    (100, 1, 10, null,    0, 3, 16, 16),
    -- last-name-last-name
    (101, 1, 10, null,    0, 3, 16, 16),
    (101, 2,  5, null, null, 1,  1,  1),
    (101, 3, 10, null,    1, 3, 16, 16),
    -- last-name[1]-last-name[1] branch
    (103, 1, 10, null,    0, 3, 16,  1),
    (103, 2, 10, null,    1, 3, 16,  1),
    (103, 3,  6, null, null, 1,  1,  1),
    (103, 4,  8, null, null, 3, 16, 16),
    -- last-name-last-name-last-name
    (102, 1, 10, null,    0, 3, 16, 16),
    (102, 2,  5, null, null, 1,  1,  1),
    (102, 3, 10, null,    1, 3, 16, 16),
    (102, 4,  5, null, null, 1,  1,  1),
    (102, 5, 10, null,    2, 3, 16, 16),
    -- last-name[1]-last-name[1]-last-name[1] branch
    (104, 1, 10, null,    0, 3, 16,  1),
    (104, 2, 10, null,    1, 3, 16,  1),
    (104, 3, 10, null,    2, 3, 16,  1),
    (101, 4,  6, null, null, 1,  1,  1),
    (104, 5,  8, null, null, 3, 16, 16)
;

create table nametemplateresult
(
    refid integer not null,
    ntid integer not null,
    result text null,

    foreign key (ntid) references nametemplate(id)
);

create table nameresult
(
    refid integer not null primary key,
    result text null
);

create view vnamecharacter as
select
    null as cid;

create view vnamecharacteru as
select
    null as cid,
    null as nuid;

create view vnamecorporation as
select
    null as coid;

create view vnamecorporationu as
select
    null as coid,
    null as nuid;

create view vcreatename as
select
    null as nsid,
    null as refid;

create view vcreatenamewusage as
select
    null as nuid,
    null as refid;

create trigger vnamecharacterInsert instead of insert on vnamecharacter
for each row begin
    insert into vnamecharacteru
        (cid, nuid)
        select new.cid as cid,
               racenameusage.nuid as nuid
          from racenameusage, metatype, character
         where racenameusage.rid = metatype.rid
           and metatype.id = character.mid
           and character.id = new.cid
           and character.sex = racenameusage.sex;
end;

create trigger vnamecharacteruInsert instead of insert on vnamecharacteru
for each row begin
    insert into vcreatenamewusage
        (nuid, refid)
        values
        (new.nuid, 100000 + new.cid);

    update character
       set name = coalesce ((select result
                               from nameresult
                              where refid = 100000 + new.cid),
                            name),
           firstname = coalesce ((select result
                                    from nametemplateresult, nametemplate
                                   where refid = 100000 + new.cid
                                     and ncid in (1, 2, 3)
                                     and nametemplateresult.ntid = nametemplate.id
                                   limit 1),
                                 firstname),
           lastname = coalesce ((select result
                                   from nametemplateresult, nametemplate
                                  where refid = 100000 + new.cid
                                    and ncid in (4)
                                    and nametemplateresult.ntid = nametemplate.id
                                  limit 1),
                                lastname)
     where id = new.cid;
end;

create trigger vnamecorporationInsert instead of insert on vnamecorporation
for each row begin
    insert into vnamecorporationu
        (coid, nuid)
        select corporation.id as coid, 
               10 + corporation.founders as nuid
          from corporation
         where corporation.id = new.coid;
end;

create trigger vnamecorporationuInsert instead of insert on vnamecorporationu
for each row begin
    insert into vcreatenamewusage
        (nuid, refid)
        values
        (new.nuid, 200000 + new.coid);

    update corporation
       set name = coalesce ((select result
                               from nameresult
                              where refid = 200000 + new.coid),
                            name)
     where id = new.coid;
end;

create trigger vcreatenameInsert instead of insert on vcreatename
for each row begin
    insert into nametemplateresult
        (refid, ntid)
        select new.refid as refid,
               nametemplate.id as ntid
          from nametemplate
         where nametemplate.nsid = new.nsid
         order by nametemplate.pos;

    update nametemplateresult
       set result = upper(substr(result, 1, 1)) || lower(substr(result, 2))
     where refid = new.refid;

    insert or replace into nameresult
        (refid, result)
        select new.refid as refid,
               group_concat(result, '') as result
          from nametemplateresult, nametemplate
         where nametemplateresult.ntid = nametemplate.id
           and nametemplateresult.refid = new.refid
         order by nametemplate.pos;
end;

create trigger vcreatenamewusageInsert instead of insert on vcreatenamewusage
for each row begin
    insert into vcreatename
        (nsid, refid)
        select namescheme.id,
               new.refid
          from namescheme, seq8
         where namescheme.nuid = new.nuid
           and seq8.b < namescheme.prio
         order by random()
         limit 1;
end;

create trigger nametemplateresultInsertFirstNameF after insert on nametemplateresult
for each row when (select ncid from nametemplate where id = new.ntid) = 1 begin
    insert or replace into markovconstruct
        (id, mvcid)
        select 3 as id,
               new.refid * 10 + seq8.b as mvcid
          from seq8
         where seq8.b < 10;

    insert into vautoconstruct
        (steps)
        select maxlength as steps
          from nametemplate
         where id = new.ntid;

    update nametemplateresult
       set result = (select substr(result, 1, nametemplate.maxsublen)
                       from markovresult, nametemplate
                      where markovresult.id = 3
                        and nametemplate.id = new.ntid
                        and length(result) >= nametemplate.minlength
                        and length(result) <= nametemplate.maxlength
                      order by random()
                      limit 1)
     where ntid = new.ntid
       and result is null;
end;

create trigger nametemplateresultInsertFirstNameM after insert on nametemplateresult
for each row when (select ncid from nametemplate where id = new.ntid) = 2 begin
    insert or replace into markovconstruct
        (id, mvcid)
        select 4 as id,
               new.refid * 20 + seq8.b as mvcid
          from seq8
         where seq8.b < 10;

    insert into vautoconstruct
        (steps)
        select maxlength as steps
          from nametemplate
         where id = new.ntid;

    update nametemplateresult
       set result = (select substr(result, 1, nametemplate.maxsublen)
                       from markovresult, nametemplate
                      where markovresult.id = 4
                        and nametemplate.id = new.ntid
                        and length(result) >= nametemplate.minlength
                        and length(result) <= nametemplate.maxlength
                      order by random()
                      limit 1)
     where ntid = new.ntid
       and result is null;
end;

create trigger nametemplateresultInsertFirstNameU after insert on nametemplateresult
for each row when (select ncid from nametemplate where id = new.ntid) = 3 begin
    insert or replace into markovconstruct
        (id, mvcid)
        select 3 as id,
               new.refid * 30 + seq8.b as mvcid
          from seq8
         where seq8.b < 5
        union
        select 4 as id,
               new.refid * 30 + seq8.b + 5 as mvcid
          from seq8
         where seq8.b < 5;

    insert into vautoconstruct
        (steps)
        select maxlength as steps
          from nametemplate
         where id = new.ntid;

    update nametemplateresult
       set result = (select substr(result, 1, nametemplate.maxsublen)
                       from markovresult, nametemplate
                      where markovresult.id in (3, 4)
                        and nametemplate.id = new.ntid
                        and length(result) >= nametemplate.minlength
                        and length(result) <= nametemplate.maxlength
                      order by random()
                      limit 1)
     where ntid = new.ntid
       and result is null;
end;

create trigger nametemplateresultInsertLastName after insert on nametemplateresult
for each row when (select ncid from nametemplate where id = new.ntid) = 4 begin
    insert or replace into markovconstruct
        (id, mvcid)
        select 5 as id,
               new.refid * 40 + seq8.b as mvcid
          from seq8
         where seq8.b < 10;

    insert into vautoconstruct
        (steps)
        select maxlength as steps
          from nametemplate
         where id = new.ntid;

    update nametemplateresult
       set result = (select substr(result, 1, nametemplate.maxsublen)
                       from markovresult, nametemplate
                      where markovresult.id = 5
                        and nametemplate.id = new.ntid
                        and length(result) >= nametemplate.minlength
                        and length(result) <= nametemplate.maxlength
                      order by random()
                      limit 1)
     where ntid = new.ntid
       and result is null;
end;

create trigger nametemplateresultInsertHyphen after insert on nametemplateresult
for each row when (select ncid from nametemplate where id = new.ntid) = 5 begin
    update nametemplateresult
       set result = '-'
     where ntid = new.ntid
       and refid = new.refid;
end;

create trigger nametemplateresultInsertSpace after insert on nametemplateresult
for each row when (select ncid from nametemplate where id = new.ntid) = 6 begin
    update nametemplateresult
       set result = ' '
     where ntid = new.ntid
       and refid = new.refid;
end;

create trigger nametemplateresultInsertLiteral after insert on nametemplateresult
for each row when (select ncid from nametemplate where id = new.ntid) = 7 begin
    update nametemplateresult
       set result = (select literal
                       from nametemplate
                      where id = new.ntid)
     where ntid = new.ntid
       and refid = new.refid;
end;

create trigger nametemplateresultInsertBranch after insert on nametemplateresult
for each row when (select ncid from nametemplate where id = new.ntid) = 8 begin
    update nametemplateresult
       set result = (select substr(name, 1, (select maxsublen from nametemplate where id = new.ntid))
                       from branch
                      order by random()
                      limit 1)
     where ntid = new.ntid
       and refid = new.refid;
end;

create trigger nametemplateresultInsertFounderFirstName after insert on nametemplateresult
for each row when (select ncid from nametemplate where id = new.ntid) = 9 begin
    update nametemplateresult
       set result = (select substr(character.firstname, 1, (select maxsublen from nametemplate where id = new.ntid))
                       from character, costaff
                      where character.id = costaff.cid
                        and costaff.coid = new.refid - 200000
                        and costaff.cofid = 1
                      limit 1
                      offset (select ref from nametemplate where id = new.ntid)
                      )
     where ntid = new.ntid
       and refid = new.refid;
end;

create trigger nametemplateresultInsertFounderLastName after insert on nametemplateresult
for each row when (select ncid from nametemplate where id = new.ntid) = 10 begin
    update nametemplateresult
       set result = (select substr(character.lastname, 1, (select maxsublen from nametemplate where id = new.ntid))
                       from character, costaff
                      where character.id = costaff.cid
                        and costaff.coid = new.refid - 200000
                        and costaff.cofid = 1
                      limit 1
                      offset (select ref from nametemplate where id = new.ntid)
                      )
     where ntid = new.ntid
       and refid = new.refid;
end;
