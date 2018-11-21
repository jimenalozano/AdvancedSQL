/* PARTE A -> CREAMOS LAS TABLAS 

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
); */ 

/* PARTE B -> INSERTAMOS LOS DATOS  

\copy usertp from './Users.tsv' header delimiter E'\t' quote E'\'' csv;
\copy badge from './Badges.tsv' header delimiter E'\t' quote E'\'' csv; */


/* PARTE C -> FUNCIONES */

-- id -> 4 display name -> 25 reputation -> 12 badge name -> 20 qtty -> 10

create or replace function mostarEncabezado() returns void as $$
declare
begin
        perform dbms_output.put_line('                                 BADGES REPORT                             ');
        perform dbms_output.put_line('---------------------------------------------------------------------------');
        perform dbms_output.put_line(' ID         Display Name        Reputation       Badge Name         Qtty   ');
        perform dbms_output.put_line('---- ------------------------- ------------ -------------------- ----------');
end;
$$ language plpgsql;

create or replace function reporteBadge (usuarioDesde usertp.id%type, usuarioHasta usertp.id%type) returns void as $$
declare
unId integer;
unNombreDeUsuario varchar;
unaReputacion integer;
primerId boolean;
miCursor cursor for
        select distinct usertp.id, usertp.displayName, usertp.reputation
        from usertp join badge on usertp.id = badge.userid
        where usertp.id >= usuarioDesde and usertp.id <= usuarioHasta
        order by usertp.id asc;
begin   
        open miCursor;
        loop
                fetch miCursor into unId, unNombreDeUsuario, unaReputacion;
                exit when not found;
                if (primerId) 
                then 
                        perform mostarEncabezado();
                        primerId = false;
                end if;
                perform imprimirElemento(cast(unId as varchar), 4);
                perform imprimirElemento(unNombreDeUsuario, 25);
                perform imprimirElemento(cast(unaReputacion as varchar), 12);
                perform seleccionarBadges(unId);
                perform DBMS_OUTPUT.new_line();
        end loop;
        close miCursor;
end;
$$ language plpgsql;

create or replace function imprimirElemento (string varchar, cantidadTotal integer) returns void as $$
declare
cantidad integer;
begin
        cantidad = length(string);
        perform dbms_output.put(string);
        cantidadTotal = cantidadTotal - cantidad;
        while cantidadTotal >= 0 loop
                perform dbms_output.put(' ');
                cantidadTotal = cantidadTotal - 1;
        end loop;     
end;
$$ language plpgsql;

create or replace function seleccionarBadges (usuario badge.userid%type) returns void as $$
declare
nombreBadge badge.name_%type;
cantidadBadge integer;
primerBadge boolean;
miCursorBadges cursor for
        select distinct name_
        from badge
        where userid = usuario
        order by name_ asc;
begin
        primerBadge = true;
        open miCursorBadges;
        loop
                fetch miCursorBadges into nombreBadge;
                exit when not found;
                if (primerBadge)
                then primerBadge = false;
                else
                        perform dbms_output.put('                                            ');
                end if;
                perform imprimirElemento(nombreBadge, 20);
                select count(*) into cantidadBadge from badge where name_=nombreBadge and userid=usuario;
                perform imprimirElemento(cast(cantidadBadge as varchar), 10);
                perform DBMS_OUTPUT.new_line();
        end loop;
        perform mostrarClases(usuario);
        close miCursorBadges;
        perform DBMS_OUTPUT.new_line();
end;
$$ LANGUAGE PLPGSQL;

create or replace function mostrarClases (usuario badge.userid%type) returns void as $$
declare
cantidadBronce integer;
cantidadOro integer;
cantidadPlata integer;
begin
        select count(*) into cantidadOro from badge where class_=1 and userid=usuario;
        select count(*) into cantidadPlata from badge where class_=2 and userid=usuario;
        select count(*) into cantidadBronce from badge where class_=3 and userid=usuario;
        
        perform dbms_output.put('                                            ');
        perform imprimirElemento('GOLD badges:', 20);
        perform imprimirElemento(cast(cantidadOro as varchar), 10);
        perform DBMS_OUTPUT.new_line();
        
        perform dbms_output.put('                                            ');
        perform imprimirElemento('SILVER badges:', 20);
        perform imprimirElemento(cast(cantidadPlata as varchar), 10);
        perform DBMS_OUTPUT.new_line();
        
        perform dbms_output.put('                                            ');
        perform imprimirElemento('BRONZE badges:', 20);
        perform imprimirElemento(cast(cantidadBronce as varchar), 10);
        perform DBMS_OUTPUT.new_line();
end;
$$ LANGUAGE PLPGSQL;


/* PARTE D 
CREATE TRIGGER votes_change_trigger
    BEFORE UPDATE ON
      usertp FOR EACH ROW EXECUTE PROCEDURE votes_change_trigger_function();
 CREATE OR REPLACE FUNCTION votes_change_trigger_function() RETURNS trigger
AS '
DECLARE
      diff integer;
BEGIN
  IF NEW.upvotes <> OLD.upvotes THEN -- si hubo un cambio
      diff := NEW.upvotes - OLD.upvotes;
      IF NEW.upvotes < 0 THEN -- si es menor a 0 corregimos
          NEW.upvotes := 0;
          diff := -OLD.upvotes;
      END IF;
      NEW.reputation = OLD.reputation + (diff * 5);
  END IF;
   IF NEW.downvotes <> OLD.downvotes THEN -- si hubo un cambio
      diff := NEW.downvotes - OLD.downvotes;
      IF NEW.downvotes < 0 THEN -- si es menor a 0 corregimos
          NEW.downvotes := 0;
          diff := -OLD.downvotes;
      END IF;
      NEW.reputation = OLD.reputation + (diff * -2);
  END IF;
  RETURN NEW;
END;
'  LANGUAGE plpgsql */
        
do $$
begin
PERFORM DBMS_OUTPUT.DISABLE();
PERFORM DBMS_OUTPUT.ENABLE();
PERFORM DBMS_OUTPUT.SERVEROUTPUT('t');
//perform reporteBadge(4, 10);
end;
$$