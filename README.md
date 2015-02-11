### Tate-Server - Requires mazacoind!

# Tate Server provides electrum SPV services for lightweight clients for MZC

This image will install dependencies and tate-server from mazaclub sources

Based on phusion/baseimage - this image uses /sbin/my_init as the ENTRYPOINT

 - /sbin/my_init will start <code>/etc/service/tate-server/run</code> and restart if it crashes
 - my_init and 'run' will start <code>/app/start.sh</code> will will construct
   <code>/etc/tate.conf</code> from environment variables.


# Usage

A simple start script is provided in the github source repo as an example. 

This image expects to find your mazacoind blockdata and mazacoin.conf in
<code>/home/maza/.mazacoin</code> 
and be owned by UID:GID 2211:2211 (maza:maza)

 * This image has VOLUMES at
   - <code>/home/maza</code>
   - <code>/var/tate-server</code>
 * It's highly recommended to use host bindmounts for data permanence.
   - <code> -v /full/host/path:/home/maza</code>
 * If you run mazacoind in a separate image on the same host, and don't use coreos/flannel
   - <code>--link mazacoind_container:mazacoind</code> will expose mazacoind as host "mazacoind"
   - It is preferred to not have mazacoind RPC ports exposed to the host network - use flanneld or --link 
 * If you server tate data via SSL, be sure to mount certs!
   - <code>-v /some/path/to/certs:/app/certs</code>
   - default is <code>tate.pem</code> and <code>tate.key</code>


The startup script for tate-server provided will acquire 
the values needed to configure tate.conf from environment variables

These can be easily set in your <code>docker run</code> statement:
```
docker run -d \ 
  -h "${HOSTNAME}" \
  --name=${NAME} \
  --restart=always \
  --link ${GROUP}_mazacoind:mazacoind \
  -p 50002:50002 \ 
  -p 8000:8000 \
  -p 50001:50001 \
  -e USER=maza \
  -e HOSTNAME=your.external.fqdn \
  -e MAZACOIND=your-mazacoind.local \
  -v ${HOST_DATA_PREFIX}/certs:/app/certs \
  -v ${HOST_DATA_PREFIX}/mazacoind:${MAZADIR} \
  -v ${HOST_DATA_PREFIX}/tate-data:${DATA_VOLDIR} \ 
  mazaclub/tate-server
```

The following variables can be set with additional <code> "-e VAR=value \"</code> lines in the <code>docker run</code> statement.
Defaults are provided.
```
USER=${USER:-maza}
TATE_HOSTNAME=${TATE_HOSTNAME:-${HOSTNAME}}
TATE_PORT=${TATE_PORT:-50001}
TATE_SSLPORT=${TATE_SSL_PORT:-50002}
MAZACOIND=${MAZACOIND:-mazacoind}
MAZADIR=${MAZADIR:-/home/${USER}/.mazacoin}
RPCPORT=${RPCPORT:-12832}
RPCUSER=${RPCUSER:-$(grep rpcuser ${MAZADIR}/mazacoin.conf |awk -F= '{print $2}')}
RPCPASSWORD=${RPCPASSWORD:-$(grep rpcpassword ${MAZADIR}/mazacoin.conf |awk -F= '{print $2}')}
```


