



--데이터 결합 (base_table.sql)
--실습 join1
SELECT lprod.lprod_gu, lprod.lprod_nm, prod.prod_id, prod.prod_name
FROM prod, lprod
WHERE prod.prod_lgu = lprod.lprod_gu;

--실습 join2
SELECT buyer.buyer_id, buyer.buyer_name, prod.prod_id, prod.prod_name 
FROM buyer, prod
WHERE prod.prod_buyer = buyer.buyer_id;

--실습 join3
SELECT m.mem_id, m.mem_name, p.prod_id, p.prod_name, c.cart_qty
FROM member m, cart c, prod p
WHERE m.mem_id = c.cart_member AND c.cart_prod = p.prod_id;

SELECT *
FROM buyer;
SELECT *
FROM prod;

--실습 join4
SELECT cst.cid, cst.cnm, cy.pid, cy.day, cy.cnt
FROM customer cst, cycle cy
WHERE cst.cid = cy.cid
AND cst.cnm IN('brown', 'sally');

--실습 join5
SELECT cst.cid, cst.cnm, cy.pid, prd.pnm, cy.day, cy.cnt
FROM customer cst, cycle cy, product prd
WHERE cst.cid = cy.cid 
AND cy.pid = prd.pid;

--실습 join6
SELECT cy.cid, cst.cnm, cy.pid, prd.pnm, SUM(cnt) cnt  
FROM customer cst, cycle cy, product prd
WHERE cst.cid = cy.cid 
AND cy.pid = prd.pid
GROUP BY cy.cid, cst.cnm, cy.pid, prd.pnm;

-->>
SELECT a.cid, customer.cnm, a.pid, product.pnm, a.cnt
FROM
    (SELECT cid, pid, SUM(cnt) cnt
    FROM cycle
    GROUP BY cid, pid) a, customer, product
WHERE a.cid = customer.cid
AND a.pid = product.pid;

--실습 join7
SELECT cy.pid, prd.pnm, cy.pid, SUM(cnt) cnt
FROM cycle cy, product prd
WHERE cy.pid = prd.pid
GROUP BY cy.pid, prd.pnm, cy.pid;

SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT *
FROM DBA_USERS;

ALTER USER HR ACCOUNT UNLOCK;

ALTER USER HR IDENTIFIED BY java;
















