##############################################################################
# Mail DB2 SQL
#
# - �����Ŀ��� ������ �ٽ� �����ؾ� �մϴ�.
# - �����ڿܿ��� ������ ���մϴ�.
# - ��¥: ���� DATE, �� TO_DATE(?, 'YYYY-MM-DD HH24:MI:SS')
# - ����: ���� VARCHAR2, ���� NUMBER
##############################################################################

# ���� ����
SQL:CopyMail
	INSERT INTO
		<TABLE_NAME> (
			M_IDX,
			MBOX_IDX,
			USERS_IDX,
			M_SENDER,
			M_RETURN,
			M_TO,
			M_CC,
			M_BCC,
			M_SENDERNM,
			M_TYPE,
			M_TITLE,
			M_TIME,
			M_SIZE,
			M_ISREAD,
			M_PRIORITY,
			M_INJURIOUSE,
			M_ATTACHE,
			M_FILENAME
		)
	SELECT
		NEXTVAL FOR SEQ_<TABLE_NAME>,
		MBOX_IDX,
		USERS_IDX,
		M_SENDER,
		M_RETURN,
		M_TO,
		M_CC,
		M_BCC,
		M_SENDERNM,
		M_TYPE,
		M_TITLE,
		M_TIME,
		M_SIZE,
		M_ISREAD,
		M_PRIORITY,
		M_INJURIOUSE,
		M_ATTACHE,
		M_FILENAME
	FROM
		<TABLE_NAME>
	WHERE
		M_IDX = ?

# ���� �߰�
SQL:InsertMail
	INSERT INTO
		<TABLE_NAME> (
			M_IDX,
			MBOX_IDX,
			USERS_IDX,
			M_SENDER,
			M_RETURN,
			M_TO,
			M_CC,
			M_BCC,
			M_SENDERNM,
			M_TYPE,
			M_TITLE,
			M_TIME,
			M_SIZE,
			M_ISREAD,
			M_PRIORITY,
			M_INJURIOUSE,
			M_ATTACHE,
			M_FILENAME
		) VALUES (
			NEXTVAL FOR SEQ_<TABLE_NAME>,
			?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
			TIMESTAMP_ISO( REPLACE(? ||'.000000', '/', '-'),
			?, ?, ?, ?, ?, ?
		) 

# ���� ��� �˻�
SQL:SelectMailList
	SELECT
		M_IDX,
		M_ISREAD,
		M_PRIORITY,
		M_FILENAME
	FROM
		<TABLE_NAME>,
		MBOX
	WHERE
		<TABLE_NAME>.USERS_IDX = ?
		AND
		<TABLE_NAME>.MBOX_IDX = MBOX.MBOX_IDX
		AND
		MBOX.MBOX_TYPE IN( 1, 5, 6 )
	ORDER BY M_IDX

# �������� ���� ��� �˻�
SQL:SelectMailListWhereMailBoxName
	SELECT
		M_IDX,
		M_ISREAD,
		M_PRIORITY,
		M_FILENAME
	FROM
		<TABLE_NAME>,
		MBOX
	WHERE
		<TABLE_NAME>.USERS_IDX = ?
		AND
		<TABLE_NAME>.MBOX_IDX = MBOX.MBOX_IDX
		AND
		MBOX.MBOX_IDX = ?
	ORDER BY M_IDX

# ���� ����
SQL:RemoveMail
	DELETE FROM
		<TABLE_NAME>
	WHERE
		M_IDX = ?
		AND
		USERS_IDX = ? 

# ��� �߰���  ���� ��ȣ �˻�
SQL:SelectCurrentSequenceNumber
	VALUES ( PREVVAL FOR SEQ_<TABLE_NAME> )

# ���� �÷��� ����
SQL:UpdateFlag
	UPDATE
		<TABLE_NAME>
	SET
		M_ISREAD = ?
	WHERE
		M_IDX = ?

# ������ ������ ����
SQL:UpdateMailBox
	UPDATE
		<TABLE_NAME>
	SET
		MBOX_IDX = ?
	WHERE
		M_IDX = ?