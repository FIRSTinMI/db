INSERT INTO
    auth.users (
        instance_id,
        id,
        aud,
        role,
        email,
        encrypted_password,
        email_confirmed_at,
        recovery_sent_at,
        last_sign_in_at,
        raw_app_meta_data,
        raw_user_meta_data,
        created_at,
        updated_at,
        confirmation_token,
        email_change,
        email_change_token_new,
        recovery_token
    ) (
        select
            '00000000-0000-0000-0000-000000000000',
            uuid_generate_v4 (),
            'authenticated',
            case when ROW_NUMBER() OVER () = 1 then 'postgres' else 'authenticated' end,
            'user' || (ROW_NUMBER() OVER ()) || '@example.com',
            crypt ('password123', gen_salt ('bf')),
            current_timestamp,
            current_timestamp,
            current_timestamp,
            case when ROW_NUMBER() OVER () = 1
                then '{"provider":"email","providers":["email"], "globalPermissions": ["Superuser"]}'::jsonb
            when ROW_NUMBER() over () = 2
                then '{"provider":"email","providers":["email"], "globalPermissions": ["Events_View"]}'::jsonb
            else '{"provider":"email","providers":["email"], "globalPermissions": []}'::jsonb
                end,
            '{}',
            current_timestamp,
            current_timestamp,
            '',
            '',
            '',
            ''
        FROM
            generate_series(1, 3)
    );

UPDATE "public"."profiles" p
SET name = split_part(u.email, '@', 1)
FROM "auth"."users" u
WHERE u.email LIKE '%example.com' AND
      p.id = u.id;

do $$
declare
    level_id int;
    season_id int;
    truck_route_id int;
    event_id uuid;
begin
    INSERT INTO "public"."levels" (name) VALUES ('FRC') RETURNING id INTO level_id;
    INSERT INTO "public"."seasons" (name, level_id, start_time, end_time) VALUES
        ('2024', level_id, current_timestamp - interval '1 month', current_timestamp + interval '1 year') RETURNING id INTO season_id;
    INSERT INTO "public"."truck_routes" (name) VALUES ('MI 1') RETURNING id INTO truck_route_id;

    INSERT INTO "public"."events" (
        season_id,
        key,
        code,
        sync_source,
        is_official,
        truck_route_id,
        start_time,
        end_time,
        status,
        name,
        time_zone
    ) values (
        season_id,
        'TESTTEST12',
        '9999micmp',
        'FrcEvents',
        false,
        truck_route_id,
        current_timestamp,
        current_timestamp + interval '1 month',
        'NotStarted',
        'Test Event',
        'America/Detroit'
    ) RETURNING id INTO event_id;

    INSERT INTO "public"."event_staffs" (event_id, user_id, permissions) VALUES (
        event_id,
        (select id from "auth"."users" where email = 'user3@example.com'),
        ARRAY ['Event_ManageEquipment', 'Event_View']
    );
end $$;