create type "public"."match_winner" as enum ('Red', 'Blue', 'TrueTie');

-- This column may not be used or may have incomplete data in qualification matches
alter table "public"."matches" add column "winner" match_winner null;
alter table "public"."matches" add column "match_name" varchar(50) null;