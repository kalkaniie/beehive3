##############################################################################
# MailBox DB2 SQL
#
# - �����Ŀ��� ������ �ٽ� �����ؾ� �մϴ�.
# - �����ڿܿ��� ������ ���մϴ�.
# - ��¥: ���� TIMESTAMP, �� TIMESTAMP_ISO(? || '.000000')
# - ����: ���� VARCHAR, ���� INT
##############################################################################

# ������ ����
SQL:Create
	INSERT INTO
		MBOX (
			MBOX_IDX,
			USERS_IDX,
			MBOX_TYPE,
			MBOX_NAME,
			MBOX_SIZE,
			MBOX_MAILCOUNT
		) VALUES (
			NEXTVAL FOR SEQ_MBOX,
			?, ?, ?, ?, ?
		)

# ������ ����
SQL:Delete
	DELETE FROM
		MBOX
	WHERE
		MBOX_IDX = ?
		AND
		USERS_IDX = ?

# ������ Ÿ������ �˻�
SQL:SelectMailBoxWhereType
	SELECT
		MBOX_IDX,
		MBOX_TYPE,
		MBOX_NAME,
		MBOX_SIZE,
		MBOX_MAILCOUNT
	FROM
		MBOX
	WHERE
		MBOX_TYPE = ?
		AND
		USERS_IDX = ? 

# ����� ������ ��� �˻�
SQL:SelectMailBoxList
	SELECT
		MBOX_IDX,
		MBOX_TYPE,
		MBOX_NAME,
		MBOX_SIZE,
		MBOX_MAILCOUNT
	FROM
		MBOX
	WHERE
		USERS_IDX = ?
	ORDER BY
		MBOX_TYPE,
		MBOX_IDX

# ������ �̸����� �˻� 
SQL:SelectMailBox
	SELECT
		MBOX_IDX,
		MBOX_TYPE,
		MBOX_NAME,
		MBOX_SIZE,
		MBOX_MAILCOUNT
	FROM
		MBOX
	WHERE
		MBOX_NAME = ?

# ������ �̸� �ٲٱ�
SQL:Rename
	UPDATE
		MBOX
	SET
		MBOX_NAME = ?
	WHERE
		MBOX_IDX = ?
		AND
		USERS_IDX = ? 

# ���̱� ���� ����(IMAP)
SQL:UpdateSubscribe
	UPDATE
		MBOX
	SET
		MBOX_MAILCOUNT = ?
	WHERE
		MBOX_IDX = ?