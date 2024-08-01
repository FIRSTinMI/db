alter table "public"."event_staffs"
alter column "permissions"
drop default;

alter table "public"."event_staffs"
alter column "permissions"
set data type text[] using "permissions"::text[];

create policy "SELECT alliances event_staff"
on "public"."alliances"
as permissive
for select
to authenticated
using (event_id IN (
    SELECT event_staffs.event_id
    FROM event_staffs
    WHERE (
        event_staffs.user_id = (SELECT auth.uid() AS uid) AND
        ('Event_View'::text = ANY (event_staffs.permissions))
    )
));


create policy "SELECT event_notes event_staff"
on "public"."event_notes"
as permissive
for select
to authenticated
using (event_id IN (
    SELECT event_staffs.event_id
    FROM event_staffs
    WHERE (
        event_staffs.user_id = (SELECT auth.uid() AS uid) AND
        ('Event_View'::text = ANY (event_staffs.permissions))
    )
));

-- ===========
-- NOTE: This policy creates a dependency loop, so can't be used. In the meantime fetch event staffs using the AdminApi
-- ===========
-- create policy "SELECT event_staffs event_staff"
-- on "public"."event_staffs"
-- as permissive
-- for select
-- to authenticated
-- using (event_id IN (
--     SELECT event_staffs.event_id
--     FROM event_staffs
--     WHERE (
--         event_staffs.user_id = (SELECT auth.uid() AS uid) AND
--         ('Event_ManageStaff'::text = ANY (event_staffs.permissions))
--     )
-- ));

create policy "SELECT event_staffs self"
on "public"."event_staffs"
as permissive
for select
to authenticated
using (user_id = (select auth.uid()));

create policy "SELECT events event_staff"
on "public"."events"
as permissive
for select
to authenticated
using (id IN (
    SELECT event_staffs.event_id
    FROM event_staffs
    WHERE (
        event_staffs.user_id = (SELECT auth.uid() AS uid) AND
        ('Event_View'::text = ANY (event_staffs.permissions))
    )
));

create policy "SELECT matches event_staff"
on "public"."matches"
as permissive
for select
to authenticated
using (event_id IN (
    SELECT event_staffs.event_id
    FROM event_staffs
    WHERE (
        event_staffs.user_id = (SELECT auth.uid() AS uid) AND
        ('Event_View'::text = ANY (event_staffs.permissions))
    )
));

create policy "SELECT schedule_deviations event_staff"
on "public"."schedule_deviations"
as permissive
for select
to authenticated
using (event_id IN (
    SELECT event_staffs.event_id
    FROM event_staffs
    WHERE (
        event_staffs.user_id = (SELECT auth.uid() AS uid) AND
        ('Event_View'::text = ANY (event_staffs.permissions))
    )
));

create policy "SELECT truck_routes event_staff"
on "public"."truck_routes"
as permissive
for select
to authenticated
using (exists (
    SELECT event_staffs.event_id
    FROM event_staffs
    WHERE (
        event_staffs.user_id = (SELECT auth.uid() AS uid) AND
        ('Event_View'::text = ANY (event_staffs.permissions))
    )
));