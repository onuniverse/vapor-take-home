# vapor-take-home

### Installing Vapor

1. Install Xcode
2. Install Brew (if needed)
3. `brew tap vapor/tap`
4. `brew install vapor/tap/vapor`

### Installing dependencies

After cloning this repo be sure to install all required dependencies via:

`vapor update`

### Database

[Download Postgres 11](https://postgresapp.com/downloads.html) if needed

Manually create databases for the app.

_Example_:

- `VaporTakeHome` **for running locally**
- `UniverseTransactionServiceTest` **for running unit tests**

### Configuring environment variables

Environment variables can be set by using a `.env` file.  
An `example.env` file is included as a template for the `.env` file.

**Required environment variables are**:

- `API_TOKEN`
- `DATABASE_URL`

### Running the app

- Postgres must be running.
- `vapor run serve`

### Generate Xcode project

`vapor xcode`

### Running the tests

- Postgres must be running.
- Open Xcode and press: `⌘ + U`


### Common errors

`PostgreSQL Error: role "vapor" does not exist` and `PostgreSQL Error: role "username" does not exist` indicate that the database connection string in the `DATABASE_URL` or `DATABASE_TEST_URL` contains a user value that does not currently exist in Postgres. Update the invalid role above with a valid one by [granting the role access the database](https://www.postgresql.org/docs/9.0/sql-grant.html) or [creating the needed user role for that database](https://www.postgresql.org/docs/8.0/sql-createuser.html).
