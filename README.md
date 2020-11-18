# Postcode App

A small Rails-based webapp to validate UK postcodes and show whether a postcode is located either within a certain 
Lower Layer Super Output Area (LSOA) prefix or included in a previously configured allow-list.

## TL;DR

If you happen to deal with ruby projects a lot, the quick start is:

```shell script
$ git clone git@github.com/defsprite/postcode-app
$ cd postcode-app
$ bundle install
$ vi config/postcodes.yml
$ bundle exec rails server
$ open "http://localhost:3000/postcode_validation/new"
```
 
## Docker

Should you have Docker installed you can build a development docker image with the following command (issued in the 
top-level directory of the project):
```shell script
$ docker build -t sh24/postcode-app:latest .
```

After that, you can now start the server:
```shell script
$ docker run --rm -p 3000:3000 sh24/postcode-app:latest
```
Voila! Pointing your browser to http://localhost:3000/postcode_validation/new should show the validation form.

To run the specs:
```shell script
docker run --rm sh24/postcode-app:latest rspec
```

## Local Installation

### Preconditions

In order to run the app locally and install gem dependencies, you will need Ruby version 2.7 and basic build tooling 
such as make and and gcc. You may need to install the following dependencies with their development header files:

- curl
- sqlite3

This depends highly on your local system, on an Ubuntu Linux this could be `apt-get install libcurl libcurl-dev` 

### Installing gem dependencies

This project uses https://bundler.io/ to manage dependent ruby gems:

```shell script
$ bundle install
```

### Database

No database setup or seeding is needed at this point.

### Starting the server

To start the web app on port 1234: 

```shell script
$ bundle exec rails server -p 1234
```
 You should now be able to reach the postcode form on http://localhost:1234/postcode_validation/new

## Configuration

You can configure the allowed LSOA prefixes and specifically allowed extra postcodes in `config/postcodes.yml` like so:

```yaml
lsoa_prefixes:
  - Lambeth
  - Southwark
extra_postcodes:
  - SH24 1AA
  - SH24 1AB
``` 

## CI
There is no CI pipeline yet, this project is used for local development only at this time. 

## Deployment
There is no setup for a production or staging system yet. 
