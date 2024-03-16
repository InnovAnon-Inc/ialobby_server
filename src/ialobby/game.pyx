# -*- coding: utf-8 -*-
# distutils: language=c++
# cython: language_level=3

"""
Game Module: core functionality

Handle common logistics for multiplayer game instances
"""

from abc import ABC, abstractmethod
from typing import Sequence

from dataclasses import dataclass
from structlog import get_logger
#from typeguard import typechecked

from .db import User

logger = get_logger()

#@typechecked
@dataclass
class Player(ABC):
    """ Networking- and Game-specific Player objects """

    user                :User

#@typechecked
@dataclass
class Move(ABC):

    player:Player
    tick  :int

#@typechecked
@dataclass
class Game(ABC):
    """ Common Game metadata """

    min_players:int
    max_players:int

#@typechecked
class GameFactory(ABC):
    """ Abstracts Player- and Game-creation from Table """
   
    @abstractmethod
    def new_game(self, players:Sequence[Player]) -> Game:
        """ constructor """

        raise NotImplementedError

    @abstractmethod
    def new_player(self, user:User) -> Player:
        """ constructor """

        raise NotImplementedError

    @abstractmethod
    def hard_min(self) -> int:
        """ hard minimum for number of players """

        raise NotImplementedError

    @abstractmethod
    def hard_max(self) -> int:
        """ hard maximum for number of players """

        raise NotImplementedError


#@typechecked
#@dataclass
#class GameModule(ABC):
#
#    min_players:int
#    max_players:int
#    cur_players:Sequence[Player]
#
#    @abstractmethod
#    def receive_player_move(self, move:Move) -> None:
#        # Logic to process and handle a player's move within the game module
#        raise NotImplementedError
#    
#    @abstractmethod
#    def tick(self) -> None:
#        # Logic to update the game module's internal state based on received moves
#        # Additional game module methods can be included based on specific game requirements
#        raise NotImplementedError
#
#    @abstractmethod
#    def get_state(self) -> ???:
#        raise NotImplementedError
#
## Specific game modules (e.g., Tic-Tac-Toe) can be defined as subclasses of GameModule with game-specific logic and rules
#@typechecked
#@dataclass
#class TicTacToe(GameModule):
#    # Define Tic-Tac-Toe-specific game logic and methods
#    pass

__author__    :str = "YouChat"
__copyright__ :str = "Copyright 2024, InnovAnon, Inc."
__license__   :str = "Proprietary"
__version__   :str = "1.0"
__maintainer__:str = "@lmaddox"
__email__     :str = "InnovAnon-Inc@gmx.com"
__status__    :str = "Production"

