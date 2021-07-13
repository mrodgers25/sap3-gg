# Stories About Places
This application was generated with the [rails_apps_composer](https://github.com/RailsApps/rails_apps_composer) gem
provided by the [RailsApps Project](http://railsapps.github.io/).

## Table of Contents
* [Prerequisites](#prerequisites)
* [Development Guide](#development-guide)
  * [Database](#database)
  * [Important URL's](#important-urls)
* [Running the app](#running-the-app)
  * [Decrypt the env](#decrypt-the-env)
  * [Encrypt the env](#encrypt-the-env)
  * [Pull and build the container image](#pull-and-build-the-container-image)
  * [Start the server](#start-the-server)
  * [Accessible commands with the server running](#accessible-commands-with-the-server-running)
    * [Bundle the gems](#bundle-the-gems)
    * [Create the databases](#create-the-databases)
    * [Run migrations](#run-migrations)
    * [Seed the databases](#seed-the-databases)
    * [Bash into the container](#bash-into-the-container)
  * [Access the admin user](#access-the-admin-user)
  * [Stop the server](#stop-the-server)
* [Deployment](#deployment)
  * [Staging](#staging)
  * [Production](#production)
* [Contributing](#contributing)
* [License](#license)

## Prerequisites
- Ruby (Make sure you're using the version listed in the Gemfile)
- [Rails](http://railsapps.github.io/installing-rails.html)
- Download [Docker Desktop](https://www.docker.com/products/docker-desktop) and log in
- Install [stack car](https://gitlab.com/notch8/stack_car)
    ``` bash
    gem install stack_car
    ```

## Development guide
### Database
This application uses PostgreSQL with ActiveRecord.

### Important URL's
- Local site: localhost:3000
- Staging site: https://stories-about-places-staging.notch8.cloud/
- Production site: https://www.storiesaboutplaces.com/

## Running the app
If you have issues with your `stack_car` installation and can't use the `sc` commands below, refer to the [documentation](https://gitlab.com/notch8/stack_car) for the corresponding `docker compose` commands.

### Decrypt the env
``` bash
keybase decrypt -i .env.enc -o .env
```

### Encrypt the env
``` bash
keybase encrypt -i .env -o .env.enc --team notch8
```

### Pull and build the container image
If this is your first time working in this repo or the Dockerfile has been updated, do the steps below.
```bash
  sc pull
  sc build
```

### Start the server
```bash
  sc up
```

### Accessible commands with the server running
Make sure these are run in a separate tab/window than the running server
#### Bundle the gems
```bash
  sc be bundle
```

#### Create the databases
```bash
  sc be rails db:create # Creates a development and test db
```

#### Run migrations
```bash
  sc be rails db:migrate
```

#### Seed the databases
```bash
  sc be rails db:seed
```

If the database has already been seeded but you need to re-seed, run the following command:
``` bash
sc be rails db:drop db:create db:migrate db:seed
```

#### Bash into the container
```bash
  sc exec bash
```

  - Access the rails console for debugging
    ```
    bundle exec rails c
    ```

  - Run rubocop (learn about the `-a` flag [here](https://docs.rubocop.org/rubocop/usage/basic_usage.html#auto-correcting-offenses))
    ```
    bundle exec rubocop -a
    ```

  - Run [rspec](https://github.com/rspec/rspec-rails/tree/4-1-maintenance#running-specs)
    ```
    bundle exec rspec
    ```
    - When running a single file: `bundle exec rspec <path-to-your-file>`

### Access the admin user
Email: admin@notch8.com
Password: password

### Stop the server
- Press `Ctrl + C` in the window where `sc up` is running
- When that's done `sc stop` shuts down the running containers

## Deployment
### Staging
When a branch is merged into `master`, it will kick off a deployment to staging

### Production
<!-- TODO(alishaevn): update these steps -->
<!-- ``` bash
sc release {staging | production} # creates and pushes the correct tags
sc deploy {staging | production} # deployes those tags to the server
```

Release and Deployment are handled by the gitlab ci by default. See ops/deploy-app to deploy from locally, but note all Rancher install pull the currently tagged registry image -->

## Contributing
If you make improvements to this application, please share with others.
- Fork the project on GitHub.
- Make your feature addition or bug fix.
- Commit with Git.
- Send the author a pull request.

If you add functionality to this application, create an alternative
implementation, or build an application that is similar, please contact
me and I’ll add a note to the README so that others can find your work.

# License
