.PHONY: dockerfile
dockerfile:
	make dist
	docker build --no-cache -t wazopbx/wazo-tester:latest -f Dockerfile .

.PHONY: venv
venv:
	virtualenv -p python3 venv

.PHONY: setup
setup:
	pip install -r requirements.txt
	pip install --editable .

.PHONY: dist
dist:
	python3 setup.py sdist bdist_wheel

.PHONY: clean
clean:
	rm -fr build dist wazotester.egg-info

.PHONY: test
test:
	py.test -p no:warnings

.PHONY: black
black:
	black --skip-string-normalization wazotester

.PHONY: flake8
flake8:
	flake8 --ignore=E501,E402,W503 wazotester

.PHONY: mypy
mypy:
	mypy wazotester

.PHONY: pylint
pylint:
	pylint wazotester

.PHONY: pycodestyle
pycodestyle:
	pycodestyle --ignore=E501,W503,E402,E701 wazotester

.PHONY: coverage
coverage:
	coverage run -m py.test -p no:warnings
	coverage report
	coverage html
	coverage xml
