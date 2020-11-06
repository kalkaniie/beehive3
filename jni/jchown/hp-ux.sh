#!/bin/sh

# HP-UX���� jni ������ ���
# cc�� ��ġ�Ǿ� �־�� ��

if [ "${JAVA_HOME}" = "" ]
then
	echo "JAVA_HOME ������ ������ �ּ���"
	echo "  ex> sh,bash: export JAVA_HOME=/usr/java"
	echo "  ex> csh : setenv JAVA_HOME /usr/java"
	exit 1;
fi

SOURCENAME=com_nara_naramail_jni_Chown
LIBNAME=libbeehive_jchown
INCLUDE="-I${JAVA_HOME}/include -I${JAVA_HOME}/include/hp-ux"

FLAG=

for i in `echo ${PATH} | awk -F: '{ for (i = 1; i <= NF; i++) print $i}'`
do
	[ "${i}" = "" ] && continue
	if [ ! -h ${i}/cc -x ${i}/gcc ]
	then
		FLAG=gcc
		break
	fi
done

if [ "${FLAG}" = "" ]
then
	for i in `echo ${PATH} | awk -F: '{ for (i = 1; i <= NF; i++) print $i}'`
	do
		if [ ! -h ${i}/cc -a -x ${i}/cc ]
		then
			FLAG=cc
			break
		fi
	done
fi


if [ "${FLAG}" = "gcc" ]
then
	# gcc�� ��ġ �Ǿ� �ִ� ���
	gcc -fPIC -Wall -c ${INCLUDE} ${SOURCENAME}.c
elif [ "${FLAG}" = "cc" ]
then
	# cc�� ��ġ �Ǿ� �ִ� ���
	cc -Aa -Ae -c +z ${INCLUDE} ${SOURCENAME}.c
else
	echo "COMPILER CHECK ERROR"
	echo "Require gcc or cc"
	exit 1
fi


ld -b -o ${LIBNAME}.sl ${SOURCENAME}.o && cp ${LIBNAME}.sl /usr/lib/
