alter table "public"."events" add column "time_zone" text not null default 'Etc/UTC'::text;


