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
- **type**: for now only `api` is implemented which makes a REST API call


### teardown
Contain a list of actions to perform after the SIP tests. As for the setup key, teardown for now implements only REST API calls.


### workers
Contains the list of workers to be created to perform the tests. It supports the following configuration parameters:

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
