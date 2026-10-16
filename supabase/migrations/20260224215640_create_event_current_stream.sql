alter table public.event_streams add column short_title varchar(150) null;

drop view public.event_current_stream;
create view public.event_current_stream with (security_invoker = on) as
with
  qid (
    event_id,
    platform,
    watch_url,
    embed_code,
    title,
    short_title,
    start_time,
    end_time
  ) as (
    select
      es.event_id,
      es.platform,
      case
        when es.platform = 'Youtube'::stream_platform then 'https://youtube.com/watch?v='::text || es.internal_id::text
        when es.platform = 'Twitch'::stream_platform then 'https://twitch.tv/'::text || es.internal_id::text
        else null::text
      end as watch_url,
      case
        when es.platform = 'Youtube'::stream_platform then (
          '<iframe src="https://www.youtube-nocookie.com/embed/'::text || es.internal_id::text
        ) || '?rel=0" width="100%" height="100%" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>'::text
        when es.platform = 'Twitch'::stream_platform then (
          '<iframe src="https://player.twitch.tv/?channel='::text || es.channel_id::text
        ) || '&parent=fimav.us" height="100%" width="100%" allowfullscreen></iframe>'::text
        else null::text
      end as embed_code,
      es.title,
      es.short_title,
      es.start_time,
      es.end_time
    from
      event_streams es
    where
      es."primary"
    order by
      es.start_time,
      es.title
  )
select
  code,
  name,
  EXTRACT(
    year
    from
      start_time
  ) as year,
  case
    when e.sync_source = 'FtcEvents' then 'https://ftc-events.firstinspires.org/' || EXTRACT(year from start_time) || '/' || e.code
    when e.sync_source = 'FrcEvents' then 'https://frc-events.firstinspires.org/' || EXTRACT(year from start_time) || '/' || e.code
    when e.sync_source = 'BlueAlliance' then 'https://thebluealliance.com/event/' || e.code
  end as event_info_url,
  start_time <= CURRENT_TIMESTAMP
  and end_time >= CURRENT_TIMESTAMP as is_current,
  case
    when end_time > now() then COALESCE(
      (
        select
          json_agg(t.*) as json_agg
        from
          (
            select
              es.watch_url,
              es.embed_code,
              es.title,
              es.short_title,
              es.platform
            from
              qid es
            where
              es.event_id = e.id
              and es.start_time < now()
              and es.end_time > now()
          ) t
      ),
      (
        select
          json_agg(t.*) as json_agg
        from
          (
            select
              es.watch_url,
              es.embed_code,
              es.title,
              es.short_title,
              es.platform
            from
              qid es
            where
              es.event_id = e.id
              and es.start_time = (
                (
                  select
                    min(x.start_time) as min
                  from
                    qid x
                  where
                    x.event_id = e.id
                )
              )
          ) t
      )
    )
    else (
      select
        json_agg(t.*) as json_agg
      from
        (
          select
            es.watch_url,
            es.embed_code,
            es.title,
            es.short_title,
            es.platform
          from
            qid es
          where
            es.event_id = e.id
        ) t
    )
  end as url
from
  events e
where
  (
    exists (
      select
        1
      from
        event_streams es
      where
        e.id = es.event_id
    )
  );
