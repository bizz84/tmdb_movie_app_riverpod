#!/bin/bash

# Generate the .env file from using the 1Password CLI
echo "TMDB_KEY=$(op read op://CodeWithAndrea/TMDB/credential)" > .env
