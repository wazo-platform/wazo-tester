dockerfile:
	docker build -t wazopbx/wazo-tester:latest -f Dockerfile .

venv:
	virtualenv -p python3 venv

setup:
	pip install -r requirements.txt
	pip install --editable .

dist:
	python3 setup.py sdist bdist_wheel

clean:
	rm -fr build dist wazotester.egg-info

test:
	py.test -p no:warnings

black:
	black --skip-string-normalization wazotester

flake8:
	flake8 --ignore=E501,E402,W503 wazotester

mypy:
	mypy wazotester

pylint:
	pylint wazotester

pycodestyle:
	pycodestyle --ignore=E501,W503,E402,E701 wazotester

coverage:
	coverage run -m py.test -p no:warnings
	coverage report
	coverage html
	coverage xml

.PHONY: dockerfile venv setup dist clean test black flake8 mypy pylint pycodestyle coverage
