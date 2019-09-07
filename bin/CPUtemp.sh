#!/bin/bash

sensors | sed -rn 's/.*Core 0:\s+([^ ]+).*/\1/p'