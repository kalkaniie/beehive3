#!/usr/bin/env perl

# beehive에서 현재 처리되고 있는 메일의 상태를 간단한
# 형식으로 보여줌
# local, local_lock, remote, remote_lock 부분의
# 현재 처리되고 있는 숫자와
# From, To 메일 주소, 메일의 상태를 보여줌

# 인자로 트적 queue의 상태만을 보고자 하면
# mailq.pl local 과 같이 적어주면 해당 디렉토리에 대해서만 출력

my $BASEDIR = '/var/spool/naramail/mqueue';

use File::stat;

my $CURRENT_TIME = time();

my $ONE_DAY = 86400;

my $BUFFSIZE = 2048;

sub PRINT_BAR {
	printf("-------------------------------------------------------------------------------\n");
}

sub numerically { $a <=> $b; };

sub GET_FILES {
	local($dir) = shift;
	opendir(DIR, $dir);
	my @files = sort(numerically grep(!/\.\.?$/, readdir(DIR)));
	closedir(DIR);
	return @files;
}

sub GET_HEADER {
	local($file) = shift;
	open(IN, "< $file") or return;
	read(IN, my $Buff, $BUFFSIZE);
	close(IN);

	#my $st = stat($file);

	my $Name_index = index($Buff, 'Name=') + 5;
	my $From_index = index($Buff, 'From=') + 5;
	my $To_index = index($Buff, 'To=') + 3;
	my $Kind_index = index($Buff, 'Kind=') + 5;
	my $Msg_index = index($Buff, 'ErrMessage=') + 11;
	my $Retry_index = index($Buff, 'Retry=') + 6;

	my $Name = substr($Buff, $Name_index, index($Buff, "\n", $Name_index) - $Name_index);
	my $From = substr($Buff, $From_index, index($Buff, "\n", $From_index) - $From_index);
	my $To = substr($Buff, $To_index, index($Buff, "\n", $To_index) - $To_index);
	my $Kind = substr($Buff, $Kind_index, index($Buff, "\n", $Kind_index) - $Kind_index);
	my $Msg = substr($Buff, $Msg_index, index($Buff, "\n", $Msg_index) - $Msg_index);
	my $Retry = substr($Buff, $Retry_index, index($Buff, "\n", $Retry_index) - $Retry_index);

	printf("%2s<%s> %s -> %s (%s)\n", '', $Name, $From, $To, $Kind);


	# file명에 unixtimestamp형식의 시간이 들어 있음
	# java에서 unixtimestamp에는 ms까지 포함되어 있으므로
	# 1000으로 나눠줌
	my $mtime = $file;
	$mtime =~ s/.*\///;
	$mtime =~ s/\..*//;
	$mtime = int($mtime / 1000);


	my ($sec, $min, $hour, $mday, $mon, $year, $wady, $yday, $isdst) = localtime($mtime);
	my $date = sprintf("%s/%02s/%02s %02s:%02s:%02s", $year + 1900, $mon + 1, $mday, $hour, $min, $sec);

	if ($mtime < $CURRENT_TIME - $ONE_DAY) {
		printf("%5s%s\n", '', $date);
	}
	else {
		printf("%5s%s\n", '', $date);
	}

	if ($Kind ne 'normal') {
		$Msg =~ s/java.io..*Exception: //;
		printf("%5sErr:%s Retry:%d\n", '', $Msg, $Retry);
	}
}

sub GET_QUEUE_INFO {
	local($dir) = shift;

	my $tmp = $dir;
	$tmp =~ s/.*\///;
	
	my @file = GET_FILES($dir);
	printf("%s: %d\n", $tmp, $#file + 1);
	if ($#file > -1) {
		foreach $x (@file) {
			GET_HEADER("$dir/$x");
		}
		printf("%s: %d\n", $tmp, $#file + 1);
	}
	return ($#file + 1);
}


my @DIRS = ('intd', 'local', 'local_lock', 'remote', 'remote_lock');

if ($#ARGV == 0) {
	if (-d "$BASEDIR/$ARGV[0]") {
		@DIRS = $ARGV[0];
	}	
}

my $total_cnt = 0;

foreach my $dir (@DIRS) {
	PRINT_BAR();
	if ($dir eq 'intd') {
		my $intd_cnt = 0;
		my @intd_dir = GET_FILES("$BASEDIR/$dir");
		foreach $l (@intd_dir) {
			$intd_cnt += GET_QUEUE_INFO("$BASEDIR/$dir/$l");
		}
		printf("intd total: %d\n", $intd_cnt);
		$total_cnt += $intd_cnt;
	}
	else {
		$total_cnt += GET_QUEUE_INFO("$BASEDIR/$dir");
	}
}

PRINT_BAR();
printf("total count: %d\n", $total_cnt);
PRINT_BAR();
