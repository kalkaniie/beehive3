##############################################################################
# IpBlocking DB2 SQL
#
# - 수정후에는 서버를 다시 시작해야 합니다.
# - 개발자외에는 수정을 금합니다.
# - 날짜: 선언 TIMESTAMP, 비교 TIMESTAMP_ISO(? || '.000000')
# - 변수: 문자 VARCHAR, 숫자 INT
##############################################################################

# 테이블 생성
SQL:CreateTable
	CREATE TABLE
		IP_BLOCKING (
			IP VARCHAR(100) NOT NULL,
			WHITE_IP CHAR(1) NOT NULL,
			BLACK_IP CHAR(1) NOT NULL,
			DYNAMIC_IP CHAR(1) NOT NULL,
			REGISTER_DATE TIMESTAMP,
			VALID_DATE TIMESTAMP,
			PRIMARY KEY (IP)
		)

# 테이블 존재 여부 검사
SQL:IsExistsTable
	SELECT
		TABNAME
	FROM
		SYSCAT.TABLES
	WHERE
		TABNAME = ?

# 테이블 삭제
SQL:DropTable
	DROP TABLE
		IP_BLOCKING

# IP 삭제
SQL:DeleteIp
	DELETE FROM
		IP_BLOCKING
	WHERE
		IP = ? 


# 유효 기간이 없는 IP 추가
SQL:InsertIpNonValidDate
	INSERT INTO
		IP_BLOCKING (
			IP,
			WHITE_IP,
			BLACK_IP,
			DYNAMIC_IP,
			REGISTER_DATE
		) VALUES (
			?, ?, ?, ?,
			TIMESTAMP_ISO(? || '.000000')
		) 

# IP 추가
SQL:InsertIp
	INSERT INTO
		IP_BLOCKING (
			IP,
			WHITE_IP,
			BLACK_IP,
			DYNAMIC_IP,
			REGISTER_DATE,
			VALID_DATE
		) VALUES (
			?, ?, ?, ?,
			TIMESTAMP_ISO(? || '.000000'),
			TIMESTAMP_ISO(? || '.000000')
		)

# IP가 존재하는지 여부 검사
SQL:IsExistsIp
	SELECT
		IP
	FROM
		IP_BLOCKING
	WHERE
		IP = ? 

# IP 검사
SQL:SelectIp
	SELECT
		IP,
		WHITE_IP,
		BLACK_IP,
		DYNAMIC_IP,
		REGISTER_DATE,
		VALID_DATE
	FROM
		IP_BLOCKING
	WHERE
		IP = ? 

# 유효 기간이 없는 IP 수정
SQL:UpdateIpNonValidDate
	UPDATE
		IP_BLOCKING
	SET
		WHITE_IP = ?,
		BLACK_IP = ?,
		DYNAMIC_IP = ?,
		REGISTER_DATE = TIMESTAMP_ISO(? || '.000000')
	WHERE
		IP = ? 

# IP 수정
SQL:UpdateIp
	UPDATE
		IP_BLOCKING
	SET
		WHITE_IP = ?,
		BLACK_IP = ?,
		DYNAMIC_IP = ?,
		REGISTER_DATE = TIMESTAMP_ISO(? || '.000000'),
		VALID_DATE = TIMESTAMP_ISO(? || '.000000')
	WHERE
		IP = ?