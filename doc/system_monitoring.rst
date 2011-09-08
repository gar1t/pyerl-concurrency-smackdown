System Monitoring
=================

Server Process CPU and Memory
-----------------------------

Python Process
..............

.. code-block:: bash

  $ pidstat -r -u -p `pgrep python2` 2

Erlang Process
..............

.. code-block:: bash

  $ pidstat -r -u -p `pgrep beam` 2


Disk Swap (Paging)
------------------

.. code-block:: bash

  $ vmstat 2
