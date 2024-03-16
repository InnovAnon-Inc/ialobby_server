# -*- coding: utf-8 -*-
# distutils: language=c++
# cython: language_level=3

"""
Entrypoint
"""

from flask import Flask, render_template
from flask_socketio import SocketIO, emit, join_room, leave_room
from structlog import get_logger
#from typeguard import typechecked

from .auth import Authentication, Authenticator, SupabaseIntegration
from .conf import config
from .lobby import Lobby
from .table import TableFactory, SocketIOTableFactory

logger                       = get_logger()

app          :Flask          = Flask(__name__)
# TODO what is this?
#app.config['SECRET_KEY'] = 'your_secret_key'  # Replace with your actual secret key
socketio     :SocketIO       = SocketIO(app)

authenticator:Authenticator  = SupabaseIntegration(config.supabase_url, config.supabase_key, config.game_name)
tf           :TableFactory   = SocketIOTableFactory(socketio)
lobby        :Lobby          = Lobby(tf)

#@typechecked
@socketio.on('connect')
def handle_connect():
    game     :str            = authenticator.get_game()
    return game

@socketio.on('login')
def handle_logi():
    # Logic to handle user connection and authentication using Supabase
    username :str            = ...
    secret   :str            = ...
    auth     :Authentication = authenticator.get_authentication(username, secret)
    valid    :bool           = auth.is_valid()
    if not auth:
        # TODO
        raise NotImplementedError

    # Upon successful authentication, allow the user to access the game lobby
    #lobby.add_user(user)
    raise NotImplementedError

#@socketio.on('join_lobby')
#def handle_join_lobby(data):
#    # Logic to allow a user to join the game lobby
#    # Validate user's access and join the lobby

# TODO disconnect
#@typechecked
@socketio.on('leave_lobby')
def handle_leave_lobby(data):
    # Logic to handle user leaving the game lobby
    # Remove user from the lobby and associated game tables
    raise NotImplementedError

# TODO list tables
# TODO join table
# TODO leave table
# TODO create table

#@typechecked
@socketio.on('player_move')
def handle_player_move(data):
    # Logic to process and handle a player's move within a specific game table
    # Update the game module's internal state based on the received move
    raise NotImplementedError

# Additional event handlers and logic for game table interactions can be added as needed

def main() -> None:
    socketio.run(app, allow_unsafe_werkzeug=True)

__author__    :str = "YouChat"
__copyright__ :str = "Copyright 2024, InnovAnon, Inc."
__license__   :str = "Proprietary"
__version__   :str = "1.0"
__maintainer__:str = "@lmaddox"
__email__     :str = "InnovAnon-Inc@gmx.com"
__status__    :str = "Production"
