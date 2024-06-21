drop policy if exists "SELECT levels global" on "public"."levels";
drop policy if exists "SELECT seasons global" on "public"."seasons";
drop policy if exists "SELECT profiles global" on "public"."profiles";
drop policy if exists "SELECT alliances global" on "public"."alliances";
drop policy if exists "SELECT event_notes global" on "public"."event_notes";
drop policy if exists "SELECT event_staffs global" on "public"."event_staffs";
drop policy if exists "SELECT events global" on "public"."events";
drop policy if exists "SELECT matches global" on "public"."matches";
drop policy if exists "SELECT schedule_deviations global" on "public"."schedule_deviations";
drop policy if exists "SELECT equipment global" on "public"."equipment";
drop policy if exists "SELECT equipment_notes global" on "public"."equipment_notes";
drop policy if exists "SELECT equipment_types global" on "public"."equipment_types";
drop policy if exists "SELECT truck_routes global" on "public"."truck_routes";

create policy "SELECT levels global"
on "public"."levels"
as permissive
for select
to authenticated
using (true);

create policy "SELECT seasons global"
on "public"."seasons"
as permissive
for select
to authenticated
using (true);

create policy "SELECT profiles global"
on "public"."profiles"
as permissive
for select
to authenticated
using (true);

create policy "SELECT alliances global"
on "public"."alliances"
as permissive
for select
to authenticated
using (
    ((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text) @> '"Events_View"'::jsonb
);

create policy "SELECT event_notes global"
on "public"."event_notes"
as permissive
for select
to authenticated
using (
    ((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text) @> '"Events_View"'::jsonb
);

create policy "SELECT event_staffs global"
on "public"."event_staffs"
as permissive
for select
to authenticated
using (
    ((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text) @> '"Events_View"'::jsonb
);

create policy "SELECT events global"
on "public"."events"
as permissive
for select
to authenticated
using (
    ((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text) @> '"Events_View"'::jsonb
);

create policy "SELECT matches global"
on "public"."matches"
as permissive
for select
to authenticated
using (
    ((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text) @> '"Events_View"'::jsonb
);

create policy "SELECT schedule_deviations global"
on "public"."schedule_deviations"
as permissive
for select
to authenticated
using (
    ((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text) @> '"Events_View"'::jsonb
);

create policy "SELECT equipment global"
on "public"."equipment"
as permissive
for select
to authenticated
using (
    ((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text) @> '"Equipment_View"'::jsonb
);

create policy "SELECT equipment_notes global"
on "public"."equipment_notes"
as permissive
for select
to authenticated
using (
    ((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text) @> '"Equipment_View"'::jsonb
);

create policy "SELECT equipment_types global"
on "public"."equipment_types"
as permissive
for select
to authenticated
using (
    ((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text) @> '"Equipment_View"'::jsonb
);

create policy "SELECT truck_routes global"
on "public"."truck_routes"
as permissive
for select
to authenticated
using (
    (((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text) @> '"Equipment_View"'::jsonb) OR
    (((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text) @> '"Events_View"'::jsonb)
);



