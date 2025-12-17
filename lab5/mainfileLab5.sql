SHOW wal_level;
SHOW synchronous_commit;
SHOW max_wal_size;
SHOW min_wal_size;
SHOW wal_compression;
SHOW checkpoint_timeout;
SHOW checkpoint_completion_target;
SHOW archive_mode;
SHOW archive_command;

select pg_current_wal_lsn() as lsn,
       pg_walfile_name(pg_current_wal_lsn()) as wal_filename;

select * from pg_ls_waldir();


drop table if exists public.test_wal;
create table public.test_wal(
  id bigserial primary key,
  data text not null
);


insert into public.test_wal(data)
select repeat('a', 10000)
from generate_series(1, 50000);

select count(*) as rows_cnt from public.test_wal;



select pg_current_wal_lsn() as lsn,
       pg_walfile_name(pg_current_wal_lsn()) as wal_filename;
select * from pg_ls_waldir();



insert into public.test_wal(data)
select repeat('b', 10000)
from generate_series(1, 20000);


checkpoint;

select * from pg_stat_checkpointer;
select pg_current_wal_lsn() as lsn,
       pg_walfile_name(pg_current_wal_lsn()) as wal_filename;



insert into public.test_wal(data)
values ('THIS_ROW_WAS_ADDED_AFTER_DUMP');
select count(*) as rows_cnt from public.test_wal;
select data from public.test_wal
order by id desc
limit 3;



