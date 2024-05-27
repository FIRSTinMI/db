create table "public"."profiles" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "name" text
);


alter table "public"."profiles" enable row level security;

alter table "public"."events" add column "name" text not null;

CREATE UNIQUE INDEX profiles_pkey ON public.profiles USING btree (id);

alter table "public"."profiles" add constraint "profiles_pkey" PRIMARY KEY using index "profiles_pkey";

alter table "public"."profiles" add constraint "public_profiles_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."profiles" validate constraint "public_profiles_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_profile_for_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  INSERT INTO public.profiles (id, name)
  SELECT
    new.id,
    COALESCE(jsonb_extract_path_text(new.raw_user_meta_data, 'name'), NULL);

  RETURN new;
END;
$function$
;

create trigger create_new_profile_for_user after
insert
    on
    auth.users for each row execute function create_profile_for_user();
