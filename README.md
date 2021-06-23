# Docker development setup

1) Install Docker.app 

2) gem install stack_car

3) We recommend committing .env to your repo with good defaults. .env.development, .env.production etc can be used for local overrides and should not be in the repo.

4) sc up

``` bash
gem install stack_car
sc up

```

# Deploy a new release

``` bash
sc release {staging | production} # creates and pushes the correct tags
sc deploy {staging | production} # deployes those tags to the server
```

Releaese and Deployment are handled by the gitlab ci by default. See ops/deploy-app to deploy from locally, but note all Rancher install pull the currently tagged registry image
Sap3 Gg
=========

This application was generated with the [rails_apps_composer](https://github.com/RailsApps/rails_apps_composer) gem
provided by the [RailsApps Project](http://railsapps.github.io/).

Diagnostics
-

This application was built with recipes that are NOT known to work together.

This application was built with preferences that are NOT known to work
together.

If the application doesn’t work as expected, please [report an issue](https://github.com/RailsApps/rails_apps_composer/issues)
and include these diagnostics:

We’d also like to know if you’ve found combinations of recipes or
preferences that do work together.

Recipes:

* core
* deployment
* devise
* email
* extras
* frontend
* gems
* git
* init
* learn_rails
* locale
* omniauth
* pages
* rails_bootstrap
* rails_devise
* rails_devise_pundit
* rails_foundation
* rails_mailinglist_signup
* rails_omniauth
* rails_signup_download
* railsapps
* readme
* roles
* setup
* tests

Preferences:

* git: true
* apps4: rails-signup-download
* announcements: none
* authentication: devise
* authorization: pundit
* better_errors: true
* deployment: none
* devise_modules: false
* form_builder: false
* local_env_file: false
* pry: false
* quiet_assets: true
* pages: users
* locale: none
* dev_webserver: thin
* prod_webserver: thin
* database: postgresql
* templates: erb
* tests: none
* frontend: bootstrap3
* email: none
* ban_spiders: true
* github: true

Ruby on Rails
---

This application requires:

-   Ruby
-   Rails

Learn more about [Installing Rails](http://railsapps.github.io/installing-rails.html).

Database
---

This application uses PostgreSQL with ActiveRecord.

Development
-

-   Template Engine: ERB
-   Testing Framework: Test::Unit
-   Front-end Framework: Bootstrap 3.0 (Sass)
-   Form Builder: None
-   Authentication: Devise
-   Authorization: Pundit
-   Admin: None






 delivery is disabled in development.

Getting Started


Lorem ipsum dolor sit amet, consectetur adipiscing elit.

Documentation and Support


This is the only documentation.

#### Issues

Lorem ipsum dolor sit amet, consectetur adipiscing elit.

Similar Projects
-

Lorem ipsum dolor sit amet, consectetur adipiscing elit.

Contributing
--

If you make improvements to this application, please share with others.

-   Fork the project on GitHub.
-   Make your feature addition or bug fix.
-   Commit with Git.
-   Send the author a pull request.

If you add functionality to this application, create an alternative
implementation, or build an application that is similar, please contact
me and I’ll add a note to the README so that others can find your work.

Credits
--

Lorem ipsum dolor sit amet, consectetur adipiscing elit.

License
--

Lorem ipsum dolor sit amet, consectetur adipiscing elit.
