# wazo coordinator and test runner

Enter a Python 3 virtualenv and run the setup:

```
$ make setup
```

You can now run the test runner:

```
$ wazotester -t 1.2.3.4 -a http://router-confd:8000 -e sipp sample.yaml
```

Where:

* **-t** is the target IP address
* **-a** is the address of the API server
* **-e** is the executable to run, defaults to `sipp`
* **sample.yaml** is the path to the configuration file

## Configuration file

`wazotester` accepts a YAML configuration file with the following root keys:

- setup
- teardown
- workers

### setup
Contain a list of actions to perform before the real testing. The parameters are the following:
- **type**: for now only `api` is implemented which makes a REST API call.

`api` supports the following configuration parameters:
* **uri**: the endpoint of the API where to make the request
* **method**: the http method to be used (defaults to `POST`)
* **store_response**: The name of the key for the `stored_responses` array used in other API calls for populating variables dependant of previous requests
* **payload**: the json payload to be sent (defaults to empty object)

#### Example using stored_responses
If you make an API call and use `store_response` value as `tenant` then in another API call you can use in the payload the value returned from the previous call like this:
```tenant_id: "{tenant.id}"```


### workers
Contains the list of workers to be created to perform the tests. 
There are two type of workers:
* sipp
* kamailio_xhttp

`sipp` supports the following configuration parameters:

* **number**: the number of instances to run (defaults to `1`)
* **repeat**: the number of times this worker should run (defaults to `1`)
* **timeout**: maximum number of seconds the worker can run before being killed, defaults to `None` (no timeout is enforced)
* **scenario**: path to the XML sipp scenario to run relative to the YAML configuration file
* **delay**: number of ms of delay before running the workers (defaults to `0`)
* **call_limit**: maximum number of concurrent active calls (`-l` parameter of sipp), defaults to `1`
* **call_number**: maximum number of calls (`-m` parameter of sipp) (defaults to `1`)
* **call_rate**: call rate increment (`-r` parameter of sipp) (defaults to `1`)
* **call\_rate\_period**: call rate period in ms (`-rp` parameter of sipp) (/(defaults to `1000`)
* **values**: key/value map of numerical or string values to be replaced in the XML tempalte.

The parameters which accept numerical values have support for random values expressed as follows:
```
delay:
  min: 1000
  max: 2000
```

Random values are calculated based on the random machine seed number printed by `wazotester` and configurabile through the `-s` option to make random tests reproducibles.


`kamailio_xhttp` supports the following configuration parameters:
* **uri**: the URI of the kamailio node and path where to send the request
* **delay**: number of seconds of delay before running the workers (defaults to `0`)
* **method**: the http method to be used (defaults to `POST`)
* **payload**: the json payload to be sent (defaults to empty object)


### teardown
Contain a list of actions to perform after the SIP tests.
It implements two methods:
* api
* kamailio_xhttp

The `api` type is the same as for `setup` and `kamailio_xhttp` is the same as for the `workers` but it's used without a delay and without threading.
