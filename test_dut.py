from subprocess import check_output, check_call, PIPE
import unittest
import os
import shutil
import numpy as np

import logging
logging.basicConfig()
LOG = logging.getLogger(__name__)

def make_dut_tb():
    check_call('make -s dut_tb', shell=True)

def make_clean():
    check_call('make -s clean', shell=True)

def parse_output(output):
    blocks = [block.splitlines() for block in output.split('=================') if block]
    register_file_history = np.empty((len(blocks),16), dtype=np.int16)
    register_file_history[:,:] = 0xDEAD
    register_file_history[:,0] = 0
    for time, block in enumerate(blocks):
        for line in block:
            if line:
                register, value = line.split(' = ')
                r = int(register[-1], base=16)
                if value != 'xxxx':
                    v = int(value, base=16)
                    register_file_history[time, r] = v

    return register_file_history


class TestClear(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/test_clear.hex','./instr.hex')
        check_call(['./dut_tb'])

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')

    def test_clear(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_output(rf_dump.read())
        self.assertListEqual(register_file_history[-1,:].tolist(), [0]*16)


class TestINC(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/test_inc.hex','./instr.hex')
        check_call(['./dut_tb'])

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')

    def test_inc(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_output(rf_dump.read())
        self.assertListEqual(register_file_history[-1,:].tolist(), [0,1,2,3,4,5,6,7,-8,-7,-6,-5,-4,-3,-2,-1])

class TestSUB(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/test_sub.hex','./instr.hex')
        check_call(['./dut_tb'])

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')

    def test_sub(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_output(rf_dump.read())
        self.assertListEqual(register_file_history[-1,:].tolist(), [0,0,1,2,-6,1,6,7,-8,-7,-6,-5,-4,-3,-2,-1])

class TestNAND(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/test_nand.hex','./instr.hex')
        check_call(['./dut_tb'])

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')

    def test_nand(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_output(rf_dump.read())
        self.assertListEqual(register_file_history[-1,:].tolist(),
        [0,
        -2, # 1 NAND 1
        -3, # 3 NAND 2
        -5, # 6 NAND 4
        -6, # -1 NAND 5
        3, # -2 NAND -3
        6,7,-8,-7,-6,-5,-4,-3,-2,-1])

class TestXOR(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/test_xor.hex','./instr.hex')
        check_call(['./dut_tb'])

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')

    def test_xor(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_output(rf_dump.read())
        self.assertListEqual(register_file_history[-1,:].tolist(),
        [0,
         0, # 1 XOR 1
         1, # 3 XOR 2
         2, # 6 XOR 4
        -6, # -1 XOR 5
         3, # -2 XOR -3
         6,7,-8,-7,-6,-5,-4,-3,-2,-1])
