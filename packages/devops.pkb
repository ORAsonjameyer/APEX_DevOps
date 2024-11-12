--
-- Package_Body "DEVOPS"
--
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_DEVOPS"."DEVOPS" as

  -- Definition der Prozedur create_credential, um eine Cloud-Credential zu erstellen
  PROCEDURE create_credential
    ( p_cred_name IN VARCHAR2, -- Name des Credentials, zum Beispiel 'DEV_TEST'
      p_username IN VARCHAR2,  -- Benutzername für das Credential
      p_password IN VARCHAR2 ) -- Passwort für das Credential
  IS
  BEGIN
    -- Aufruf der DBMS_CLOUD-Methode, um das Credential mit den übergebenen Parametern zu erstellen
    dbms_cloud.create_credential (
      credential_name => p_cred_name,  -- Setzt den Namen des zu erstellenden Credentials
      username        => p_username,   -- Setzt den Benutzernamen
      password        => p_password    -- Setzt das Passwort
    );
  END create_credential;


-- Definition der Prozedur zum Exportieren von Objekten in ein GitHub-Repository
  PROCEDURE export_objects_to_github IS
    l_repo_handle clob;
  BEGIN
    -- Initialisiert das GitHub-Repository und speichert das Handle
    l_repo_handle := dbms_cloud_repo.init_github_repo(
      credential_name => 'GITHUB_CRED',
      owner           => 'WKSP_DEVOPS',
      repo_name       => 'test'
    );

    -- Schleife durch alle relevanten Objekte (Tabellen, Views, Packages, Package Bodies)
    FOR obj IN (
      SELECT *
      FROM user_objects
      WHERE object_type IN ('TABLE', 'VIEW', 'PACKAGE', 'PACKAGE BODY')
    ) LOOP
      -- Exportiert das jeweilige Objekt in das Repository
      dbms_cloud_repo.export_object(
        repo          => l_repo_handle,
        file_path     => CASE obj.object_type
                          WHEN 'TABLE' THEN 'models/' || LOWER(obj.object_name) || '.sql'
                          WHEN 'VIEW' THEN 'views/' || LOWER(obj.object_name) || '.sql'
                          -- WHEN 'PACKAGE' THEN 'packages/' || LOWER(obj.object_name) || '.pks'
                          -- WHEN 'PACKAGE BODY' THEN 'packages/' || LOWER(obj.object_name) || '.pkb'
                        END,
        object_type   => CASE obj.object_type
                          WHEN 'TABLE' THEN 'TABLE'
                          WHEN 'VIEW' THEN 'VIEW'
                          WHEN 'PACKAGE' THEN 'PACKAGE_SPEC'
                          WHEN 'PACKAGE BODY' THEN 'PACKAGE_BODY'
                        END,
        object_name   => obj.object_name,
        object_schema => 'WKSP_DEVOPS',
        branch_name   => 'main',
        commit_details => json_object(
          'message' VALUE 'DBMS_CLOUD_REPO commit',
          'author' VALUE 'Sonja Meyer',
          'email' VALUE 'sonja.meyer@oracle.com'
        ),
        append => FALSE
      );
    END LOOP;
  END export_objects_to_github;


end "DEVOPS";
/