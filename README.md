Kitabu Server
================

API
----------

Adding links --

- /api/add_link?url=**&phoneno=**&typep=true&tag_list=** (POST)

`{"link":{"id":1,"url":"http://prashant.at","tag_list":[],"typep":null,"user":{"id":1,"phoneno":"5109048439","email":"prashant.barca@gmail.com","name":"Prashant"}}}` or `false`.

- /api/delete_link/:id/:phoneno (GET)

`true` or `false`.

- /api/getlinks/:id/:phoneno <- Add an id and phonenumber to the URL. The id will be the highest id value in the local db. The server will only fetch and give the values greater than this id. So only newer values get added to the Sqlite db.

Return json format `{"public":[], "private":[]}`.

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
