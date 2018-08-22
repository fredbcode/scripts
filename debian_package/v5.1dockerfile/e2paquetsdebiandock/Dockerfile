FROM debian:9
MAINTAINER "numsys - @ - free.fr"
WORKDIR /home/compile
ARG COMMIT
ARG BUILD_DATE
ENV VERSION 5.1.2
ENV OS debian

LABEL commit.e2guardian=$COMMIT build_date.e2guardian=$BUILD_DATE
# COMPIL
RUN apt update \
&& apt install --no-install-recommends --no-install-suggests -y curl unzip base-files automake base-passwd \
bash coreutils dash debianutils diffutils dpkg e2fsprogs findutils grep gzip hostname ncurses-base \
libevent-pthreads-* libevent-dev ncurses-bin perl-base sed login sysvinit-utils tar bsdutils \
mount util-linux libc6-dev libc-dev gcc g++ make dpkg-dev autotools-dev debhelper dh-autoreconf dpatch \
libclamav-dev libpcre3-dev zlib1g-dev pkg-config libssl-dev libssl1.1 git ca-certificates lsb-release \
&& cd /home/compile && curl -k https://codeload.github.com/e2guardian/e2guardian/zip/v$VERSION > e2.zip && unzip e2.zip && cd e2guardian-$VERSION/ \
&& ./autogen.sh && ./configure  '--prefix=/usr' '--enable-clamd=yes' '--with-proxyuser=e2guardian' '--with-proxygroup=e2guardian' \
'--sysconfdir=/etc' '--localstatedir=/var' '--enable-icap=yes' '--enable-commandline=yes' '--enable-email=yes' \
'--enable-ntlm=yes' '--mandir=${prefix}/share/man' '--infodir=${prefix}/share/info' \
'--enable-pcre=yes' '--enable-sslmitm=yes' 'CPPFLAGS=-mno-sse2 -g -O2' \
&& make \
&& mkdir /etc/e2guardian && cp src/e2guardian /usr/sbin/ && mkdir /var/log/e2guardian \
&& mkdir -p /usr/share/e2guardian/languages && cp -Rf data/languages /usr/share/e2guardian/ && cp data/*.gif /usr/share/e2guardian/ && cp data/*swf /usr/share/e2guardian/ \
&& cp -Rf configs/* /etc/e2guardian/ \
&& adduser --no-create-home --system e2guardian \
&& addgroup --system e2guardian \
&& chmod 750 -Rf /etc/e2guardian && chmod 750 -Rf /usr/share/e2guardian && chown -Rf e2guardian /etc/e2guardian /usr/share/e2guardian /var/log/e2guardian \
&& find /etc/e2guardian -type f -name .in -delete \
&& find /usr/share/e2guardian -type f -name .in -delete \
# ROOT mode if needed ...
#&& sed -i "s/#daemonuser = 'e2guardian'/daemonuser = 'root'/g" /etc/e2guardian/e2guardian.conf \
#&& sed -i "s/#daemongroup = 'e2guardian'/daemongroup = 'root'/g" /etc/e2guardian/e2guardian.conf \
#&& sed -i "s/#dockermode = off/dockermode = on/g" /etc/e2guardian/e2guardian.conf 
# CREATE PACKAGE
&& apt-get install -y git binutils && git clone https://github.com/fredbcode/scripts \
&& cd scripts/debian_package \
&& cp /usr/sbin/e2guardian e2"$OS"_package/data/usr/sbin \
&& cp -Rf /etc/e2guardian e2"$OS"_package/data/etc/ \
&& cp /home/compile/e2guardian-$VERSION/data/scripts/e2guardian.service e2"$OS"_package/data/lib/systemd/system \
&& VFULL=`/usr/sbin/e2guardian -v | sed -n 1p | cut -d " " -f 2` \
&& sed -i "s/Version:.*$/Version: "$VFULL"/g" e2"$OS"_package/control/control \
&& SIZE=`stat -c %s e2"$OS"_package/data` && echo $SIZE \ 
&& sed -i "s/Installed-Size:.*$/Installed-Size: "$SIZE"/g" e2"$OS"_package/control/control && cat e2"$OS"_package/control/control \  
&& ./rebuild.sh e2"$OS"_package \
&& OSFULL=`lsb_release -cs` \ 
&& cp e2"$OS"_package.deb e2guardian_"$OS"_"$OSFULL"_package.deb \
&& cp e2"$OS"_package.deb /tmp/e2guardian_"$OS"_"$OSFULL"_package.deb 

EXPOSE 8080
CMD /usr/sbin/e2guardian -N
