FROM centos:centos6

ADD devtools-1.1.repo /etc/yum.repos.d/
ADD epel-release-6-8.noarch.rpm /tmp/

RUN echo multilib_policy=best >> /etc/yum.conf
RUN rpm -ivh /tmp/epel-release-6-8.noarch.rpm
RUN yum groupinstall -y 'Development Tools'
RUN yum install -y devtoolset-1.1 rpmdevtools git cmake28 ccache zlib-devel libpcap-devel pcre-devel readline-devel valgrind-devel python-devel python-pip

RUN ln -sn cmake28 /usr/bin/cmake
RUN scl enable devtoolset-1.1 'pip install buildbot-slave'

WORKDIR /data
CMD scl enable devtoolset-1.1 'buildslave start' && tail -f twistd.log
