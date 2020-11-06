##############################################################################
# MailBox Oracle SQL
#
# - 수정후에는 서버를 다시 시작해야 합니다.
# - 개발자외에는 수정을 금합니다.
# - 날짜: 선언 DATE, 비교 TO_DATE(?, 'YYYY-MM-DD HH24:MI:SS')
# - 변수: 문자 VARCHAR2, 숫자 NUMBER
##############################################################################

# 편지함 생성
SQL:Create
	INSERT INTO
		MBOX (
			MBOX_IDX,
			USERS_IDX,
			MBOX_TYPE,
			MBOX_NAME,
			MBOX_SIZE,
			MBOX_MAILCOUNT,
			MBOX_SUBSCRIBE,
			MBOX_REF
		) VALUES (
			NEXTVAL FOR SEQ_MBOX,
			?, ?, ?, ?, ?, ?, ?
		)

# 편지함 삭제
SQL:Delete
	DELETE FROM
		MBOX
	WHERE
		MBOX_IDX = ?
		AND
		USERS_IDX = ?

# 편지함 타입으로 검색
SQL:SelectMailBoxWhereType
	SELECT
		MBOX_IDX,
		MBOX_TYPE,
		MBOX_NAME,
		MBOX_SIZE,
		MBOX_MAILCOUNT,
		MBOX_SUBSCRIBE,
		MBOX_REF
	FROM
		MBOX
	WHERE
		MBOX_TYPE = ?
		AND
		USERS_IDX = ? 

# 사용자 편지함 목록 검색
SQL:SelectMailBoxList
	SELECT
		MBOX_IDX,
		MBOX_TYPE,
		MBOX_NAME,
		MBOX_SIZE,
		MBOX_MAILCOUNT,
		MBOX_SUBSCRIBE,
		MBOX_REF
	FROM
		MBOX
	WHERE
		USERS_IDX = ?
	ORDER BY
		MBOX_TYPE,
		MBOX_IDX

# 편지함 이름으로 검색 
SQL:SelectMailBox
	SELECT
		MBOX_IDX,
		MBOX_TYPE,
		MBOX_NAME,
		MBOX_SIZE,
		MBOX_MAILCOUNT,
		MBOX_SUBSCRIBE,
		MBOX_REF
	FROM
		MBOX
	WHERE
		MBOX_NAME = ?

# 편지함 이름 바꾸기
SQL:Rename
	UPDATE
		MBOX
	SET
		MBOX_NAME = ?
	WHERE
		MBOX_IDX = ?
		AND
		USERS_IDX = ? 

# 보이기 여부 수정(IMAP)
SQL:UpdateSubscribe
	UPDATE
		MBOX
	SET
		MBOX_SUBSCRIBE = ?
	WHERE
		MBOX_IDX = ?

# 하위 편지함 존재 여부 검사
SQL:SelectSubMailBox
	SELECT
		MBOX_IDX
	FROM
		MBOX
	WHERE
		MBOX_REF = ?