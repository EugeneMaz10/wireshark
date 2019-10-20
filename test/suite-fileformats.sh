#!/bin/bash
#
# Test file format conversions of the Wireshark tools
#
# Wireshark - Network traffic analyzer
# By Gerald Combs <gerald@wireshark.org>
# Copyright 2005 Ulf Lamping
#
# SPDX-License-Identifier: GPL-2.0-or-later
#


# common exit status values
EXIT_OK=0
EXIT_COMMAND_LINE=1
EXIT_ERROR=2

TS_FF_ARGS="-Tfields -e frame.number -e frame.time_epoch -e frame.time_delta"

FF_BASELINE=./ff-ts-usec-pcap-direct.txt
DIFF_OUT=./diff-output.txt

# Microsecond pcap / stdin
ff_step_usec_pcap_stdin() {
	$TSHARK $TS_FF_ARGS -r - < "${CAPTURE_DIR}dhcp.pcap" > ./ff-ts-usec-pcap-stdin.txt 2> /dev/null
	diff -u $FF_BASELINE ./ff-ts-usec-pcap-stdin.txt > $DIFF_OUT 2>&1
	RETURNVALUE=$?
	if [ ! $RETURNVALUE -eq $EXIT_OK ]; then
		test_step_failed "Output of microsecond pcap direct read vs microsecond pcap via stdin differ"
		cat $DIFF_OUT
		return
	fi
	test_step_ok
}

# Nanosecond pcap / stdin
ff_step_nsec_pcap_stdin() {
	$TSHARK $TS_FF_ARGS -r - < "${CAPTURE_DIR}dhcp-nanosecond.pcap" > ./ff-ts-nsec-pcap-stdin.txt 2> /dev/null
	diff -u $FF_BASELINE ./ff-ts-nsec-pcap-stdin.txt > $DIFF_OUT 2>&1
	RETURNVALUE=$?
	if [ ! $RETURNVALUE -eq $EXIT_OK ]; then
		test_step_failed "Output of microsecond pcap direct read vs nanosecond pcap via stdin differ"
		cat $DIFF_OUT
		return
	fi
	test_step_ok
}

# Nanosecond pcap / direct
ff_step_nsec_pcap_direct() {
	$TSHARK $TS_FF_ARGS -r "${CAPTURE_DIR}dhcp-nanosecond.pcap" > ./ff-ts-nsec-pcap-direct.txt 2> /dev/null
	diff -u $FF_BASELINE ./ff-ts-nsec-pcap-direct.txt > $DIFF_OUT 2>&1
	RETURNVALUE=$?
	if [ ! $RETURNVALUE -eq $EXIT_OK ]; then
		test_step_failed "Output of microsecond pcap direct read vs nanosecond pcap direct read differ"
		cat $DIFF_OUT
		return
	fi
	test_step_ok
}

# Microsecond pcapng / stdin
ff_step_usec_pcapng_stdin() {
	$TSHARK $TS_FF_ARGS -r - < "${CAPTURE_DIR}dhcp.pcapng" > ./ff-ts-usec-pcapng-stdin.txt 2> /dev/null
	diff -u $FF_BASELINE ./ff-ts-usec-pcapng-stdin.txt > $DIFF_OUT 2>&1
	RETURNVALUE=$?
	if [ ! $RETURNVALUE -eq $EXIT_OK ]; then
		test_step_failed "Output of microsecond pcap direct read vs microsecond pcapng via stdin differ"
		cat $DIFF_OUT
		return
	fi
	test_step_ok
}

# Microsecond pcapng / direct
ff_step_usec_pcapng_direct() {
	$TSHARK $TS_FF_ARGS -r "${CAPTURE_DIR}dhcp.pcapng" > ./ff-ts-usec-pcapng-direct.txt 2> /dev/null
	diff -u $FF_BASELINE ./ff-ts-usec-pcapng-direct.txt > $DIFF_OUT 2>&1
	RETURNVALUE=$?
	if [ ! $RETURNVALUE -eq $EXIT_OK ]; then
		test_step_failed "Output of microsecond pcap direct read vs microsecond pcapng direct read differ"
		cat $DIFF_OUT
		return
	fi
	test_step_ok
}

# Nanosecond pcapng / stdin
ff_step_nsec_pcapng_stdin() {
	$TSHARK $TS_FF_ARGS -r - < "${CAPTURE_DIR}dhcp-nanosecond.pcapng" > ./ff-ts-nsec-pcapng-stdin.txt 2> /dev/null
	diff -u $FF_BASELINE ./ff-ts-nsec-pcapng-stdin.txt > $DIFF_OUT 2>&1
	RETURNVALUE=$?
	if [ ! $RETURNVALUE -eq $EXIT_OK ]; then
		test_step_failed "Output of microsecond pcap direct read vs nanosecond pcapng via stdin differ"
		cat $DIFF_OUT
		return
	fi
	test_step_ok
}

# Nanosecond pcapng / direct
ff_step_nsec_pcapng_direct() {
	$TSHARK $TS_FF_ARGS -r "${CAPTURE_DIR}dhcp-nanosecond.pcapng" > ./ff-ts-nsec-pcapng-direct.txt 2> /dev/null
	diff -u $FF_BASELINE ./ff-ts-nsec-pcapng-direct.txt > $DIFF_OUT 2>&1
	RETURNVALUE=$?
	if [ ! $RETURNVALUE -eq $EXIT_OK ]; then
		test_step_failed "Output of microsecond pcap direct read vs nanosecond pcapng direct read differ"
		cat $DIFF_OUT
		return
	fi
	test_step_ok
}

tshark_ff_suite() {
	# Microsecond pcap direct read is used as the baseline.
	test_step_add "Microsecond pcap via stdin" ff_step_usec_pcap_stdin
	test_step_add "Nanosecond pcap via stdin" ff_step_nsec_pcap_stdin
	test_step_add "Nanosecond pcap direct read" ff_step_nsec_pcap_direct
	test_step_add "Microsecond pcapng via stdin" ff_step_usec_pcapng_stdin
	test_step_add "Microsecond pcapng direct read" ff_step_usec_pcapng_direct
	test_step_add "Nanosecond pcapng via stdin" ff_step_nsec_pcapng_stdin
	test_step_add "Nanosecond pcapng direct read" ff_step_nsec_pcapng_direct
}

ff_cleanup_step() {
	rm -f ./ff-ts-*.txt
	rm -f $DIFF_OUT
}

ff_prep_step() {
	ff_cleanup_step
	$TSHARK $TS_FF_ARGS -r "${CAPTURE_DIR}dhcp.pcap" > $FF_BASELINE 2> /dev/null
}

fileformats_suite() {
	test_step_set_pre ff_prep_step
	test_step_set_post ff_cleanup_step
	test_suite_add "TShark file format conversion" tshark_ff_suite
	#test_suite_add "Wireshark file format" wireshark_ff_suite
	#test_suite_add "Editcap file format" editcap_ff_suite
}
#
# Editor modelines  -  http://www.wireshark.org/tools/modelines.html
#
# Local variables:
# sh-basic-offset: 8
# tab-width: 8
# indent-tabs-mode: t
# End:
#
# vi: set shiftwidth=8 tabstop=8 noexpandtab:
# :indentSize=8:tabSize=8:noTabs=false:
#