#!/bin/bash -x
IMAGE="mazaclub/tate-server"
GROUP="tate"
APP="tateserver"
HOST_DATA_PREFIX="/opt/data/tate-server"
MAZADIR="/home/maza/.mazacoin"
DATA_VOLDIR="/var/tate-server"
HOSTNAME="YOUR.EXTERNAL.FQDN"
NAME="${GROUP}_${APP}"
#DATA=
#APPDATA=tatedata
#DATADIR=/data/tate-server
#DAEMON_DATA=mazablocks
#VOLUME_DAEMON=${GROUP}_${DAEMON_DATA}
#VOLUME_DATA=${GROUP}_${APPDATA}
#PORT1="-p 50001:50003"
#PORT2="-p 50002:50004"
#PORT3="-p 8000:8000"

#check_data () {
# docker ps -a |grep ${GROUP}_${APPDATA} || docker run -d --name=${GROUP}_${APPDATA} -v ${DATA_VOLDIR}  ${DATA}
#

run () {
#check_data
docker run -d \
  -h "${HOSTNAME}" \
  --name=${NAME} \
  --restart=always \
  --link ${GROUP}_mazacoind:mazacoind \
  -p 50002:50002 \
  -p 8000:8000 \
  -v ${HOST_DATA_PREFIX}/mazacoind:${MAZADIR}
  -v ${HOST_DATA_PREFIX}/tate-data:${DATA_VOLDIR}
  ${IMAGE}

}

start () {
docker start ${NAME}
}
stop () {
docker stop ${NAME}
}

remove () {
docker rm ${NAME}
}


case ${1} in
 remove) remove
	;;
  start) start
	;;
   stop) stop
	;;
    run) run
	;;
      *) echo "Usage: ${0} [run|start|stop|remove]"
	;;
esac
