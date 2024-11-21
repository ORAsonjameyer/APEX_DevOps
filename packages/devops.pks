--
-- Package_Spec "DEVOPS"
--
CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_DEVOPS"."DEVOPS" AS
  -- Spezifikation des Packages "DEVOPS"

  -- Prozedur zur Erstellung eines Cloud-Credentials
  PROCEDURE create_credential(
    p_cred_name IN VARCHAR2, -- Name des Credentials, z. B. 'DEV_TEST'
    p_username  IN VARCHAR2, -- Benutzername für das Credential
    p_password  IN VARCHAR2  -- Passwort für das Credential
  );

  -- Prozedur zum Erstellen eines Branches in einem GitHub-Repository
  PROCEDURE create_branch(
    p_credname  IN VARCHAR2,
    p_reponame  IN VARCHAR2,
    p_repoowner IN VARCHAR2
  );

END "DEVOPS";
/