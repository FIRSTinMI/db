drop view if exists "public"."event_dashboard";

create view "public"."event_dashboard" with (security_invoker = true) as (
  select
    e.*,
    case
      when (e.status in ('QualsInProgress', 'AwaitingAlliances'))
      then (
        select cast(m.match_number as text) || (case when m.play_number > 1 then 'P' || cast(m.play_number as text) else '' end)
        from public.matches m
        where m.event_id = e.id and m.tournament_level = 'Qualification' and m.post_result_time is not null
        order by m.post_result_time desc
        limit 1)
      when (e.status in ('PlayoffsInProgress', 'WinnerDetermined'))
      then (
        select cast(m.match_number as text) || (case when m.play_number > 1 then 'P' || cast(m.play_number as text) else '' end)
        from public.matches m
        where m.event_id = e.id and m.tournament_level = 'Playoff' and m.post_result_time is not null
        order by m.post_result_time desc
        limit 1)
      else null
      end last_match_num,
    case
      when (e.status in ('QualsInProgress', 'AwaitingAlliances'))
      then (
        select m.match_number
        from public.matches m
        where m.event_id = e.id and m.tournament_level = 'Qualification'
        order by m.match_number desc
        limit 1)
      when (e.status in ('PlayoffsInProgress', 'WinnerDetermined'))
      then (
        select m.match_number
        from public.matches m
        where m.event_id = e.id and m.tournament_level = 'Playoff'
        order by m.match_number desc
        limit 1)
      else null
      end level_matches,
    case
      when (e.status in ('QualsInProgress', 'AwaitingAlliances'))
      then (
        select m.scheduled_start_time
        from public.matches m
        where m.event_id = e.id and m.tournament_level = 'Qualification' and m.post_result_time is not null
        order by m.post_result_time desc
        limit 1)
      when (e.status in ('PlayoffsInProgress', 'WinnerDetermined'))
      then (
        select m.scheduled_start_time
        from public.matches m
        where m.event_id = e.id and m.tournament_level = 'Playoff' and m.post_result_time is not null
        order by m.post_result_time desc
        limit 1)
      else null
      end last_match_scheduled,
    case
      when (e.status in ('QualsInProgress', 'AwaitingAlliances'))
      then (
        select m.actual_start_time
        from public.matches m
        where m.event_id = e.id and m.tournament_level = 'Qualification' and m.post_result_time is not null
        order by m.post_result_time desc
        limit 1)
      when (e.status in ('PlayoffsInProgress', 'WinnerDetermined'))
      then (
        select m.actual_start_time
        from public.matches m
        where m.event_id = e.id and m.tournament_level = 'Playoff' and m.post_result_time is not null
        order by m.post_result_time desc
        limit 1)
      else null
      end last_match_actual
  FROM public.events e
);