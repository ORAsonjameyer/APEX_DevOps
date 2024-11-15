--
-- Table "EMP"
--
CREATE TABLE "WKSP_DEVOPS"."EMP" 
   (	"EMPNO" NUMBER(4,0) NOT NULL ENABLE, 
	"ENAME" VARCHAR2(10) COLLATE "USING_NLS_COMP", 
	"JOB" VARCHAR2(9) COLLATE "USING_NLS_COMP", 
	"MGR" NUMBER(4,0), 
	"HIREDATE" DATE, 
	"SAL" NUMBER(7,2), 
	"COMM" NUMBER(7,2), 
	"DEPTNO" NUMBER(2,0), 
	 PRIMARY KEY ("EMPNO")
  USING INDEX  ENABLE, 
	 FOREIGN KEY ("MGR")
	  REFERENCES "WKSP_DEVOPS"."EMP" ("EMPNO") ENABLE, 
	 FOREIGN KEY ("DEPTNO")
	  REFERENCES "WKSP_DEVOPS"."DEPT" ("DEPTNO") ENABLE
   )  DEFAULT COLLATION "USING_NLS_COMP"
/