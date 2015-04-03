from subprocess import check_output, check_call, PIPE
import unittest
import os
import shutil

import logging
logging.basicConfig()
LOG = logging.getLogger(__name__)

def make_dut_tb():
    LOG.debug(check_call('make -s dut_tb', shell=True))

def make_clean():
    LOG.debug(check_call('make -s clean', shell=True))

class TestClear(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/test_clear.hex','./instr.hex')

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('./instr.hex')

    def test_clear(self):
        stdout = check_output(['./dut_tb'])
        last_block = stdout.split('==')[-1]
        for line in last_block.split('\n'):
            if line:
                reg, value = line.split(' = ')
                self.assertEqual(' = '.join([reg, '0000']), line)
