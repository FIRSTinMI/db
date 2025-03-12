drop view "public"."event_match_video_stats";

create view "public"."event_match_video_stats" with(security_invoker=true) as (
    select
    e.id,
    e.name,
    e.start_time,
    e.end_time,
    (
        select
        count(*)::integer as count
        from
        matches mq
        where
        e.id = mq.event_id
        and mq.tournament_level = 'Qualification'::tournament_level
        and not mq.is_discarded
        and mq.actual_start_time is not null
    ) as "numQual",
    (
        select
        count(*)::integer as count
        from
        matches mqv
        where
        e.id = mqv.event_id
        and mqv.tournament_level = 'Qualification'::tournament_level
        and not mqv.is_discarded
        and mqv.actual_start_time is not null
        and mqv.match_video_link is not null
    ) as "numQualVideos",
    (
        select
        array_agg(
            COALESCE(
            mql.match_name,
            concat('Qual ', mql.match_number)::character varying
            )
            order by
            mql.match_number,
            mql.play_number
        ) as array_agg
        from
        matches mql
        where
        e.id = mql.event_id
        and mql.tournament_level = 'Qualification'::tournament_level
        and not mql.is_discarded
        and mql.actual_start_time is not null
        and mql.actual_start_time <= (now() - '00:30:00'::interval)
        and mql.match_video_link is null
    ) as "lateQualVideos",
    (
        select
        count(*)::integer as count
        from
        matches mp
        where
        e.id = mp.event_id
        and mp.tournament_level = 'Playoff'::tournament_level
        and not mp.is_discarded
        and mp.actual_start_time is not null
    ) as "numPlayoff",
    (
        select
        count(*)::integer as count
        from
        matches mpv
        where
        e.id = mpv.event_id
        and mpv.tournament_level = 'Playoff'::tournament_level
        and not mpv.is_discarded
        and mpv.actual_start_time is not null
        and mpv.match_video_link is not null
    ) as "numPlayoffVideos",
    (
        select
        array_agg(
            COALESCE(
            mpl.match_name,
            concat('Playoff ', mpl.match_number)::character varying
            )
            order by
            mpl.match_number,
            mpl.play_number
        ) as array_agg
        from
        matches mpl
        where
        e.id = mpl.event_id
        and mpl.tournament_level = 'Playoff'::tournament_level
        and not mpl.is_discarded
        and mpl.actual_start_time is not null
        and mpl.actual_start_time <= (now() - '00:30:00'::interval)
        and mpl.match_video_link is null
    ) as "latePlayoffVideos"
    from
    events e
    where e.is_official
);
