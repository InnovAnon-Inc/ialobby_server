# -*- coding: utf-8 -*-
# distutils: language=c++
# cython: language_level=3

"""
Configuration Module
"""

from argparse import Namespace
from configargparse import ArgumentParser
from typeguard import typechecked

# Initialize a parser with default values and configuration file support
parser:ArgumentParser = ArgumentParser(default_config_files=['config.ini', '.env'])
parser.add_argument('--supabase_url', type=str, env_var='SUPABASE_URL', help='Supabase URL')
parser.add_argument('--supabase_key', type=str, env_var='SUPABASE_KEY', help='Supabase API Key')
parser.add_argument('--game_name',    type=str, env_var='GAME_NAME',    help='Game Name')

@typechecked
def load_config() -> Namespace:
    """ Load constants and program arguments from command line, environemt, config files """

    # Load configuration from environment variables and configuration files
    return parser.parse_args()

# Load the configuration when the module is imported
config:Namespace = load_config()

__author__    :str = "YouChat"
__copyright__ :str = "Copyright 2024, InnovAnon, Inc."
__license__   :str = "Proprietary"
__version__   :str = "1.0"
__maintainer__:str = "@lmaddox"
__email__     :str = "InnovAnon-Inc@gmx.com"
__status__    :str = "Production"
