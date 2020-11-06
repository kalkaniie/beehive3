@echo off
SET /p PID=<beehive3.pid
DEL beehive-pid
TASKKILL /F /PID %PID%
echo Beehive MTA Shutdown Completed.