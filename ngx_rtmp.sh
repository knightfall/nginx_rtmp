#!/bin/bash
apt update && apt upgrade -y
apt install build-essential libpcre3 libpcre3-dev libssl-dev zlib1g zlib1g-dev -y
cd /root
mkdir nginx && cd nginx
wget http://nginx.org/download/nginx-1.18.0.tar.gz
tar -xvf nginx-1.18*
git clone https://github.com/sergey-dryabzhinsky/nginx-rtmp-module.git
git clone https://github.com/vozlt/nginx-module-vts.git
cd nginx-1.18.0
./configure \
--with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -fPIC -D_FORTIFY_SOURCE=2' \
--with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -fPIC' --prefix=/usr/share/nginx \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--http-log-path=/var/log/nginx/access.log \
--error-log-path=/var/log/nginx/error.log \
--lock-path=/var/lock/nginx.lock \
--pid-path=/run/nginx.pid \
--modules-path=/usr/lib/nginx/modules \
--http-client-body-temp-path=/var/lib/nginx/body \
--http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
--http-proxy-temp-path=/var/lib/nginx/proxy \
--http-scgi-temp-path=/var/lib/nginx/scgi \
--http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
--with-debug \
--with-compat \
--with-file-aio \
--with-pcre-jit \
--with-http_ssl_module \
--with-http_stub_status_module \
--with-http_realip_module \
--with-http_auth_request_module \
--with-http_v2_module \
--with-http_dav_module \
--with-http_slice_module \
--with-threads \
--with-http_addition_module \
--with-http_sub_module \
--with-stream=dynamic \
--with-stream_ssl_module \
--with-stream_ssl_preread_module \
--add-module=../nginx-rtmp-module \
--add-module=../nginx-module-vts
make -j 2
make install 
mkdir /usr/lib/nginx
cd ..
wget https://raw.githubusercontent.com/knightfall/nginx_rtmp/master/nginx -O /etc/init.d/nginx
wget https://raw.githubusercontent.com/knightfall/nginx_rtmp/master/conf/nginx.conf -O /etc/nginx/nginx.conf
chmod +x /etc/init.d/nginx
update-rc.d -f nginx defaults
systemct start nginx



