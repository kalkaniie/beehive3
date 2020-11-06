##############################################################################
# BeforeSmtpSession DB2 SQL
#
# - �����Ŀ��� ������ �ٽ� �����ؾ� �մϴ�.
# - �����ڿܿ��� ������ ���մϴ�.
# - ��¥: ���� TIMESTAMP, �� TIMESTAMP_ISO(? || '.000000')
# - ����: ���� VARCHAR, ���� INT
##############################################################################

# ���̺� ����
SQL:CreateTable
	CREATE TABLE
		POP_BEFORE_SMTP (
			PRIMARY KEY (IP_ADDRESS),
			IP_ADDRESS VARCHAR(100) NOT NULL,
			SESSION_TIME TIMESTAMP NOT NULL
		)

# ���̺� ���� ���� �˻�
SQL:IsExistsTable
	SELECT
		TABNAME
	FROM
		SYSCAT.TABLES
	WHERE
		TABNAME = ?

# ��ȿ�Ⱓ�� ���� ������ ����
SQL:DeleteSessionBeforeDate
	DELETE FROM
		POP_BEFORE_SMTP
	WHERE
		SESSION_TIME <  TIMESTAMP_ISO(? || '.000000')

# ���� �߰�
SQL:InsertSession
	INSERT INTO
		POP_BEFORE_SMTP (
			IP_ADDRESS,
			SESSION_TIME
		) VALUES (
			?,
			TIMESTAMP_ISO(? || '.000000')
		) 

# ���� ���� ���� �˻�
SQL:IsExistsSession
	SELECT
		COUNT(*)
	FROM
		POP_BEFORE_SMTP
	WHERE
		IP_ADDRESS = ?

# ���ǽð� ����
SQL:UpdateSession
	UPDATE
		POP_BEFORE_SMTP
	SET
		SESSION_TIME = TIMESTAMP_ISO(? || '.000000')
	WHERE
		IP_ADDRESS = ? 

# ���� ����
SQL:DeleteSession
	DELETE FROM
		POP_BEFORE_SMTP
	WHERE
		IP_ADDRESS = ?