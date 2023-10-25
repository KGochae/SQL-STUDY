# 조회수가 가장 높은 중고거래 게시물에 대한 첨부파일 경로를 조회하는 SQL문을 작성
# 첨부파일 경로는 FILE ID를 기준으로 내림차순
# 기본적인 파일경로는 /home/grep/src/ 
# BOARD_ID를 기준으로 디렉토리가 구분되고
# 파일이름은 FILE_ID , FILE_NAME , FILE_EXT 로 구성되도록 출력
# 조회수가 가장 높은 게시물은 하나만 존재

SELECT  
    #   A.BOARD_ID
    # , A.VIEWS
    # , B.*
     CONCAT('/home/grep/src/', A.BOARD_ID, '/', B.FILE_ID, B.FILE_NAME, B.FILE_EXT) AS FILE_PATH
FROM(SELECT *
    FROM USED_GOODS_BOARD
    ORDER BY VIEWS DESC
    LIMIT 1) A
LEFT JOIN USED_GOODS_FILE B ON A.BOARD_ID = B.BOARD_ID
ORDER BY B.FILE_ID DESC


# 먼저USED_GOODS_BOARD 테이블에 VIEW 가 가장높은 데이터만 뽑아줍니다. 저는 views를 내림차순으로 정렬한뒤 limit 함수를 이용해서 가장 위에있는(가장 조회수가 높은) 데이터를 뽑았습니다. 
# 문제에서 가장 조회수가 높은 게시물은 하나만 존재한다고 했기 때문에 limit 함수를 이용했습니다. (만약 중복이 있다면 dense_rank() 를 이용해 순위를 매겨야겠네요!) 👉 서브쿼리 A 에 해당합니다
# USED_GOODS_FILE 테이블에는 BOARD_ID, FILE_ID, FILE_NAME, FILE_EXT 에 대한 정보가 있습니다.가장 높은 조회수를 갖고있는 데이터의 BOARD_ID를 KEY로 JOIN 해준다음 위의 필요한 컬럼들을 결합해줍니다.
# 다음 CONCAT() 함수를 이용해서 문제에서 제시된 것처럼 문자열을 합쳐줍니다.
