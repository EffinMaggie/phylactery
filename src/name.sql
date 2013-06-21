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
    (105,  11,  'last-name trade',                            20),
    (106,  11,  'first-name last-name',                        5),
    (107,  11,  'first-name last-name trade',                 10),
    (101,  12,  'last-name-last-name',                         10),
    (103,  12,  'last-name[1]last-name[1] trade',             10),
    (102,  13,  'last-name-last-name-last-name',               10),
    (104,  13,  'last-name[1]last-name[1]last-name[1] trade', 10)
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
    (8,  'trade'),
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
    maxlength integer not null default 12,
    maxsublen integer not null default 12,

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
    (5, 5, 4, null,    2,   12,   12),

    -- first/male-first/male last
    (6, 1, 2, null,    3,    8,    8),
    (6, 2, 5, null,    1,    1,    1),
    (6, 3, 2, null,    3,    8,    8),
    (6, 4, 6, null,    1,    1,    1),
    (6, 5, 4, null,    2,   12,   12)
;

insert into nametemplate
    (nsid, pos, ncid, literal, ref, minlength, maxlength, maxsublen)
    values
    -- last-name
    (100, 1, 10, null,    0, 3, 12, 12),
    -- last-name trade
    (105, 1, 10, null,    0, 3, 12, 12),
    (105, 2,  6, null,    0, 1,  1,  1),
    (105, 3,  8, null,    0, 3, 20, 20),
    -- first-name last-name
    (106, 1,  9, null,    0, 3, 12, 12),
    (106, 2,  6, null,    0, 1,  1,  1),
    (106, 3, 10, null,    0, 3, 12, 12),
    -- first-name last-name trade
    (107, 1,  9, null,    0, 3, 12, 12),
    (107, 2,  6, null,    0, 1,  1,  1),
    (107, 3, 10, null,    0, 3, 12, 12),
    (107, 4,  6, null,    0, 1,  1,  1),
    (107, 5,  8, null,    0, 3, 20, 20),
    -- last-name-last-name
    (101, 1, 10, null,    0, 3, 12, 12),
    (101, 2,  5, null, null, 1,  1,  1),
    (101, 3, 10, null,    1, 3, 12, 12),
    -- last-name[1]-last-name[1] trade
    (103, 1, 10, null,    0, 3, 12,  1),
    (103, 2, 10, null,    1, 3, 12,  1),
    (103, 3,  6, null, null, 1,  1,  1),
    (103, 4,  8, null, null, 3, 20, 20),
    -- last-name-last-name-last-name
    (102, 1, 10, null,    0, 3, 12, 12),
    (102, 2,  5, null, null, 1,  1,  1),
    (102, 3, 10, null,    1, 3, 12, 12),
    (102, 4,  5, null, null, 1,  1,  1),
    (102, 5, 10, null,    2, 3, 12, 12),
    -- last-name[1]-last-name[1]-last-name[1] trade
    (104, 1, 10, null,    0, 3, 12,  1),
    (104, 2, 10, null,    1, 3, 12,  1),
    (104, 3, 10, null,    2, 3, 12,  1),
    (104, 4,  6, null, null, 1,  1,  1),
    (104, 5,  8, null, null, 3, 20, 20)
;

create table constrainedmarkov
(
    refid integer not null,
    ntid integer not null,
    mcid integer not null,
    result text null,
    retries integer not null default 20,

    primary key (refid, ntid),

    foreign key (ntid) references nametemplate(id)
);

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

create view vconstrainedmarkov as
select
    null as refid,
    null as mcid,
    null as ntid;

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

create trigger constrainedmarkovInsert after insert on constrainedmarkov
for each row begin
    insert into vconstrainedmarkov
        (refid, mcid, ntid)
        select new.refid,
               new.mcid,
               new.ntid
          from seq8
         where seq8.b < new.retries;
end;

create trigger vconstrainedmarkovInsert instead of insert on vconstrainedmarkov
for each row when exists(select 1
                           from constrainedmarkov, nametemplate
                          where constrainedmarkov.ntid = nametemplate.id
                            and constrainedmarkov.ntid = new.ntid
                            and constrainedmarkov.refid = new.refid
                            and (   result is null
                                 or length(result) < minlength
                                 or length(result) > maxlength)
                            and retries > 0)
begin
    insert or replace into markovconstruct
        (id, mvcid)
        select new.mcid as id,
               new.refid * 60 + new.ntid as mvcid;

    insert into vautoconstruct
        (steps)
        select maxlength as steps
          from nametemplate
         where id = new.ntid;

    update constrainedmarkov
       set result = (select result
                       from markovresult
                      where mvcid = new.refid * 60 + new.ntid),
           retries = retries - 1
     where refid = new.refid
       and ntid = new.ntid;
end;

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
    insert into constrainedmarkov
        (refid, mcid, ntid)
        values
        (new.refid, 3, new.ntid);

    update nametemplateresult
       set result = (select substr(result, 1, nametemplate.maxsublen)
                       from constrainedmarkov, nametemplate
                      where constrainedmarkov.refid = new.refid
                        and constrainedmarkov.ntid = nametemplate.id
                        and nametemplate.id = new.ntid)
     where ntid = new.ntid
       and result is null;
end;

create trigger nametemplateresultInsertFirstNameM after insert on nametemplateresult
for each row when (select ncid from nametemplate where id = new.ntid) = 2 begin
    insert into constrainedmarkov
        (refid, mcid, ntid)
        values
        (new.refid, 4, new.ntid);

    update nametemplateresult
       set result = (select substr(result, 1, nametemplate.maxsublen)
                       from constrainedmarkov, nametemplate
                      where constrainedmarkov.refid = new.refid
                        and constrainedmarkov.ntid = nametemplate.id
                        and nametemplate.id = new.ntid)
     where ntid = new.ntid
       and result is null;
end;

create trigger nametemplateresultInsertFirstNameU after insert on nametemplateresult
for each row when (select ncid from nametemplate where id = new.ntid) = 3 begin
    insert into constrainedmarkov
        (refid, mcid, ntid)
        values
        (new.refid, 3 + (abs(random()) % 2), new.ntid);

    update nametemplateresult
       set result = (select substr(result, 1, nametemplate.maxsublen)
                       from constrainedmarkov, nametemplate
                      where constrainedmarkov.refid = new.refid
                        and constrainedmarkov.ntid = nametemplate.id
                        and nametemplate.id = new.ntid)
     where ntid = new.ntid
       and result is null;
end;

create trigger nametemplateresultInsertLastName after insert on nametemplateresult
for each row when (select ncid from nametemplate where id = new.ntid) = 4 begin
    insert into constrainedmarkov
        (refid, mcid, ntid)
        values
        (new.refid, 5, new.ntid);

    update nametemplateresult
       set result = (select substr(result, 1, nametemplate.maxsublen)
                       from constrainedmarkov, nametemplate
                      where constrainedmarkov.refid = new.refid
                        and constrainedmarkov.ntid = nametemplate.id
                        and nametemplate.id = new.ntid)
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
                       from trade
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
