#!/bin/bash
source .venv/bin/activate && prisma migrate deploy && python main.py