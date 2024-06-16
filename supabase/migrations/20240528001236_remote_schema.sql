drop policy if exists "SELECT alliances" on "public"."alliances";
drop policy if exists "SELECT event_notes" on "public"."event_notes";
drop policy if exists "SELECT event_staffs" on "public"."event_staffs";
drop policy if exists "Enable read access for authenticated users" on "public"."events";
drop policy if exists "SELECT events" on "public"."events";
drop policy if exists "Enable read access for all users" on "public"."levels";
drop policy if exists "SELECT matches" on "public"."matches";
drop policy if exists "SELECT schedule_deviations" on "public"."schedule_deviations";
drop policy if exists "Enable read access for all users" on "public"."seasons";
drop policy if exists "Enable read access for all users" on "public"."truck_routes";

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
using (('"Events_View"'::jsonb IN ( SELECT ((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text))));

create policy "SELECT event_notes global"
on "public"."event_notes"
as permissive
for select
to authenticated
using (('"Events_View"'::jsonb IN ( SELECT ((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text))));

create policy "SELECT event_staffs global"
on "public"."event_staffs"
as permissive
for select
to authenticated
using (('"Events_View"'::jsonb IN ( SELECT ((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text))));

create policy "SELECT events global"
on "public"."events"
as permissive
for select
to authenticated
using (('"Events_View"'::jsonb IN ( SELECT ((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text))));

create policy "SELECT matches global"
on "public"."matches"
as permissive
for select
to authenticated
using (('"Events_View"'::jsonb IN ( SELECT ((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text))));

create policy "SELECT schedule_deviations global"
on "public"."schedule_deviations"
as permissive
for select
to authenticated
using (('"Events_View"'::jsonb IN ( SELECT ((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text))));

create policy "SELECT equipment global"
on "public"."equipment"
as permissive
for select
to authenticated
using (('"Equipment_Note"'::jsonb IN ( SELECT ((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text))));

create policy "SELECT equipment_notes global"
on "public"."equipment_notes"
as permissive
for select
to authenticated
using (('"Equipment_Note"'::jsonb IN ( SELECT ((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text))));

create policy "SELECT equipment_types global"
on "public"."equipment_types"
as permissive
for select
to authenticated
using (('"Equipment_Note"'::jsonb IN ( SELECT ((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text))));

create policy "SELECT truck_routes global"
on "public"."truck_routes"
as permissive
for select
to authenticated
using (
    ('"Equipment_Note"'::jsonb IN ( SELECT ((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text))) OR
    ('"Events_View"'::jsonb IN ( SELECT ((auth.jwt() -> 'app_metadata'::text) -> 'globalPermissions'::text)))
);
