# -*- coding: utf-8 -*-
# distutils: language=c++
# cython: language_level=3

"""
Table Module: core functionality

Handle common logistics for multiplayer game tables
"""

from abc import ABC, abstractmethod
from typing import Dict, Optional

from dataclasses import dataclass
#from flask_socketio import rooms
from flask_socketio import SocketIO, emit, join_room, leave_room
from overrides import override
from structlog import get_logger
from typeguard import typechecked

from db import User
from game import GameFactory, Player

logger = get_logger()

@typechecked
class Table:
    """ Manage Players and Game """

    def __init__(self, room_name:str, factory:GameFactory):
        self.room_name  :str               = room_name
        self.factory    :GameFactory       = factory
        self.players    :Dict[User,Player] = []
        self.game       :Optional[Game]    = None

    def join(self, user:User) -> bool:
        """ Request to join the Table """

        if user in self.players:
            return False

        if len(self.players) >= self.factory.hard_max():
            return False

        player         :Player             = self.factory.new_player(user)

        if (self.game is not None and
            not self.game.join(player)):
            return False

        self.players[user]                 = player
        return True

    def part(self, user:User) -> bool:
        """ Request to leave the Table """

        if user not in self.players:
            return False

        player        :Player             = self.players[user]
        if self.game is not None:
            self.game.part(player)
            if self.game.is_over():
                check :bool               = self.game.destroy()
                assert check
                self.game                 = None

        del self.players[user]
        return True

    def is_empty(self) -> bool:
        """ Whether the table has Players """

        return not self.players

    def destroy(self) -> bool:
        """ Request to destroy the Table """

        if not self.is_empty():
            return False

        if (self.game is not None and
            not self.game.destroy()):
            return False

        self.game                         = None
        return True

    def start(self) -> bool:
        """ Request to start the Game """

        if self.game is not None:
            return False

        if     len(self.players) <  self.factory.hard_min():
            return False
        assert len(self.players) <= self.factory.hard_max()

        self.game                         = self.factory.new_game(self.players.values())
        return True

@typechecked
class SocketIOTable(Table):
    """ Flask_SocketIO-specific Table """

    def __init__(self, room_name:str, socketio:SocketIO):
        super().__init__(room_name)
        self.socketio:SocketIO = socketio

    @override
    def join(self, user:User) -> bool:
        if not super().join(user):
            return False
        self.socketio.enter_room(user, self.room_name)
        return True

    @override
    def part(self, user:User) -> bool:
        if not super().part(user):
            return False
        self.socketio.leave_room(user, self.room_name)
        return True

    @override
    def destroy(self) -> bool:
        if not super().destroy():
            return False
        self.socketio.emit('table_destroyed', room=self.room_name)
        return True

@typechecked
class TableFactory(ABC):
    """ Abstract Table-creation from Lobby """

    @abstractmethod
    def new_table(self, room_name:str) -> Table:
        """ constructor """

        raise NotImplementedError

@typechecked
@dataclass
class SocketIOTableFactory(TableFactory):
    """ Flask_SocketIO-specific TableFactory """

    socketio:SocketIO

    @override
    def new_table(self, room_name:str) -> Table:
        return SocketIOTable(room_name, self.socketio)

__author__    :str = "YouChat"
__copyright__ :str = "Copyright 2024, InnovAnon, Inc."
__license__   :str = "Proprietary"
__version__   :str = "1.0"
__maintainer__:str = "@lmaddox"
__email__     :str = "InnovAnon-Inc@gmx.com"
__status__    :str = "Production"
