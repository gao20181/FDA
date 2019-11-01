
--预处理去除重复的药
--由于是按drugname筛选，可能将一部分有用信息删除，此处可能有问题
CREATE TABLE drug_distinct ( SELECT DISTINCT primaryid, drugname FROM drug );


--预处理出每一种药的总数
CREATE TABLE drug_sum_17q1 (
SELECT
	temp.drugname,count( temp.drugname ) AS sum 
FROM
	(
	SELECT
		drug_dt.primaryid,drug_dt.drugname 
	FROM
		drug_dt 
	WHERE
		drug_dt.primaryid IN ( SELECT primaryid FROM demo WHERE fda_dt LIKE '201701%' OR fda_dt LIKE '201702%' OR fda_dt LIKE '201703%' ) 
		) temp 
GROUP BY
	temp.drugname 
HAVING
	count( temp.drugname ) >= 1 
	);
	
	
--统计一个季度事件总数N,
--方法是统计demo中，一个季度里primaryid的个数
SELECT
	count( primaryid ) AS N 
FROM
	( SELECT primaryid FROM demo WHERE fda_dt LIKE '201701%' OR fda_dt LIKE '201702%' OR fda_dt LIKE '201703%' ) temp;

--统计一个季度发生某一事件的总数E
--方法是统计reac中，pt为某一症状的个数
SELECT
	count( * ) AS E 
FROM
	(
	SELECT
		reac.primaryid,
		reac.pt 
	FROM
		reac 
	WHERE
		reac.pt = "flushing" 
		AND reac.primaryid IN ( SELECT primaryid FROM demo WHERE fda_dt LIKE '201701%' OR fda_dt LIKE '201702%' OR fda_dt LIKE '201703%' ) 
	) temp;


--统计一个季度中DE
--方法是统计每一种药对应某一症状的个数
SELECT
	temp.drugname,
	count( temp.drugname ) AS DE 
FROM
	(
	SELECT
		drug_dt.drugname 
	FROM
		drug_dt,reac 
	WHERE
		reac.pt = 'flushing' AND drug_dt.primaryid = reac.primaryid 
		AND reac.primaryid IN ( SELECT primaryid FROM demo WHERE fda_dt LIKE '201701%' OR fda_dt LIKE '201702%' OR fda_dt LIKE '201703%' ) 
	) temp 
GROUP BY
	temp.drugname 
HAVING
	count( temp.drugname ) >=4;
	
	
	--De
	--由第一步预处理的drug_sum减对应的DE得到
	
	--dE
	--由E-DE得到
	
	--de
	--由e-De得到
