# 小厨房 · GitHub Pages 版

纯静态网页 + Supabase 免费实时数据库。电脑关机、人在外地都能用，链接永久有效。

## 三步上线

### 1. 建仓库（网页操作，不用命令行）

1. 打开 https://github.com/new
2. Repository name 填 `menu`，选 **Public**（Pages 免费），点 Create
3. 页面上点 **uploading an existing file**，把本文件夹里的 **5 个文件**全部拖进去（`index.html`、`style.css`、`supabase.js`、`schema.sql`、`.nojekyll`），Commit

### 2. 开 Pages

仓库 → **Settings → Pages** → Source 选 `Deploy from a branch` → Branch 选 `main`、目录 `/ (root)` → Save。

等 1 分钟，链接就是：

```
https://你的用户名.github.io/menu/
```

（`schema.sql` 和 `.nojekyll` 不需要被访问，放着即可；`supabase.js` 是本地打包的 SDK，别删，删了页面打不开。）

### 3. 建数据库

1. https://supabase.com 用 GitHub 登录，**New project**，区域选 **Singapore**，密码随便设一个记住
2. 项目建好后 → 左侧 **SQL Editor** → New query → 打开本项目 `index.html` 同目录那个 `schema.sql`，全选复制粘贴进去 → **Run**
3. 左侧 **Project Settings → API**，复制两样东西：
   - `Project URL`（形如 `https://abcd1234.supabase.co`）
   - `anon public` key（`eyJ...` 开头的一长串）

### 4. 生成链接

浏览器打开你的 Pages 链接 → 粘贴上面两个值 → 点「生成两个链接」→ 得到：

- **她的链接** `...#mode=order&s=...` ← 发给她
- **你的链接** `...#mode=chef&s=...`  ← 自己存书签

配置都编码在链接里，**不用改代码，不用重新部署**。以后想换数据库，重新生成一次就行。

## 日常

- 她：打开链接 → 挑菜 → 发给他。手机浏览器「添加到主屏幕」当 App 用。
- 你：打开你的链接 → 新单实时跳出来（带提示音；iOS 需要点一次「📣 通知」授权）。

## 常见问题

**页面说「读不到数据」**
`schema.sql` 没跑，或者 URL/key 填错。重跑一遍 SQL 最快。

**新单不会自动出现，刷新才有**
`alter publication supabase_realtime add table public.orders;` 这句没执行成功。去 SQL Editor 单独跑一次。

**Supabase 免费额度**
数据库 500MB、每月 5GB 流量、项目 7 天不活动会被暂停（有请求就算活动，日常用不会停）。点菜这点数据用十年也用不完。

**安全**
链接里的 `s=` 就是数据库地址 + anon key，属于「拿到链接就能读写」。自己是私用没问题，别把链接贴到群里。
`anon key` 是 Supabase 设计为可公开的，真正的权限由 RLS 控制；这里为了俩人方便是全开的。

**想换成自己的域名**
Pages → Settings → Pages → Custom domain 填域名，再在 DNS 加一条 CNAME 指向 `你的用户名.github.io`。

**想清空订单**
Supabase → Table Editor → orders → 全选删除；或 SQL：`delete from public.orders;`

## 数据结构

| 字段 | 说明 |
|---|---|
| `items` | `[{id,name,emoji,group,qty}]` |
| `answers` | 辣度/时间/心情等选项 |
| `note` | 她的自由备注 |
| `status` | `pending` / `accepted` / `done` / `passed` |
| `chef_reply` | 你的回话 |
| `created_at` / `status_at` | 时间 |

想加菜：直接改 `index.html` 里的 `MENU` 数组，Push 一次就生效。
