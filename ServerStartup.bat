@echo off

echo Now Starting ARMA 3 Server
cd F:\Arma3server\Arma 3 Server
start "arma3" /min /high /affinity 30 "arma3server.exe" -mod=@Epoch;-mod=@epochhive;@m3editor;@sem;@ZEVMission; -config=F:\Arma3server\Arma 3 Server\TADST\sx\TADST_config.cfg -ip=127.0.0.1 -port=2302 -profiles=F:\Arma3server\Arma 3 Server\TADST\sx -cfg=F:\Arma3server\Arma 3 Server\TADST\sx\TADST_basic.cfg -name=SX
timeout 10
echo ARMA 3 Server has lunched
timeout 1

exit 

echo Now Starting Database
cd D:\Servers\Arma 3 Server\DB
START redis-server.exe redis.conf
timeout 1
echo Database has Started
timeout 6


-autoInit -loadMissionToMemory