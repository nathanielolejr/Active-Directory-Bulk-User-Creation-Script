# Active Directory Bulk User Creation Script

## Overview
This PowerShell script automates the creation of multiple Active Directory (AD) users from a CSV file. It assigns user attributes, managers, and group memberships based on job level, while ensuring accounts are secure and properly configured.

## Features
- Creates AD users in bulk from CSV input.
- Sets standard user attributes (name, email, department, office, etc.).
- Assigns managers automatically if provided.
- Enforces password reset on first login.
- Adds users to groups dynamically based on **JobLevel**.
- Skips users that already exist to prevent duplicates.

## CSV Format Example
```csv
SamAccountName,FirstName,LastName,DisplayName,Email,Password,OU,Manager,JobLevel,Department,Office,Title,Company,Description,Initials,AccountExpires
jdoe,John,Doe,John Doe,jdoe@domain.com,P@ssword123,"OU=Users,DC=domain,DC=com",manager1,Associate,IT,HeadOffice,Technician,Contoso,Support,J,D2025-12-31
asmith,Alice,Smith,Alice Smith,asmith@domain.com,P@ssword123,"OU=Users,DC=domain,DC=com",manager2,Manager,Finance,BranchOffice,Manager,Contoso,Finance,A,D2026-01-01
