alter table "public"."event_streams" add column if not exists "channel_id" character varying(255) null;

update "public"."event_streams" es set "channel_id" = (select tr.streaming_config ->> 'Channel_Id' from events e join truck_routes tr on e.truck_route_id = tr.id where e.id = es.event_id) where es."channel_id" is null;
