##############################################################################
# IpBlocking DB2 SQL
#
# - �����Ŀ��� ������ �ٽ� �����ؾ� �մϴ�.
# - �����ڿܿ��� ������ ���մϴ�.
# - ��¥: ���� TIMESTAMP, �� TIMESTAMP_ISO(? || '.000000')
# - ����: ���� VARCHAR, ���� INT
##############################################################################

# ���̺� ����
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

# ���̺� ���� ���� �˻�
SQL:IsExistsTable
	SELECT
		TABNAME
	FROM
		SYSCAT.TABLES
	WHERE
		TABNAME = ?

# ���̺� ����
SQL:DropTable
	DROP TABLE
		IP_BLOCKING

# IP ����
SQL:DeleteIp
	DELETE FROM
		IP_BLOCKING
	WHERE
		IP = ? 


# ��ȿ �Ⱓ�� ���� IP �߰�
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

# IP �߰�
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

# IP�� �����ϴ��� ���� �˻�
SQL:IsExistsIp
	SELECT
		IP
	FROM
		IP_BLOCKING
	WHERE
		IP = ? 

# IP �˻�
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

# ��ȿ �Ⱓ�� ���� IP ����
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

# IP ����
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