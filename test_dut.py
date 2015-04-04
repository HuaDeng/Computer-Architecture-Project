from subprocess import check_output, check_call, PIPE, STDOUT
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

def parse_rf_output(output):
    blocks = [block.splitlines() for block in output.split('=================') if block]
    register_file_history = np.empty((len(blocks),16), dtype=np.int16)
    register_file_history[:,:] = 0xDEAD
    register_file_history[:,0] = 0
    for time, block in enumerate(blocks):
        for line in block:
            if line:
                register, value = line.split(' = ')
                r = int(register[-1], base=16)
                if 'x' not in value:
                    v = int(value, base=16)
                    register_file_history[time, r] = v

    return register_file_history

def parse_mem_output(output):
    block = output.splitlines()
    register_file_history = np.empty(65536, dtype=np.int16)
    register_file_history[:] = 0xDEAD
    for line in block:
        if line:
            register, value = line.split(' = ')
            r = int(register[3:], base=16)
            if value != 'xxxx':
                v = int(value, base=16)
                register_file_history[r] = v

    return register_file_history


class TestClear(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/test_clear.hex','./instr.hex')
        check_output(['./dut_tb'], stderr=STDOUT)

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')
        os.unlink('mem_dump.txt')

    def test_clear(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_rf_output(rf_dump.read())
        self.assertListEqual(register_file_history[-1,:].tolist(), [0]*16)


class TestINC(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/test_inc.hex','./instr.hex')
        check_output(['./dut_tb'], stderr=STDOUT)

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')
        os.unlink('mem_dump.txt')

    def test_inc(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_rf_output(rf_dump.read())
        self.assertListEqual(register_file_history[-1,:].tolist(), [0,1,2,3,4,5,6,7,-8,-7,-6,-5,-4,-3,-2,-1])

class TestSUB(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/test_sub.hex','./instr.hex')
        check_output(['./dut_tb'], stderr=STDOUT)

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')
        os.unlink('mem_dump.txt')

    def test_sub(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_rf_output(rf_dump.read())
        self.assertListEqual(register_file_history[-1,:].tolist(), [0,0,1,2,-6,1,6,7,-8,-7,-6,-5,-4,-3,-2,-1])

class TestNAND(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/test_nand.hex','./instr.hex')
        check_output(['./dut_tb'], stderr=STDOUT)

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')
        os.unlink('mem_dump.txt')

    def test_nand(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_rf_output(rf_dump.read())
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
        check_output(['./dut_tb'], stderr=STDOUT)

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')
        os.unlink('mem_dump.txt')

    def test_xor(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_rf_output(rf_dump.read())
        self.assertListEqual(register_file_history[-1,:].tolist(),
        [0,
         0, # 1 XOR 1
         1, # 3 XOR 2
         2, # 6 XOR 4
        -6, # -1 XOR 5
         3, # -2 XOR -3
         6,7,-8,-7,-6,-5,-4,-3,-2,-1])

class TestSRA(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/test_sra.hex','./instr.hex')
        check_output(['./dut_tb'], stderr=STDOUT)

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')
        os.unlink('mem_dump.txt')

    def test_sra(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_rf_output(rf_dump.read())
        self.assertListEqual(register_file_history[-1,:].tolist(),
        [0,
         2, # 4 >> 1
         1, # 4 >> 2
         -1, # -1 >> 3
         4,
         5,
         6,7,-8,-7,-6,-5,-4,-3,-2,-1])

class TestSRL(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/test_srl.hex','./instr.hex')
        check_output(['./dut_tb'], stderr=STDOUT)

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')
        os.unlink('mem_dump.txt')

    def test_srl(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_rf_output(rf_dump.read())
        self.assertListEqual(register_file_history[-1,:].tolist(),
        [0,
         2, # 4 >> 1
         1, # 4 >> 2
         0x1FFF, # -1 >> 3
         4,
         5,
         6,7,-8,-7,-6,-5,-4,-3,-2,-1])

class TestSLL(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/test_sll.hex','./instr.hex')
        check_output(['./dut_tb'], stderr=STDOUT)

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')
        os.unlink('mem_dump.txt')

    def test_sll(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_rf_output(rf_dump.read())
        self.assertListEqual(register_file_history[-1,:].tolist(),
        [0,
         8, # 4 << 1
         16, # 4 << 2
         -8, # -1 << 3
         4,
         5,
         6,7,-8,-7,-6,-5,-4,-3,-2,-1])


class TestSW(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/test_sw.hex','./instr.hex')
        check_output(['./dut_tb'], stderr=STDOUT)

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')
        os.unlink('mem_dump.txt')

    def test_sw(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_rf_output(rf_dump.read())

        with open('mem_dump.txt') as mem_dump:
            end_mem = parse_mem_output(mem_dump.read())

        # SW R5, 0x55
        self.assertEqual(end_mem[0x55], register_file_history[-1, 5])

        #SW R5, 0x0 ; DS = 0xFFFF
        self.assertEqual(end_mem[-1], register_file_history[-1, 5])

        #SW R6, -0x1 ; DS = 0xFFFF
        self.assertEqual(end_mem[-2], register_file_history[-1, 6])

class TestLW(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/test_lw.hex','./instr.hex')
        check_output(['./dut_tb'], stderr=STDOUT)

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')
        os.unlink('mem_dump.txt')

    def test_lw(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_rf_output(rf_dump.read())

        with open('mem_dump.txt') as mem_dump:
            end_mem = parse_mem_output(mem_dump.read())

        # LW R1, #-1  ; DS=0xFFFF
        self.assertEqual(end_mem[-2], register_file_history[-1, 1])


class TestLHB(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/test_lhb.hex','./instr.hex')
        check_output(['./dut_tb'], stderr=STDOUT)

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')
        os.unlink('mem_dump.txt')

    def test_lhb(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_rf_output(rf_dump.read())

        self.assertListEqual([0x0000,0x0100,0x0200,0x0300,0x0400,0x0500,0x0600,0x0700,0x0800,0x0900,0x0A00,0x0B00,0x0C00,0x0D00,0x0E00,0x0F00],
        register_file_history[-1].astype(np.uint16).tolist())

class TestLLB(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/test_llb.hex','./instr.hex')
        check_output(['./dut_tb'], stderr=STDOUT)

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')
        os.unlink('mem_dump.txt')

    def test_llb(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_rf_output(rf_dump.read())

        self.assertListEqual([0x0000,0x0101,0x0202,0x0303,0x0404,0x0505,0x0606,0x0707,0x0808,0x0909,0x0A0A,0x0B0B,0x0C0C,0x0D0D,0x0E0E,0x0F0F],
        register_file_history[-1].astype(np.uint16).tolist())

class TestB(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/test_b.hex','./instr.hex')
        check_output(['./dut_tb'], stderr=STDOUT)

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')
        os.unlink('mem_dump.txt')

    def test_b(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_rf_output(rf_dump.read())

        self.assertListEqual(register_file_history[-1,:].tolist(), [0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0])

class TestCALL(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/test_call.hex','./instr.hex')
        check_output(['./dut_tb'], stderr=STDOUT)

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')
        os.unlink('mem_dump.txt')

    def test_call(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_rf_output(rf_dump.read())

        self.assertEqual(register_file_history[-1,1], 1)


class TestBasicOp(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/basic_op.hex','./instr.hex')
        check_output(['./dut_tb'], stderr=STDOUT)

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')
        os.unlink('mem_dump.txt')

    def test_basic_op(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_rf_output(rf_dump.read())

        with open('mem_dump.txt') as mem_dump:
            end_mem = parse_mem_output(mem_dump.read())

        self.assertListEqual([0x0000,0x0001,0x0010,0x0011,0xFFFF,0x0011,0x0011,0x000F,0xFFFF,0x0FFF,0xFFF0,0xFFF0,0xDEAD,0xDEAD,0x000B,0xDEAD],
        register_file_history[-1].astype(np.uint16).tolist())
        self.assertEqual(0xFFF0, end_mem[10].astype(np.uint16))

class TestDataDependency(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        make_dut_tb()
        shutil.copy('tests/data_dependency.hex','./instr.hex')
        check_output(['./dut_tb'], stderr=STDOUT)

    @classmethod
    def tearDownClass(cls):
        make_clean()
        os.unlink('instr.hex')
        os.unlink('rf_dump.txt')
        os.unlink('mem_dump.txt')

    def test_data_dependency(self):
        with open('rf_dump.txt') as rf_dump:
            register_file_history = parse_rf_output(rf_dump.read())

        with open('mem_dump.txt') as mem_dump:
            end_mem = parse_mem_output(mem_dump.read())

        self.assertListEqual([0x0000,0x0000,0x0000,0x0000,0x000C,0xDEAD,0xDEAD,0xDEAD,0xDEAD,0xDEAD,0xDEAD,0xDEAD,0xDEAD,0xDEAD,0x0000,0xDEAD],
        register_file_history[-1].astype(np.uint16).tolist())
        self.assertEqual(0x0000, end_mem[1].astype(np.uint16))
        self.assertEqual(0x0000, end_mem[7].astype(np.uint16))
