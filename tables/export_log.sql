--
-- Table "EXPORT_LOG"
--
CREATE TABLE "WKSP_DEVOPS"."EXPORT_LOG" 
   (	"LOG_ID" NUMBER GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"OBJECT_NAME" VARCHAR2(100) COLLATE "USING_NLS_COMP", 
	"OBJECT_TYPE" VARCHAR2(50) COLLATE "USING_NLS_COMP", 
	"FILE_PATH" VARCHAR2(200) COLLATE "USING_NLS_COMP", 
	"EXPORT_STATUS" VARCHAR2(20) COLLATE "USING_NLS_COMP", 
	"LOG_TIMESTAMP" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP, 
	 PRIMARY KEY ("LOG_ID")
  USING INDEX  ENABLE
   )  DEFAULT COLLATION "USING_NLS_COMP"
/