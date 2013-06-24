create table race
(
    id integer not null primary key,
    name text not null,
    sentient boolean not null default 0,
    karma integer not null default 500,
    sexes integer not null default 2
);

create table racerange
(
    rid integer not null,
    aid integer null,
    sid integer null,
    minvalue integer,
    maxvalue integer,

    foreign key (rid) references race(id),
    foreign key (aid) references attribute(id),
    foreign key (sid) references skill(id)
);

create table metatype
(
    id integer not null primary key,
    rid integer not null,
    name text not null,
    sentient boolean null,
    karma integer null,
    tile text not null default '?',
    mythical integer not null default 0,

    foreign key (rid) references race(id)
);

create table metatypemodifier
(
    rid integer not null,
    mid integer not null,
    aid integer null,
    sid integer null,
    value integer not null,

    foreign key (rid) references race(id),
    foreign key (mid) references metatype(id),
    foreign key (aid) references attribute(id),
    foreign key (sid) references skill(id)
);

create table racenameusage
(
    rid integer not null,
    sex integer not null,
    nuid integer not null,

    primary key (rid, sex),

    foreign key (rid) references race(id),
    foreign key (nuid) references nameusage(id)
);

create view vrace as select distinct
    r.id as rid,
    m.id as mid,
    coalesce (m.sentient, r.sentient) as sentient,
    coalesce (m.name, r.name) as name,
    r.karma + coalesce (m.karma, 0) as karma
from race as r
left join metatype as m on m.rid = r.id
;

create view vrange as
select
    m.id as mid,
    a.id as aid,
    null as sid,
    case when maxvalue is null then coalesce (minvalue, 1) else minvalue end
    + coalesce (mv.value, 0) as minvalue,
    coalesce (maxvalue, case when a.id <= 12 then 6 else null end) + coalesce (mv.value, 0) as maxvalue
from metatype as m
left join attribute as a -- on a.id <= 12
left join racerange as rv on rv.rid = m.rid and rv.aid = a.id
left join metatypemodifier as mv on mv.mid = m.id and mv.aid = a.id
union
select
    m.id as mid,
    null as aid,
    s.id as sid,
    case when mv.value is null then minvalue else coalesce (minvalue, 0) end
    + coalesce (mv.value, 0) as minvalue,
    coalesce (maxvalue, 12) + coalesce (mv.value, 0) as maxvalue
from metatype as m
left join skill as s
left join racerange as rv on rv.rid = m.rid and rv.sid = s.id
left join metatypemodifier as mv on mv.rid = m.rid and mv.mid = m.id and mv.sid = s.id
;

insert into race
    (id,  name,   sentient, karma, sexes)
    values
    (1,  'humanoid',     1,   300,     2),
    (2,  'agent',        0,   200,     1),
    (3,  'spirit',       0,   300,     2),
    (4,  'feline',       0,   100,     2),
    (5,  'canine',       0,   100,     2),
    (6,  'rodent',       0,    50,     2),
    (7,  'serpentes',    0,   100,     2),
    (8,  'fay',          0,   200,     2),
    (9,  'caudata',      0,    50,     2),
    (10, 'aves',         0,   100,     2),
    (11, 'shapeshifter', 0,   800,     1),
    (12, 'lagomorpha',   0,    50,     2)
;

insert into racenameusage
    (rid, sex, nuid)
    values
    (1, 0, 1),
    (1, 1, 2)
;

insert into racerange
    (rid, aid, sid, minvalue, maxvalue)
    values
    (1, 11, null, null, 6),
    (1, 12, null, null, 6),

    (1, 20, null, 6, null),
    (1, 21, null, 6, null),

    (2, 1, null, null, 0),
    (2, 2, null, null, 0),
    (2, 3, null, null, 0),
    (2, 4, null, null, 0),
    (2, 11, null, null, 0),
    (2, 12, null, 2, 8),

    (3, 11, null, 2, 7),
    (3, 12, null, null, 0),

    (4, 11, null, null, 6),
    (4, 12, null, null, 6),

    (5, 11, null, null, 6),
    (5, 12, null, null, 6),

    (6, 11, null, null, 6),
    (6, 12, null, null, 6)
;

insert into metatype
    (id, rid,  name,    sentient, tile, mythical)
    values
    ( 0,   1,  'human',        1,  '@',        0)
;

insert into metatype
    (id, rid,  name,          karma, tile, mythical)
    values
    ( 1,   2,  'agent',       50,    'A',  0),
    ( 2,   3,  'banshee',     50,    'B',  1),
    ( 3,   3,  'wisp',        -50,   'W',  1),
    ( 4,   3,  'ghost',       null,  'G',  1),
    ( 5,   3,  'poltergeist', null,  'P',  1),
    ( 6,   3,  'sylph',       null,  'S',  1),
    ( 7,   4,  'cat',         null,  'C',  0),
    ( 8,   4,  'manx',        null,  'M',  0),
    ( 9,   4,  'cougar',      100,   'C',  0),
    (10,   4,  'cheetah',     100,   'C',  0),
    (11,   4,  'tiger',       300,   'T',  0),
    (12,   4,  'lynx',        200,   'L',  0),
    (13,   5,  'poodle',      null,  'P',  0),
    (14,   5,  'wolf',        100,   'W',  0),
    (15,   6,  'squirrel',    null,  'S',  0),
    (16,   6,  'rat',         null,  'R',  0),
    (17,   6,  'mouse',       null,  'M',  0),
    (18,   6,  'hamster',     null,  'H',  0),
    (19,   6,  'guinea pig',  null,  'G',  0),
    (20,   7,  'snake',       null,  'S',  0),
    (21,   7,  'cobra',       100,   'O',  0),
    (22,   7,  'rattlesnake', 50,    'R',  0),
    (23,   7,  'wyrm',        900,   'W',  1),
    (24,   7,  'dragon',      1900,  'D',  1),
    (25,   8,  'pixie',       null,  'P',  1),
    (26,   8,  'imp',         50,    'I',  1),
    (27,   8,  'goblin',      100,   'G',  1),
    (28,   8,  'drake',       150,   'D',  1),
    (29,   9,  'salamander',  null,  'S',  0),
    (30,   9,  'newt',        null,  'N',  0),
    (31,   10, 'kestrel',     50,    'K',  0),
    (32,   10, 'sparrow',     null,  'S',  0),
    (33,   10, 'swallow',     null,  'S',  0),
    (34,   10, 'griffin',     500,   'G',  0),
    (35,   11, 'neck',        null,  'N',  0),
    (36,   11, 'strömkarl',   null, 'S',  0),
    (37,   12, 'rabbit',      null,  'R',  0),
    (38,   12, 'pika',        null,  'P',  0),
    (39,   12, 'leveret',     -25,   'L',  0),
    (40,   12, 'hare',        50,    'H',  0)
;

