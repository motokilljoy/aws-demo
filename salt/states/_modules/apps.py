import salt

import salt
import sys
import platform
import string
import random

def status():
	return "installed"

def setup(superuser, superpass, appuser, lto_password):
	return "user: " + user + ", pwd: " + lto_password
