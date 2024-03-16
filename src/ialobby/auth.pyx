# -*- coding: utf-8 -*-
# distutils: language=c++
# cython: language_level=3

""" Authentication Module """

from abc import ABC, abstractmethod
from typing import Any, Dict, List, Optional

from dataclasses import dataclass
#from overrides import override
from postgrest import APIResponse
from structlog import get_logger
from supabase import create_client, Client
#from typeguard import typechecked

from .db import Code, Game, User

logger                                  = get_logger()

#@typechecked
@dataclass
class Authentication:
    """ (noun) proof that somebody is a particular person """

    user           :Optional[User]
    code           :Optional[Code]

    def is_valid(self) -> bool:
        """ (adjective) A ticket or other document is valid if it is based on or used according to a set of official conditions that often include a time limit """

        if self.user is None:
            assert self.code is None
            return False
        if self.code is None:
            return False
        return self.code.remaining > 0

#@typechecked
class Authenticator(ABC):
    """
    (noun) a person or thing that retrieves Authentication.
    """

    @abstractmethod
    def get_game(self) -> Game:
        """
        abstract accessor for Game DBO:
        allow game-specific lookups
        """

        raise NotImplementedError

    @abstractmethod
    def get_user(self, username:str) -> Optional[User]:
        """
        abstract accessor for User DBO:
        allow lookup by username
        """

        raise NotImplementedError

    @abstractmethod
    def get_code(self, user:User, secret:str) -> Optional[Code]:
        """
        abstract accessor for Code DBO:
        allow checking user- and game-specific `secret`
        """

        raise NotImplementedError

    def get_authentication(self, username:str, secret:str) -> Authentication:
        """
        accessor for a user's authentication status
        """

        user       :Optional[User]      = self.get_user(username)
        if user is None:
            return Authentication(None, None)

        code       :Optional[Code]      = self.get_code(user, secret)
        return Authentication(user, code)

#@typechecked
class SupabaseIntegration(Authenticator):
    """ Supbase-specific Authenticator """

    def __init__(self, supabase_url:str, supabase_key:str, game_name:str):
        self.client   :Client              = create_client(supabase_url, supabase_key)
        self.game     :Optional[Game]      = None
        self.game_name:str                 = game_name

    #@override
    def get_game(self) -> Game:
        if self.game is not None:
            return self.game

        response      :APIResponse         = self.client.table('game').select('*').eq('name', self.game_name).execute()

        data0         :List[Dict[str,Any]] = response.data
        assert len(data0) == 1

        data00        :Dict[str,Any]       = data0[0]
        self.game     :Game                = Game.from_response(data00)
        return self.game

    #@override
    def get_user(self, username:str) -> Optional[User]:
        response      :APIResponse         = self.client.table('user').select('*').eq('name', username).execute()

        data0         :List[Dict[str,Any]] = response.data
        if len(data0) != 1:
            return None

        data00        :Dict[str,Any]       = data0[0]
        user          :User                = User.from_response(data00)
        return user

    #@override
    def get_code(self, user:User, secret:str) -> Optional[Code]:
        game          :Game                = self.get_game()
        response1     :APIResponse         = self.client.table('code').select('*').eq('user_id', user.id).eq('game_id', game.id).eq('secret', secret).execute()

        data1         :List[Dict[str,Any]] = response1.data
        if len(data1) != 1:
            return None

        data10        :Dict[str,Any]       = data1[0]
        code          :Code                = Code.from_response(data10)
        return code

__author__    :str = "YouChat"
__copyright__ :str = "Copyright 2024, InnovAnon, Inc."
__license__   :str = "Proprietary"
__version__   :str = "1.0"
__maintainer__:str = "@lmaddox"
__email__     :str = "InnovAnon-Inc@gmx.com"
__status__    :str = "Production"
