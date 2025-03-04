alter table "public"."equipment_logs" add column "category" text;

alter table "public"."equipment_logs" add column "extra_info" jsonb;

alter table "public"."equipment_logs" add column "severity" text default 'Info' not null;

