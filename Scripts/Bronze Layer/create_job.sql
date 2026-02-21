/*
Create SQL Server Agent job to run bronze.load_bronze every day at 04:00 AM.
Run this script in `msdb` context (or in SSMS) as a login with permission to create Agent jobs.
*/
USE msdb;
GO

-- Job name
DECLARE @job_name SYSNAME = N'bronze.load_bronze_daily';
DECLARE @schedule_name SYSNAME = N'bronze.load_bronze_4am_daily';
DECLARE @database_name SYSNAME = N'DataWarehouse'; 
DECLARE @owner_login_var SYSNAME = SUSER_SNAME();

IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @job_name)
BEGIN
    PRINT 'Job already exists: ' + @job_name;
END
ELSE
BEGIN
    EXEC msdb.dbo.sp_add_job
        @job_name = @job_name,
        @enabled = 1,
        @description = N'Runs bronze.load_bronze daily at 04:00 AM',
        @owner_login_name = @owner_login_var;

    EXEC msdb.dbo.sp_add_jobstep
        @job_name = @job_name,
        @step_name = N'Execute bronze.proc_load_bronze',
        @subsystem = N'TSQL',
        @command = N'EXEC bronze.proc_load_bronze;',
        @database_name = @database_name,
        @on_success_action = 1; -- quit with success

    -- Create daily schedule at 04:00:00
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name = @schedule_name,
        @enabled = 1,
        @freq_type = 4,         -- daily
        @freq_interval = 1,     -- every day
        @active_start_time = 40000; -- 04:00:00

    EXEC msdb.dbo.sp_attach_schedule
        @job_name = @job_name,
        @schedule_name = @schedule_name;

    EXEC msdb.dbo.sp_add_jobserver
        @job_name = @job_name,
        @server_name = @@SERVERNAME;

    PRINT 'Created job: ' + @job_name + ' with schedule ' + @schedule_name;
END


-- To remove the job later use (run in msdb):
-- EXEC msdb.dbo.sp_delete_job @job_name = N'bronze.load_bronze_daily';
