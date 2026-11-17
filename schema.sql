-- 小厨房 · 数据库初始化
-- 用法：Supabase 项目 → 左侧 SQL Editor → 新建查询 → 粘贴全部 → Run

create table if not exists public.orders (
  id          uuid primary key default gen_random_uuid(),
  items       jsonb       not null default '[]'::jsonb,
  answers     jsonb       not null default '{}'::jsonb,
  note        text        not null default '',
  status      text        not null default 'pending',   -- pending / accepted / done / passed
  chef_reply  text        not null default '',
  created_at  timestamptz not null default now(),
  status_at   timestamptz
);

create index if not exists orders_created_at_idx on public.orders (created_at desc);

-- 权限：链接本身就是口令，匿名可读写（俩人用的私用小站）
alter table public.orders enable row level security;

drop policy if exists "kitchen read"   on public.orders;
drop policy if exists "kitchen insert" on public.orders;
drop policy if exists "kitchen update" on public.orders;
drop policy if exists "kitchen delete" on public.orders;

create policy "kitchen read"   on public.orders for select using (true);
create policy "kitchen insert" on public.orders for insert with check (true);
create policy "kitchen update" on public.orders for update using (true) with check (true);
create policy "kitchen delete" on public.orders for delete using (true);

-- 开启实时推送（少了这一步，页面不会自动跳单）
alter publication supabase_realtime add table public.orders;

-- 顺手保留最近 500 单即可，多的自己删
-- delete from public.orders where created_at < now() - interval '90 days';
