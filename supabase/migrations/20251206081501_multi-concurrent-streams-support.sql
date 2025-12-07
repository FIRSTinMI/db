alter table "public"."event_streams"
    add column if not exists "end_time" timestamp with time zone null,
    add column if not exists "primary" boolean default true not null;

update "public"."event_streams" s set end_time = s.start_time + interval '1 day' where end_time is null;


alter table "public"."event_streams"
    alter column "start_time" set not null,
    alter column "end_time" set not null;

drop view if exists "public"."event_current_stream";

create view "public"."event_current_stream" with(security_invoker=true) as (
  with qid(event_id, platform, url, title, start_time, end_time) as (
    select
      es.event_id,
      es.platform,
      case when es.platform = 'Youtube' then 'https://youtube.com/watch?v=' || es.internal_id
           when es.platform = 'Twitch' then 'https://twitch.tv/' || es.internal_id
      end,
      es.title,
      es.start_time,
      null
    from event_streams es
    where es.end_time > now() and es.primary
  )
  select e.code, coalesce(
      -- first try streams currently running
      (select json_agg(t) from (select es.url, es.title, es.platform from qid es where es.event_id = e.id and es.start_time < now() order by es.start_time asc, es.title asc) t),
      -- otherwise return the first stream(s)
      (select json_agg(t) from (select es.url, es.title, es.platform from qid es where es.event_id = e.id order by es.start_time asc limit 1 ) t)
    ) url from events e
    where exists(select 1 from event_streams es where e.id = es.event_id)
);