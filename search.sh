#!/bin/sh
#
## ������: 2004/06/25
#
# KM 3.0�� �⺻ ��ġ ��ġ

# �⺻ ��ġ ��ġ
BASEDIR=/usr/local/kebi
BEEHIVE_DIR=${BASEDIR}/beehive2
BEEHIVE_JAR=beehive2.jar

java -classpath ${BEEHIVE_JAR}:lib/log4j-1.2.8.jar com.nara.beehive.main.bin.MailLogSearchStart  $*
