#!/bin/sh

if [ -e kernel.s ]; then
  nasm boot.s -o boot.bin -l boot.lst
  nasm kernel.s -o kernel.bin -l kernel.lst
  cat boot.bin kernel.bin > boot.img
else
  nasm boot.s -o boot.img -l boot.lst
fi