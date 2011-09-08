Simplest Possible Server
========================

.. code-block:: python
   :linenos:

   def serve():
       lsock = listen_socket()
       while True:
           handle_client(accept(lsock))

   def handle_client(client):
       def thread():
           read_request(client)
           send_response(client, "hello")
       start_thread(thread)

   serve()

