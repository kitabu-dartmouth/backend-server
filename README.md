Kitabu Server
================

This application was generated with the [rails_apps_composer](https://github.com/RailsApps/rails_apps_composer) gem
provided by the [RailsApps Project](http://railsapps.github.io/).

Rails Composer is supported by developers who purchase our RailsApps tutorials.

API
----------

Adding links --

- /api/add_link?url=**&phoneno=**&typep=true&tag_list=** (POST)

- /api/delete_link/:id/:phoneno (GET)

- /api/getlinks/:id <- Add an id to the URL. The id will be the highest id value in the local db. The server will only fetch and give the values greater than this id. So only newer values get added to the Sqlite db.

Problems? Issues?
-----------

Need help? Ask on Stack Overflow with the tag 'railsapps.'

Your application contains diagnostics in the README file. Please provide a copy of the README file when reporting any issues.

If the application doesn't work as expected, please [report an issue](https://github.com/RailsApps/rails_apps_composer/issues)
and include the diagnostics.

Ruby on Rails
-------------

This application requires:

- Ruby 2.3.0
- Rails 5.0.1

Learn more about [Installing Rails](http://railsapps.github.io/installing-rails.html).

Getting Started
---------------

Documentation and Support
-------------------------

Issues
-------------

Similar Projects
----------------

Contributing
------------

Credits
-------

License
-------
