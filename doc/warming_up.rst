Warming Up
==========

Requirements
------------

 * Erlang
 * Python 2.x
 * ApacheBench

Starting
--------

Python
......

.. code-block:: bash

  $ ./server.py
  Python server is listening on port 7000

Erlang
......

.. code-block:: bash

  $ ./server.escript
  Erlang server is listening on port 7000

Taunt!
------

.. code-block:: bash

  $ ab -r -n 100 -c 10 http://127.0.0.1:7000/
