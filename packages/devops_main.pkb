--
-- Package_Body "DEVOPS_MAIN"
--
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_DEVOPS"."DEVOPS_MAIN" AS

  -- Prozedur zur Erstellung eines Cloud-Credentials
  PROCEDURE create_credential
    ( p_cred_name IN VARCHAR2,
      p_username  IN VARCHAR2,
      p_password  IN VARCHAR2 )
      IS
      BEGIN
        dbms_cloud.create_credential (
          credential_name => p_cred_name,
          username        => p_username,
          password        => p_password
        );
  END create_credential;

  -- Prozedur zum Erstellen eines GitHub-Repositories
  PROCEDURE create_repository
    ( p_credname  IN VARCHAR2,
      p_reponame  IN VARCHAR2,
      p_repoowner IN VARCHAR2,
      p_private   IN BOOLEAN DEFAULT FALSE )
      IS
        repoHandle CLOB;
      BEGIN
        -- Initialisiere das GitHub-Repository
        repoHandle := dbms_cloud_repo.init_github_repo(
          credential_name => p_credname,
          repo_name       => p_reponame,
          owner           => p_repoowner
        );

        -- Erstelle das GitHub-Repository
        dbms_cloud_repo.create_repository(
          repo        => repoHandle,
          description => 'Repo created in your GitHub environment',
          private     => p_private
        );
  END create_repository;

  -- Prozedur zum Erstellen eines Branches in einem GitHub-Repository
  PROCEDURE create_branch
    ( p_credname   IN VARCHAR2,
      p_reponame   IN VARCHAR2,
      p_repoowner  IN VARCHAR2,
      p_branchname IN VARCHAR2 )
      IS
        repoHandle CLOB;
      BEGIN
        -- Initialisiere das GitHub-Repository
        repoHandle := dbms_cloud_repo.init_github_repo(
          credential_name => p_credname,
          repo_name       => p_reponame,
          owner           => p_repoowner
        );

        -- Erstelle einen neuen Branch im angegebenen GitHub-Repository
        dbms_cloud_repo.create_branch(
          repo               => repoHandle,
          branch_name        => p_branchname,
          parent_branch_name => 'main'
        );
  END create_branch;


PROCEDURE export_objects
    ( p_credname   IN VARCHAR2,
      p_reponame   IN VARCHAR2,
      p_repoowner  IN VARCHAR2,
      p_branchname IN VARCHAR2,
      p_schema     IN VARCHAR2 )
IS
    repoHandle CLOB;
BEGIN
    -- Initialisiere das GitHub-Repository
    repoHandle := dbms_cloud_repo.init_github_repo(
                      credential_name => p_credname,
                      repo_name       => p_reponame,
                      owner           => p_repoowner
                  );

    -- Schleife durch die zu exportierenden Objekte
    FOR rec IN (
        SELECT *
        FROM all_objects
        WHERE object_type IN ('TABLE', 'VIEW', 'PACKAGE', 'PACKAGE BODY', 'TRIGGER', 'FUNCTION', 'PROCEDURE', 'SEQUENCE', 'INDEX')
          AND owner = p_schema
          AND object_name LIKE 'DEVOPS%'
    )
    LOOP
        -- Exportieren der Objekte in das GitHub-Repository
        dbms_cloud_repo.export_object(
            repo => repoHandle,
            file_path => CASE rec.object_type
                           WHEN 'TABLE' THEN 'tables/' || LOWER(rec.object_name) || '.sql'
                           WHEN 'VIEW' THEN 'views/' || LOWER(rec.object_name) || '.sql'
                           WHEN 'PACKAGE' THEN 'packages/' || LOWER(rec.object_name) || '.pks'
                           WHEN 'PACKAGE BODY' THEN 'packages/' || LOWER(rec.object_name) || '.pkb'
                           WHEN 'TRIGGER' THEN 'triggers/' || LOWER(rec.object_name) || '.trg'
                           WHEN 'FUNCTION' THEN 'functions/' || LOWER(rec.object_name) || '.fnc'
                           WHEN 'PROCEDURE' THEN 'procedures/' || LOWER(rec.object_name) || '.prc'
                           WHEN 'SEQUENCE' THEN 'sequences/' || LOWER(rec.object_name) || '.seq'
                           WHEN 'INDEX' THEN 'indexes/' || LOWER(rec.object_name) || '.idx'
                         END,
            object_type => CASE rec.object_type
                             WHEN 'TABLE' THEN 'TABLE'
                             WHEN 'VIEW' THEN 'VIEW'
                             WHEN 'PACKAGE' THEN 'PACKAGE_SPEC'
                             WHEN 'PACKAGE BODY' THEN 'PACKAGE_BODY'
                             WHEN 'TRIGGER' THEN 'TRIGGER'
                             WHEN 'FUNCTION' THEN 'FUNCTION'
                             WHEN 'PROCEDURE' THEN 'PROCEDURE'
                             WHEN 'SEQUENCE' THEN 'SEQUENCE'
                             WHEN 'INDEX' THEN 'INDEX'
                           END,
            object_name => rec.object_name,
            object_schema => p_schema,
            branch_name => p_branchname,
            commit_details => json_object('message' VALUE 'DBMS_CLOUD_REPO SQL Developer commit',
                                          'author'  VALUE 'Sonja',
                                          'email'   VALUE 'sonja.meyer@oracle.com'
                                         ),
            append => FALSE
        );
    END LOOP;

    -- Logge das Ende der Prozedur in die Tabelle DEVOPS_EXPORT_LOG
    INSERT INTO DEVOPS_EXPORT_LOG (log_timestamp, export_status)
        VALUES (SYSTIMESTAMP, 'COMPLETED');

