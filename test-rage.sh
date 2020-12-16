#!/bin/bash
set -eux

RAGE_DIR=$PWD/../Rust/rage
(cd $RAGE_DIR; cargo build --all)
export PATH=$PATH:$RAGE_DIR/target/debug

age-plugin-trezor -i "111" | tee trezor1.id
age-plugin-trezor -i "222" | tee trezor2.id
R1=$(grep recipient trezor1.id | cut -f 3 -d ' ')
R2=$(grep recipient trezor2.id | cut -f 3 -d ' ')

date | tee msg.txt

rage -e -r $R1 < msg.txt > enc.txt
rage -di trezor1.id < enc.txt

rage -e -r $R2 < msg.txt > enc.txt
rage -di trezor2.id < enc.txt

rage -e -r $R1 -r $R2 < msg.txt > enc.txt
rage -di trezor1.id < enc.txt
rage -di trezor2.id < enc.txt
