/* PARTE A -> CREAMOS LAS TABLAS

create table userTP (
        userId          integer not null,      
        reputation      integer not null,
        creationDate    timestamp not null,      -- en realidad deberia ser timestamptz porque incluye el timezone pero no me lo acepta
        displayName     varchar not null,
        lastAccessDate  timestamp not null,     -- en realidad deberia ser timestamptz porque incluye el timezone pero no me lo acepta
        websiteUrl      varchar,    
        location        varchar,
        aboutMe         varchar not null,      -- hay un tipo que es xml pero no me lo acepta
        views           integer not null,
        upVotes         integer not null,
        downVotes       integer not null,
        
        primary key (userId)
);

create table badge (
        id              varchar not null,     -- id del badge                   
        userId          integer not null,       -- id del usuario  
        name            varchar not null,     -- nombre del badge
        date_badge      timestamp not null,     -- en realidad deberia ser timestamptz porque incluye el timezone pero no me lo acepta
        class           integer not null,
        
        primary key (id),
        foreign key (userId) references userTP
);*/

/* PARTE B -> INSERTAMOS LOS DATOS -> ESTO ES LO QUE NO ME ANDA

\copy badge from './Badges.tsv' header delimiter ' ';
\copy userID from './Users.tsv' header delimiter ' ';
*/

/* PARTE C -> FUNCIONES

create or replace function reporteBadge (usuarioDesde userTP.userId%type, usuarioHasta userTP.userId%type) return void // tiene que imprimir una tabla, nose si es void
as
        id integer;
        displayName varchar;
        reputation varchar;
        badgeName varchar;
        qtty integer;
begin
end;

*/
        


