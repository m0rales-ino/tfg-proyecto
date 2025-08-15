#!/bin/bash

vivado -mode batch -source src/Ethernet_Frame_Generator_Analyzer.tcl -nojournal -nolog
vivado -mode gui -project Ethernet_Frame_Generator_Analyzer/Ethernet_Frame_Generator_Analyzer.xpr -nojournal -nolog
