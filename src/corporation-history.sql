create table coevent
(
    id integer not null primary key,

    description text not null
);

create table cohistory
(
    id integer not null primary key,

    coid integer not null,
    coeid integer not null,
    eventdate integer null,

    foreign key (coid) references corporation(id),
    foreign key (coeid) references coevent(id)
);
