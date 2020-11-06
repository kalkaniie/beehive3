##############################################################################
# BeforeSmtpSession DB2 SQL
#
# - 수정후에는 서버를 다시 시작해야 합니다.
# - 개발자외에는 수정을 금합니다.
# - 날짜: 선언 TIMESTAMP, 비교 TIMESTAMP_ISO(? || '.000000')
# - 변수: 문자 VARCHAR, 숫자 INT
##############################################################################

# 테이블 생성
SQL:CreateTable
	CREATE TABLE
		POP_BEFORE_SMTP (
			PRIMARY KEY (IP_ADDRESS),
			IP_ADDRESS VARCHAR(100) NOT NULL,
			SESSION_TIME TIMESTAMP NOT NULL
		)

# 테이블 존재 여부 검사
SQL:IsExistsTable
	SELECT
		TABNAME
	FROM
		SYSCAT.TABLES
	WHERE
		TABNAME = ?

# 유효기간이 지난 세션을 삭제
SQL:DeleteSessionBeforeDate
	DELETE FROM
		POP_BEFORE_SMTP
	WHERE
		SESSION_TIME <  TIMESTAMP_ISO(? || '.000000')

# 세션 추가
SQL:InsertSession
	INSERT INTO
		POP_BEFORE_SMTP (
			IP_ADDRESS,
			SESSION_TIME
		) VALUES (
			?,
			TIMESTAMP_ISO(? || '.000000')
		) 

# 세션 존재 여부 검사
SQL:IsExistsSession
	SELECT
		COUNT(*)
	FROM
		POP_BEFORE_SMTP
	WHERE
		IP_ADDRESS = ?

# 세션시간 수정
SQL:UpdateSession
	UPDATE
		POP_BEFORE_SMTP
	SET
		SESSION_TIME = TIMESTAMP_ISO(? || '.000000')
	WHERE
		IP_ADDRESS = ? 

# 세션 삭제
SQL:DeleteSession
	DELETE FROM
		POP_BEFORE_SMTP
	WHERE
		IP_ADDRESS = ?