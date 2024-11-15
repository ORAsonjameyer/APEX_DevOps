--
-- Package_Spec "DEVOPS_MAIN"
--
CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_DEVOPS"."DEVOPS_MAIN" AS
  -- Spezifikation des Packages "DEVOPS"


  -- Prozedur zur Erstellung eines Cloud-Credentials
  PROCEDURE create_credential(
    p_cred_name IN VARCHAR2, -- Name des Credentials, z. B. 'DEV_TEST'
    p_username  IN VARCHAR2, -- Benutzername für das Credential
    p_password  IN VARCHAR2  -- Passwort für das Credential
  );


    -- Prozedur zum Erstellen eines GitHub-Repositories
  PROCEDURE create_repository(
    p_credname  IN VARCHAR2,
    p_reponame  IN VARCHAR2,
    p_repoowner IN VARCHAR2,
    p_private   IN BOOLEAN DEFAULT FALSE
  );
  

  -- Prozedur zum Erstellen eines Branches in einem GitHub-Repository
  PROCEDURE create_branch(
    p_credname  IN VARCHAR2,
    p_reponame  IN VARCHAR2,
    p_repoowner IN VARCHAR2,
    p_branchname IN VARCHAR2
  );


  -- Prozedur zum Exportieren von Objekten in ein GitHub-Repository
  PROCEDURE export_objects(
    p_credname   IN VARCHAR2,
    p_reponame   IN VARCHAR2,
    p_repoowner  IN VARCHAR2,
    p_branchname IN VARCHAR2,
    p_schema     IN VARCHAR2
  );


  -- Prozedur zum Abfragen von Objekten aus einem Schema
  PROCEDURE query_objects(
    p_schema     IN VARCHAR2
  );


    -- Prozedur zur Erstellung eines Cloud-Credentials
  PROCEDURE export_app(
    p_credname   IN VARCHAR2,
    p_reponame   IN VARCHAR2,
    p_repoowner  IN VARCHAR2,
    p_branchname IN VARCHAR2,
    p_schema     IN VARCHAR2
  );

END "DEVOPS_MAIN";
/