END export_objects;



  -- Prozedur zum Abfragen von Objekten aus einem Schema
  PROCEDURE query_objects
    ( p_schema     IN VARCHAR2 )
      IS
      BEGIN
        FOR rec IN (
          SELECT *
          FROM all_objects
          WHERE object_type IN ('TABLE', 'VIEW', 'PACKAGE', 'PACKAGE BODY', 'TRIGGER', 'FUNCTION', 'PROCEDURE', 'SEQUENCE', 'INDEX')
            AND owner = p_schema
            AND object_name LIKE '%WORK%'
            AND object_name NOT IN ('VTL_WORK_NET', 'VTL_WORK_GROSS', 'P_WORK_HELPER')
        )
        LOOP
          DBMS_OUTPUT.PUT_LINE('Object Name: ' || rec.object_name || ', Object Type: ' || rec.object_type);
        END LOOP;
  END query_objects;


  PROCEDURE export_app(
    p_credname   IN VARCHAR2,
    p_reponame   IN VARCHAR2,
    p_repoowner  IN VARCHAR2,
    p_branchname IN VARCHAR2,
    p_schema     IN VARCHAR2
  ) IS
    repoHandle     CLOB;
    l_file         APEX_T_EXPORT_FILES;
    l_app_id       NUMBER := 102;  -- Replace with your App ID
    l_name         VARCHAR2(255 CHAR);
    l_app_clob     CLOB;
    l_app_blob     BLOB;
  BEGIN
    -- Initialize GitHub repository handle
    repoHandle := DBMS_CLOUD_REPO.init_github_repo(
                    credential_name => p_credname,
                    repo_name       => p_reponame,
                    owner           => p_repoowner
                  );

    -- Export the APEX application
    l_file := APEX_EXPORT.get_application(p_application_id => l_app_id);
    l_name := l_file(1).name;

    -- Convert the exported CLOB to BLOB
    l_app_clob := l_file(1).contents;
    l_app_blob := APEX_UTIL.clob_to_blob(l_app_clob);

    -- Commit the exported application to the specified GitHub branch
    DBMS_CLOUD_REPO.put_file(
      repo           => repoHandle,
      file_path      => 'apex/' || l_name,
      contents       => l_app_blob,
      branch_name    => p_branchname,
      commit_details => JSON_OBJECT('message' VALUE 'DBMS_CLOUD_REPO commit',
                                    'author'  VALUE p_repoowner,
                                    'email'   VALUE 'noreply@example.com')
    );
  END export_app;


END DEVOPS_MAIN;
/