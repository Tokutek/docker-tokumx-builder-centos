FROM tianon/centos:5.10

ADD devtools-1.1.repo /etc/yum.repos.d/
ADD epel-release-5-4.noarch.rpm /tmp/
ADD virtualenv-1.11.4.tar.gz /tmp/

RUN echo multilib_policy=best >> /etc/yum.conf
RUN rpm -ivh /tmp/epel-release-5-4.noarch.rpm
RUN yum groupinstall -y 'Development Tools'
RUN yum install -y devtoolset-1.1 rpmdevtools git cmake28 ccache zlib-devel libpcap-devel pcre-devel readline-devel devtoolset-1.1-valgrind-devel python26 python26-devel

RUN ln -sn cmake28 /usr/bin/cmake
RUN (cd /tmp/virtualenv-1.11.4; scl enable devtoolset-1.1 'python26 setup.py install')
RUN virtualenv ~/venv
RUN echo "source ~/venv/bin/activate; scl enable devtoolset-1.1 'pip install buildbot-slave'" | /bin/bash

WORKDIR /data
CMD echo "source ~/venv/bin/activate; scl enable devtoolset-1.1 'buildslave start' && tail -f twistd.log" | /bin/bash
