#!/usr/bin/env perl

# ������: 2004/09/14
#         hostname ���

$HOSTNAME=`hostname`;
chomp($HOSTNAME);

# 5300 ��Ʈ�� ���� �������� �����ؼ� state ������ ���

$RANGE = 0;
$NOARG = 1;

sub USAGE;
sub INT_TERM_HANDLER;

$ppid = $$;

$SIG{INT} = 'INT_TERM_HANDLER';
$SIG{TERM} = 'INT_TERM_HANDLER';

$MIN_INTERVAL = 1;
$MAX_INTERVAL = 3600;

$MIN_COUNT = 1;

# �⺻��
$INTERVAL = 0;
$COUNT = 0;

# ���ڰ� ���� ��� �ѹ��� ����
if ($#ARGV == -1) {
	$COUNT = 1;
}
elsif ($#ARGV == 0 || $#ARGV == 1) {
	if ($ARGV[0] < $MIN_INTERVAL || $ARGV[0] > $MAX_INTERVAL) {
		USAGE($RANGE);
	}
	$INTERVAL = $ARGV[0];
	if ($#ARGV == 1) {
		if ($ARGV[1] < $MIN_COUNT) {
			USAGE($RANGE);
		}
		$COUNT = $ARGV[1];
	}
}
else {
	USAGE($NOARG);
}

use Socket;

my $HOST = '127.0.0.1';
my $PORT = 5300;

my $IADDR = inet_aton($HOST);
my $PADDR = sockaddr_in($PORT, $IADDR);
my $PROTO = getprotobyname('tcp');

sub USAGE {
	local($TYPE) = shift;
	printf("%s [INTERVAL] [COUNT]\n", $0);
	printf("ex> %s : ���� ���� ǥ��\n", $0);
	printf("ex> %s 10 : 10�� �������� ��� state ����͸�\n", $0);
	printf("ex> %s 10 3 : 10��  �������� 3�� state ����͸�\n", $0);
	if ($TYPE == $RANGE) {
		printf(" INTERVAL RANGE : %d < INTERVAL < %d\n", $MIN_INTERVAL, $MAX_INTERVAL);
		printf(" COUNT RANGE : %d < COUNT\n", $MIN_COUNT);
	}
	exit(1);
}

sub INT_TERM_HANDLER {
	if ($ppid == $$) {
		while (waitpid(-1, WHOHANG) > 0) {
		}
	}
	else {
		QUIT();
	}
	exit(0);
}

sub CONNECT {
	socket(SOCK, PF_INET, SOCK_STREAM, $PROTO) or die("socket: $!");
	connect(SOCK, $PADDR) or die("connect: $!");
}

sub CLOSE {
	close(SOCK) or die("close: $!");
}

sub PASSWD {
	my $CMD = sprintf("pass kebi\r\n");
	send(SOCK, $CMD, 0) or die("send: $!");
}

sub STATE {
	my $CMD = sprintf("state\r\n");
	send(SOCK, $CMD, 0) or die("send: $!");
}

sub QUIT {
	my $CMD = sprintf("quit\r\n");
	send(SOCK, $CMD, 0) or die("send: $!");
}

sub GET {
	while (<SOCK>) {
		print;
	}
}

# ���� �ð�
sub GET_DATE {
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time());
	my $date = sprintf("%04d/%02d/%02d %02d:%02d:%02d", $year + 1900, $mon + 1, $mday, $hour, $min, $sec);
	return $date;
}

sub GET_LOAD {
	my $cmd = 'uptime';
	my $load = `$cmd`;
	my @data = split(' ', $load);
	my $str = sprintf("%s %s %s", $data[$#data - 2], $data[$#data - 1], $data[$#data]);
	return $str;
}

sub PUT_LOOP {
	my $cnt = 0;
	# ����, 5����, 15���� ����
	PASSWD();
	while (1) {
		$cnt++;
		$date = GET_DATE();
		$load = GET_LOAD();
		printf("[01;32m%s - %s : %s[00;00m\n", $HOSTNAME, $date, $load);
		STATE();
		if ($cnt == $COUNT) {
			last;
		}
		sleep ($INTERVAL);
	}
	QUIT();
}

sub FORK {
	# parent
	if ($pid = fork()) {
		if ($pid = fork()) {
		}
		elsif (defined $pid) {
			GET();
			exit(0);
		}
	}
	elsif (defined $pid) {
		PUT_LOOP();
		exit(0);
	}
}

sub WAIT_CHILD {
	while (waitpid(-1, WHOHANG) > 0) {
	}
}

# SMTP MONITORING PORT CONNECT
CONNECT();
# CHILD1: GET
# CHILD2: PUT
FORK();
# CONNECTION CLOSE
CLOSE();

# WAIT CHILD PROCESSS
WAIT_CHILD();
