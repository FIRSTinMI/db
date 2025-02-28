create or replace view "public"."event_match_video_stats" with (security_invoker=true) as SELECT e.id,
    e.name,
    e.start_time,
    e.end_time,
    ( SELECT (count(*))::integer AS count
           FROM matches mq
          WHERE ((e.id = mq.event_id) AND (mq.tournament_level = 'Qualification'::tournament_level) AND (NOT mq.is_discarded) AND (mq.actual_start_time IS NOT NULL))) AS num_qual,
    ( SELECT (count(*))::integer AS count
           FROM matches mqv
          WHERE ((e.id = mqv.event_id) AND (mqv.tournament_level = 'Qualification'::tournament_level) AND (NOT mqv.is_discarded) AND (mqv.actual_start_time IS NOT NULL) AND (mqv.match_video_link IS NOT NULL))) AS num_qual_videos,
    ( SELECT (count(*))::integer AS count
           FROM matches mql
          WHERE ((e.id = mql.event_id) AND (mql.tournament_level = 'Qualification'::tournament_level) AND (NOT mql.is_discarded) AND (mql.actual_start_time IS NOT NULL) AND (mql.actual_start_time <= (now() - '00:30:00'::interval)) AND (mql.match_video_link IS NULL))) AS num_late_qual_videos,
    ( SELECT (count(*))::integer AS count
           FROM matches mp
          WHERE ((e.id = mp.event_id) AND (mp.tournament_level = 'Playoff'::tournament_level) AND (NOT mp.is_discarded) AND (mp.actual_start_time IS NOT NULL))) AS num_playoff,
    ( SELECT (count(*))::integer AS count
           FROM matches mpv
          WHERE ((e.id = mpv.event_id) AND (mpv.tournament_level = 'Playoff'::tournament_level) AND (NOT mpv.is_discarded) AND (mpv.actual_start_time IS NOT NULL) AND (mpv.match_video_link IS NOT NULL))) AS num_playoff_videos,
    ( SELECT (count(*))::integer AS count
           FROM matches mpl
          WHERE ((e.id = mpl.event_id) AND (mpl.tournament_level = 'Playoff'::tournament_level) AND (NOT mpl.is_discarded) AND (mpl.actual_start_time IS NOT NULL) AND (mpl.actual_start_time <= (now() - '00:30:00'::interval)) AND (mpl.match_video_link IS NULL))) AS num_late_playoff_videos
   FROM events e
  WHERE ((e.start_time <= now()) AND (e.end_time >= now()));



