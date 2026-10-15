#!/bin/bash

BASE_URL="https://raw.githubusercontent.com/arthurpeixotomelo/ws/main/config/arch"

archinstall --config "$BASE_URL/$1_config.json" --creds "$BASE_URL/creds.json"