c=`ps -ef|grep tomcat-8080/conf |grep -v grep |wc -l`
time=$(date +%Y-%m-%d\ %H:%M:%S)
echo $time
echo $c
if [ $c -eq 0 ]
then
        echo "tomcat over"
        echo `/opt/tomcat/tomcat-8080/bin/startup.sh`
        echo "tomcat start"
elif [ $c -gt 1 ]
then
        echo "tomcat Start the too much"
        echo `/opt/tomcat/tomcat-8080/bin/shutdown.sh`
        echo "tomcat close"
        echo `/opt/tomcat/tomcat-8080/bin/startup.sh`
        echo "tomcat start"
else
        echo "tomcat normal running"
fi