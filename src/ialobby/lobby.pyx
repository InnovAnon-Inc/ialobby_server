# -*- coding: utf-8 -*-
# distutils: language=c++
# cython: language_level=3

"""
Lobby Module: core functionality

Handle common logistics for multiplayer game servers
"""

from typing import Dict, Optional

from dataclasses import dataclass
from structlog import get_logger
from typeguard import typechecked
from uuid import uuid4

from db import User
from table import TableFactory, Table

logger = get_logger()

@typechecked
class Lobby:
    """ Manage Tables """

    # TODO need a way to manage RT / tick-based games

    def __init__(self, factory:TableFactory):
        self.factory :TableFactory     = factory
        self.tables  :Dict[str, Table] = {}

    def new_table_name(self, room_name:Optional[str]) -> Optional[str]:
        """ Helper method: ensure unique Table names """

        if room_name is not None:
            if room_name in self.tables:
                return None
            return room_name

        room_name:str = uuid4()
        while room_name in self.tables:
            room_name = uuid4()
        assert room_name not in self.tables
        return room_name

    def create_table(self, room_name: Optional[str], user:User) -> Optional[str]:
        """ Request to create a new Table """

        room_name = self.new_table_name(room_name)
        if room_name is None:
            return None

        table:Table = self.factory.new_table(room_name)
        if not table.join(user):
            return None

        self.tables[room_name] = table
        return room_name

    def join_table(self, room_name: str, user:User) -> bool:
        """ Request to join an existing Table """

        table = self.tables.get(room_name)
        if table is None:
            return False

        return table.join(user)

    def part_table(self, room_name: str, user:User) -> bool:
        """ Request to leave a Table """

        table = self.tables.get(room_name)
        if table is None:
            return False

        if not table.part(user):
            return False

        if table.is_empty():
            check:bool = self.destroy_table(room_name)
            assert check
        return True

    def destroy_table(self, room_name: str) -> bool:
        """ Request to destroy a Table """

        table = self.tables.get(room_name)
        if table is None:
            return False

        if not table.is_empty():
            return False

        #for player in table.players:
        #    #self.part_table(room_name, player.user) # TODO recursive loop
        #    self.socketio.leave_room(player, table.room_name)  # Remove players from the table's room

        del self.tables[room_name]
        return True

    # TODO get_tables
    # TODO how to notify lobby/table/game that a user has disconnected?
    # TODO change min/max players on table


__author__    :str = "YouChat"
__copyright__ :str = "Copyright 2024, InnovAnon, Inc."
__license__   :str = "Proprietary"
__version__   :str = "1.0"
__maintainer__:str = "@lmaddox"
__email__     :str = "InnovAnon-Inc@gmx.com"
__status__    :str = "Production"
