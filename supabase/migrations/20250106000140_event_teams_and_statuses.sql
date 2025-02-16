-- REGION: event_team_statuses
create table "public"."event_team_statuses" (
    "id" text not null,
    "name" text not null,
    "ordinal" bigint not null
);

alter table "public"."event_team_statuses" enable row level security;

create policy "SELECT event_team_statuses global"
on "public"."event_team_statuses"
as permissive
for select
to authenticated
using (true);

insert into "public"."event_team_statuses" ("id", "name", "ordinal") values
    ('NotArrived', 'Not Arrived', 10),
    ('Dropped', 'Dropped', 20);


-- REGION: event_teams
create table "public"."event_teams" (
    "id" bigint generated by default as identity not null,
    "event_id" uuid not null,
    "team_number" bigint not null,
    "level_id" integer not null,
    "notes" text,
    "status_id" text not null
);

alter table "public"."event_teams" enable row level security;

create policy "SELECT event_teams event_staff"
on "public"."event_teams"
as permissive
for select
to authenticated
using ((event_id IN ( SELECT event_staffs.event_id
   FROM event_staffs
  WHERE ((event_staffs.user_id = ( SELECT auth.uid() AS uid)) AND ('Event_View'::text = ANY (event_staffs.permissions))))));

create policy "SELECT event_teams global"
on "public"."event_teams"
as permissive
for select
to authenticated
using ((((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text) @> '"Events_View"'::jsonb));


-- REGION: indexes
CREATE UNIQUE INDEX event_team_statuses_ordinal_key ON public.event_team_statuses USING btree (ordinal);

CREATE UNIQUE INDEX event_team_statuses_pkey ON public.event_team_statuses USING btree (id);

CREATE UNIQUE INDEX event_teams_pkey ON public.event_teams USING btree (id);

alter table "public"."event_team_statuses" add constraint "event_team_statuses_pkey" PRIMARY KEY using index "event_team_statuses_pkey";

alter table "public"."event_teams" add constraint "event_teams_pkey" PRIMARY KEY using index "event_teams_pkey";

alter table "public"."event_team_statuses" add constraint "event_team_statuses_ordinal_key" UNIQUE using index "event_team_statuses_ordinal_key";

alter table "public"."event_teams" add constraint "public_event_teams_event_id_fkey" FOREIGN KEY (event_id) REFERENCES events(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."event_teams" validate constraint "public_event_teams_event_id_fkey";

alter table "public"."event_teams" add constraint "public_event_teams_level_id_fkey" FOREIGN KEY (level_id) REFERENCES levels(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."event_teams" validate constraint "public_event_teams_level_id_fkey";

alter table "public"."event_teams" add constraint "public_event_teams_status_id_fkey" FOREIGN KEY (status_id) REFERENCES event_team_statuses(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."event_teams" validate constraint "public_event_teams_status_id_fkey";


-- REGION: perms
grant delete on table "public"."event_team_statuses" to "anon";

grant insert on table "public"."event_team_statuses" to "anon";

grant references on table "public"."event_team_statuses" to "anon";

grant select on table "public"."event_team_statuses" to "anon";

grant trigger on table "public"."event_team_statuses" to "anon";

grant truncate on table "public"."event_team_statuses" to "anon";

grant update on table "public"."event_team_statuses" to "anon";

grant delete on table "public"."event_team_statuses" to "authenticated";

grant insert on table "public"."event_team_statuses" to "authenticated";

grant references on table "public"."event_team_statuses" to "authenticated";

grant select on table "public"."event_team_statuses" to "authenticated";

grant trigger on table "public"."event_team_statuses" to "authenticated";

grant truncate on table "public"."event_team_statuses" to "authenticated";

grant update on table "public"."event_team_statuses" to "authenticated";

grant delete on table "public"."event_team_statuses" to "service_role";

grant insert on table "public"."event_team_statuses" to "service_role";

grant references on table "public"."event_team_statuses" to "service_role";

grant select on table "public"."event_team_statuses" to "service_role";

grant trigger on table "public"."event_team_statuses" to "service_role";

grant truncate on table "public"."event_team_statuses" to "service_role";

grant update on table "public"."event_team_statuses" to "service_role";

grant delete on table "public"."event_teams" to "anon";

grant insert on table "public"."event_teams" to "anon";

grant references on table "public"."event_teams" to "anon";

grant select on table "public"."event_teams" to "anon";

grant trigger on table "public"."event_teams" to "anon";

grant truncate on table "public"."event_teams" to "anon";

grant update on table "public"."event_teams" to "anon";

grant delete on table "public"."event_teams" to "authenticated";

grant insert on table "public"."event_teams" to "authenticated";

grant references on table "public"."event_teams" to "authenticated";

grant select on table "public"."event_teams" to "authenticated";

grant trigger on table "public"."event_teams" to "authenticated";

grant truncate on table "public"."event_teams" to "authenticated";

grant update on table "public"."event_teams" to "authenticated";

grant delete on table "public"."event_teams" to "service_role";

grant insert on table "public"."event_teams" to "service_role";

grant references on table "public"."event_teams" to "service_role";

grant select on table "public"."event_teams" to "service_role";

grant trigger on table "public"."event_teams" to "service_role";

grant truncate on table "public"."event_teams" to "service_role";

grant update on table "public"."event_teams" to "service_role";

