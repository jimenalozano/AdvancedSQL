/* PARTE A -> CREAMOS LAS TABLAS */

create table usertp (
        id          integer not null,
        reputation      integer not null,
        creationdate    timestamp not null,
        displayname     varchar not null,
        lastaccessdate  timestamp not null,
        websiteurl      varchar,
        location_        varchar,           -- _ por reservada
        aboutme         varchar,      -- hay un tipo que es xml pero no me lo acepta
        views           integer not null,
        upvotes         integer not null,
        downvotes       integer not null,
        accountid          integer,

        primary key (id)
);


create table badge (
        id              varchar not null,     -- id del badge
        userid          integer not null,       -- id del usuario
        name_            varchar not null,     -- nombre del badge  -- _ por reservada
        datebadge      timestamp not null,
        class_           integer not null,     -- _ por reservada
        tagbased        boolean not null,

        primary key (id),
        foreign key (userid) references usertp
);

/* PARTE B -> INSERTAMOS LOS DATOS */

\copy usertp from './Users.tsv' header delimiter E'\t' quote E'\'' csv;
\copy badge from './Badges.tsv' header delimiter E'\t' quote E'\'' csv;


/* PARTE C -> FUNCIONES */

create or replace function reporteBadge (usuarioDesde userTP.userId%type, usuarioHasta userTP.userId%type) return void // tiene que imprimir una tabla, nose si es void
as
        id integer;
        displayName varchar;
        reputation varchar;
        badgeName varchar;
        qtty integer;
begin
end;
