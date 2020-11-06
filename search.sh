#!/bin/sh
#
## 수정일: 2004/06/25
#
# KM 3.0의 기본 설치 위치

# 기본 설치 위치
BASEDIR=/usr/local/kebi
BEEHIVE_DIR=${BASEDIR}/beehive2
BEEHIVE_JAR=beehive2.jar

java -classpath ${BEEHIVE_JAR}:lib/log4j-1.2.8.jar com.nara.beehive.main.bin.MailLogSearchStart  $*
