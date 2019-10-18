import unittest

from click.testing import CliRunner
from wazotester import wazotester


class WazotesterTest(unittest.TestCase):
    def test_wazotester_missing_parameters(self):

        runner = CliRunner()
        result = runner.invoke(wazotester)
        self.assertNotEqual(0, result.exit_code)
