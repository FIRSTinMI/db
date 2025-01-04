create policy "SELECT events av_token"
on "public"."events"
as permissive
for select
to public
using (
    id = (auth.jwt() ->> 'eventId'::text)::uuid
);

create policy "SELECT matches av_token"
on "public"."matches"
as permissive
for select
to public
using (
    event_id = (auth.jwt() ->> 'eventId'::text)::uuid
);

create policy "SELECT schedule_deviations av_token"
on "public"."schedule_deviations"
as permissive
for select
to public
using (
    event_id = (auth.jwt() ->> 'eventId'::text)::uuid
);