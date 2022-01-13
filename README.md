# vapor-take-home

## Setup

### Installing Vapor (v3)

1. Install Xcode
2. Install Brew (if needed)
3. `brew tap vapor/tap`
4. `brew install vapor/tap/vapor3`

### Installing dependencies

After cloning this repo be sure to install all required dependencies via:

`swift package update`

### Database

[Download Postgres 11](https://postgresapp.com/downloads.html) if needed

Manually create databases for the app:

- `VaporTakeHome`

### Configuring environment variables

Environment variables can be set by creating a `.env` file.  
An `example.env` file is included as a template for the `.env` file, this can be copied over and the `change-me`s should be replaced.

**Required environment variables are**:

- `API_TOKEN` - Discogs API token sent to you by interviewer
- `DATABASE_URL` - a postgres connection URL for the database set up above 

### Generate Xcode project

`vapor3 xcode`

### Running the app

- Postgres must be running.
- `vapor3 run serve` or run button in Xcode

### Running the tests

- Postgres must be running.
- Open Xcode and press: `⌘ + U`

### Common errors

`PostgreSQL Error: role "vapor" does not exist` and `PostgreSQL Error: role "username" does not exist` indicate that the database connection string in the `DATABASE_URL` or `DATABASE_TEST_URL` contains a user value that does not currently exist in Postgres. Update the invalid role above with a valid one by [granting the role access the database](https://www.postgresql.org/docs/9.0/sql-grant.html) or [creating the needed user role for that database](https://www.postgresql.org/docs/8.0/sql-createuser.html).


## Instructions

This sample project is set up to manage Users in a postgres database and fetch artists from a 3rd party service (Discogs). 

You will be adding new endpoints for searching for releases by artists and allowing users to create and manage playlists of these.

There is API documentation for what these endpoints should look like in api.yaml in the project root. 

This documentation is in the OpenAPI (previously swagger) format and can be viewed using Swagger UI plugins in different editors, or by copying the contents of that document to http://editor.swagger.io

There is also a postman collection included that has both the existing and new endpoints included in this repo.

### Song (Release) Search

An endpoint does not exist on the Discogs API to search releases by both title and artist ID, so use the all releases by artist endpoint

documentation here: https://www.discogs.com/developers#page:database,header:database-artist-releases

and then filter the results by the search string passed in.

### Playlists

Release ids should be used for creating or deleting songs from a playlist. When fetching a playlist detail, fetch the details of each song and return them formatted to match the documentation.

An individual release can be fetched from Discogs using the endpoint documented here:

https://www.discogs.com/developers#page:database,header:database-release
