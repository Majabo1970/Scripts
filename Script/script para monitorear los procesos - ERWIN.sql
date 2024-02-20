print "Copyright Erwin Avila©"
print "----------------------"
go
/*
sp_who

-----------------
--- SHOW PLAN ---
-----------------
declare @w_sql varchar(255), @w_id int, @w_seg smallint, @w_inicio datetime

select @w_id = 105
select @w_seg = 10
select @w_inicio = getdate()
select @w_sql = "sp_showplan " + convert(varchar, @w_id) + ", null, null, null"

while 1=1
begin

   if exists (select 1 from master..sysprocesses where spid = @w_id)
      exec (@w_sql)
   else
      break

   waitfor delay "00:00:01"

   if abs(datediff(ss, getdate(), @w_inicio)) > @w_seg
      break
end

------------------------
-- PROCESOS HOLDEADOS --
------------------------
select 
db_name(dbid),
spid,
page, 
xactid, 
masterxactid, 
starttime, 
name, 
xloid
from master..syslogshold

*/
/*
------------------------
--- BLOQUEOS ACTIVOS ---
------------------------
select 
"db_name" = db_name(dbid),
"Table" = substring(object_name(id, dbid), 1, 35),
page,
"type" = 
case type
  when   1 then "Exclusive table lock"
  when   2 then "Shared table lock"
  when   3 then "Exclusive intent lock"
  when   4 then "Shared intent lock"
  when   5 then "Exclusive page lock"
  when   6 then "Shared page lock"
  when   7 then "Update page lock"
  when   8 then "Exclusive row lock"
  when   9 then "Shared row lock"
  when  10 then "Update row lock"
  when  11 then "Shared next key lock"
  when 253 then "Lock is blocking another process"
  when 512 then "Demand lock"
end,
spid,
class,
fid,
context --,
--row,
--loid
from master..syslocks

*/
------------------------
-- PROCESOS ACTIVOS ----
------------------------

select 
db_name = substring(db_name(dbid), 1, 20), 
spname = substring(object_name(id,dbid), 1, 35),
spid, 
--kpid,
status = case status
           when "sleeping" then "Wait on Disk I/O" -- or other resource"
           else status
         end,
hostname,
program_name,
--hostprocess,
cmd,
cpu,
physical_io,
memusage,
blocked,
stmtnum,
linenum,
Inicio = loggedindatetime,
'Tiempo Transcurrido' = datediff(mi, loggedindatetime, getdate()),
--batch_id = show_plan(spid, -1, -1, -1),
--context_id = show_plan(spid, show_plan(spid, -1, -1, -1), -1, -1),
--stmt_num = show_plan(spid, show_plan(spid, -1, -1, -1), show_plan(spid, show_plan(spid, -1, -1, -1), -1, -1), -1),
ipaddr
from 
   master..sysprocesses prc
where 
(
   cmd not in ('DEADLOCK TUNE', 'MIRROR HANDLER', 'PORT MANAGER', 'NETWORK HANDLER', 'SITE HANDLER','CHECKPOINT SLEEP', 'HK WASH', 'HK GC', 'HK CHORES')
   and 
   program_name not in ('Microsoft ISQL/w', 'Aqua_Data_Studio', 'DBISQL', 'SC_ASE_Plugin', 'Application Serv', 'Reentry start', 'REENTRY', '<astc>', 'Logger', 'DBArtisan', 'ASE isql', 'Rapid SQL', 'ISQL-32', 'Embarcadero Inte', 'JS Agent', 'distsrv')
  )
--*/
--   program_name in ('SQR', 'bcp')
--and program_name = 'bcp'
--and cmd = 'INSERT'


/*

select convert(varchar, dateadd(ss, datediff(ss, "2010/02/27 02:43:29", "2010/02/27 03:29:20"), "1900/01/01 00:0:00"), 108)


*/