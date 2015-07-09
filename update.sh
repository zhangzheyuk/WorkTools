#!/bin/bash
pmc_service_path='/opt/xdja/tomcat-pmc'
pmc_path='/opt/xdja/pmc'

#停止tomcat
function stop_tomcat(){

for i in $*

    do
        #检查服务是否开启
        service_pid=`ps -ef |grep $i |grep -v grep | awk '{print $2}'`
#       ecss_pid=`ps -ef | grep tomcat |grep $server_name_1  |grep -v grep | awk '{print $2}'`

        if [ -z $service_pid  ]; then
                echo "$i tomcat 服务未启动"
        else
                echo "$i $tomcat 服务pid为$service_pid"
                #停止pmc服务
                kill -9 $service_pid
                service_pid=`ps -ef | grep tomcat |grep $i  |grep -v grep | awk '{print $2}'`
                #[ -z $n ] && echo "k不存在" || echo "k存在"
                [ -z $service_pid  ] && echo "$i tomcat 服务已停止" || echo "$i tomcat  服务pid为$mdms_pid  服务停止......fail"
        fi
    done
}

#启动tomcat
function start_tomcat(){
        #重启服务
#       sh /usr/local/src/ecss-tomcat/bin/startup.sh
        sh $1/bin/startup.sh
        service_pid=`ps -ef |grep $1  |grep -v grep | awk '{print $2}'`
        [ -z $service_pid  ] && echo "$1 tomcat  服务启动失败" || echo "$1 tomcat  服务启动成功   pid为$service_pid "
}

unzip -o pmc-[0-9]*.war -d pmc
unzip -o pmc-web*.war -d pmc-web
unzip -o pmc-service*.war -d pmc-service
echo "=====解压成功====================="

\cp -f  cfg/pmc-web/* pmc-web/WEB-INF/classes/ 
\cp -f  cfg/pmc-service/* pmc-service/WEB-INF/classes/ 
\cp -f  cfg/pmc/* pmc/WEB-INF/classes/
echo "=====替换配置成功=================" 

#停止Pmc以及tomcat-pmc服务
stop_tomcat /opt/xdja/pmc /opt/xdja/tomcat-pmc
echo "=====停止个人中心服务成功========="
sleep 3

#删除缓存文件
rm -rf $pmc_service_path/work/*
rm -rf $pmc_serivce_path/logs/*
rm -rf $pmc_path/work/*
rm -rf $pmc_path/logs/*
echo "=====删除tomcat缓存文件成功======="

#删除webapp
rm -rf $pmc_service_path/webapps/pmc-service
rm -rf $pmc_service_path/webapps/pmc-web
rm -rf $pmc_path/webapps/pmc
echo "=====删除webapp成功==============="

#替换webapp
mv pmc-service $pmc_service_path/webapps/
mv pmc-web $pmc_service_path/webapps/
mv pmc $pmc_path/webapps/pmc
echo "=====更换webapp成功==============="

#重启tomcat
start_tomcat /opt/xdja/tomcat-pmc
sleep 5
start_tomcat /opt/xdja/pmc
echo "======重启tomcat成功==============="
