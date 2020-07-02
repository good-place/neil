# Neil - your life score accountant manager

This is my attempt to create simple cli application for my time tracker needs.
It is the idea phase right now.

Name is again from the Good Place series after Neil the manager in Accounting
office who calculates the life score.

## Domain

Legend:
Default field type is string.
\# - reference
{} - table. If there are nested fields, it is embeded only in the parent document.
[] - array

- client
  - name
  - {invoice info}
    - street
    - city
    - zip
    - reg-id
    - vat-id
    - legal
  - note
- project
  - name
  - #{client}
  - note
- task
  - name
  - #{project}
  - [work interval]
    - start
    - end
    - note
  - note

## Architecture

- server as register [neil]
  - jdn
  - levelDB
  - RPC
- CLI tools to create and manipulate the data [neil/tell]
  - jtbox
  - RPC
- web server with reports and analyticks [neil/watch]
  - RPC
  - mendoza
