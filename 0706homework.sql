--숙제

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod b JOIN prod p ON p.prod_id = b.buy_prod;

--1번
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod b, prod p 
WHERE p.prod_id = b.buy_prod(+)
  AND buy_date(+) = '20050125';

--2번
SELECT NVL(buy_date,TO_DATE('050125','YY/MM/DD'))buy_date,
       buy_prod, prod_id, prod_name, buy_qty
FROM buyprod b, prod p 
WHERE p.prod_id = b.buy_prod(+)
  AND buy_date(+) = '20050125';
  
--3번
SELECT NVL(buy_date,TO_DATE('050125','YY/MM/DD'))buy_date, 
       buy_prod, 
       prod_id, 
       prod_name, 
       NVL(buy_qty,0)
FROM buyprod b, prod p 
WHERE p.prod_id = b.buy_prod(+)
  AND buy_date(+) = '20050125';
  
  
--4번
SELECT p.pid, p.pnm , NVL(c.cid,0)cid, NVL(c.day,0)day, NVL(c.cnt,0)cnt
FROM cycle c , product p 
WHERE c.pid(+)= p.pid
    AND c.cid(+)=1;
    
--5번
SELECT p.pid, p.pnm ,NVL(c.cid,0)cid, NVL(c.day,0)day, NVL(c.cnt,0)cnt
FROM cycle c , product p , customer cu
WHERE c.pid(+)= p.pid
  AND c.cid(+)=1
  AND c.cid = cu.cid(+)  ;
