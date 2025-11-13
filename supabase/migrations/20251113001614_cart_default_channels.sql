create type "public"."streaming_service" as enum ('Twitch', 'Youtube');

alter table "public"."truck_routes" add column "default_twitch_channel" varchar(255) null;
alter table "public"."truck_routes" add column "default_youtube_channel" varchar(255) null;
alter table "public"."truck_routes" add column "default_streaming_service" streaming_service null;