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
    file_path VARCHAR2(200);
    object_type VARCHAR2(50);
BEGIN
    -- Initialisiere das GitHub-Repository
    repoHandle := dbms_cloud_repo.init_github_repo(
                      credential_name => p_credname,
                      repo_name       => p_reponame,
                      owner           => p_repoowner
                  );

    -- Cursor Loop: Loop durch alle relevanten Objekte im Schema
    FOR rec IN (
        SELECT *
        FROM all_objects
        WHERE object_type IN ('TABLE', 'VIEW', 'PACKAGE', 'PACKAGE BODY', 'TRIGGER', 'FUNCTION', 'PROCEDURE', 'SEQUENCE', 'INDEX')
          AND owner = p_schema
          AND object_name NOT IN ('VTL_WORK_NET', 'VTL_WORK_GROSS', 'P_WORK_HELPER')
          AND object_name NOT LIKE 'DBTOOL%' 
          AND object_name NOT LIKE 'SYS%'
    )
    LOOP
        BEGIN
            -- Setze den Dateipfad und den Objekttyp basierend auf dem Objekttyp
            file_path := CASE rec.object_type
                            WHEN 'TABLE' THEN 'tables/' || LOWER(rec.object_name) || '.sql'
                            WHEN 'VIEW' THEN 'views/' || LOWER(rec.object_name) || '.sql'
                            WHEN 'PACKAGE' THEN 'packages/' || LOWER(rec.object_name) || '.pks'
                            WHEN 'PACKAGE BODY' THEN 'packages/' || LOWER(rec.object_name) || '.pkb'
                            -- Weitere Objekttypen können hier hinzugefügt werden
                         END;

            object_type := CASE rec.object_type
                            WHEN 'TABLE' THEN 'TABLE'
                            WHEN 'VIEW' THEN 'VIEW'
                            WHEN 'PACKAGE' THEN 'PACKAGE_SPEC'
                            WHEN 'PACKAGE BODY' THEN 'PACKAGE_BODY'
                            -- Weitere Objekttypen können hier hinzugefügt werden
                          END;

            -- Exportiere das Objekt ins GitHub Repository
            dbms_cloud_repo.export_object(
                repo => repoHandle,
                file_path => file_path,
                object_type => object_type,
                object_name => rec.object_name,
                object_schema => p_schema,
                branch_name => p_branchname,
                commit_details => json_object('message' VALUE 'DBMS_CLOUD_REPO commit',
                                              'author'  VALUE 'XXX',
                                              'email'   VALUE 'XXX'
                                             ),
                append => FALSE -- Specify whether to append content to the file
            );

            -- Logge den erfolgreichen Export
            INSERT INTO export_log (object_name, object_type, file_path, export_status)
            VALUES (rec.object_name, rec.object_type, file_path, 'SUCCESS');

        EXCEPTION
            WHEN OTHERS THEN
                -- Logge den Fehler, falls ein Export fehlschlägt
                INSERT INTO export_log (object_name, object_type, file_path, export_status)
                VALUES (rec.object_name, rec.object_type, file_path, 'FAILED');

                -- Optional: RAISE zur Fehlerweitergabe
                RAISE;
        END; -- Ende des inneren BEGIN-Blocks
    END LOOP;

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



END DEVOPS_MAIN;
/